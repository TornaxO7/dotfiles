{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, agenix, ... }:
    let
      init_system =
        { configuration
        , system ? "x86_64-linux"
        , extra-modules ? [ ]
        ,
        }: nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            ./secrets/default.nix
            ./modules/default.nix
            home-manager.nixosModules.home-manager
            agenix.nixosModules.default
            configuration
          ] ++ extra-modules;

          specialArgs = {
            inherit home-manager;
          };
        };
    in
    {
      nixosConfigurations = {
        pc = init_system {
          configuration = ./nixos-configurations/pc/default.nix;
          extra-modules = [
            ./modules/desktop
            ./modules/game/steam.nix
            ./modules/paperless
            ./modules/yubikey
          ];
        };

        laptop = init_system {
          configuration = ./nixos-configurations/laptop;
          extra-modules = [
            ./modules/desktop
            ./modules/yubikey
          ];
        };
      };
    };
}
