{ pkgs, lib, key, ... }:
let
  inherit (lib) makeBinPath;
in
{
  config = {
    environment.systemPackages = with pkgs; [
      rage
      age-plugin-yubikey
    ];

    age.ageBin = "PATH=${makeBinPath [pkgs.age-plugin-yubikey]}:$PATH ${pkgs.rage}/bin/rage";
    age.identityPaths = [ key ];

    age.secrets = {
      paperless.file = ./paperless.age;
    };
  };
}
