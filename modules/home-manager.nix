{ self, inputs, config, username, home-configuration, system, ... }: {
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
      inherit inputs system;
      age = config.age;
      my_flake = self;
    };

    backupFileExtension = "backup";
  };

  home-manager.users.${username} = { ... }: {
    imports = [ home-configuration ];
  };
}
