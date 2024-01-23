{ pkgs, lib, ... }:
{
  imports = [
    ./i3.nix
    ./i3status-rs.nix
    ./services.nix
  ];

  config = {
    home.packages = with pkgs; [
      cacert
      font-awesome
      xournalpp
    ];

    programs.rio.enable = true;

    xdg.configFile.vifm = {
      enable = true;
      # cache has to writeable so we have to do it that way
      source = lib.file.mkOutOfStoreSymlink /home/tornax/dotfiles/config/vifm;
      target = "vifm";
    };
  };
}
