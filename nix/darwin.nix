{ pkgs, ... }:
{
  # Packages installed in system profile
  environment.systemPackages = [

  ];

  # Skip to prevent error
  # Environment.etc."nix/nix.conf" because /etc/nix/nix.conf already exists, skipping...
  environment.etc."nix/nix.conf".enable = false;

  system = {
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
}
