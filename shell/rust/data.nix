{ pkgs, rust-toolchain }:
rec {
  packages = with pkgs; [
    evcxr
  ] ++ [ rust-toolchain ];

  buildInputs = with pkgs; [
    rustup
    dbus
    pango

    cargo-nextest
    cargo-cross

    shaderc
    directx-shader-compiler
    vulkan-tools
    # vulkan-tools-lunarg

    pcsc-tools
    pcsclite

    cmake
    fontconfig

    wayland

    vulkan-validation-layers
    vulkan-headers
    vulkan-loader

    libGL

    libX11
    libXcursor
    libXrandr
    libXi
    libxkbfile
    xkbutils
    xkbevd
    libXScrnSaver
    libxkbcommon
  ];

  nativeBuildInputs = with pkgs; [
    pkg-config
  ];

  shellHook = import ../shared_hook.nix;

  # VK_LAYER_PATH = "${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d";
  LD_LIBRARY_PATH = "$LD_LIBRARY_PATH:${builtins.toString (pkgs.lib.makeLibraryPath buildInputs)}";

  CARGO_BUILD_RUSTDOCFLAGS = "--default-theme=ayu";
}
