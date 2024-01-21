{ nixpkgs, agenix }:

{ configuration
, key
, system ? "x86_64-linux"
}: nixpkgs.lib.nixosSystem {
  inherit system;

  modules = [
    ../secrets/default.nix
    ../modules/default.nix
    agenix.nixosModules.default
    configuration
  ];

  specialArgs = {
    inherit key;
  };
}
