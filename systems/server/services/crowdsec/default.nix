utils:
{ inputs, config, pkgs, ... }:
{
  imports = [
    inputs.crowdsec.nixosModules.crowdsec
  ];

  config = {
    services.crowdsec = {
      enable = true;
      allowLocalJournalAccess = true;
      enrollKeyFile = config.age.secrets.crowdsec.path;
      settings = {
        cscli.hub_branch = "master";
        api.server = {
          listen_uri = "127.0.0.1:8080";
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

          # addBouncers = owner: pkg-name: adder "bouncers" owner pkg-name;
          addCollection = owner: pkg-name: adder "collections" owner pkg-name;

          # == actual script ==
          script = pkgs.writeScriptBin script-name ''
            #!${pkgs.runtimeShell}
            set -eu
            set -o pipefail

            ${addCollection "crowdsecurity" "linux"}
          '';
        in
        [ "${script}/bin/${script-name}" ];
    };
  };
}
