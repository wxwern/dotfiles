# dotfiles

This repository contains dotfiles, scripts and config files that is used to setup my macOS system.

To have most apps setup up and running, simply execute `install_software.sh`, which will automatically install formulae, casks and Mac App Store apps I use.

To install most dotfiles, simply run the `configure_dotfiles.sh` script. It'll not override existing files unless `-f` is used, and performs a soft link rather than copy the files for easier maintainence.

To apply some basic system tweaks, run the `configure_system.sh` script.

Caveats:
- Manual installation required for items in the `others` directory.
