{ config, pkgs, username, ... }:
{
  boot = {
    tmp.cleanOnBoot = true;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
    };
  };


  nix = {
    package = pkgs.nix;

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      trusted-users = [ config.users.users.tornax.name ];
    };
  };

  networking.hosts = {
    # "127.0.0.1" = [ "www.youtube.com" ];
  };

  nixpkgs = {
    config.allowUnfree = true;
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "Hack" ]; })
  ];

  environment = {
    pathsToLink = [ "/share/zsh" ];
    sessionVariables = {
      MOZ_USE_XINPUT2 = "1";
    };
    systemPackages = with pkgs; [
      tailscale
    ];
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
  };

  users = {
    defaultUserShell = pkgs.fish;

    groups = {
      plugdev = { };
    };

    users = rec {
      tornax = {
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
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC7Xq+9744TurpKZrBz7WpriCne5mcbfYxb4vwwRjVrV openpgp:0x654A6D6C"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILQpLDXEFoPLUzT6a1cEh4j9OEyOpkcVQJ7jVAsQywvz Generated By Termius"
        ];
      };
      root.openssh.authorizedKeys.keys = tornax.openssh.authorizedKeys.keys;
    };
  };

  security.sudo-rs = {
    enable = true;
    wheelNeedsPassword = false;
  };

  services = {
    openssh.enable = true;
    tailscale.enable = true;
  };

  virtualisation.docker.enable = true;

  system.stateVersion = "22.11";
  time.timeZone = "Europe/Berlin";
}
