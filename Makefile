SHELL := /bin/bash
UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S),Linux)
VSCOUSR_DIR  := $(HOME)/.config/VSCodium/User
endif
ifeq ($(UNAME_S),Darwin)
VSCOUSR_DIR  := $(HOME)/Library/Application Support/Code/User
endif
PREFIX=/usr/local
PROFILE_FILE := $(HOME)/.profile
BASHRCC_FILE := $(HOME)/.bashrc
NIXCONF_FILE := $(HOME)/.config/nix/nix.conf
NIXPKGC_FILE := $(HOME)/.config/nixpkgs/config.nix
USERLOC_DIR  := $(HOME)/.local
NIXPROF_DIR  := /nix/var/nix/profiles/per-user/$(USER)/default
FFDESKT_FILE := /usr/share/applications/firefox.desktop
TAG=\# managed by dotfiles

.PHONY: help nix lint uninstall install setup-nix

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

install-other: other/settings.json other/keybindings.json
	# bash prompt with git branch
	echo 'parse_git_branch() { git branch 2> /dev/null | sed -e ' \
	"'/^[^*]/d' -e 's/* \(.*\)/(\\\1)/';" \
	"} $(TAG)" >> $(BASHRCC_FILE)
	echo "export PS1=\"\\u@\\h \\[\\\e[32m\\]\\w\\[\\\e[91m\\]\\\$$(parse_git_branch)\\[\\\e[00m\\] $$ \" $(TAG)" >> $(BASHRCC_FILE)

	# vscodium config (sas not able to nixify easily)
	mkdir -p "$(VSCOUSR_DIR)/share/applications"
	cp other/settings.json $(VSCOUSR_DIR)
	cp other/keybindings.json $(VSCOUSR_DIR)
	
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
	

$(NIXPROF_DIR):
	nix-env --profile $(NIXPROF_DIR) -i nix


setup-nix-homemanager:
	nix build --no-link ./nix/#homeConfigurations.pietu.activationPackage
	"$$(nix path-info ./nix/#homeConfigurations.pietu.activationPackage)"/activate

switch-homemanager:
	home-manager switch --flake './nix/#pietu'

setup-nix-darwin:
	nix build ./nix/#darwinConfigurations.pietu.system
	./result/sw/bin/darwin-rebuild switch --flake ./nix/#pietu

	#may have to do
	#printf 'run\tprivate/var/run\n' | sudo tee -a /etc/synthetic.conf
	# /System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t

nix: $(NIXPROF_DIR) $(wildcard nix/*.nix) ## Build nix profile
ifeq ($(UNAME_S),Linux)
	nix-env --profile $< -i -f nix/common-linux.nix
	nix-env --profile $< -i -f nix/dev-linux.nix
	nix-env --profile $< -i -f nix/office-linux.nix
	nix-env --profile $< -i -f nix/creative-linux.nix
	nix-env --profile $< -i -f nix/convenience-linux.nix
endif
ifeq ($(UNAME_S),Darwin)
	nix-env --profile $< -i -f nix/dev-macos.nix
endif
	nix-env --profile $< -i -f nix/tools.nix
	nix-env --profile $< -i -f nix/messaging.nix
	
lint:
	nixpkgs-fmt nix/

