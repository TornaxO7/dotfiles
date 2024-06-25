{ inputs, pkgs, lib, config, system, ... }:
let
  inherit (lib) makeBinPath;

  owner = config.users.users.tornax.name;
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
      deepl = {
        inherit owner;
        file = ./deepl.age;
      };

      tornax-nas = {
        inherit owner;
        file = ./tornax-nas.age;
      };

      discord-webhook = {
        inherit owner;
        file = ./discord-webhook.age;
      };
    };
  };
}
