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

    # Cloud development
    awscli2
    aws-sam-cli

    # Other
    vale
    spotify-tui
    cmatrix

    # Data
    visidata

    # Dependencies
    gpgme
    gawk
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
      jakebecker.elixir-ls
      github.copilot
      matklad.rust-analyzer
      # ms-vscode.PowerShell
      ms-python.python
      ms-dotnettools.csharp
      phoenixframework.phoenix
      redhat.vscode-xml
      redhat.vscode-yaml
      vscodevim.vim
      timonwong.shellcheck
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "vsc-community-material-theme";
        publisher = "equinusocio";
        version = "1.4.4";
        sha256 = "005l4pr9x3v6x8450jn0dh7klv0pv7gv7si955r7b4kh19r4hz9y";
      }
      {
        name = "aws-toolkit-vscode";
        publisher = "AmazonWebServices";
        version = "1.94.0";
        sha256 = "Z++saaEDeGuqg7moF3m9yugIxrMulIiz+zwnm+RJzbs=";
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
      "gitlens.menus" = {
        "editorGroup" = {
          "blame" = false;
          "compare" = false;
        };
      };
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
      "workbench.colorTheme" = "Community Material Theme Palenight High Contrast";
      "workbench.colorCustomizations" = {
        "terminal.findMatchBackground" = "#e26cff";
        "terminal.findMatchBorder" = "#e26cff";
        "terminal.findMatchHighlightBackground" = "#e26cff";
        "terminal.findMatchHighlightBorder" = "#e26cff";
        "terminalOverviewRuler.findMatchForeground" = "#e26cff";
      };
      "security.workspace.trust.untrustedFiles" = "open";
      "python.terminal.activateEnvironment" = false;
      "editor.bracketPairColorization.enabled" = true;
      "editor.accessibilitySupport" = "off";
      "diffEditor.ignoreTrimWhitespace" = false;
      "redhat.telemetry.enabled" = false;
      # rust analyzer
      "rust-analyzer.lens.implementations" = false;
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
      refs = "for-each-ref --sort=-comitterdate refs/heads/";
      stashgrep = "!f() { for i in `git stash list --format=\"%gd\"`; \
                do git stash show -p $i | grep -H --label=\"$i\" \"$@\" ; done ; }; f";
    };
    extraConfig = {
      includeIf."gitdir:~/code/work/".path = "~/code/work/.gitconfig";
    };
  };

  programs.ssh = {
    enable = true;
    forwardAgent = true;

    extraConfig = ''
      Host github.com
        IgnoreUnknown UseKeychain
        User git
        UseKeychain yes
        AddKeysToAgent yes
        IdentityFile ~/.ssh/id_ed25519

      Host github.com
        AddKeysToAgent yes
        UseKeychain yes
        IdentityFile ~/.ssh/id_ed25519_work

      Host gitlab.com
        IgnoreUnknown UseKeychain
        User git
        UseKeychain yes
        AddKeysToAgent yes
        IdentityFile ~/.ssh/id_ed25519
    '';
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;

    dotDir = ".config/zsh";

    shellAliases = {
      ll = "ls -l";
    };

    profileExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)";
    '';

    initExtra = ''
      # https://github.com/ohmyzsh/ohmyzsh/issues/2537
      unsetopt share_history
      export PATH="/Users/changeme/.local/bin:$PATH"
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
