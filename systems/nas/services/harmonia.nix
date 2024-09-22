port: { config, ... }:
let
  portStr = toString port;
in
{
  networking.firewall.allowedTCPPorts = [ port ];

  services.harmonia = {
    enable = true;
    signKeyPath = config.age.secrets.harmonia.path;
    settings = {
      bind = "[::]:${portStr}";
      workers = 2;
      max_connection_rate = 1;
      priority = 30;
    };
  };
}
