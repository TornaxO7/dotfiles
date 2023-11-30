{ pkgs }:
pkgs.mkShell {
  packages = with pkgs; [
    typst
  ];

  shellHook = import ../shared_hook.nix;
}
