# dotfiles

This repository contains a basic setup of my macOS system.

## Automated setup

```
./install_software.sh
```
Installs most software I use on my macOS system, including Homebrew formulae, casks and Mac App Store apps.

```
./configure_system.sh
```
Configures system and application tweaks.

```
./configure_dev_mount.sh
```
Creates the `Development` APFS volume if it doesn't exist, mounts it at `~/Development` (persisted in `/etc/fstab`), creates its directory structure, and sets up appropriate symlinks.

```
./configure_dotfiles.sh
```
Configures dotfiles and other config files via symlinks. The first arg of this script is passed to all `ln` commands.

