{ self, inputs, ... }:
let
  username = "tornax";

  mkSystem =
    { configuration
    , home-configuration
    , other ? { }
    }: { name, config, ... }: {
      imports = [ configuration ];

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        sharedModules = [
          ../home/default
          self.homeManagerModules.gtt
          inputs.wired.homeManagerModules.default
          inputs.bs.homeManagerModules.bugstalker
        ];
        extraSpecialArgs = {
          inherit inputs;
          age = config.age;
          my_flake = self;
        };
      };

      home-manager.users.${username} = { ... }: {
        imports = [ home-configuration ];
      };
    } // other;
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
          inputs.colemna.packages.${ pkgs.system}.colemna
        ];

        nix. registry = {
          my. flake = self;
          unstable.flake = inputs.unstable;
        };

        deployment.allowLocalDeployment = true;
      };

    pc = mkSystem {
      configuration = ../systems/pc;
      home-configuration = ../system/pc/home;

      other = {
        deployment.buildOnTarget = true;
      };
    };

    laptop = mkSystem {
      configuration = ../systems/laptop;
      home-configuration = ../systems/laptop/home;
    };

    nas = mkSystem {
      configuration = ../systems/nas;
      home-configuration = ../systems/nas;
    };

    # pc = { name, ... }: {
    #   imports = [
    #     ./systems/pc
    #   ];

    #   deployment.buildOnTarget = true;
    #   networking.hostName = name;
    # };

    # laptop = { name, ... }: {
    #   networking.hostName = name;
    # };

    # nas = { name, ... }: {
    #   networking.hostName = name;
    # };
  };
}
