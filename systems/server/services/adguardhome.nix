utils: { config, lib, services-root, domain-root, ts-ip, ts-ips, ... }:
let
  ip-addr = ts-ip;
in
{
  networking.firewall = {
    allowedTCPPorts = [ 3000 ];
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
        anonymize_client_ip = false;
        upstream_dns = [
          # adguard
          "tls://dns.adguard-dns.com"
          "https://dns.adguard-dns.com/dns-query"
          # cloudflare
          "https://security.cloudflare-dns.com/dns-query"
          "tls://security.cloudflare-dns.com"
          # mullvad
          "tls://extended.dns.mullvad.net"
          "https://extended.dns.mullvad.net/dns-query"
          # openbld.net
          "https://ada.openbld.net/dns-query"
          "tls://ada.openbld.net"
          # quad9 dns
          "https://dns.quad9.net/dns-query"
          "tls://dns.quad9.net"
          # rabbit DNS
          "https://security.rabbitdns.org/dns-query"
          # digitale gesellschaft
          "https://dns.digitale-gesellschaft.ch/dns-query"
          "tls://dns.digitale-gesellschaft.ch"
        ];

        bootstrap_dns = [
          "tls://1.1.1.1"
          "tls://1.0.0.1"
          "8.8.8.8"
          "8.8.4.4"
          "2001:4860:4860::8888"
          "9.9.9.10"
          "149.112.112.10"
          "2620:fe::10"
          "2620:fe::fe:10"
        ];

        fallback_dns = [
          "1.1.1.1"
          # adguard
          "94.140.14.14"
          "94.140.15.15"
        ];

        # upstream_mode = "fastest_addr";
        upstream_mode = "parallel";
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
