{ pkgs, ... }:
{
  home.packages = with pkgs; [
    prismlauncher

    # https://github.com/NixOS/nixpkgs/issues/206378#issuecomment-1399327787
    alsa-oss

    jdk17
  ];
}
