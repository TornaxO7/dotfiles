hostname:
{ self, config, pkgs, unstable, inputs, ssh-keys, ... }:
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
    };

    nixpkgs.config.allowUnfree = true;

    fonts.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" "Hack" ]; })
    ];

    environment = {
      systemPackages = with pkgs; [
        cacert
        just
        systemctl-tui
        tailscale
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
      users.root.openssh.authorizedKeys.keys = ssh-keys;
    };

    services = {
      openssh.enable = true;
      bustd.enable = true;
      tailscale.enable = true;
    };

    security.sudo.enable = false;

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
