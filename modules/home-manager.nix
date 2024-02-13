{ inputs, config, username, hmModules, ... }: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    sharedModules = [
      ../home/default.nix
      inputs.gtt.homeManagerModules.default
      inputs.wired.homeManagerModules.default
    ];
    extraSpecialArgs = {
      inherit inputs;
      age = config.age;
    };
  };

  home-manager.users.${username} = { ... }: {
    imports = hmModules;
  };
}
