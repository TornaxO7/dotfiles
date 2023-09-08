{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ast-grep
    bandwhich
    borgbackup
    du-dust
    fd
    ffmpeg_6-full
    file
    fira-code
    fira-code-symbols
    firefox
    gcc13
    gptfdisk
    highlight
    iamb
    imagemagick
    irssi
    liberation_ttf
    nodejs_20
    openvpn
    ouch
    pinentry
    pkg-config-unwrapped
    powertop
    python312
    ripgrep
    # ripgrep-all
    rsync
    rustup
    speedtest-cli
    tokei
    udisks
    vifm-full
    wiki-tui
  ];
}
