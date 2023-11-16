{ pkgs ? import <nixpkgs> { } }:
{
  default = pkgs.mkShell {
    shellHook = ''
      echo "success";
    '';
  };

  rs = import ./rust { inherit pkgs; };
  hs = import ./haskell { inherit pkgs; };
  py = import ./python { inherit pkgs; };
  c = import ./c { inherit pkgs; };
}
