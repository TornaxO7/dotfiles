{ pkgs ? import <nixpkgs> { } }:
{
  default = pkgs.mkShell {
    packages = with pkgs; [ home-manager ];

    shellHook = ''
      echo "success";
    '';
  };

  rs = import ./rust/default.nix { inherit pkgs; };
  rsm = import ./rust/mold.nix { inherit pkgs; };
  rsn = import ./rust/nightly.nix { inherit pkgs; };
  hs = import ./haskell { inherit pkgs; };
  py = import ./python { inherit pkgs; };
  c = import ./c { inherit pkgs; };
}
