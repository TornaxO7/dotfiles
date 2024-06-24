{ ... }:
{
  imports = [
    ./desktop/default
    ./desktop/xorg/default.nix
    ./desktop/xorg/i3.nix
    ./syncthing.nix
  ];
}
