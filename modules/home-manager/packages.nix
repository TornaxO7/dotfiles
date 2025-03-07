{ my_flake, pkgs, unstable, ... }:
let
  custom-packages = with my_flake.packages.${pkgs.system}; [
  ];

  unstable-packages = with unstable; [
    compose2nix
    crates-tui
    du-dust
    fd
    jless
    mergiraf
    nps
    ouch
    ripgrep
    ripgrep-all
    rustic-rs
    sd
    spotify-player
    television
    tokei
  ];

  nixpkgs-packages = with pkgs; [
    bandwhich
    choose
    difftastic
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
    nodejs_20
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
  home.packages = custom-packages ++ nixpkgs-packages ++ unstable-packages;
}
