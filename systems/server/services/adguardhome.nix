{ config, lib, wg, ... }:
let
  domain = "dns.${wg.server.host}";
in
{
  networking.firewall.interfaces."wg0" = {
    # for ui
    allowedTCPPorts = [ 3000 ];
    # for dns requests
    allowedUDPPorts = [ 53 ];
  };

  services = {
    adguardhome = {
      enable = true;
      host = wg.server.addr;
      settings = {
        http = {
          address = wg.server.addr;
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
            domain = "*.${wg.nas.host}";
            answer = wg.nas.addr;
            enabled = true;
          }
          {
            domain = "*.${wg.server.host}";
            answer = wg.server.addr;
            enabled = true;
          }
        ];

        dns = rec {
          bind_hosts = [ wg.server.addr ];
          port = 53;
          ratelimit = 0;
          anonymize_client_ip = false;
          edns_client_subnet.enabled = true;
          upstream_dns = [
            # -- adguard
            "https://dns.adguard-dns.com/dns-query"
            "tls://dns.adguard-dns.com"
            "quic://dns.adguard-dns.com"
            "sdns://AQIAAAAAAAAAETk0LjE0MC4xNC4xNDo1NDQzINErR_JS3PLCu_iZEIbq95zkSV2LFsigxDIuUso_OQhzIjIuZG5zY3J5cHQuZGVmYXVsdC5uczEuYWRndWFyZC5jb20"
            "sdns://AQIAAAAAAAAAGFsyYTEwOjUwYzA6OmFkMTpmZl06NTQ0MyDRK0fyUtzywrv4mRCG6vec5EldixbIoMQyLlLKPzkIcyIyLmRuc2NyeXB0LmRlZmF1bHQubnMxLmFkZ3VhcmQuY29t"

            # -- cloudflare
            "tls://one.one.one.one"

            # -- google
            "https://dns.google/dns-query"
            "tls://dns.google"

            # -- quad
            "sdns://AQMAAAAAAAAADDkuOS45Ljk6ODQ0MyBnyEe4yHWM0SAkVUO-dWdG3zTfHYTAC4xHA2jfgh2GPhkyLmRuc2NyeXB0LWNlcnQucXVhZDkubmV0"
            "sdns://AQMAAAAAAAAAElsyNjIwOmZlOjpmZV06ODQ0MyBnyEe4yHWM0SAkVUO-dWdG3zTfHYTAC4xHA2jfgh2GPhkyLmRuc2NyeXB0LWNlcnQucXVhZDkubmV0"
            "https://dns.quad9.net/dns-query"
            "tls://dns.quad9.net"

            # -- dns.sb
            "https://doh.dns.sb/dns-query"
            "tls://dot.sb"
          ];

          bootstrap_dns = [
            # -- adguard
            "94.140.14.14"
            "94.140.15.15"
            "2a10:50c0::ad1:ff"
            "2a10:50c0::ad2:ff"

            # -- cloudflare
            "1.1.1.1"
            "1.0.0.1"
            "2606:4700:4700::1111"
            "2606:4700:4700::1001"

            # -- google
            "8.8.8.8"
            "8.8.4.4"
            "2001:4860:4860::8888"
            "2001:4860:4860::8844"

            # -- quad
            "9.9.9.9"
            "149.112.112.112"
            "2620:fe::fe"
            "2620:fe::9"

            # -- dns.sb
            "185.222.222.222"
            "45.11.45.11"
            "2a09::"
            "2a11::"
          ];

          fallback_dns = bootstrap_dns;

          upstream_mode = "parallel";
        };

        clients.persistent = map (lib.mergeAttrs { use_global_settings = true; }) [
          {
            name = "server";
            ids = [ wg.server.addr ];
          }
          {
            name = "pc";
            ids = [ wg.pc.addr ];
          }
          {
            name = "nas";
            ids = [ wg.nas.addr ];
          }
          {
            name = "laptop";
            ids = [ wg.laptop.addr ];
          }
          {
            name = "mobile";
            ids = [ wg.mobile.addr ];
          }
        ];

        dhcpcd.enabled = false;
        statistics.enabled = true;
        tls.enabled = false;
      };
    };

    traefik.dynamicConfigOptions.http = {
      routers.dns = {
        rule = "Host(`${domain}`)";
        entryPoints = [ "http-vpn" ];
        service = "adguard";
      };

      services.adguard.loadbalancer.servers = [
        {
          url = "http://${config.services.adguardhome.host}:${toString config.services.adguardhome.port}";
        }
      ];
    };
  };
}
