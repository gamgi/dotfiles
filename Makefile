SHELL := /bin/bash
UNAME_S := $(shell uname -s)
USER := changeme

PREFIX=/usr/local
PROFILE_FILE := $(HOME)/.profile
BASHRCC_FILE := $(HOME)/.bashrc
NIXCONF_FILE := $(HOME)/.config/nix/nix.conf
NIXPKGC_FILE := $(HOME)/.config/nixpkgs/config.nix
USERLOC_DIR  := $(HOME)/.local
FFDESKT_FILE := /usr/share/applications/firefox.desktop
TAG=\# managed by dotfiles


.PHONY: help nix setup lint uninstall install setup-nix install-scripts \
        install-nix install-other setup-nix-homemanager switch-home update-home switch-darwin setup-nix-darwin install-homebrew setup-asdf

help: ## Display this help
	@grep -E '^[ a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "%-30s %s\n", $$1, $$2}'

uninstall: ## Uninstall
	# clean up .profile
	sed -i "/$(TAG)$$/d" $(PROFILE_FILE) || true
	sed -i "/$(TAG)$$/d" $(NIXCONF_FILE) || true
	sed -i "/$(TAG)$$/d" $(BASHRCC_FILE) || true
	sed -i "/$(TAG)$$/d" $(PROFILE_FILE) || true
	sed -i "/$(TAG)$$/d" $(FFDESKT_FILE) || true

	# remove script links
	rm "$(DESTDIR)$(USERLOC_DIR)/bin/devbox" || true

	# clean up config.nix
	sed -i "/$(TAG)$$/d" $(NIXPKGC_FILE) || true

	# remove nix to pop_os link
	rm -r "$(USERLOC_DIR)/share/applications"
	mkdir -p "$(USERLOC_DIR)/share/applications"

install: install-scripts install-nix install-other  ## Install

setup: setup-nix setup-nix-homemanager ## Setup

install-other:
	# bash prompt with git branch
	echo 'parse_git_branch() { git branch 2> /dev/null | sed -e ' \
	"'/^[^*]/d' -e 's/* \(.*\)/(\\\1)/';" \
	"} $(TAG)" >> $(BASHRCC_FILE)
	echo "export PS1=\"\\u@\\h \\[\\\e[32m\\]\\w\\[\\\e[91m\\]\\\$$(parse_git_branch)\\[\\\e[00m\\] $$ \" $(TAG)" >> $(BASHRCC_FILE)

	# set firefox gtk theme
	sudo sed -i -- 's/^Exec=firefox %u$$/Exec=bash -c "GTK_THEME=\\" \\" firefox %u"/' /usr/share/applications/firefox.desktop


install-nix:
	sh <(curl -L https://nixos.org/nix/install) --daemon

setup-nix:
	# enable experimental nix features
	mkdir -p "$$(dirname $(NIXCONF_FILE))"
	echo "experimental-features = nix-command flakes $(TAG)" >> $(NIXCONF_FILE)

	# allow unfree
	@if [ -f "$(NIXPKGC_FILE)" ]; then \
	  echo "$(NIXPKGC_FILE) already exists, modifying."; \
	  sed -n -i 'p;1a allowUnfree = true; $(TAG)' $(NIXPKGC_FILE); \
	else \
	  mkdir -p "$$(dirname $(NIXPKGC_FILE))"; \
	  echo "{\nallowUnfree = true; $(TAG)\n}" > $(NIXPKGC_FILE); \
	fi

install-scripts:
	#mkdir -p "$(DESTDIR)$(USERLOC_DIR)/bin"

$(NIXPROF_DIR):
	nix-env --profile $(NIXPROF_DIR) -i nix


setup-nix-homemanager:
	nix build --no-link ./nix/#homeConfigurations.$(USER).activationPackage
	"$$(nix path-info ./nix/#homeConfigurations.$(USER).activationPackage)"/activate

switch-home:
	# home-manager switch -b backup --flake './nix/#$(USER)'
	home-manager switch --flake './nix/#$(USER)'

news:
	home-manager news --flake './nix/#$(USER)'

update-home:
	nix flake update ./nix/flake.nix

switch-darwin:
	./result/sw/bin/darwin-rebuild switch --flake './nix/#$(USER)'


setup-nix-darwin:
	nix build ./nix/#darwinConfigurations.$(USER).system
	./result/sw/bin/darwin-rebuild switch --flake './nix/#$(USER)'

	#may have to do
	#printf 'run\tprivate/var/run\n' | sudo tee -a /etc/synthetic.conf
	# /System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t

install-homebrew:
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

setup-asdf:
	asdf plugin-add rust https://github.com/code-lever/asdf-rust.git || true
	# asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git || true

	asdf install rust nightly




.PHONY: lint
lint:
	nixpkgs-fmt nix/
