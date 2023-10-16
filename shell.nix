{ pkgs ? import <nixpkgs> { } }:
let
  cairo = pkgs.callPackage ./cairo.nix {};
in
{
  default = pkgs.mkShell {
    NIX_CONFIG = "extra-experimental-features = nix-command flakes";

    packages = with pkgs; [
      nix
      git
      home-manager

      gnupg
      rage
      age-plugin-yubikey
    ];
  };
}
