{
  description = "NixOS configuration";

  inputs = {
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-26.05";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "stable";

    nix-colors.url = "github:misterio77/nix-colors";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "unstable";

    helix.url = "github:helix-editor/helix/master";
    # rio.url = "github:raphamorim/rio";
    yazi.url = "github:sxyazi/yazi";
    bs.url = "github:godzie44/BugStalker";

    rust-overlay.url = "github:oxalica/rust-overlay";

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ self, flake-parts, stable, ... }:
    flake-parts.lib.mkFlake { inherit self inputs; } {
      imports = [
        ./systems
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
          # paperless-ngx = pkgs.callPackage ./pkgs/paperless-ngx.nix { };
        };
      };

      flake = {
        nixosModules.bustd = import ./nixosModules/bustd.nix self;

        homeConfigurations."tornax" =
          let
            system = "x86_64-linux";
            stable = import inputs.stable {
              inherit system;
            };

            unstable = import inputs.unstable {
              inherit system;
            };
          in
          inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = stable;

            modules = [ (import ./modules/home-manager/home.nix "tornax") ];
            extraSpecialArgs = {
              inherit unstable;
            };
          };

        homeManagerModules = {
          gtt = import ./homeManagerModules/gtt.nix;
        };
      };
    };
}
