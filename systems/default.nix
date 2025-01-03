{ self, inputs, lib, ... }:
let
  username = "tornax";
  unstable = import inputs.unstable { system = "x86_64-linux"; };

  hmModule = import ../modules/home-manager;
  sharedMainModule = import ../modules/default.nix;

  ips = {
    pc = "100.64.0.1";
    nas = "100.64.0.2";
    laptop = "100.64.0.3";
    mobile = "100.64.0.4";
    server = null;
  };

  mkSystem =
    { configuration
    , home-configuration
    , hostname
    , ip-addr
    , specialArgs ? { }
    }: inputs.stable.lib.nixosSystem {
      specialArgs = lib.attrsets.recursiveUpdate specialArgs {
        inherit self inputs unstable ip-addr;
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
      ip-addr = ips.pc;
    };

    laptop = mkSystem {
      configuration = ./laptop;
      home-configuration = ./laptop/home;
      hostname = "laptop";
      ip-addr = ips.laptop;
    };

    nas = mkSystem {
      configuration = ./nas;
      home-configuration = ./nas/home;
      hostname = "nas";
      ip-addr = ips.nas;
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
      ip-addr = ips.server;
      specialArgs = {
        services-root = "/services";
        domain-root = "tornaxo7.de";
      };
    };
  };
}
