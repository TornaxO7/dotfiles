{ inputs, pkgs, lib, config, ... }:
let
  inherit (lib) makeBinPath;

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
    environment.systemPackages = [ inputs.agenix.packages.${pkgs.system}.default ];

    age.ageBin = "PATH=${makeBinPath [pkgs.age-plugin-yubikey]}:$PATH ${pkgs.rage}/bin/rage";
    age.identityPaths = [
      "/etc/ssh/pc"
      "/etc/ssh/laptop"
      "/etc/ssh/nas"
    ];

    age.secrets = {
      deepl = add-secret ./deepl.age;
      harmonia = add-secret ./harmonia.age;
      gotify-token = add-secret ./gotify-token.age;
    };
  };
}
