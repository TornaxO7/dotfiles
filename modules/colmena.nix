{ self, inputs, lib, ... }:
let
  username = "tornax";

  mkSystem =
    { configuration
    , home-configuration
    , extra-config ? { }
    , specialArgs ? { }
    }: { name, config, ... }: {
      imports = [ configuration ];

      config = lib.recursiveUpdate extra-config {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          sharedModules = [
            self.homeManagerModules.gtt
            inputs.wired.homeManagerModules.default
            inputs.bs.homeManagerModules.bugstalker
          ];
          extraSpecialArgs = lib.recursiveUpdate
            {
              inherit inputs;
              age = config.age;
              my_flake = self;
            }
            specialArgs;
        };

        networking.hostName = name;

        deployment.targetUser = username;

        home-manager.users.${username} = { ... }: {
          imports = [
            home-configuration
            ../home/default
          ];
        };
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

      nixpkgs = import inputs.stable {
        system = "x86_64-linux";
      };
    };

    defaults = { pkgs, ... }:
      {
        imports = [
          ./.
          ../secrets
          inputs.home-manager.nixosModules.home-manager
          inputs.agenix.nixosModules.default

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

        deployment.allowLocalDeployment = true;
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
      specialArgs = rec {
        zpool-name = "hdds";
        zpool-root = "/${zpool-name}";

        ip-addr = "100.88.51.57";
      };
    };
  };
}
