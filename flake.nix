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
    rio_term.url = "github:raphamorim/rio";
    yazi.url = "github:sxyazi/yazi";

    rust-overlay.url = "github:oxalica/rust-overlay";

    flake-parts.url = "github:hercules-ci/flake-parts";

    devenv.url = "github:cachix/devenv";
    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs = inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit self inputs; } {
      imports = [
        ./systems/default.nix
        ./modules/deploy.nix
        ./shell
      ];

      flake.homeConfigurations."tornax@pc" =
        let
          system = "x86_64-linux";
          pkgs = import inputs.nixpkgs {
            inherit system;

            overlays = with inputs; [
              helix.overlays.default
              wired.overlays.default
              devenv.overlays.default
              yazi.overlays.default
              rust-overlay.overlays.default
              (final: prev: {
                rio = rio_term.packages.${final.system}.default;
                deploy-rs = deploy-rs.packages.${final.system}.default;
              })
            ];
          };
        in
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            inputs.wired.homeManagerModules.default

            ./home/desktop/default.nix
            ./home/desktop/xorg/default.nix
            ./home/desktop/xorg/i3.nix
            ./home/syncthing.nix
            ./home/default.nix

            ./systems/pc/home/default.nix
            ({ ... }: {
              home.sessionVariables = {
                PATH = "\"$PATH\":/home/tornax/.nix-profile/bin";
              };
            })
          ];
        };

      systems = [ "x86_64-linux" ];

      perSystem = { system, ... }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = with inputs; [
            helix.overlays.default
            wired.overlays.default
            devenv.overlays.default
            yazi.overlays.default
            rust-overlay.overlays.default
            (final: prev: {
              rio = rio_term.packages.${final.system}.default;
              deploy-rs = deploy-rs.packages.${final.system}.default;
            })
          ];
        };
      };
    };
}
