{ pkgs, ... }:
let
  username = "yetam";
in
{
  config = {
    users.users.yetam = {
      isNormalUser = true;
      name = username;
    };

    services.xserver.desktopManager.gnome.enable = true;

    home-manager.users.yetam.home = {
      inherit username;
      homeDirectory = "/home/${username}";

      keyboard = {
        layout = "de";
      };

      language.base = "en_US.UTF-8";
      stateVersion = "23.05";

      packages = with pkgs; [
        unityhub
        vscode
      ];
    };
  };
}
