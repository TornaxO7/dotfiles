{ self, inputs, lib, ... }:
let
  username = "tornax";
  unstable = import inputs.unstable { system = "x86_64-linux"; };

  hmModule = import ../modules/home-manager;
  sharedMainModule = import ../modules/default.nix;

  ts-ips = {
    pc = "100.64.0.1";
    nas = "100.64.0.2";
    laptop = "100.64.0.3";
    mobile = "100.64.0.4";
    server = "100.64.0.5";
  };

  mkSystem =
    { configuration
    , home-configuration
    , hostname
    , ts-ip
    , specialArgs ? { }
    }: inputs.stable.lib.nixosSystem {
      specialArgs = lib.attrsets.recursiveUpdate specialArgs {
        inherit self inputs unstable ts-ip ts-ips;
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
      ts-ip = ts-ips.pc;
    };

    laptop = mkSystem {
      configuration = ./laptop;
      home-configuration = ./laptop/home;
      hostname = "laptop";
      ts-ip = ts-ips.laptop;
    };

    nas = mkSystem {
      configuration = ./nas;
      home-configuration = ./nas/home;
      hostname = "nas";
      ts-ip = ts-ips.nas;
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
      ts-ip = ts-ips.server;
      specialArgs = {
        services-root = "/services";
        domain-root = "tornaxo7.de";
      };
    };
  };
}
