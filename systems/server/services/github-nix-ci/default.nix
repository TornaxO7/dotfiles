{ config, inputs, ... }:
{
  age.secrets = {
    github-nix-ci = {
      file = ../../../../secrets/github-nix-ci/TornaxO7.token.age;
    };
  };

  containers.github-nix-ci = {
    autoStart = true;

    bindMounts.token = {
      hostPath = config.age.secrets.github-nix-ci.path;
      isReadOnly = true;
      mountPoint = "/mnt/token";
    };

    config = { ... }: {
      imports = [
        inputs.github-nix-ci.nixosModules.default
        inputs.agenix.nixosModules.default
      ];

      config = {
        services.github-nix-ci = {
          personalRunners = {
            tokenFile = config.containers.github-nix-ci.bindMounts.token.mountPoint;
            "TornaxO7/vibe".num = 2;
          };
        };

        system.stateVersion = "25.05";
      };
    };
  };

}
