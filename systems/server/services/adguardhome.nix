utils: { config, services-root, domain-root, ts-ip, ts-ips, ... }:
{
  services.adguardhome = {
    enable = true;
    host = ts-ip;
    settings = {
      http = {
        address = ts-ip;
        pprof.enabled = false;
      };

      theme = "dark";
      language = "en";

      users = [
        {
          name = config.users.users.main.name;
          password = "$2y$10$y.8mAdOmnDQiFK7OfBYHjeOS9/9ib6pNMNmCqQnE7rMyQUa5bzlw6";
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
      ];

      dns = {
        bind_hosts = [ ts-ip ];
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
          # rabbit DNS
          "https://security.rabbitdns.org/dns-query"
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

        upstream_mode = "fastest_addr";
      };

      dhcpcd.enabled = false;
      statistics.enabled = true;
      tls.enabled = false;
    };
  };
}
