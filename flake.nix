{
  description = "NixOS configuration";

  inputs = {
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-24.05";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "unstable";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "stable";

    helix.url = "github:helix-editor/helix/master";
    wired.url = "github:Toqozz/wired-notify";
    rio.url = "github:raphamorim/rio";
    yazi.url = "github:sxyazi/yazi";
    gtt.url = "github:TornaxO7/gtt/add-flake";
    iamb.url = "github:ulyssa/iamb";
    bs.url = "github:godzie44/BugStalker";
    deploy-rs.url = "github:serokell/deploy-rs";
    colemna.url = "github:zhaofengli/colmena";

    rust-overlay.url = "github:oxalica/rust-overlay";

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ self, flake-parts, stable, ... }:
    flake-parts.lib.mkFlake { inherit self inputs; } {
      imports = [
        # ./systems/default.nix
        # ./modules/deploy.nix
        ./modules/colemna.nix
        ./shell
      ];

      systems = [ "x86_64-linux" ];

      perSystem = { system, pkgs, ... }: {
        _module.args.pkgs = import inputs.unstable {
          inherit system;
          overlays = with inputs; [
            rust-overlay.overlays.default
          ];
        };

        packages = {
          bustd = pkgs.callPackage ./pkgs/bustd.nix { };
          crates-tui = pkgs.callPackage ./pkgs/crates-tui.nix { };
          prometheus-alertmanager = pkgs.callPackage ./pkgs/prometheus-alertmanager.nix { };
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
