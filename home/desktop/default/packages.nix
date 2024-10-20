{ pkgs, unstable, ... }:
let
  unstable-pkgs = with unstable; [
    joplin-desktop
  ];

  stable-pkgs = with pkgs; [
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
in
{
  config.home = {
    # for firefox
    sessionVariables = {
      MOZ_USE_XINPUT2 = "1";
    };

    packages = stable-pkgs ++ unstable-pkgs;
  };
}
