{ config, pkgs, username, ... }:

{
  home.stateVersion = "22.11";
  home.username = "${username}";
  home.homeDirectory = "/Users/${username}";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # System profile packages
  home.packages = with pkgs; [
    # Development
    bun
    git
    lazygit
    tmux
    nixpkgs-fmt
    flyctl
    postgresql
    # powershell
    dotnet-sdk_7
    mono6
    ffmpeg
    shunit2
    shellcheck
    shellspec
    bats
    terraform
    cookiecutter
    cloc
    lldb_16
    plantuml
    graphviz
    watchexec

    # Cloud development
    awscli2
    aws-sam-cli
    yq

    # *nix
    tree
    unixtools.watch

    # Network
    nmap
    wakeonlan

    # Other
    # vale
    cmatrix
    # doxygen
    # asdf-vm

    # Data
    visidata
    jq
    duckdb
    ripgrep

    # Dependencies
    gpgme
    gawk
    ncurses
    # openssl
    # openssl.dev
    # openssl.out
    # openssl_1_1
    # openssl_1_1.dev
    # openssl_1_1.out
    # openssh
    # zlib
    # zlib.dev
    # zlib.out
  ];

  nixpkgs.config.allowUnfree = true;
  # nixpkgs.config.allowUnfreePredicate = (pkg: true);

  # Raw packages

  programs = {
    man.enable = true;
  };

  # Raw configuration files
  # home.file.".vimrc".source = ./vimrc;

  programs.vscode = {
    enable = true;
    # PROBLEM SIWTH EXTENSIONS?
    # 1. check code --list-extensions
    # 2. delete .vscode/extensions
    # 3. change something and rebuld home manager
    # workaround https://github.com/nix-community/home-manager/issues/3507
    mutableExtensionsDir = true;
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      dbaeumer.vscode-eslint
      eamodio.gitlens
      esbenp.prettier-vscode
      hashicorp.terraform
      # jakebecker.elixir-ls
      github.copilot
      # matklad.rust-analyzer
      rust-lang.rust-analyzer
      # ms-vscode.PowerShell
      ms-python.python
      # ms-dotnettools.csdevkit
      ms-dotnettools.csharp
      # github.vscode-github-actions
      # ms-vscode-remote.remote-containers
      phoenixframework.phoenix
      redhat.vscode-xml
      redhat.vscode-yaml
      vscodevim.vim
      # scala-lang.scala
      # scalameta.metals
      timonwong.shellcheck
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "vsc-material-theme";
        publisher = "equinusocio";
        version = "34.3.0";
        sha256 = "sha256-2SA2k2qngI3t3isSUCdxYHsAFVW+atGFFRnzP2RFdxw=";
      }
      {
        name = "mypy-type-checker";
        publisher = "ms-python";
        version = "2023.7.13181008";
        sha256 = "sha256-RBSnOHD1XAfHvt7t3qdkxjoDvQrH4cLTHZYAoSpLD3g=";
      }
      {
        name = "vsc-material-theme-icons";
        publisher = "equinusocio";
        version = "2.2.1";
        sha256 = "03mxvm8c9zffzykc84n2y34jzl3l7jvnsvnqwn6gk9adzfd2bh41";
      }
      {
        name = "volar";
        publisher = "Vue";
        version = "1.2.0";
        sha256 = "sha256-rIvZEl2KxT8m7lFQZ3lIRzksmxIx2+tKFR7v2HCj/XM=";
      }
      {
        name = "bun-vscode";
        publisher = "oven";
        version = "0.0.8";
        sha256 = "sha256-GJTCn6s9nN3kgbyJ4f1eFm7/fQezW2OmzcbSuYskDnk=";
      }
      {
        name = "even-better-toml";
        publisher = "tamasfe";
        version = "0.19.2";
        sha256 = "sha256-JKj6noi2dTe02PxX/kS117ZhW8u7Bhj4QowZQiJKP2E=";
      }
      #{
      #  name = "csharp";
      #  publisher = "ms-dotnettools";
      #  version = "1.25.4";
      #  sha256 = "sha256-9vLEwa0HB6DOLyoOXqMwWkFCe7S8epg3rfyPgSco5VY=";
      #}
      {
        name = "plastic-scm";
        publisher = "plastic-scm";
        version = "0.1.2";
        sha256 = "sha256-kqN163LhfjDnvuJdSlEXxl5fKEA3HgshRwaTTFa6IJ4=";
      }
    ];
    keybindings = [
      {
        key = "ctrl+shift+x";
        command = "-workbench.view.extensions";
        when = "viewContainer.workbench.view.extensions.enabled";
      }
      {
        key = "ctrl+shift+x";
        command = "workbench.action.terminal.toggleTerminal";
        when = "terminal.active";
      }
      {
        key = "ctrl+`";
        command = "-workbench.action.terminal.toggleTerminal";
        when = "terminal.active";
      }
      {
        key = "shift+enter";
        command = "-jupyter.execSelectionInteractive";
        when = "editorTextFocus && jupyter.featureenabled && jupyter.ownsSelection && !findInputFocussed && !notebookEditorFocused && !replaceInputFocussed && editorLangId == 'python'";
      }
      {
        key = "shift+enter";
        command = "-python.execSelectionInTerminal";
        when = "editorTextFocus && !findInputFocussed && !notebookEditorFocused && !python.datascience.ownsSelection && !replaceInputFocussed && editorLangId == 'python'";
      }
      {
        key = "ctrl+shift+k";
        command = "-editor.action.deleteLines";
        when = "textInputFocus && !editorReadonly";
      }
      {
        key = "ctrl+shift+k";
        command = "workbench.action.terminal.focus";
      }
      {
        key = "alt+down";
        command = "workbench.action.terminal.focusNext";
        when = "terminalFocus && terminalProcessSupported && !terminalEditorFocus";
      }
      {
        key = "ctrl+pagedown";
        command = "-workbench.action.terminal.focusNext";
        when = "terminalFocus && terminalProcessSupported && !terminalEditorFocus";
      }
      {
        key = "alt+up";
        command = "workbench.action.terminal.focusPrevious";
        when = "terminalFocus && terminalProcessSupported && !terminalEditorFocus";
      }
      {
        key = "ctrl+pageup";
        command = "-workbench.action.terminal.focusPrevious";
        when = "terminalFocus && terminalProcessSupported && !terminalEditorFocus";
      }
      {
        key = "ctrl+shift+k";
        command = "workbench.action.focusActiveEditorGroup";
        when = "terminalFocus";
      }
      {
        key = "shift+enter";
        command = "-python.execSelectionInTerminal";
        when = "editorTextFocus && !findInputFocussed && !jupyter.ownsSelection && !notebookEditorFocused && !replaceInputFocussed && editorLangId == 'python'";
      }
      {
        key = "cmd+k cmd+c";
        command = "-editor.action.addCommentLine";
        when = "editorTextFocus && !editorReadonly";
      }
      {
        key = "shift+cmd+7";
        command = "editor.action.commentLine";
        when = "editorTextFocus && !editorReadonly";
      }
      {
        key = "cmd+/";
        command = "-editor.action.commentLine";
        when = "editorTextFocus && !editorReadonly";
      }
      # maybe not needed
      {
        key = "ctrl+r";
        command = "-extension.vim_ctrl+r";
        when = "editorTextFocus && vim.active && vim.use<C-r> && !inDebugRepl";
      }
      {
        key = "ctrl+r";
        command = "-workbench.action.terminal.runRecentCommand";
        when = "accessibilityModeEnabled && terminalFocus && terminalHasBeenCreated || accessibilityModeEnabled && terminalFocus && terminalProcessSupported";
      }
    ];
    userSettings = {
      "vim.useCtrlKeys" = false;
      "editor.scrollBeyondLastLine" = false;
      "window.title" = "\${dirty}\${activeEditorLong}\${separator}\${rootName}\${separator}\${appName}";
      "terminal.integrated.fontSize" = 10;
      "zenMode.hideLineNumbers" = false;
      "zenMode.centerLayout" = false;
      "zenMode.fullScreen" = false;
      "gitlens.menus" = {
        "editorGroup" = {
          "blame" = false;
          "compare" = false;
        };
      };
      "github.gitAuthentication" = false;
      "git.terminalAuthentication" = false;
      "extensions.autoCheckUpdates" = false;
      # disable AWS toolkit telemetry
      "aws.telemetry" = false;
      # "powershell.powerShellAdditionalExePaths" = {
      #   "nix" = "/Users/changeme/.nix-profile/bin/pwsh";
      # };
      # "powershell.powerShellDefaultVersion" = "nix";
      "editor.fontSize" = 12;
      "editor.autoClosingBrackets" = "never";
      "editor.autoClosingQuotes" = "beforeWhitespace";
      "editor.inlineSuggest.enabled" = true;
      "keyboard.dispatch" = "keyCode";
      "gitlens.codeLens.enabled" = false;
      "gitlens.statusBar.enabled" = false;
      "gitlens.hovers.avatars" = false;
      "gitlens.ai.experimental.generateCommitMessage.enabled" = false;
      "workbench.colorTheme" = "Material Theme Palenight High Contrast";
      "workbench.colorCustomizations" = {
        "terminal.findMatchBackground" = "#e26cff";
        "terminal.findMatchBorder" = "#e26cff";
        "terminal.findMatchHighlightBackground" = "#e26cff";
        "terminal.findMatchHighlightBorder" = "#e26cff";
        "terminalOverviewRuler.findMatchForeground" = "#e26cff";
      };
      "security.workspace.trust.untrustedFiles" = "open";
      "python.terminal.activateEnvironment" = false;
      # "rust-analyzer.cargo.autoreload" = false;
      "editor.bracketPairColorization.enabled" = true;
      "editor.accessibilitySupport" = "off";
      "diffEditor.ignoreTrimWhitespace" = false;
      "redhat.telemetry.enabled" = false;
      # rust analyzer
      "rust-analyzer.inlayHints.typeHints.enable" = false;
      "rust-analyzer.inlayHints.chainingHints.enable" = false;
      "rust-analyzer.inlayHints.parameterHints.enable" = false;
      "editor.minimap.enabled" = false;
      "rust-analyzer.inlayHints.closureReturnTypeHints.enable" = "always";
      "[html]"."editor.defaultFormatter" = "vscode.html-language-features";
      "[yaml]"."editor.defaultFormatter" = "redhat.vscode-yaml";
      "[javascript]"."editor.defaultFormatter" = "vscode.typescript-language-features";
      "[json]"."editor.defaultFormatter" = "vscode.json-language-features";
      "[jsonc]"."editor.defaultFormatter" = "vscode.json-language-features";
      "[typescript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[python]"."editor.formatOnType" = true;
      "[python]"."editor.defaultFormatter" = "ms-python.black-formatter";
      "[css]"."editor.defaultFormatter" = "vscode.css-language-features";
      "git.mergeEditor" = false;
      "github.copilot.enable" = {
        "*" = true;
        "yaml" = false;
        "plaintext" = true;
        "markdown" = true;
        "rs" = false;
      };
      "prettier.requireConfig" = true;
    };
  };

  programs.git = {
    enable = true;
    userName = "change me";
    userEmail = "changeme@example.com";

    aliases = {
      waddup = "for-each-ref --sort=-committerdate refs/heads/";
      stashgrep = "!f() { for i in `git stash list --format=\"%gd\"`; \
                do git stash show -p $i | grep -H --label=\"$i\" \"$@\" ; done ; }; f";
    };
    extraConfig = {
      includeIf."gitdir:~/code/work/".path = "~/code/work/.gitconfig";
      core.editor = "vim";
    };
  };

  programs.ssh = {
    enable = true;
    forwardAgent = true;

    extraConfig = ''
      Match host github.com exec "[ $(git config user.email) = changeme ]"
        IdentityFile ~/.ssh/id_ed25519_work

      Host github.com
        AddKeysToAgent yes
        UseKeychain yes
        IdentityFile ~/.ssh/id_ed25519

      Host gitlab.com
        IgnoreUnknown UseKeychain
        User git
        UseKeychain yes
        AddKeysToAgent yes
        IdentityFile ~/.ssh/id_ed25519

      Host example
        HostName 0.0.0.0
        UseKeychain yes
        AddKeysToAgent yes
        IdentityFile ~/.ssh/id_ed25519_example
    '';
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;

    dotDir = ".config/zsh";

    shellAliases = {
      ll = "ls -l";
    };

    profileExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)";
      source /Users/changeme/.asdf/installs/rust/nightly/env;
      source /Users/changeme/.asdf/installs/rust/1.86.0/env;
    '';

    initExtra = ''
      # https://github.com/ohmyzsh/ohmyzsh/issues/2537
      unsetopt share_history
      export PATH="/Users/changeme/.local/bin:$PATH"
      # TODO issue with oh-my-zsh not adding asdf to path, needs to be investigated
      export PATH="$HOME/.asdf/shims:$PATH"
    '';

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "ssh-agent"
        "asdf"
      ];
      theme = "clean";
      extraConfig = ''
        zstyle :omz:plugins:ssh-agent identities id_ed25519_work id_ed25519
      '';
    };
  };

  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      vim-airline
      vim-nix
    ];
    settings = { ignorecase = true; };
    extraConfig = ''
      set mouse=a
      set nu
    '';
  };
}
