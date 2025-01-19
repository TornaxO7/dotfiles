{ inputs, ... }:
let
  add-secret = path: {
    owner = "root";
    group = "crowdsec";
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
    };
  };
}
