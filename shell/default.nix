{ inputs, pkgs ? import <nixpkgs> { }, devenv }:
{
  default = pkgs.mkShell {
    packages = with pkgs; [ home-manager rage age-plugin-yubikey ];

    shellHook = import ./shared_hook.nix;
  };

  rs = devenv.lib.mkShell {
    inherit inputs pkgs;


    modules = [
      ({ pkgs, ... }: {
        languages.rust = {
          enable = true;
          channel = "stable";
        };
      })
    ];
  };

  rsm = import ./rust/mold.nix { inherit pkgs; };
  rsn = import ./rust/nightly.nix { inherit pkgs; };
  hs = devenv.lib.mkShell {
    inherit inputs pkgs;

    modules = [
      ({ pkgs, ... }: {
        languages.haskell.enable = true;

        packages = with pkgs.haskellPackages; [
          random
        ];
      })
    ];
  };

  py = devenv.lib.mkShell {
    inherit inputs pkgs;

    modules = [
      ({ pkgs, ... }: {
        languages.python = {
          enable = true;

          package = (pkgs.python3.withPackages (ps: with ps; [
            numpy
            matplotlib
            pandas
            scikit-learn
          ]));
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
