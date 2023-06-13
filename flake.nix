{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      init_system =
        { configuration
        , system ? "x86_64-linux"
        , extra_modules ? [ ]
        ,
        }: nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            configuration
            ./nixos-configurations/shared/default.nix
          ] ++ extra_modules;

          specialArgs = {
            inherit home-manager;
          };
        };
    in
    {
      nixosConfigurations = {
        pc = init_system {
          configuration = ./nixos-configurations/pc;
          extra_modules = [
            ./nixos-configurations/shared/desktop/default.nix
          ];
        };
      };
    };
}
