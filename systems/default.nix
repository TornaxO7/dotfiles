{ self, inputs, ... }:
let
  coreModules = [
    ../modules/default.nix
    ../secrets/default.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.agenix.nixosModules.default

    self.nixosModules.bustd

    ({ ... }: {
      nix.registry = {
        my.flake = self;
        unstable.flake = inputs.unstable;
      };
    })
  ];

  mkSystem =
    { configuration
    , user ? "tornax"
    , system ? "x86_64-linux"
    , modules ? [ ]
    , hmModules ? [ ]
    }: inputs.stable.lib.nixosSystem
      {
        inherit system;

        modules = coreModules ++ modules ++ [
          configuration
        ];

        specialArgs = {
          inherit inputs hmModules system self;
          username = user;
          unstable = import inputs.unstable {
            inherit system;
          };
        };
      };
in
{
  flake.nixosConfigurations = {
    pc = mkSystem {
      configuration = ./pc/default.nix;
      modules = [
        ../modules/desktop/default.nix
        ../modules/desktop/xorg/default.nix
        ../modules/desktop/xorg/i3.nix
        ../modules/game/steam.nix
        ../modules/yubikey/default.nix
        ../modules/udev_moonlander_rules.nix
        ../modules/kdeconnect.nix
      ];

      hmModules = [
        ./pc/home/default.nix
      ];
    };

    laptop = mkSystem {
      configuration = ./laptop/default.nix;
      modules = [
        ../modules/desktop/default.nix
        ../modules/desktop/xorg/default.nix
        ../modules/desktop/xorg/i3.nix
        ../modules/yubikey/default.nix
        ../modules/kdeconnect.nix
      ];

      hmModules = [
        ./laptop/home/default.nix
      ];
    };

    # nas = mkSystem {
    #   configuration = ./nas/default.nix;
    #   modules = [ ];
    # };
  };
}
