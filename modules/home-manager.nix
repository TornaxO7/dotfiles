home-configuration: { self, inputs, config, username, unstable, ... }: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    sharedModules = [
      self.homeManagerModules.gtt
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

  home-manager.users.${username} = { ... }: {
    imports = [
      home-configuration
      ../home/default
    ];
  };
}
