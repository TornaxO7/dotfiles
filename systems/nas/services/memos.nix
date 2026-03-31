{ config, wg1, zpool-root, ... }:
let
  port = 49205;
in
{
  networking.firewall.allowedTCPPorts = [ port ];

  services.memos = {
    enable = true;
    dataDir = "${zpool-root}/memos";

    settings = {
      MEMOS_MODE = "prod";
      MEMOS_ADDR = wg1.nas.addr;
      MEMOS_PORT = toString port;
      MEMOS_DRIVER = "sqlite";
      MEMOS_DATA = config.services.memos.dataDir;
    };
  };
}
