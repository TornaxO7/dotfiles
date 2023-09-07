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
      forAllSystems = function:
        nixpkgs.lib.genAttrs [
          "x86_64-linux"
          "aarch64-linux"
        ]
          (system: function nixpkgs.legacyPackages.${system});

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
            ./modules/desktop/default.nix
            ./modules/desktop/xorg.nix
            ./modules/game/steam.nix
            ./modules/yubikey
            ./modules/udev_moonlander_rules.nix
          ];
        };

        laptop = init_system {
          configuration = ./nixos-configurations/laptop;
          extra-modules = [
            ./modules/desktop/default.nix
            ./modules/yubikey
          ];
        };
      };

      devShells = forAllSystems (pkgs: import ./shell.nix { inherit pkgs; });
    };
}
