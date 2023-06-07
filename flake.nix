{
    description = "Flake dotfiles from TornaxO7";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
        # home-manager.url = "github:nix-community/home-manager";
    };

    outputs = inputs@{self, nixpkgs, flake-utils}: {
        let
            username = "tornax";
            init_system = {system ? "x86_64-linux"}: {
            :
            };
        in {
            nixosConfigurations."TORNAX-MAIN" = init_system {
            };
        };
    };
}