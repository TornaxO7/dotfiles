{ inputs, pkgs, lib, config, system, ... }:
let
  inherit (lib) makeBinPath;
in
{
  config = {
    environment.systemPackages = [ inputs.agenix.packages.${system}.default ];

    age.ageBin = "PATH=${makeBinPath [pkgs.age-plugin-yubikey]}:$PATH ${pkgs.rage}/bin/rage";
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
