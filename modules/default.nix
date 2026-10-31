{ self, config, pkgs, unstable, inputs, hostname, lib, ... }:
{
  disabledModules = [
    "services/security/crowdsec.nix"
    "services/security/crowdsec-firewall-bouncer.nix"
  ];

  imports = [
    self.nixosModules.bustd
    inputs.home-manager.nixosModules.home-manager

    "${inputs.unstable}/nixos/modules/services/security/crowdsec"
    "${inputs.unstable}/nixos/modules/services/security/crowdsec-firewall-bouncer.nix"
  ];

  config = {
    services = {
      crowdsec.package = pkgs.callPackage "${inputs.unstable}/pkgs/by-name/cr/crowdsec/package.nix" { };
      crowdsec-firewall-bouncer.package = pkgs.callPackage "${inputs.unstable}/pkgs/by-name/cr/crowdsec-firewall-bouncer/package.nix" { };

      openssh.hostKeys = [
        {
          path = "/etc/ssh/${hostname}";
          type = "ed25519";
        }
      ];
    };

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
      };

      nameservers = lib.mkDefault [
        # -- adguard
        "94.140.14.14"
        "94.140.15.15"
        "2a10:50c0::ad1:ff"
        "2a10:50c0::ad2:ff"

        # -- cloudflare
        "1.1.1.1"
        "1.0.0.1"
        "2606:4700:4700::1111"
        "2606:4700:4700::1001"

        # -- google
        "8.8.8.8"
        "8.8.4.4"
        "2001:4860:4860::8888"
        "2001:4860:4860::8844"

        # -- quad
        "9.9.9.9"
        "149.112.112.112"
        "2620:fe::fe"
        "2620:fe::9"

        # -- dns.sb
        "185.222.222.222"
        "45.11.45.11"
        "2a09::"
        "2a11::"

        # --joindns4.eu
        "86.54.11.13"
        "2a13:1001::86:54:11:13"
      ];
    };

    nixpkgs.config.allowUnfree = true;

    fonts.packages = with pkgs.nerd-fonts; [
      fira-code
      hack
    ];

    # disable due to fish: https://discourse.nixos.org/t/slow-build-at-building-man-cache/52365/2?u=tornaxo7
    documentation = {
      man.cache.enable = false;
      # until crowdsec doc has been released in stable
      nixos.enable = false;
    };

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
      users =
        let
          all-ssh-keys = import ./ssh-keys.nix;
          ssh-keys = with all-ssh-keys; [
            pc
            pc-sk
            laptop
            laptop-sk
            mobile
          ];
        in
        {
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
        inherit inputs unstable self;
        age = config.age;
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
      gnome.gnome-keyring.enable = false;
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
