{
  description = "Flake dotfiles from TornaxO7";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    # home-manager.url = "github:nix-community/home-manager";
  };

  outputs = inputs@{ self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
        pkgs = nixpkgs.legacyPackages.${system};
    in {
        devShells.default = import ./shell.nix { inherit pkgs; };
    });
}