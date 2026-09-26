#!/usr/bin/env bash

# set script dir as working dir
cd "$(dirname "$0")"

VOLUME_NAME="Development"
MOUNT_POINT="$HOME/Development"
USER=$(whoami)
LINKS=()

# --- Helpers ---
phase-header() {
  echo
  printf "\033[1;34m"
  LEN=$(echo "PHASE $1: $2" | wc -c)
  printf "%*s\n" $((LEN+4)) | tr ' ' '='
  printf "  PHASE %s: %s  \n" "$1" "$2"
  printf "%*s\n" $((LEN+4)) | tr ' ' '='
  printf "\033[0m"
  echo
}

echo_item() {
  echo "  - $1"
}

echo_title() {
  echo -e "\033[1;32m$1\033[0m"
}

echo_warn() {
  echo -e "\033[1;31m  - $1\033[0m"
}

find_volume() {
  # diskutil reference (e.g., disk3s7) of a APFS Case-Sensitive volume with the given name, or empty if none
  diskutil apfs list | grep -B3 "Name: *$1 (Case-sensitive)" | grep -Eo 'Volume disk[0-9]+s[0-9]+' | awk '{print $2}' | head -1
}

SUDO=""
if [ "$(id -u)" -ne 0 ]; then SUDO="sudo"; fi


# PHASE 1
phase-header "1" "APFS Volume"

# --- Volume creation ---
echo_title "Preparing an APFS volume named \"$VOLUME_NAME\"..."
VOL_DEV=$(find_volume "$VOLUME_NAME")
if [ -z "$VOL_DEV" ]; then
  echo_item "Creating a case-sensitive APFS volume in the system volume's container..."
  DATA_DEV=$(diskutil info /System/Volumes/Data | awk '/Device Node/ {print $3}')
  $SUDO diskutil apfs addVolume "$DATA_DEV" -v "$VOLUME_NAME" -s || {
    echo_warn "Volume creation failed or cancelled. Aborting."
    exit 1
  }
  VOL_DEV=$(find_volume "$VOLUME_NAME")
  if [ -z "$VOL_DEV" ]; then
    echo_warn "Volume creation failed. Aborting."
    exit 1
  fi
  echo_item "Created $VOLUME_NAME on $VOL_DEV"
else
  echo_item "Found $VOLUME_NAME on $VOL_DEV"
fi

VOL_UUID=$(diskutil info "$VOL_DEV" | awk '/Volume UUID/ {print $3}')


# PHASE 2
phase-header "2" "Mount Point"

# --- Mount point directory ---
echo_title "Ensuring mount point directory..."
echo_item "mkdir -p $MOUNT_POINT"
mkdir -p "$MOUNT_POINT"

# --- fstab (boot-time mount) ---
echo_title "Ensuring /etc/fstab entry..."
if grep -q "UUID=$VOL_UUID $MOUNT_POINT" /etc/fstab; then
  echo_item "fstab entry already correct"
else
  echo_item "Updating fstab entry (UUID=$VOL_UUID -> $MOUNT_POINT)"
  $SUDO true || {
    echo_warn "Failed to gain sudo privileges. Ensure you have write permissions and try again."
    exit 1
  }
  $SUDO sed -i '' "/UUID=$VOL_UUID /d" /etc/fstab || true
  echo "UUID=$VOL_UUID $MOUNT_POINT apfs rw 0 2" | $SUDO tee -a /etc/fstab > /dev/null || {
    echo_warn "Failed to update /etc/fstab. Ensure you have write permissions and try again."
    exit 1
  }
fi

# --- Mount now ---
echo_title "Mounting..."
CURRENT_MOUNT=$(diskutil info "$VOL_DEV" | awk '/Mount Point/ {print $3}')
if [ "$CURRENT_MOUNT" = "$MOUNT_POINT" ]; then
  echo_item "Already mounted at $MOUNT_POINT"
else
  if [ "$CURRENT_MOUNT" != "Not Mounted" ]; then
    echo_item "Unmounting from $CURRENT_MOUNT"
    until diskutil unmount "$VOL_DEV"; do
      echo_item "Unmount failed (volume busy). Close apps using $MOUNT_POINT / $CURRENT_MOUNT, then press Enter to retry (Ctrl-C to abort): "
      read -p ""
    done
  fi
  if [ -f /etc/fstab ] && grep -q "UUID=$VOL_UUID $MOUNT_POINT" /etc/fstab; then
    echo_item "Mounting $VOL_DEV at $MOUNT_POINT"
    diskutil mount "$VOL_DEV" || diskutil mount -mountpoint "$MOUNT_POINT" "$VOL_DEV" || {
      echo_warn "Mount failed. Ensure /etc/fstab has the correct entry and try again."
      exit 1
    }
  else
    echo_item "Mounting $VOL_DEV at $MOUNT_POINT"
    diskutil mount -mountpoint "$MOUNT_POINT" "$VOL_DEV" || {
      echo_warn "Mount failed. Ensure /etc/fstab has the correct entry and try again."
      exit 1
    }
  fi
