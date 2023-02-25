{ config, pkgs, ... }:

{
  home.stateVersion = "22.11";
  home.username = "pietu";
  home.homeDirectory = "/Users/pietu";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.packages = with pkgs; [
   git
  ];

  nixpkgs.config.allowUnfree = true;

  programs = {
    man.enable = true;
    vim.enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Pietu R";
    userEmail = "pietu_r@gmx.com";
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

    profileExtra = "source $HOME/.cargo/env";

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "ssh-agent" ];
      theme = "af-magic";
    };
  };
}

