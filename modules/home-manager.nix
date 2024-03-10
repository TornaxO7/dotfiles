{ self, inputs, config, username, hmModules, system, ... }: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    sharedModules = [
      ../home/default.nix
      self.homeManagerModules.gtt
      inputs.wired.homeManagerModules.default
    ];
    extraSpecialArgs = {
      inherit inputs system;
      age = config.age;
    };

    backupFileExtension = "backup";
  };

  home-manager.users.${username} = { ... }: {
    imports = hmModules;
  };
}
