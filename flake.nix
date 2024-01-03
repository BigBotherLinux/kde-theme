{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: 
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    bb-kde-theme = pkgs.callPackage ./default.nix { };

  in
  {
    packages.${system}.bb-kde-theme = bb-kde-theme;

    defaultPackage.${system} = bb-kde-theme;

    homeManagerConfigurations = {
      # Example Home Manager configuration
      example = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        configuration = { config, pkgs, ... }: {
          # Your Home Manager configuration
        };
      };
    };
  };
}
