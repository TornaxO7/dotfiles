{ pkgs ? import <nixpkgs> { } }:
let
in
{
  default = pkgs.mkShell {
    shellHook = ''
      echo "success";
    '';
  };

  rs = import ./rust { inherit pkgs; };
  hs = import ./haskell { inherit pkgs; };
  py = import ./python { inherit pkgs; };
}
