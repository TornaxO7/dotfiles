let
  rust-overlay = builtins.fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz";

  pkgs = import <nixpkgs> {
    overlays = [ (import rust-overlay) ];
  };

  toolchain = pkgs.rust-bin.fromRustupToolchainFile ./toolchain.toml;
in
pkgs.mkShell rec {
  packages = [ toolchain ];

  buildInputs = with pkgs; [
    rustup

    xorg.libX11 xorg.libXcursor xorg.libXrandr xorg.libXi

    pkg-config

    shaderc directx-shader-compiler libGL
    vulkan-headers vulkan-loader vulkan-tools vulkan-tools-lunarg
    vulkan-validation-layers
  ];

  shellHook = ''
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${builtins.toString (pkgs.lib.makeLibraryPath buildInputs)}";
  '';
}
