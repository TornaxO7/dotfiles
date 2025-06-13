{
  description = "NixOS configuration";

  inputs = {
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-25.05";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "unstable";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "stable";

    helix.url = "github:helix-editor/helix/master";
    wired.url = "github:Toqozz/wired-notify";
    ra-multiplex.url = "github:pr2502/ra-multiplex";
    rio.url = "github:raphamorim/rio";
    yazi.url = "github:sxyazi/yazi";
    gtt.url = "github:TornaxO7/gtt/add-flake";
    bs.url = "github:godzie44/BugStalker";
    wgsl-analyzer.url = "github:wgsl-analyzer/wgsl-analyzer";

    github-nix-ci.url = "github:juspay/github-nix-ci";

    crowdsec = {
      url = "git+https://codeberg.org/kampka/nix-flake-crowdsec.git";
      # inputs.nixpkgs.follows = "stable";
    };

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
