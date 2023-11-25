{ pkgs }:
pkgs.mkShell (import ./data.nix {
  inherit pkgs;

  rust-toolchain = pkgs.rust-bin.selectLatestNightlyWith (toolchain: toolchain.default);
})
