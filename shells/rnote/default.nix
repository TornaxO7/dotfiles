let
  rust-overlay = builtins.fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz";

  pkgs = import <nixpkgs> {
    overlays = [(import rust-overlay)];
  };

  toolchain = pkgs.rust-bin.fromRustupToolchainFile ./toolchain.toml;
  cairopkg = pkgs.callPackage ./cairo.nix {};
in
  pkgs.mkShell {
    packages = [
      toolchain
      cairopkg
    ];

    inputsFrom = with pkgs; [
      rnote
    ];

    GSETTINGS_SCHEMA_DIR = "/home/tornax/.local/share/glib-2.0/schemas";
  }