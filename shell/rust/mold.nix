{ pkgs }:
let
  shell_description = import ./data.nix { inherit pkgs; }
    //
    {
      RUSTC_LINKER = "${pkgs.llvmPackages.clangUseLLVM}/bin/clang";
      RUSTFLAGS = "-Clink-arg=-fuse-ld=${pkgs.mold}/bin/mold";
    };
in
pkgs.mkShell shell_description
