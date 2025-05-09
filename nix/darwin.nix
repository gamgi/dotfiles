{ pkgs, ... }:
{
  # Packages installed in system profile
  environment.systemPackages = [

  ];

  # Homebrew packages
  homebrew = {
    enable = true;
    # updates homebrew packages on activation,
    # can make darwin-rebuild much slower (otherwise i'd forget to do it ever though)
    onActivation.upgrade = true;
    brews = [
      # NOTE: Prefer casks and nixpkgs
      "asdf"
      "openssl@3"
      "xz"
      "zlib"
      #"mono"
      #"websocat" # for up-to-date version
    ];
    casks = [
      # "iterm2"
      # "hammerspoon"
      # "amethyst"
      # "alfred"
      # "logseq"
      # "discord"
      # "iina"
      # "scoot"
      # "dotnet-sdk"
      # "mono-mdk"
      "insomnia"
      "cyberduck"
      "keycastr"
    ];
  };


  # Skip to prevent error
  # Environment.etc."nix/nix.conf" because /etc/nix/nix.conf already exists, skipping...
  environment.etc."nix/nix.conf".enable = false;

  system = {
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };
  system.defaults.dock.tilesize = 32;
  system.defaults.dock.autohide = true;

  nix.package = pkgs.nix;

  # Local DNS overrides
  # services.dnsmasq.enable = true;
  # services.dnsmasq.addresses = {
  #   localhost = "127.0.0.1";
  #   "dashboard.example.local" = "127.0.0.1";
  # };
}
