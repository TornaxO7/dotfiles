{ ... }:
{
  imports = [
    ./packages.nix
    ./session_paths.nix
    ./session_variables.nix
    ./programs
    ./services.nix
    ./xdg.nix
  ];
}
