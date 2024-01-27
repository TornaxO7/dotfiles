{ pkgs }:
let
  shell_description = import ./data.nix {
    inherit pkgs;
    rust-toolchain = pkgs.rust-bin.stable.latest.default.override {
      extensions = [ "rust-src" "rust-analyzer" ];
    };
  };
in
pkgs.mkShell.override
{
  stdenv = pkgs.stdenvAdapters.useMoldLinker pkgs.clangStdenv;
}
  shell_description
