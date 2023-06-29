{ pkgs, ... }:
{
  config.home.packages = with pkgs; [
    arandr
    discord
    flameshot
    google-chrome
    pavucontrol
    playerctl
    pulseaudio
    redshift
    signal-desktop
    spotify
    texlive.combined.scheme-full
    yubikey-manager-qt
    xclip
  ];
}
