{ inputs, my_flake, pkgs, system, ... }:
let
  custom-packages = with my_flake.packages.${system}; [
    crates-tui
  ];

  inputs-packages = [
    inputs.iamb.packages.${system}.default
  ];

  nixpkgs-packages = with pkgs; [
    act
    actionlint
    ast-grep
    bandwhich
    choose
    distrobox
    python311Packages.deepl
    difftastic
    du-dust
    evcxr
    fd
    fend
    ffmpeg_6-full
    file
    fira-code
    fira-code-symbols
    gcc13
    gptfdisk
    gpg-tui
    highlight
    hyperfine
    imagemagick
    irssi
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
    pkg-config
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
    youtube-dl
  ];
in
{
  home.packages = custom-packages ++ nixpkgs-packages ++ inputs-packages;
}
