{ my_flake, pkgs, unstable, ... }:
let
  custom-packages = with my_flake.packages.${pkgs.system}; [
  ];

  unstable-packages = with unstable; [
    compose2nix
    mergiraf
    nps
    crates-tui
  ];

  nixpkgs-packages = with pkgs; [
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
    libgcc
    gpg-tui
    gptfdisk
    hyperfine
    imagemagick
    jless
    liberation_ttf
    magic-wormhole-rs
    mdcat
    nodejs_20
    onefetch
    openvpn
    ouch
    pastel
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
    television
    trippy
    tokei
    udisks
  ];
in
{
  home.packages = custom-packages ++ nixpkgs-packages ++ unstable-packages;
}
