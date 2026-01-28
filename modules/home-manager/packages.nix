{ pkgs, unstable, ... }:
let
  unstable-packages = with unstable; [
    crates-tui
    dust
    fd
    jless
    mergiraf
    ouch
    ripgrep
    ripgrep-all
    rustic
    sd
    spotify-player
    television
    tokei
  ];

  stable-packages = with pkgs; [
    difftastic
    dig
    distrobox
    evcxr
    fend
    ffmpeg_6-full
    file
    fira-code
    fira-code-symbols
    libgcc
    gpg-tui
    gptfdisk
    hyperfine
    imagemagick
    liberation_ttf
    magic-wormhole-rs
    mdcat
    onefetch
    openvpn
    pastel
    pkg-config
    powertop
    python312
    rsync
    speedtest-cli
    trippy
    udisks
  ];
in
{
  home.packages = stable-packages ++ unstable-packages;
}
