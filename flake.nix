{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }: 
  let
    init_system = {
      configuration,
      system ? "x86_64-linux",
      extra_modules ? [],
    }: nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        configuration
        ./nixos-configurations/shared/defaut.nix
        home-manager.nixosModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.tornax = import ./home/default.nix;
          };
        }
      ];
      specialArgs = {
      };
    };
  in
  {
    nixosConfigurations = {
      pc = init_system {
        configuration = ./nixos-configurations/pc;
      };
    };
  };
}