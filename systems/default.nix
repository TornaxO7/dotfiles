{ self, inputs, ... }:
let
  coreModules = [
    ../modules/default.nix
    inputs.home-manager.nixosModules.home-manager

    ({ ... }: {
      nix.registry = {
        my.flake = self;
        unstable.flake = inputs.nixpkgs;
      };

      nixpkgs.overlays = with inputs; [
        helix.overlays.default
        wired.overlays.default
        devenv.overlays.default
        yazi.overlays.default
        (final: prev: {
          rio = rio_term.packages.${final.system}.default;
          deploy-rs = deploy-rs.packages.${final.system}.default;
        })
      ];
    })
  ];

  mkSystem =
    { configuration
    , key
    , user ? "tornax"
    , system ? "x86_64-linux"
    , modules ? [ ]
    , hmModules ? [ ]
    }: inputs.nixpkgs.lib.nixosSystem
      {
        inherit system;

        modules = coreModules ++ modules ++ [
          configuration

          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
            };

            home-manager.users.${user} = { ... }: {
              imports = [
                ../home/default.nix
              ] ++ hmModules;
            };
          }
        ];

        specialArgs = {
          inherit key;
          username = user;
        };
      };
in
{
  flake.nixosConfigurations = {
    pc = mkSystem {
      configuration = ./pc/default.nix;
      key = ./pc/identity;
      modules = [
        ../secrets
        inputs.agenix.nixosModules.default
        ../modules/desktop/default.nix
        ../modules/desktop/xorg/default.nix
        ../modules/desktop/xorg/i3.nix
        ../modules/game/steam.nix
        ../modules/yubikey/default.nix
        ../modules/udev_moonlander_rules.nix
        ../modules/kdeconnect.nix
        ../modules/paperless/default.nix
      ];

      hmModules = [
        inputs.wired.homeManagerModules.default

        ../home/desktop/default.nix
        ../home/desktop/xorg/default.nix
        ../home/desktop/xorg/i3.nix

        ./pc/home/default.nix
      ];
    };

    # laptop = mkSystem {
    #   configuration = ./laptop/default.nix;
    #   key = ./laptop/identity;
    #   modules = [
    #     ../modules/desktop/default.nix
    #     ../modules/desktop/xorg/default.nix
    #     ../modules/desktop/xorg/i3.nix
    #     ../modules/yubikey/default.nix
    #     ../modules/kdeconnect.nix
    #   ];

    #   hmModules = [
    #     inputs.wired.homeManagerModules.default

    #     ../home/desktop/default.nix
    #     ../home/desktop/xorg/default.nix
    #     ../home/desktop/xorg/i3.nix

    #     ./laptop/home/default.nix
    #   ];
    # };
  };
}
