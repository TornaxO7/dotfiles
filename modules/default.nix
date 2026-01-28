{ self, config, pkgs, unstable, inputs, ssh-keys, wg, hostname, ... }:
{
  imports = [
    self.nixosModules.bustd
    inputs.home-manager.nixosModules.home-manager
  ];

  config = {
    boot = {
      tmp.cleanOnBoot = true;
      loader = {
        systemd-boot = {
          enable = true;
          configurationLimit = 5;
        };
        efi.canTouchEfiVariables = true;
        efi.efiSysMountPoint = "/boot";
      };
    };

    nix = {
      package = unstable.lix;

      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        auto-optimise-store = true;
      };

      registry = {
        my.flake = self;
        unstable.flake = inputs.unstable;
        stable.flake = inputs.stable;
      };
    };

    networking = {
      hostName = hostname;
      nftables.enable = true;

      wg-quick.interfaces.wg0 = {
        generatePrivateKeyFile = true;
        privateKeyFile = "/etc/wireguard/private.key";
        dns = [ wg.server.addr ];
      };
    };

    nixpkgs.config.allowUnfree = true;

    fonts.packages = with pkgs.nerd-fonts; [
      fira-code
      hack
    ];

    # disable due to fish: https://discourse.nixos.org/t/slow-build-at-building-man-cache/52365/2?u=tornaxo7
    documentation.man.generateCaches = false;

    environment = {
      systemPackages = with pkgs; [
        systemctl-tui
      ];
      shellAliases = {
        "stui" = "systemctl-tui";
      };
    };

    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
        LC_ADDRESS = "de_DE.UTF-8";
        LC_IDENTIFICATION = "de_DE.UTF-8";
        LC_MEASUREMENT = "de_DE.UTF-8";
        LC_MONETARY = "de_DE.UTF-8";
        LC_NAME = "de_DE.UTF-8";
        LC_PAPER = "de_DE.UTF-8";
        LC_TELEPHONE = "de_DE.UTF-8";
        LC_NUMERIC = "de_DE.UTF-8";
        LC_TIME = "de_DE.UTF-8";
      };
    };

    console.keyMap = "bone";

    programs = {
      git.enable = true;
      fish.enable = true;
      ssh.askPassword = "${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass";
    };

    users = {
      defaultUserShell = pkgs.fish;
      users = {
        tornax = {
          isNormalUser = true;
          openssh.authorizedKeys.keys = ssh-keys;
        };

        root = {
          hashedPassword = "!";
          openssh.authorizedKeys.keys = ssh-keys;
        };
      };
    };

    home-manager = {
      useUserPackages = true;
      sharedModules = [
        inputs.nix-colors.homeManagerModules.default
      ];

      extraSpecialArgs = {
        inherit inputs unstable;
        age = config.age;
        my_flake = self;
      };

      users.tornax = { ... }: {
        colorScheme = inputs.nix-colors.colorSchemes.tokyo-night-storm;

        home = {
          username = "tornax";
          homeDirectory = "/home/tornax";

          keyboard = {
            layout = "de";
            variant = "bone";
          };

          language.base = "en_US.UTF-8";
          stateVersion = "23.05";
        };
      };
    };

    services = {
      openssh.enable = true;
      bustd.enable = true;
    };

    systemd.services.NetworkManager-wait-online.enable = false;

    virtualisation.podman = {
      enable = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };

    system.stateVersion = "22.11";
    time.timeZone = "Europe/Berlin";
  };
}
