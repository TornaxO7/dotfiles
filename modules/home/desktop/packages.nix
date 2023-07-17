{ pkgs, ... }:
{
  config.home.packages = with pkgs; [
    anki-bin
    arandr
    authy
    bitwarden
    discord
    element-desktop
    flameshot
    google-chrome
    pavucontrol
    playerctl
    pulseaudio
    redshift
    signal-desktop
    simplescreenrecorder
    spotify
    texlive.combined.scheme-full
    vimiv-qt
    xclip
    xournalpp
    yubikey-manager-qt
  ];
}
