let
  pkgs = import <nixpkgs> { };
  inherit (pkgs) buildEnv;

in
buildEnv {
  name = "my-office";
  paths = with pkgs; [
    libreoffice
  ];
}
