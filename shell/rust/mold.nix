{ pkgs }:
let
  shell_description = import ./data.nix {
    inherit pkgs;
    rust-toolchain = pkgs.rust-bin.stable.latest.default;
  };
in
pkgs.mkShell.override
{
  stdenv = pkgs.stdenvAdapters.useMoldLinker pkgs.clangStdenv;
}
  shell_description
