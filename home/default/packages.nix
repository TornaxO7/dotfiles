{ my_flake, pkgs, ... }:
let
  custom-packages = with my_flake.packages.${pkgs.system}; [
    crates-tui
  ];

  nixpkgs-packages = with pkgs; [
    act
    ast-grep
    bandwhich
    choose
    difftastic
    distrobox
    du-dust
    evcxr
    fd
    fend
    ffmpeg_6-full
    file
    fira-code
    fira-code-symbols
    gcc13
    gpg-tui
    gptfdisk
    highlight
    hyperfine
    imagemagick
    jless
    liberation_ttf
    magic-wormhole-rs
    mdcat
    nix-index
    nodejs_20
    onefetch
    openvpn
    ouch
    pastel
    pferd
    pkg-config
    powertop
    python312
    ripgrep
    ripgrep-all
    rsync
    rustic-rs
    sd
    speedtest-cli
    spotify-player
    termusic
    tokei
    udisks
    youtube-dl
  ];
in
{
  home.packages = custom-packages ++ nixpkgs-packages;
}
