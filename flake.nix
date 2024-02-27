{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    helix.url = "github:helix-editor/helix/master";
    wired.url = "github:Toqozz/wired-notify";
    rio.url = "github:raphamorim/rio";
    # yazi.url = "github:sxyazi/yazi";
    gtt.url = "github:TornaxO7/gtt/add-flake";

    rust-overlay.url = "github:oxalica/rust-overlay";

    flake-parts.url = "github:hercules-ci/flake-parts";

    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs = inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit self inputs; } {
      imports = [
        ./systems/default.nix
        ./modules/deploy.nix
        ./shell
      ];

      systems = [ "x86_64-linux" ];

      perSystem = { system, pkgs, ... }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = with inputs; [
            rust-overlay.overlays.default
          ];
        };

        packages = {
          bustd = pkgs.callPackage ./pkgs/bustd.nix { };
        };
      };

      flake = {
        nixosModules.bustd = import ./nixosModules/bustd.nix self;

        homeManagerModules = {
          gtt = import ./homeManagerModules/gtt.nix;
        };
      };
    };
}
