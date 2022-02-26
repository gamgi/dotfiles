PREFIX=/usr/local
PROFILE_FILE := $(HOME)/.profile
USERLOC_DIR  := $(HOME)/.local

TAG=\# managed by dotfiles

.PHONY: help lint uninstall install install-scripts

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

install: install-scripts ## Install

install-scripts: scripts/devbox
	mkdir -p "$(DESTDIR)$(USERLOC_DIR)/bin"
	
	# link scripts to ~/.local/bin/
	ln -s "$$PWD/scripts/devbox" "$(DESTDIR)$(USERLOC_DIR)/bin/devbox"

