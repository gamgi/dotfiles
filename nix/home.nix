{ config, pkgs, username, ... }:

{
  home.stateVersion = "22.11";
  home.username = "${username}";
  home.homeDirectory = "/Users/${username}";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.atuin = {
    enable = true;
  };

  # hotkey daemon
  services.skhd.enable = true;

  xdg.configFile."skhd/skhdrc".text = ''
    ctrl + alt - m : open -a Firefox https://github.com/pulls/authored

    # send window to a space
    shift + alt - 1 : yabai -m window --space 1
    shift + alt - 2 : yabai -m window --space 2
    shift + alt - 3 : yabai -m window --space 3
  '';

  # System profile packages
  home.packages = with pkgs; [
    # Development
    bun
    git
    lazygit
    tmux
    nixpkgs-fmt
    flyctl
    postgresql_18
    hyperfine
    entr
    # powershell
    # mono6
    ffmpeg
    exiftool
    shellcheck
    # shellspec
    # bats
    # terraform installed with brew
    # cookiecutter
    cloc
    plantuml
    # graphviz
    # watchexec
    # youplot

    # Cloud development

    # *nix
    tree
    unixtools.watch

    # Network
    # nmap
    # wakeonlan

    # Other
    # vale
    cmatrix
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
    imagemagick
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


  programs.git = {
    enable = true;
    settings = {
      user.name = "change me";
      user.email = "changeme@example.com";
      alias = {
        waddup = "for-each-ref --sort=-committerdate refs/heads/";
        stashgrep = "!f() { for i in `git stash list --format=\"%gd\"`; \
        do git stash show -p $i | grep -H --label=\"$i\" \"$@\" ; done ; }; f";
        co = "checkout";
        fix-committer = ''!git filter-branch --commit-filter 'GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"; GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"; GIT_COMMITTER_DATE="$GIT_AUTHOR_DATE"; git commit-tree "$@"' -- $(git merge-base master HEAD)..HEAD'';

      };
      includeIf."gitdir:~/code/work/".path = "~/code/work/.gitconfig";
      core.editor = "vim";
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings."*".forwardAgent = true;

    extraConfig = ''
      Match host github.com exec "[ $(git config user.email) = changeme ]"
        IdentityFile ~/.ssh/id_ed25519_work

      Host github.com
        AddKeysToAgent yes
        UseKeychain yes
        IdentityFile ~/.ssh/id_ed25519

    '';
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;

    dotDir = "${config.xdg.configHome}/zsh";

    shellAliases = {
      ll = "ls -l";
    };

    profileExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)";
      source /Users/changeme/.asdf/installs/rust/nightly/env;
      source /Users/changeme/.asdf/installs/rust/1.92.0/env;
    '';

    initContent = ''
      # https://github.com/ohmyzsh/ohmyzsh/issues/2537
      unsetopt share_history
      unsetopt SHARE_HISTORY
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
      theme = "awesomepanda";
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
