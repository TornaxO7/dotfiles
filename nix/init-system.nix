{ nixpkgs }:

{ configuration
, key
, system ? "x86_64-linux"
, modules ? [ ]
}: nixpkgs.lib.nixosSystem {
  inherit system;

  modules = [
    ../modules/default.nix
    configuration
  ] ++ modules;

  specialArgs = {
    inherit key;
  };
}
