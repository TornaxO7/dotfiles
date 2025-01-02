{ self, inputs, lib, ... }:
let
  username = "tornax";
  unstable = import inputs.unstable { system = "x86_64-linux"; };

  hmModule = import ../modules/home-manager;
  sharedMainModule = import ../modules/default.nix;

  wireguard = {
    server = "10.0.0.1";
    pc = "10.0.0.2";
    laptop = "10.0.0.3";
    nas = "10.0.0.4";
    mobile = "10.0.0.5";
  };

  mkSystem =
    { configuration
    , home-configuration
    , hostname
    , ip-addr
    , specialArgs ? { }
    }: inputs.stable.lib.nixosSystem {
      specialArgs = lib.attrsets.recursiveUpdate specialArgs {
        inherit self inputs unstable;
      };
      modules = [
        configuration
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
      ip-addr = wireguard.pc;
    };

    laptop = mkSystem {
      configuration = ./laptop;
      home-configuration = ./laptop/home;
      hostname = "laptop";
      ip-addr = wireguard.laptop;
    };

    nas = mkSystem {
      configuration = ./nas;
      home-configuration = ./nas/home;
      hostname = "nas";
      ip-addr = wireguard.nas;
      specialArgs = rec {
        zpool-name = "hdds";
        zpool-root = "/${zpool-name}";

        services-root = "/services";
        domain-root = "nas.local";
      };
    };

    server = mkSystem {
      configuration = ./server;
      home-configuration = ./server/home;
      hostname = "server";
      ip-addr = wireguard.server;
      specialArgs = {
        inherit wireguard;

        services-root = "/services";
        domain-root = "tornaxo7.de";
      };
    };
  };
}
