let
  pkgs = import <nixpkgs> {};
in
pkgs.mkShell {
  packages = with pkgs; [
    manim
    python311

    python311Packages.numpy
    python311Packages.matplotlib
  ];
}
