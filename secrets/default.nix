{ inputs, pkgs, lib, config, ... }:
let
  inherit (lib) makeBinPath;

  owner = config.users.users.main.name;
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
      deepl = {
        inherit owner;
        file = ./deepl.age;
      };
      harmonia = {
        inherit owner;
        file = ./harmonia.age;
      };
    };
  };
}
