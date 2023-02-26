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
    git
    tmux
    nixpkgs-fmt
    asdf-vm

    # Dependencies
    gpgme
    gawk
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (pkg: true);

  # Raw packages

  programs = {
    man.enable = true;
  };

  # Raw configuration files
  # home.file.".vimrc".source = ./vimrc;

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
        IdentityFile ~/.ssh/id_rsa

      Host gitlab.com
        IgnoreUnknown UseKeychain
        User git
        UseKeychain yes
        AddKeysToAgent yes
        IdentityFile ~/.ssh/id_rsa
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
      # "source $HOME/.cargo/env";
    '';

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "ssh-agent" ];
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
