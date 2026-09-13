{ self, inputs, lib, ... }:
let
  tld = "tornaxo7.de";

  wg0 = {
    # clients
    pc = {
      addr = "10.0.0.1";
      publicKey = "9ZdXIaUIlq6RZJiJvDGgOGzKjtz09VGRUgnmxsjUa1U=";
    };
    nas = {
      addr = "10.0.0.2";
      publicKey = "iq//654gWYsvFKAOcYNDRmbaYlsgk46NyX4vY2qOPxM=";
    };
    laptop = {
      addr = "10.0.0.3";
      publicKey = "uv2QNQNv5qpyh21Hj3cawSWHhz1SK2VgcfECk7fnCgc=";
    };
    mobile = {
      addr = "10.0.0.4";
      publicKey = "ifkaiOHyvb99Za8kaI/MD0WV39WyvTJ4o5YCGrCv1yE=";
    };
    ipad = {
      addr = "10.0.0.5";
      publicKey = "xXEMsTTfRS9iWxkNrS5IQgjVVCDrhceXxxVN6+mxdVo=";
    };

    # servers
    mini = {
      addr = "10.0.0.10";
      publicKey = "Gird3QH1s/eOpHJ2i2Xv3flYEOVSorKLFN3vsoL41nU=";
      host = "mini.vpn.${tld}";
    };

    small = {
      addr = "10.0.0.11";
      publicKey = "WLpImVPTt11gjkEcs5TpdzHDUWPm8vdMlHOGSNNx8Es=";
      host = "small.vpn.${tld}";
    };

    big = {
      addr = "10.0.0.12";
      publicKey = "PHvgf7n+aPJpJVxLz0g9H2JadIPCRvOeeN0azVsfXnw=";
      host = "big.vpn.${tld}";
    };

    netmask = "10.0.0.0/24";
    port = 53;
  };

  mkSystem =
    { config-module
    , hostname
    , system ? "x86_64-linux"
    , specialArgs ? { }
    }:
    let
      unstable = import inputs.unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    inputs.stable.lib.nixosSystem {
      specialArgs = lib.recursiveUpdate specialArgs {
        inherit self inputs unstable wg0 hostname tld;
      };

      modules = [
        ../modules/default.nix
        config-module
      ];
    };
in
{
  flake = {
    nixosConfigurations = {
      pc = mkSystem {
        config-module = ./pc;
        hostname = "pc";
      };

      laptop = mkSystem {
        config-module = ./laptop;
        hostname = "laptop";
      };

      nas = mkSystem {
        config-module = ./nas;
        hostname = "nas";
        specialArgs = rec {
          zpool-name = "hdds";
          zpool-root = "/${zpool-name}";

          services-root = "/services";
          root-domain = "nas.vpn.tornaxo7.de";
        };
      };

      mini = mkSystem {
        config-module = ./mini;
        hostname = "mini";
      };

      small = mkSystem {
        config-module = ./small;
        hostname = "small";
      };

      big = mkSystem {
        config-module = ./big;
        hostname = "big";
        specialArgs = {
          services-root = "/services";
        };
      };

      # nix build .#nixosConfigurations.iso.config.system.build.isoImage
      #
      # Just enter root automatically...
      iso = mkSystem {
        hostname = "iso";
        config-module =
          ({ modulesPath, pkgs, ... }: {
            imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") ];
            config = {
              nixpkgs.hostPlatform = "x86_64-linux";
              isoImage.squashfsCompression = "lz4";

              environment.systemPackages = with pkgs; [
                helix
              ];

              security = {
                sudo.enable = false;
                sudo-rs.enable = true;
              };
            };
          })
        ;
      };
    };

    # packages.x86_64-linux.iso = self.nixosConfigurations.iso.config.system.build.isoImage;
  };
}
