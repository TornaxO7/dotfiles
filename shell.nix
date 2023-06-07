{ pkgs ? import <nixpkgs> {} }: pkgs.mkShell {
    packages = [pkgs.git pkgs.zsh];
}
