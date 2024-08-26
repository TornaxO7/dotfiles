{ ... }:
{
  config = {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };

    services.xserver.desktopManager.plasma5.enable = true;
  };
}
