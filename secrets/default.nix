{pkgs, lib, ...}:
let
  inherit (lib) makeBinPath;

  pc_key = ./identities/pc;
  laptop_key = ./identities/laptop;
in
{
  config = {
    age.ageBin = "PATH=${makeBinPath [pkgs.age-plugin-yubikey]}:$PATH ${pkgs.rage}/bin/rage";
    age.identityPaths = [pc_key laptop_key];
  };
}
