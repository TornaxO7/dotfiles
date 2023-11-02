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
    pavucontrol
    playerctl
    pulseaudio
    redshift
    rio
    slack
    signal-desktop
    simplescreenrecorder
    spotify
    texlive.combined.scheme-full
    thunderbird
    vimiv-qt
    xclip
    xournalpp
    yubikey-manager-qt
  ];
}
