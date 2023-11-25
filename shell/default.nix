{ pkgs ? import <nixpkgs> { } }:
{
  default = pkgs.mkShell {
    shellHook = ''
      echo "success";
    '';
  };

  rs = pkgs.mkShell ((import ./rust/data.nix) { inherit pkgs; });
  rsm = import ./rust/mold.nix { inherit pkgs; };
  rsn = import ./rust/nightly.nix { inherit pkgs; };
  hs = import ./haskell { inherit pkgs; };
  py = import ./python { inherit pkgs; };
  c = import ./c { inherit pkgs; };
}
