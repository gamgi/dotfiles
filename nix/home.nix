{ config, pkgs, ... }:

{
  home.stateVersion = "22.11";
  home.username = "pietu";
  home.homeDirectory = "/Users/pietu";

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
    powershell
    dotnet-sdk_7
    mono6
    vale
    ffmpeg
    shunit2
    shellcheck
    spotify-tui
    terraform
    cmatrix

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
      ms-vscode.PowerShell
      ms-python.python
      ms-dotnettools.csharp
      phoenixframework.phoenix
      redhat.vscode-xml
      redhat.vscode-yaml
      vscodevim.vim
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "vsc-community-material-theme";
        publisher = "equinusocio";
        version = "1.4.4";
        sha256 = "005l4pr9x3v6x8450jn0dh7klv0pv7gv7si955r7b4kh19r4hz9y";
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
    userSettings = {
        "vim.useCtrlKeys"= false;
        "editor.scrollBeyondLastLine"= false;
        "window.title"= "\${dirty}\${activeEditorLong}\${separator}\${rootName}\${separator}\${appName}";
        "editor.autoClosingQuotes"= "beforeWhitespace";
        "terminal.integrated.fontSize"= 12;
        "editor.fontSize"= 13;
        "keyboard.dispatch"= "keyCode";
        "gitlens.codeLens.enabled"= false;
        "gitlens.statusBar.enabled"= false;
        "gitlens.hovers.avatars"= false;
        "workbench.colorTheme"= "Material Theme Palenight High Contrast";
        "security.workspace.trust.untrustedFiles"= "open";
        "python.terminal.activateEnvironment"= false;
        "editor.bracketPairColorization.enabled"= true;
        "editor.autoClosingBrackets"= "never";
        "diffEditor.ignoreTrimWhitespace"= false;
        "redhat.telemetry.enabled"= false;
        "rust-analyzer.lens.implementations"= false;
        "rust-analyzer.inlayHints.typeHints.enable"= false;
        "rust-analyzer.inlayHints.chainingHints.enable"= false;
        "rust-analyzer.inlayHints.parameterHints.enable"= false;
        "editor.minimap.enabled"= false;
        "rust-analyzer.inlayHints.closureReturnTypeHints.enable"= "always";
        "git.mergeEditor"= false;
        "prettier.requireConfig"= true;
    };
  };

  programs.git = {
    enable = true;
    userName = "Pietu R";
    userEmail = "pietu_r@gmx.com";

    aliases = {
      refs = "for-each-ref --sort=-comitterdate refs/heads/";
      stashgrep = "!f() { for i in `git stash list --format=\"%gd\"`; \
                do git stash show -p $i | grep -H --label=\"$i\" \"$@\" ; done ; }; f";
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
