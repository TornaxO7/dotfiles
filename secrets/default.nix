{ pkgs, lib, ... }:
let
  inherit (lib) makeBinPath;
in
{
  config = {
    environment.systemPackages = with pkgs; [
      rage
    ];

    age.ageBin = "PATH=${makeBinPath [pkgs.age-plugin-yubikey]}:$PATH ${pkgs.rage}/bin/rage";
    age.identityPaths = [
      "/etc/ssh/pc"
      "/etc/ssh/laptop"
    ];

    age.secrets = {
      paperless.file = ./paperless.age;
    };
  };
}
