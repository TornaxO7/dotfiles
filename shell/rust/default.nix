{ pkgs }:
pkgs.mkShell (import ./data.nix {
  inherit pkgs;

  rust-toolchain = pkgs.rust-bin.stable.latest.default.override {
    extensions = [ "rust-src" "rust-analyzer" ];
  };
})
