{ self, inputs, lib, ... }:
let
  username = "tornax";
  unstable = import inputs.unstable { system = "x86_64-linux"; };

  hmModule = import ../modules/home-manager;
  sharedMainModule = import ../modules/default.nix;
  systemManager = import ./system-manager.nix;

  mkSystem =
    { configuration
    , home-configuration
    , hostname
    , specialArgs ? { }
    }: inputs.stable.lib.nixosSystem {
      specialArgs = lib.attrsets.recursiveUpdate specialArgs {
        inherit self inputs unstable;
      };
      modules = [
        configuration
        systemManager
        (hmModule username home-configuration)
        (sharedMainModule username hostname)
      ];
    };
in
{
  flake.nixosConfigurations = {
    pc = mkSystem {
      configuration = (import ./pc) username;
      home-configuration = ./pc/home;
      hostname = "pc";
    };

    laptop = mkSystem {
      configuration = ./laptop;
      home-configuration = ./laptop/home;
      hostname = "laptop";
    };

    nas = mkSystem {
      configuration = ./nas;
      home-configuration = ./nas/home;
      hostname = "nas";
      specialArgs = rec {
        zpool-name = "hdds";
        zpool-root = "/${zpool-name}";

        services-root = "/services";
      };
    };

    server = mkSystem {
      configuration = ./server;
      home-configuration = ./server/home;
      hostname = "server";
    };
  };
}
