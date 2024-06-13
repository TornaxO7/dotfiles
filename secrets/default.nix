{ inputs, config, system, ... }:
{
  config = {
    environment.systemPackages = [ inputs.agenix.packages.${system}.default ];

    age.identityPaths = [
      "/etc/ssh/pc"
      "/etc/ssh/laptop"
      "/etc/ssh/nas"
    ];

    age.secrets = {
      paperless.file = ./paperless.age;
      deepl = {
        owner = config.users.users.tornax.name;
        file = ./deepl.age;
      };
    };
  };
}
