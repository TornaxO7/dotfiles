{ pkgs, ... }:
{
  config.home.packages = with pkgs; [
    arandr
    discord
    element-desktop
    flameshot
    google-chrome
    pavucontrol
    playerctl
    pulseaudio
    redshift
    signal-desktop
    spotify
    texlive.combined.scheme-full
    xclip
    yubikey-manager-qt
  ];
}
