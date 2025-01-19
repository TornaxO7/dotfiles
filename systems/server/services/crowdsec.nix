utils:
{ inputs, config, pkgs, ... }:
let
  crowdsec = "crowdsec";

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

    services = {
      crowdsec-firewall-bouncer = {
        enable = true;
        settings = {
          # no other choice at the moment
          api_key = bouncer-api-key;
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
