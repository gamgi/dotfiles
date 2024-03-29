{
  description = "Home Manager configuration";

  inputs = {
    # Specify the sources
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

    outputs = { nixpkgs, darwin, home-manager, ... }:
      let
        system = "aarch64-darwin";
        username = "changeme";
        pkgs = nixpkgs.legacyPackages.${system};
        allowUnfree = { nixpkgs.config.allowUnfree = true; };
      in
      {
        homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
          # https://github.com/nix-community/home-manager/issues/2942#issuecomment-1378627909
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };

          # Specify your home configuration modules here, for example,
          # the path to your home.nix.
          modules = [
            ./home.nix
          ];

          # Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
          extraSpecialArgs = { inherit username; };
        };
        darwinConfigurations.${username} = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./darwin.nix
          ];
        };
      };
  }
