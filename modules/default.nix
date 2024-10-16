username:
hostname:
{ self, config, pkgs, unstable, inputs, ... }:
{
  imports = [
    self.nixosModules.bustd
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
        trusted-users = [ config.users.users.main.name ];
      };

      registry = {
        my.flake = self;
        unstable.flake = inputs.unstable;
        stable.flake = inputs.stable;
      };
    };

    networking.hostName = hostname;

    nixpkgs.config.allowUnfree = true;

    fonts.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" "Hack" ]; })
    ];

    environment = {
      systemPackages = with pkgs; [
        cacert
        just
      ];
      shellAliases = {
        "stui" = "${pkgs.systemctl-tui}/bin/systemctl-tui";
        "trs" = "${pkgs.trashy}/bin/trashy";
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
        LC_NUMERIC = "de_DE.UTF-8";
        LC_PAPER = "de_DE.UTF-8";
        LC_TELEPHONE = "de_DE.UTF-8";
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

      groups = {
        plugdev = { };
      };

      users = {
        main = {
          name = username;
          isNormalUser = true;
          description = username;
          extraGroups = [
            "audio"
            "lp"
            "netdev"
            "networkmanager"
            "paperless"
            "plugdev"
            "video"
            "wheel"
            "docker"
          ];
          openssh.authorizedKeys.keys = [
            "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIKYt8yowEzE4esfqvtHUz3xssgpe2IOGpsN/Vo5PtRD1AAAABHNzaDo="
            "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAILKD6K2md+9ItTDpBjk2sXldOZNCcKV013PExYOfoJqsAAAABHNzaDo="
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA8MZMcbVs9Wr6f1VMUcYq1Aftbz8e/hekpto4yhwPIO tornax@nas"
          ];
        };
      };
    };

    security.sudo-rs = {
      enable = true;
    };

    services = {
      openssh.enable = true;
      bustd.enable = true;
    };

    systemd.services.NetworkManager-wait-online.enable = false;

    virtualisation.podman.enable = true;

    system.stateVersion = "22.11";
    time.timeZone = "Europe/Berlin";
  };
}
