let
  pkgs = import <nixpkgs> { };
  inherit (pkgs) buildEnv;

in
buildEnv {
  name = "my-common";
  paths = [
    pkgs.gnome3.gnome-tweaks
    pkgs.figlet
    pkgs._1password-gui
    pkgs.nixpkgs-fmt
  ];
}
