{ self, inputs, ... }:
let
  coreModules = [
    ../modules/default.nix
    ../secrets/default.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.agenix.nixosModules.default

    ({ ... }: {
      nix.registry = {
        my.flake = self;
        unstable.flake = inputs.nixpkgs;
      };
    })
  ];

  mkSystem =
    { configuration
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
          inputs.nixos-cosmic.nixosModules.default

          self.nixosModules.bustd
        ];

        specialArgs = {
          inherit inputs hmModules system self;
          username = user;
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
        ../modules/desktop/cosmic.nix
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
  };
}
