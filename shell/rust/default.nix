{ pkgs }:
pkgs.mkShell rec {
  packages = with pkgs; [ rust-bin.stable.latest.default ];

  buildInputs = with pkgs; [
    rustup

    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
    xorg.libxkbfile
    xorg.xkbutils
    xorg.xkbevd
    xorg.libXScrnSaver
    libxkbcommon

    dbus
    pango

    pkg-config

    cargo-nextest
    cargo-cross

    shaderc
    directx-shader-compiler
    libGL
    vulkan-headers
    vulkan-loader
    vulkan-tools
    vulkan-tools-lunarg
    vulkan-validation-layers

    pcsctools
    pcsclite

    cmake
    fontconfig
  ];

  shellHook = import ../shared_hook.nix;

  VK_LAYER_PATH = "${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d";
  LD_LIBRARY_PATH = "$LD_LIBRARY_PATH:${builtins.toString (pkgs.lib.makeLibraryPath buildInputs)}";
}
