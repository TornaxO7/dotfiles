let
  pkgs = import <nixpkgs> {};
in
pkgs.mkShell {
  packages = with pkgs; [
    haskell.compiler.native-bignum.ghcHEAD
    haskellPackages.stack
  ];
}
