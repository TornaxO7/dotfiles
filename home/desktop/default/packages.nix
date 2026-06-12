{ pkgs, unstable, ... }:
let
  unstable-pkgs = with unstable; [
  ];

  stable-pkgs = with pkgs; [
    anki-bin
    arandr
    evince
    inlyne
    pavucontrol
    playerctl
    pulseaudio
    signal-desktop
    simplescreenrecorder
    spotify
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
