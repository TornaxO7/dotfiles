{ self, inputs, lib, ... }:
let
  wg-keys = import ../modules/wg-keys.nix;

  # todo: declare wg networks
  wg0 = rec {
    server = {
      addr = "10.0.0.1";

      # mini
      # publicKey = "Gird3QH1s/eOpHJ2i2Xv3flYEOVSorKLFN3vsoL41nU=";
      # ip4 = "202.61.242.79";
      # ip6 = "2a03:4000:52:316::";
      # host = "mini.vpn.${domain}";

      # server
      ip4 = "2.56.97.207";
      ip6 = "2a03:4000:3e:26f::";
      publicKey = "PHvgf7n+aPJpJVxLz0g9H2JadIPCRvOeeN0azVsfXnw=";
      host = "server.vpn.${domain}";
    };
    pc = {
      addr = "10.0.0.2";
      publicKey = "9ZdXIaUIlq6RZJiJvDGgOGzKjtz09VGRUgnmxsjUa1U=";
      host = "pc.vpn.${domain}";
    };
    nas = {
      addr = "10.0.0.3";
      publicKey = "iq//654gWYsvFKAOcYNDRmbaYlsgk46NyX4vY2qOPxM=";
      host = "nas.vpn.${domain}";
    };
    laptop = {
      addr = "10.0.0.4";
      publicKey = "uv2QNQNv5qpyh21Hj3cawSWHhz1SK2VgcfECk7fnCgc=";
      host = "laptop.vpn.${domain}";
    };
    mobile = {
      addr = "10.0.0.5";
      publicKey = "ifkaiOHyvb99Za8kaI/MD0WV39WyvTJ4o5YCGrCv1yE=";
      host = "mobile.vpn.${domain}";
    };

    netmask = "10.0.0.0/24";
    domain = "tornaxo7.de";
    port = 49200;
    # port = 53; # (mini)
  };

  wg1 = {
    pc = {
      addr = "10.0.1.2";
    };
    nas = {
      addr = "10.0.1.3";
    };
    mobile = {
      addr = "10.0.1.5";
    };
    ipad = {
      addr = "10.0.1.6";
      publicKey = "xXEMsTTfRS9iWxkNrS5IQgjVVCDrhceXxxVN6+mxdVo=";
    };
    netmask = "10.0.1.0/24";
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
        inherit self inputs unstable wg0 wg1 hostname;
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

      server = mkSystem {
        config-module = ./server;
        hostname = "server";
        specialArgs = {
          services-root = "/services";
          root-domain = "toranxo7.de";
        };
      };

      mini = mkSystem {
        config-module = ./mini;
        hostname = "mini";
        specialArgs = {
          root-domain = "tornaxo7.de";
        };
      };

      small = mkSystem {
        config-module = ./small;
        hostname = "small";
        specialArgs = {
          root-domain = "tornaxo7.de";
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
