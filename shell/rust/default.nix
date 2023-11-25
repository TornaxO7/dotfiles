{ pkgs }:
let
  shell_description = import ./data { inherit pkgs; }
    //
    {
      packages = with pkgs; [ rust-bin.nightly.latest ];
    };
in
pkgs.mkShell shell_description
