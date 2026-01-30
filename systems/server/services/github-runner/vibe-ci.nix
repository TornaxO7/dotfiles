{ config, inputs, ... }:
let
  user = config.users.users.tornax.name;
  group = config.users.users.tornax.group;
in
{
  age.secrets = {
    github-nix-ci = {
      file = ../../../../secrets/github-runner/TornaxO7.token.age;
      owner = config.containers.vibe-ci.config.services.github-runners.vibe.user;
    };
  };

  containers.vibe-ci = {
    autoStart = true;

    bindMounts.token = {
      hostPath = config.age.secrets.github-nix-ci.path;
      isReadOnly = true;
      mountPoint = "/mnt/token";
    };

    config = { pkgs, ... }:
      let
        workDir = "/var/ci";
      in
      {
        imports = [
          inputs.agenix.nixosModules.default
        ];

        config = {
          systemd.tmpfiles.rules = [
            "d ${workDir} 0755 ${user} ${group} -"
          ];

          users = {
            users = {
              tornax = {
                name = user;
                group = group;
                isSystemUser = true;
              };
            };

            groups.tornax = { };
          };

          nix = {
            package = pkgs.lix;

            settings = {
              experimental-features = [ "nix-command" "flakes" ];
              auto-optimise-store = true;
            };
          };

          services = {
            resolved.enable = true;

            github-runners.vibe = {
              enable = true;
              url = "https://github.com/TornaxO7/vibe";
              user = user;
              tokenFile = config.containers.vibe-ci.bindMounts.token.mountPoint;
              workDir = workDir;
            };
          };

          networking.useHostResolvConf = false;

          hardware.graphics.enable = true;

          system.stateVersion = "22.11";
          time.timeZone = "Europe/Berlin";
        };
      };
  };
}
