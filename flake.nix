{
  description = "Flake dotfiles from TornaxO7";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # home-manager.url = "github:nix-community/home-manager";
  };

  outputs = inputs@{ self, nixpkgs }:
  let
    forEachSystem = init_function: nixpkgs.lib.genAttrs [
      "x86_64-linux"
    ] (system: init_function nixpkgs.legacyPackages.${system});
  in {
    devShells = forEachSystem (pkgs: {
      default = import ./shell.nix {inherit pkgs;};
    });
  };
}