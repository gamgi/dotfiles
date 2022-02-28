let
  pkgs = import <nixpkgs> { };
  inherit (pkgs) buildEnv;

in
buildEnv {
  name = "my-tools";
  paths = with pkgs; [
    jq
    feh
  ];
  pathsToLink = [ "/share" "/bin" ];
}