fi


# PHASE 3
phase-header "3" "Directories"

# --- Directory structure ---
echo_title "Creating volume directory structure..."
TARGET_DIRS=("_global" "external" "internal" "local" "worktrees")
for dir in "${TARGET_DIRS[@]}"; do
  echo_item "mkdir -p $MOUNT_POINT/$dir"
  mkdir -p "$MOUNT_POINT/$dir"
done
echo_item "mkdir -p $MOUNT_POINT/_global/bun (target of ~/.bun)"
mkdir -p "$MOUNT_POINT/_global/bun"



# PHASE 4
phase-header "4" "Symlinks"

ensure_link() {
  # Create a symlink at $1 pointing to $2.
  # If $1 exists as a real file/directory (authoritative), it is moved to $3;
  # stale content at $3 is backed up to $3.<unixtime>.bak first, with a warning.
  local path="$1" target="$2" move_to="${3:-}" oldbak
  LINKS+=("$path")
  if [ -L "$path" ] && [ "$(readlink "$path")" = "$target" ]; then
    # Symlink already correct
    echo_item "$path -> $target (unchanged)"
  elif [ -L "$path" ]; then
    # Symlink exists but points elsewhere; repoint it
    ln -sfn "$target" "$path"
    echo_item "Repointed $path -> $target"
  elif [ -e "$path" ]; then
    # Path exists as a real file/directory; move it to $move_to if specified, else leave it untouched
    if [ -z "$move_to" ]; then
      echo_warn "$path exists as a real file/directory - left untouched (setup may be incomplete!)"
    elif [ ! -e "$move_to" ] || rmdir "$move_to" 2>/dev/null; then
      # Move path to $move_to (available) and link
      mkdir -p "$(dirname "$move_to")" && \
      mv "$path" "$move_to" && \
      ln -s "$target" "$path" && \
      echo_item "Moved $path to $move_to, linked $path -> $target" || {
        echo_warn "Failed to move $path to $move_to and link. Check permissions and try again."
        exit 1
      }
    else
      # $move_to exists; back it up, then move path to $move_to and link
      oldbak="$move_to.$(date +%s).bak"
      mv "$move_to" "$oldbak" && \
      mv "$path" "$move_to" && \
      ln -s "$target" "$path" && \
      echo_warn "Stale $move_to backed up to $oldbak, replaced by $path, linked $path -> $target" || {
        echo_warn "Failed to move $path to $move_to and link. Check permissions and try again."
        exit 1
      }
    fi
  else
    # Path does not exist; create symlink
    ln -s "$target" "$path"
    echo_item "Linked $path -> $target"
  fi
}

# --- Symlink creation ---
echo_title "Creating compatibility symlinks..."
mkdir -p "$HOME/Repositories"
ensure_link "$HOME/Repositories/internal" "../Development/internal" "$MOUNT_POINT/internal"
ensure_link "$HOME/Repositories/external" "../Development/external" "$MOUNT_POINT/external"
ensure_link "$HOME/Repositories/worktrees" "../Development/worktrees" "$MOUNT_POINT/worktrees"
ensure_link "$HOME/Projects" "Development/local" "$MOUNT_POINT/local"
ensure_link "$HOME/.bun" "./Development/_global/bun" "$MOUNT_POINT/_global/bun"
ensure_link "$HOME/dotfiles" "Repositories/internal/dotfiles" "$MOUNT_POINT/internal/dotfiles"


# PHASE 5
phase-header "5" "Permissions"
echo_title "Restricting mount point and surface directories to owner (rwx------)..."

# --- Top-level mount permissions ---
echo_item "Restricting $MOUNT_POINT to owner"
chmod 700 "$MOUNT_POINT"
if [ "$(stat -f "%Su" "$MOUNT_POINT")" != "$USER" ]; then
  echo_item "Changing ownership of $MOUNT_POINT to $USER"
  $SUDO chown "$USER" "$MOUNT_POINT"
fi

# --- Recursive permissions for directories ---
for dir in "${TARGET_DIRS[@]}"; do
  echo_item "Restricting $MOUNT_POINT/$dir to owner"
  chmod 700 "$MOUNT_POINT/$dir"
  if [ "$(stat -f "%Su" "$MOUNT_POINT/$dir")" != "$USER" ]; then
    echo_item "Changing recursive ownership of $MOUNT_POINT/$dir to $USER"
    $SUDO chown -R "$USER" "$MOUNT_POINT/$dir"
  fi
done


# END
phase-header "6" "Summary"
echo_title "Done."
echo "  - Volume: $VOLUME_NAME on $VOL_DEV (UUID=$VOL_UUID)"
echo "  - Mount:  $(diskutil info "$VOL_DEV" | awk '/Mount Point/ {print $3}')"
echo
echo "  Symlinks:"
ls -l "${LINKS[@]}" 2>&1 | sed 's/^/    /'
echo
