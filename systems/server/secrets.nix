{ inputs, config, ... }:
let
  add-secret = path: {
    owner = config.users.users.main.name;
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
      secrets = { };
    };
  };
}
