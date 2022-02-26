let
  pkgs = import <nixpkgs> { };
  pkgs-vscode = (import ./pkgs-vscode.nix) { inherit pkgs; };
  inherit (pkgs) buildEnv;

in
buildEnv {
  name = "my-dev";
  paths = [
    pkgs.git
    pkgs-vscode.vscode-with-extensions
  ];
}
