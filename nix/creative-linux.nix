let
  pkgs = import <nixpkgs> { };
  inherit (pkgs) buildEnv;

in
buildEnv {
  name = "my-creative";
  paths = with pkgs; [
    gimp
    inkscape
    imagemagick
    ffmpeg
  ];
}
