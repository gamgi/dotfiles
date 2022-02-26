PREFIX=/usr/local
PROFILE_FILE := $(HOME)/.profile
NIXCONF_FILE := $(HOME)/.config/nix/nix.conf
NIXPKGC_FILE := $(HOME)/.config/nixpkgs/config.nix
USERLOC_DIR  := $(HOME)/.local
NIXPROF_DIR  := /nix/var/nix/profiles/per-user/$(USER)/testing
TAG=\# managed by dotfiles

.PHONY: help build lint uninstall install install-nix install-scripts

help: ## Display this help
	@grep -E '^[ a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "%-30s %s\n", $$1, $$2}'

uninstall: ## Uninstall
	# clean up .profile
	sed -i "/$(TAG)$$/d" $(PROFILE_FILE)
	sed -i "/$(TAG)$$/d" $(NIXCONF_FILE)
	
	# remove script links
	rm "$(DESTDIR)$(USERLOC_DIR)/bin/devbox" || true
	
	# clean up config.nix
	sed -i "/$(TAG)$$/d" $(NIXPKGC_FILE)

install: install-scripts install-nix ## Install

install-nix:
	# enable experimental nix features
	mkdir -p "$$(dirname $(NIXCONF_FILE))"
	echo "experimental-features = nix-command flakes $(TAG)" >> $(NIXCONF_FILE)
	
	# add nix profile .desktop files to application launcher
	echo "export XDG_DATA_DIRS=\"~/.nix-profile/share/applications:\$\$$XDG_DATA_DIRS\" $(TAG)" >> $(PROFILE_FILE)
	
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

build: $(NIXPROF_DIR) nix/common.nix nix/creative.nix nix/dev.nix
	nix-env --profile $< -i -f nix/common.nix
	nix-env --profile $< -i -f nix/creative.nix
	nix-env --profile $< -i -f nix/dev.nix
	
lint:
	nixpkgs-fmt --check nix/

