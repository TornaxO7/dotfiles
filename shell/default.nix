{ inputs, pkgs ? import <nixpkgs> { }, devenv }:
{
  default = pkgs.mkShell {
    packages = with pkgs; [ home-manager rage age-plugin-yubikey ];

    shellHook = import ./shared_hook.nix;
  };

  rs = import ./rust/default.nix { inherit pkgs; };
  rsm = import ./rust/mold.nix { inherit pkgs; };
  rsn = import ./rust/nightly.nix { inherit pkgs; };
  hs = import ./haskell { inherit pkgs; };

  py = devenv.lib.mkShell {
    inherit inputs pkgs;

    modules = [
      ({ pkgs, ... }: {
        languages.python = {
          enable = true;

          venv.enable = true;
          venv.requirements = ./requirements;
        };
      })
    ];
  };

  c = devenv.lib.mkShell
    {
      inherit inputs pkgs;

      modules = [
        ({ pkgs, ... }: {
          languages.c.enable = true;
        })
      ];
    };

  typst = import
    ./typst
    {
      inherit pkgs;
    };
}
