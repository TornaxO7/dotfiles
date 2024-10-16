{ self, pkgs, unstable, ... }:
let
  custom-packages = with self.packages.${pkgs.system}; [
    # crates-tui
  ];

  unstable-packages = with unstable; [
    compose2nix
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
    trashy
    tokei
    udisks
  ];
in
{
  home.packages = custom-packages ++ nixpkgs-packages ++ unstable-packages;
}
