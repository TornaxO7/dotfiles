{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix.url = "github:helix-editor/helix/master";
    wired.url = "github:Toqozz/wired-notify";
    rio_term.url = "github:raphamorim/rio";
    yazi.url = "github:sxyazi/yazi";

    rust-overlay.url = "github:oxalica/rust-overlay";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , home-manager
    , agenix
    , wired
    , rust-overlay
    , helix
    , rio_term
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

      init_system =
        { configuration
        , key
        , system ? "x86_64-linux"
        ,
        }: nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            ./secrets/default.nix
            ./modules/default.nix
            agenix.nixosModules.default
            configuration
          ];

          specialArgs = {
            inherit key;
          };
        };
    in
    {
      nixosConfigurations = {
        pc = init_system {
          configuration = ./nixos-configurations/pc/default.nix;
          key = ./secrets/identities/pc;
        };

        laptop = init_system {
          configuration = ./nixos-configurations/laptop;
          key = ./secrets/identities/laptop;
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
              yazi.overlays.default
              (final: prev: {
                rio = rio_term.packages.${x86}.default;
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
    };
}
