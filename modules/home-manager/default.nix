system-home-config: { self, lib, inputs, config, unstable, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  config = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      sharedModules = [
        inputs.wired.homeManagerModules.default
        inputs.nix-colors.homeManagerModules.default
        # inputs.bs.homeManagerModules.bugstalker
      ];
      extraSpecialArgs = {
        inherit inputs unstable;
        age = config.age;
        my_flake = self;
      };

      backupFileExtension = "backup";
    };

    home-manager.users.tornax = { ... }: {
      imports = [
        system-home-config

        ./packages.nix
        ./session_paths.nix
        ./session_variables.nix
        ./programs
        ./services.nix
      ];

      config = {
        colorScheme = inputs.nix-colors.colorSchemes.tokyo-night-storm;

        home = {
          username = "tornax";
          homeDirectory = lib.mkDefault "/home/tornax";

          keyboard = {
            layout = "de";
            variant = "bone";
          };

          language.base = "en_US.UTF-8";
          stateVersion = "23.05";
        };

        nixpkgs.config.allowUnfree = true;
      };
    };
  };
}
