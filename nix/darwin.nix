{ pkgs, ... }:
{
  system.stateVersion = 6;
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
      "tfenv"
      "kubectl"
      "kubectx"
      "gh"
    ];
    casks = [
      # "hammerspoon"
      # "amethyst"
      # "alfred"
      # "logseq"
      # "discord"
      # "iina"
      # "scoot"
      # "dotnet-sdk"
      # "mono-mdk"
      "1password-cli"
      "alt-tab"
      "insomnia"
      "cyberduck"
      "keycastr"
      "ngrok"
      "claude-code"
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
  system.primaryUser = "changeme";
  system.defaults.dock.tilesize = 32;
  system.defaults.dock.autohide = true;

  nix.package = pkgs.nix;

  # Denylist compromised CA certs
  security.pki.caCertificateBlacklist = [
    "Comodo AAA Services root"
    "emSign ECC Root CA - G3"
  ];

  # Local DNS overrides
  # services.dnsmasq.enable = true;
  # services.dnsmasq.addresses = {
  #   localhost = "127.0.0.1";
  #   "dashboard.example.local" = "127.0.0.1";
  # };
}
