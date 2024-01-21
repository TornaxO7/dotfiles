{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };


    helix.url = "github:helix-editor/helix/master";
    wired.url = "github:Toqozz/wired-notify";
    rio_term.url = "github:raphamorim/rio";
    yazi.url = "github:sxyazi/yazi";

    rust-overlay.url = "github:oxalica/rust-overlay";

    devenv.url = "github:cachix/devenv";
    deploy-rs.url = "github:serokell/deploy-rs";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , home-manager
    , agenix
    , wired
    , rust-overlay
    , helix
    , devenv
    , rio_term
    , deploy-rs
    , yazi
    , ...
    }:
    let
      forAllSystems = function:
        nixpkgs.lib.genAttrs [
          "x86_64-linux"
        ]
          (system: function (import nixpkgs {
            inherit system;

            overlays = [
              rust-overlay.overlays.default
            ];
          }));

      init_system = import ./nix/init-system.nix { inherit nixpkgs; };
    in
    {
      nixosConfigurations = {
        pc = init_system {
          configuration = ./nixos-configurations/pc/default.nix;
          key = ./secrets/identities/pc;
          modules = [
            ./secrets/default.nix
            agenix.nixosModules.default
          ];
        };

        laptop = init_system {
          configuration = ./nixos-configurations/laptop;
          key = ./secrets/identities/laptop;
        };
      };

      deploy.nodes.laptop = {
        hostname = "laptop";

        profiles = {
          system = {
            user = "root";
            path = deploy-rs.lib.${self.nixosConfigurations.laptop.pkgs.system}.activate.nixos self.nixosConfigurations.laptop;
          };

          home = {
            user = "tornax";
            path = deploy-rs.lib.${self.nixosConfigurations.laptop.pkgs.system}.activate.home-manager self.homeConfigurations."tornax@laptop";
          };
        };
      };

      homeConfigurations =
        let
          x86 = "x86_64-linux";
          pkgs = import nixpkgs {
            system = x86;

            overlays = [
              helix.overlays.default
              wired.overlays.default
              devenv.overlays.default
              yazi.overlays.default
              (final: prev: {
                rio = rio_term.packages.${x86}.default;
                deploy-rs = deploy-rs.packages.${x86}.default;
              })
            ];
          };

          sharedModules = [
            ./home
            ./home/desktop/default.nix
            ./home/desktop/xorg/default.nix
            ./home/desktop/xorg/i3.nix
            wired.homeManagerModules.default

            ({ ... }: {
              nix.registry = {
                my.flake = self;
                unstable.flake = inputs.nixpkgs;
              };
            })
          ];
        in
        {
          "tornax@pc" = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;

            modules = [
              ./nixos-configurations/pc/home/default.nix
            ] ++ sharedModules;
          };

          "tornax@laptop" = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;

            modules = [
              ./nixos-configurations/laptop/home/default.nix
            ] ++ sharedModules;
          };
        };

      devShells = forAllSystems (pkgs: import ./shell { inherit inputs pkgs; });

      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
