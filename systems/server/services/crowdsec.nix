utils:
{ inputs, config, pkgs, ... }:
{
  imports = [
    inputs.crowdsec.nixosModules.crowdsec
    inputs.crowdsec.nixosModules.crowdsec-firewall-bouncer
  ];

  config = {
    nixpkgs.overlays = [ inputs.crowdsec.overlays.default ];

    age.secrets.crowdsec = {
      owner = "crowdsec";
      group = "crowdsec";
      file = ../../../../secrets/crowdsec.age;
    };

    services = {
      crowdsec-firewall-bouncer = {
        enable = true;
        settings = {
          api_url = "http://127.0.0.1:8080";
        };
      };

      crowdsec = {
        enable = true;
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
            hub_branch = "master";
            prometheus_uri = "127.0.0.1:6060";
          };
          api.server = {
            listen_uri = "127.0.0.1:8080";
          };
        };
      };
    };

    systemd.services.crowdsec.serviceConfig = {
      ExecStartPre =
        let
          script-name = "register-crowdsec-stuff";

          adder = category: owner: pkg-name: ''
            if ! cscli ${category} list | grep -q "${pkg-name}"; then
              cscli ${category} install ${owner}/${pkg-name}
            fi
          '';

          addBouncers = owner: pkg-name: adder "bouncers" owner pkg-name;
          addCollection = owner: pkg-name: adder "collections" owner pkg-name;

          # == actual script ==
          script = pkgs.writeScriptBin script-name ''
            #!${pkgs.runtimeShell}
            set -eu
            set -o pipefail

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
