{ ... }:
{
  imports = [
    ./desktop/default.nix
    ./desktop/xorg/default.nix
    ./desktop/xorg/i3.nix
    ./syncthing.nix
  ];
}
