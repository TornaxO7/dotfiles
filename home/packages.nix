{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ast-grep
    bandwhich
    choose
    difftastic
    du-dust
    fd
    ffmpeg_6-full
    file
    fira-code
    fira-code-symbols
    gcc13
    gptfdisk
    highlight
    hyperfine
    iamb
    imagemagick
    irssi
    jless
    liberation_ttf
    magic-wormhole-rs
    mdcat
    nix-index
    nodejs_20
    openvpn
    ouch
    pinentry
    pkg-config-unwrapped
    pomsky
    powertop
    pastel
    python312
    ripgrep
    ripgrep-all
    rsync
    rustic-rs
    sd
    speedtest-cli
    termusic
    tokei
    udisks
    vifm-full
    wiki-tui
    wormhole-rs
    yt-dlp
  ];
}
