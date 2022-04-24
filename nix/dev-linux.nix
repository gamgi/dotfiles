let
  pkgs = import <nixpkgs> { };
  pkgs-vscode = (import ./pkgs-vscode.nix) { inherit pkgs; };
  pkgs-vscodium = (import ./pkgs-vscodium.nix) { inherit pkgs; };
  inherit (pkgs) buildEnv;

in
buildEnv {
  name = "my-dev";
  paths = with pkgs; [
    git
    # docker via system
    #pkgs-vscode.vscode-with-extensions
    pkgs-vscodium.vscodium-with-extensions
    terraform
    insomnia
  ];
}

