{ pkgs }:
pkgs.mkShell rec {
  packages = with pkgs; [
    openssl
  ];

  LD_LIBRARY_PATH = "${builtins.toString (pkgs.lib.makeLibraryPath packages)}";
}
