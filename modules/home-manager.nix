{ self, inputs, config, username, home-configuration, ... }: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    sharedModules = [
      self.homeManagerModules.gtt
      inputs.wired.homeManagerModules.default
      inputs.bs.homeManagerModules.bugstalker
    ];
    extraSpecialArgs = {
      inherit inputs;
      age = config.age;
      my_flake = self;
    };

    backupFileExtension = "backup";
  };

  home-manager.users.${username} = { ... }: {
    imports = [
      home-configuration
      ../home/default
    ];
  };
}
