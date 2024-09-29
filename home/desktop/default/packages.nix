{ pkgs, ... }:
{
  config.home.packages = with pkgs; [
    anki-bin
    arandr
    appflowy
    vesktop
    evince
    flameshot
    inlyne
    newsflash
    pavucontrol
    playerctl
    pulseaudio
    redshift
    slack
    signal-desktop
    simplescreenrecorder
    spotify
    thunderbird
    vimiv-qt
    xclip
    xournalpp
    # yubikey-manager-qt
  ];
}
