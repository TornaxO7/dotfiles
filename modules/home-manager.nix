{ inputs, config, username, hmModules, system, ... }: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    sharedModules = [
      ../home/default.nix
      inputs.gtt.homeManagerModules.default
      inputs.wired.homeManagerModules.default
    ];
    extraSpecialArgs = {
      inherit inputs system;
      age = config.age;
    };
  };

  home-manager.users.${username} = { ... }: {
    imports = hmModules;
  };
}
