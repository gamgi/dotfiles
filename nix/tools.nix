let
  pkgs = import <nixpkgs> { };
  inherit (pkgs) buildEnv;

in
buildEnv {
  name = "my-tools";
  paths = with pkgs; [
    jq
    feh
    nmap
    visidata
  ];
  pathsToLink = [ "/share" "/bin" ];
}
