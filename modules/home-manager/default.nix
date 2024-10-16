username: home-configuration: { self, inputs, config, unstable, ... }:
let
  main-home-conf = import ./home.nix;
in
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
        inputs.bs.homeManagerModules.bugstalker
      ];
      extraSpecialArgs = {
        inherit inputs unstable;
        age = config.age;
        my_flake = self;
      };

      backupFileExtension = "backup";
    };

    home-manager.users.main = { ... }: {
      imports = [ (main-home-conf username) home-configuration ];
    };
  };
}
