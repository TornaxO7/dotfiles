{ inputs, ... }:
let
  add-secret = path: {
    owner = "root";
    file = path;
  };
in
{
  imports = [
    inputs.agenix.nixosModules.default
  ];

  config = {
    age = {
      identityPaths = [
        "/etc/ssh/server"
      ];

      secrets = {
        crowdsec.file = ../../secrets/crowdsec.age;
      };
    };
  };
}
