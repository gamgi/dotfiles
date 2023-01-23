let
  pkgs = import <nixpkgs> { };
  inherit (pkgs) buildEnv;

in
buildEnv {
  name = "my-dev";
  paths = with pkgs; [
    # act
    tree
    # dnsmasq
    gpgme
    gawk
    autoconf
    libxslt
    fop
  ];
}

