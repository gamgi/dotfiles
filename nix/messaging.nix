let
  pkgs = import <nixpkgs> { };
  inherit (pkgs) buildEnv;

in
buildEnv {
  name = "my-messaging";
  paths = with pkgs; [
    # discord
  ];
  pathsToLink = [ "/share" "/bin" ];
}
