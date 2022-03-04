PREFIX=/usr/local
PROFILE_FILE := $(HOME)/.profile
BASHRCC_FILE := $(HOME)/.bashrc
NIXCONF_FILE := $(HOME)/.config/nix/nix.conf
NIXPKGC_FILE := $(HOME)/.config/nixpkgs/config.nix
USERLOC_DIR  := $(HOME)/.local
VSCOUSR_DIR  := $(HOME)/.config/VSCodium/User
NIXPROF_DIR  := /nix/var/nix/profiles/per-user/$(USER)/default
TAG=\# managed by dotfiles

.PHONY: help nix lint uninstall install install-nix install-scripts

help: ## Display this help
	@grep -E '^[ a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "%-30s %s\n", $$1, $$2}'

uninstall: ## Uninstall
	# clean up .profile
	sed -i "/$(TAG)$$/d" $(PROFILE_FILE)
	sed -i "/$(TAG)$$/d" $(NIXCONF_FILE)
	sed -i "/$(TAG)$$/d" $(BASHRCC_FILE)
	
	# remove script links
	rm "$(DESTDIR)$(USERLOC_DIR)/bin/devbox" || true
	
	# clean up config.nix
	sed -i "/$(TAG)$$/d" $(NIXPKGC_FILE)

install: install-scripts install-nix install-other  ## Install

install-other: other/settings.json other/keybindings.json
	# bash prompt with git branch
	echo 'parse_git_branch() { git branch 2> /dev/null | sed -e' \
	"'/^[^*]/d' -e 's/* \(.*\)/(\\\1)/';" \
	"} $(TAG)" >> $(BASHRCC_FILE)
	echo "export PS1=\"\\u@\\h \\[\\\e[32m\\]\\w \\[\\\e[91m\\]\\\$$(parse_git_branch)\\[\\\e[00m\\]$$ \" $(TAG)" >> $(BASHRCC_FILE)

	# vscodium config (sas not able to nixify easily)
	cp other/settings.json $(VSCOUSR_DIR)
	cp other/keybindings.json $(VSCOUSR_DIR)

install-nix:
	# enable experimental nix features
	mkdir -p "$$(dirname $(NIXCONF_FILE))"
	echo "experimental-features = nix-command flakes $(TAG)" >> $(NIXCONF_FILE)
	
	# add nix profile .desktop files to application launcher
	echo "export XDG_DATA_DIRS=\"~/.nix-profile/share:\$\$$XDG_DATA_DIRS\" $(TAG)" >> $(PROFILE_FILE)
	
	# allow unfree
	@if [ -f "$(NIXPKGC_FILE)" ]; then \
	  echo "$(NIXPKGC_FILE) already exists, modifying."; \
	  sed -n -i 'p;1a allowUnfree = true; $(TAG)' $(NIXPKGC_FILE); \
	else \
	  echo -e "{\nallowUnfree = true; $(TAG)\n}" > $(NIXPKGC_FILE); \
	fi

install-scripts: scripts/devbox
	mkdir -p "$(DESTDIR)$(USERLOC_DIR)/bin"
	
	# link scripts to ~/.local/bin/
	ln -s "$$PWD/scripts/devbox" "$(DESTDIR)$(USERLOC_DIR)/bin/devbox"

$(NIXPROF_DIR):
	nix-env --profile $(NIXPROF_DIR) -i nix


nix: $(NIXPROF_DIR) $(wildcard nix/*.nix) ## Build nix profile
	nix-env --profile $< -i -f nix/common.nix
	nix-env --profile $< -i -f nix/creative.nix
	nix-env --profile $< -i -f nix/dev.nix
	nix-env --profile $< -i -f nix/tools.nix
	nix-env --profile $< -i -f nix/messaging.nix
	nix-env --profile $< -i -f nix/convenience.nix
	nix-env --profile $< -i -f nix/office.nix
	
lint:
	nixpkgs-fmt nix/

