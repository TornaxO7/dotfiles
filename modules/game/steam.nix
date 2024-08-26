{ ... }:
{
  config = {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };

    services.xserver.desktopManager.plasma5.enable = true;
  };
}
