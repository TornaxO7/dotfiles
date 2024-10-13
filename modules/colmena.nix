{ self, inputs, lib, ... }:
let
  username = "tornax";

  mkSystem =
    { configuration
    , home-configuration
    , extra-config ? { }
    , targetUser ? username
    }: { name, config, ... }: {
      imports = [
        configuration
        ((import ./home-manager.nix) home-configuration)
      ];

      config = lib.recursiveUpdate extra-config {
        networking.hostName = name;
        deployment.targetUser = targetUser;
      };
    };
in
{
  flake.colmena = {
    meta = {
      specialArgs = {
        inherit self inputs username;
        unstable = import inputs.unstable {
          system = "x86_64-linux";
        };
      };

      nodeSpecialArgs = {
        nas = rec {
          zpool-name = "hdds";
          zpool-root = "/${zpool-name}";

          services-root = "/services";
        };
      };

      nixpkgs = import inputs.stable {
        system = "x86_64-linux";
      };
    };

    defaults = { pkgs, ... }:
      {
        imports = [
          ./.
          ../secrets

          inputs.agenix.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
          self.nixosModules.bustd
        ];

        environment.systemPackages = [
          inputs.colmena.packages.${pkgs.system}.colmena
        ];

        nix.registry = {
          my.flake = self;
          unstable.flake = inputs.unstable;
          stable.flake = inputs.stable;
        };

        deployment = {
          allowLocalDeployment = true;
        };
      };

    pc = mkSystem {
      configuration = ../systems/pc;
      home-configuration = ../systems/pc/home;
      extra-config = {
        deployment = {
          buildOnTarget = true;
        };
      };
    };

    laptop = mkSystem {
      configuration = ../systems/laptop;
      home-configuration = ../systems/laptop/home;
    };

    nas = mkSystem {
      configuration = ../systems/nas;
      home-configuration = ../systems/nas/home;
    };

    server = mkSystem {
      configuration = ../systems/server;
      home-configuration = ../systems/server/home;
      extra-config = {
        deployment = {
          targetHost = "tornaxo7.de";
          targetUser = "colmena";
        };
      };
    };
  };
}
