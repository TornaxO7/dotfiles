{ lib, ts-ip, ts-ips, ... }:
let
  ip-addr = ts-ip;
in
{
  networking.firewall.interfaces."tailscale0" = {
    # for ui
    allowedTCPPorts = [ 3000 ];
    # for dns requests
    allowedUDPPorts = [ 53 ];
  };

  services.adguardhome = {
    enable = true;
    host = ip-addr;
    settings = {
      http = {
        address = ip-addr;
        pprof.enabled = false;
      };

      theme = "dark";
      language = "en";

      users = [
        {
          name = "main";
          password = "$2y$10$XKlxY4De85EPwIMBaNWHJu2c0d.mjcwMTXA2ehen2HFv/DTQx7WUq";
        }
      ];

      filters = [
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
          name = "AdGuard DNS filter";
          id = 1;
        }
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_2.txt";
          name = "AdAway Default Blocklist";
          id = 2;
        }
      ];

      filtering.rewrites = [
        {
          domain = "*.nas.local";
          answer = ts-ips.nas;
        }
        {
          domain = "*.server.local";
          answer = ts-ips.server;
        }
      ];

      dns = {
        bind_hosts = [ ip-addr ];
        port = 53;
        ratelimit = 0;
        anonymize_client_ip = false;
        upstream_dns = [
          # -- adguard
          "tls://94.140.14.14"
          "tls://94.140.15.15"

          # -- cloudflare
          "tls://1.1.1.1"
          "tls://1.0.0.1"

          # -- mullvad
          "tls://base.dns.mullvad.net"
          "https://base.dns.mullvad.net/dns-query"
        ];

        bootstrap_dns = [
          # -- adguard
          "tls://94.140.14.14"
          "tls://94.140.15.15"

          # -- cloudflare
          "tls://1.1.1.1"
        ];

        fallback_dns = [
          "1.1.1.1"

          # adguard
          "94.140.14.14"
          "94.140.15.15"
        ];

        upstream_mode = "fastest_addr";
      };

      clients.persistent =
        let
          converter = hostname: ts-ip-addr: {
            name = hostname;
            ids = [ ts-ip-addr ];
            use_global_settings = true;
          };
        in
        lib.attrsets.mapAttrsToList converter ts-ips;

      dhcpcd.enabled = false;
      statistics.enabled = true;
      tls.enabled = false;
    };
  };
}
