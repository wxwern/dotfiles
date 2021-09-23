# dotfiles

This repository contains dotfiles, scripts and config files that is used to setup my macOS system.

To have most apps setup up and running, simply execute `install_software.sh`, which will automatically install formulae, casks and Mac App Store apps I use.

To install most dotfiles, simply run the `configure_dotfiles.sh` script. It'll not override existing files unless `-f` is used, and performs a soft link rather than copy the files for easier maintainence.

Caveats:
- Terminal setup requires installing [MesloLGM Nerd Font Mono](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Meslo/M) and manual import of `iTermProfile.json` into iTerm2.
