let
  pkgs = import <nixpkgs> { };
  pkgs-spotify = (import ./pkgs-spotify.nix) { inherit pkgs; };
  inherit (pkgs) buildEnv;

in
buildEnv {
  name = "my-convenience";
  paths = with pkgs; [
    pkgs-spotify.spotify
  ];
}
