# Dotfiles

## Overview

* `home-manager` manages user configuration
* `nix-darwin` manages system configuration
* `make` as general purpose script runner

## First-time setup

1. Clone this repo
2. Install unmanaged software
  - See list of unmanaged software below
  - brew (via sh or .pkg)
  - xcode (`xcode-select --install`)
3. Altern username in `flake.nix`, `Makefile` and so on.
4. Run `make install`
5. Run `make setup`
6. Run `make setup-asdf`
7. Install firefox plugins, setup bookmarks, add ssh keys.

## Usage

### Adding a nix package

1. Edit `nix/home.nix`.
2. Run `make switch-home`

### Adding a brew package

Brew pacakges are managed by the `darwinConfigs.<name>.homebrew`.

1. Edit `nix/darwin.nix`.
2. Run `make switch-darwin`

### Updating channels

1. Backup or commit `flake.lock`
2. Run `make update-home`
3. Run `make switch-home` (takes a long time)

### Packages not managed by nix

A choice has been made to leave the following outside nix.

* firefox
* iterm2
* 1password
* appstore items (magnet, monosnap, intermission)
* obsidian
* docker
* slack
...etc

## Troubleshooting

### Nix broken after MacOS update

https://github.com/NixOS/nix/issues/3616

1. Check if `nix` and `nix-env` commands work
2. check if `/nix` exists
3. Check if `/etc/fstab/` has nix entry
4. Check if `/Library/LaunchDaemons/org.nixos.darwin-store.plist` exists
5. Based on above, proceed as in https://gist.github.com/meeech/0b97a86f235d10bc4e2a1116eec38e7e


