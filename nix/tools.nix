let
  pkgs = import <nixpkgs> { };
  inherit (pkgs) buildEnv;

in
buildEnv {
  name = "my-tools";
  paths = with pkgs; [
    jq
  ];
  pathsToLink = [ "/share" "/bin" ];
}
