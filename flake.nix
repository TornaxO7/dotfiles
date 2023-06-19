{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixneovim.url = "github:nixneovim/nixneovim";
    # nixneovim.url = "path:/home/tornax/Programming/pull_requests/NixNeovim";
    nixneovimplugins.url = "github:jooooscha/nixpkgs-vim-extra-plugins";
  };

  outputs = { nixpkgs, home-manager, nixneovim, nixneovimplugins, ... }:
    let
      init_system =
        { configuration
        , system ? "x86_64-linux"
        , extra-modules ? [ ]
        , extra-home-manager-modules ? [ ]
        ,
        }: nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            ./shared/default.nix
            home-manager.nixosModules.home-manager
            configuration
          ] ++ extra-modules;

          specialArgs = {
            inherit home-manager nixneovim nixneovimplugins;
          };
        };
    in
    {
      nixosConfigurations = {
        pc = init_system {
          configuration = ./nixos-configurations/pc;
          extra-modules = [
            ./shared/desktop/default.nix
            ./modules/yubikey
          ];
        };

        laptop = init_system {
          configuration = ./nixos-configurations/laptop;
          extra-modules = [
            ./shared/desktop/default.nix
            ./modules/yubikey
          ];
        };
      };
    };
}
