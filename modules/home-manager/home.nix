username: { inputs, ... }:
{
  imports = [
    ./packages.nix
    ./session_paths.nix
    ./session_variables.nix
    ./programs
    ./services.nix

    inputs.nix-colors.homeManagerModules.default
  ];

  config = {
    colorScheme = inputs.nix-colors.colorSchemes.tokyo-night-storm;

    home = {
      inherit username;
      homeDirectory = "/home/${username}";

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
