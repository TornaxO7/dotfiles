{ pkgs ? import <nixpkgs> { } }:
let
in
{ 
  default = pkgs.mkShell {
    shellHook = ''
      echo "success";
    '';
  };
}
