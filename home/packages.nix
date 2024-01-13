{ pkgs, ... }:
{
  home.packages = with pkgs; [
    act
    ast-grep
    bandwhich
    choose
    devenv
    difftastic
    du-dust
    fd
    fend
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
    pastel
    pkg-config-unwrapped
    pomsky
    powertop
    python312
    ripgrep
    ripgrep-all
    rsync
    rustic-rs
    sd
    speedtest-cli
    spotify-player
    tailspin
    termusic
    tokei
    udisks
    vifm-full
    wiki-tui
    wormhole-rs
    yt-dlp
  ];
}
