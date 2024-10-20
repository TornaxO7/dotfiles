{ ... }:
{
  perSystem = { pkgs, ... }: {
    devShells = {

      rev = import ./rev.nix { inherit pkgs; };

      default = pkgs.mkShell {
        packages = with pkgs;
          [
            home-manager
            deploy-rs
          ];

        shellHook = import ./shared_hook.nix;
      };

      rs = import ./rust/default.nix { inherit pkgs; };
      rsm = import ./rust/mold.nix { inherit pkgs; };
      rsn = import ./rust/nightly.nix { inherit pkgs; };
      hs = import ./haskell/default.nix { inherit pkgs; };

      py =
        let
          packages = ps: with ps; [
            numpy
            matplotlib
            pandas
            scikit-learn
          ];
        in
        pkgs.python3.withPackages packages;

      c = pkgs.mkShell {
        packages = with pkgs; [
          libgcc
        ];
      };

      typst = import
        ./typst
        {
          inherit pkgs;
        };
    };
  };
}
