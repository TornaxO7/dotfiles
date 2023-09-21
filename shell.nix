{ pkgs ? import <nixpkgs> { } }:
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
