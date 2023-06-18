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
            ./nixos-configurations/shared/default.nix
            configuration
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
            ./modules/yubikey
          ];
        };

        laptop = init_system {
          configuration = ./nixos-configurations/laptop;
          extra_modules = [
            ./nixos-configurations/shared/desktop/default.nix
            ./modules/yubikey
          ];
        };
      };
    };
}
