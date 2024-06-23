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
    , home-configuration
    , user ? "tornax"
    , system ? "x86_64-linux"
    }: inputs.stable.lib.nixosSystem
      {
        inherit system;

        modules = coreModules ++ [ configuration ];
        specialArgs = {
          inherit inputs home-configuration system self;
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
      home-configuration = ./pc/home/default.nix;
    };

    laptop = mkSystem {
      configuration = ./laptop/default.nix;
      home-configuration = ./laptop/home/default.nix;
    };
  };
}
