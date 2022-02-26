let
  pkgs = import <nixpkgs> { };
  inherit (pkgs) buildEnv;

in
buildEnv {
  name = "my-creative";
  paths = [
    pkgs.gimp
  ];
}
