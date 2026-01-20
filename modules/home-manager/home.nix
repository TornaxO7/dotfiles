{ config, inputs, ... }:
{
  imports = [
    ./packages.nix
    ./session_paths.nix
    ./session_variables.nix
    ./programs
    ./services.nix
  ];

  config = {
    colorScheme = inputs.nix-colors.colorSchemes.tokyo-night-storm;

    home = {
      username = config.users.users.main.name;
      homeDirectory = "/home/${config.users.users.main.name}";

      keyboard = {
        layout = "de";
        variant = "bone";
      };

      language.base = "en_US.UTF-8";
      stateVersion = "23.05";
    };

    nixpkgs.config.allowUnfree = true;
  };
}
