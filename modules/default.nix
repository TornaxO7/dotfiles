{ config, pkgs, nix, system, ... }:
{
  config = {
    boot.tmp.cleanOnBoot = true;

    nix = {
      package = nix.packages.${system}.default;
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
        # fix pcscd
        pcscliteWithPolkit.out
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

    programs.fish.enable = true;
    users = {
      groups = {
        plugdev = { };
      };

      users = {
        tornax = {
          name = "tornax";
          shell = pkgs.fish;
          isNormalUser = true;
          description = "tornax";
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
      };
    };


    security.sudo = {
      extraRules = [
        {
          groups = [ "wheel" ];
          commands = [
            {
              command = "/run/current-system/sw/bin/reboot";
              options = [ "NOPASSWD" ];
            }
            {
              command = "/run/current-system/sw/bin/poweroff";
              options = [ "NOPASSWD" ];
            }
          ];
        }
      ];
      extraConfig = "Defaults insults";
    };

    services = {
      openssh.enable = true;
      tailscale.enable = true;
      pcscd.enable = true;
    };

    virtualisation.docker.enable = true;

    programs = {
      zsh.enable = true;
      git.enable = true;
    };

    system.stateVersion = "22.11";
  };
}
