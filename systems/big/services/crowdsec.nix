# Bouncers = Action handlers on given events
{ inputs, config, pkgs, ... }:
let
  crowdsec = "crowdsec";
  system = pkgs.system;

  ports = {
    firewall-bouncer = 49180;
    metrics = 49181;
  };

  bouncer-api-key = "h5naEQ8J73qF52uuzqdfAf9fhWfT53tJktpYqczkNYDJvnkxnMpEKx9EdVrcx7SL";
in
{
  imports = [
    inputs.crowdsec.nixosModules.crowdsec
    inputs.crowdsec.nixosModules.crowdsec-firewall-bouncer
  ];

  config = {
    nixpkgs.overlays = [ inputs.crowdsec.overlays.default ];

    age.secrets =
      let
        add-secret = file: {
          inherit file;
          owner = crowdsec;
          group = crowdsec;
        };
      in
      {
        crowdsec = add-secret ../../../secrets/crowdsec.age;
      };

    systemd.services.traefik = {
      requires = [ "crowdsec.service" ];
      serviceConfig = {
        ExecStartPre = "${pkgs.coreutils}/bin/sleep 3s";
      };
    };

    services = {
      crowdsec-firewall-bouncer = {
        enable = true;
        package = inputs.crowdsec.packages.${system}.crowdsec-firewall-bouncer;
        settings = {
          # API key to communicate with the local api of crowdsec
          api_key = bouncer-api-key;
          api_url = "http://127.0.0.1:${toString ports.firewall-bouncer}";
          scenarios_containing = [ "ssh" "http" ];

          nftables.set-only = false;
        };
      };

      crowdsec = {
        enable = true;
        package = inputs.crowdsec.packages.${system}.crowdsec;
        allowLocalJournalAccess = true;
        enrollKeyFile = config.age.secrets.crowdsec.path;
        acquisitions = [
          {
            source = "journalctl";
            journalctl_filter = [ "_SYSTEMD_UNIT=sshd.service" ];
            labels.type = "syslog";
          }
          {
            source = "journalctl";
            journalctl_filter = [ "-k" ];
            labels.type = "syslog";
          }
        ];
        settings = {
          cscli = {
            output = "human";
            hub_branch = "master";
            prometheus_uri = "127.0.0.1:${toString ports.metrics}";
          };
          api.server = {
            listen_uri = "127.0.0.1:${toString ports.firewall-bouncer}";
          };
        };
      };

      traefik = {
        staticConfigOptions = {
          experimental.plugins.crowdsec-bouncer-traefik-plugin = {
            moduleName = "github.com/maxlerebourg/crowdsec-bouncer-traefik-plugin";
            version = "v1.4.2";
          };

          entryPoints.https.http.middlewares = [ "crowdsec@file" ];
        };
        dynamicConfigOptions.http.middlewares = {
          crowdsec.plugin.crowdsec-bouncer-traefik-plugin = {
            CrowdsecMode = "stream";
            CrowdsecLapiScheme = "http";
            CrowdsecLapiHost = "127.0.0.1:${toString ports.firewall-bouncer}";
            CrowdsecLapiKey = "h5naEQ8J73qF52uuzqdfAf9fhWfT53tJktpYqczkNYDJvnkxnMpEKx9EdVrcx7SL";
            ClientTrustedIPs = [
              "100.64.0.0/10"
              "fd7a:115c:a1e0::/48"
            ];
            Enabled = true;
          };
        };
      };
    };

    systemd.services.crowdsec.serviceConfig = {
      ExecStartPre =
        let
          script-name = "register-crowdsec-stuff";

          addBouncers = bouncer-name: api-key: ''
            if ! cscli bouncers list | grep -q "${bouncer-name}"; then
              cscli bouncers add ${bouncer-name} --key "${api-key}"
            fi
          '';
          addCollection = owner: pkg-name: ''
            if ! cscli collections list | grep -q "${pkg-name}"; then
              cscli collections install ${owner}/${pkg-name}
            fi
          '';

          # == actual script ==
          script = pkgs.writeScriptBin script-name ''
            #!${pkgs.runtimeShell}
            set -eu
            set -o pipefail

            ${addBouncers "nftables-firewall" bouncer-api-key}

            ${addCollection "crowdsecurity" "linux"}
            ${addCollection "crowdsecurity" "sshd"}
            ${addCollection "crowdsecurity" "iptables"}
            ${addCollection "crowdsecurity" "traefik"}
            ${addCollection "crowdsecurity" "http-cve"}
            ${addCollection "crowdsecurity" "base-http-scenarios"}
            ${addCollection "crowdsecurity" "http-dos"}
          '';
        in
        [ "${script}/bin/${script-name}" ];
    };
  };
}
