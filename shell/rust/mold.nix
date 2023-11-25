{ pkgs }:
let
  shell_description = import ./data.nix { inherit pkgs; }
    //
    {
      packages = with pkgs; [ rust-bin.stable.latest.default ];

      CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER = "${pkgs.llvmPackages.clangUseLLVM}/bin/clang";
      CARGO_ENCODED_RUSTFLAGS = "-Clink-arg=-fuse-ld=${pkgs.mold}/bin/mold";
    };
in
pkgs.mkShell shell_description
