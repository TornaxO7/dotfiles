{ inputs, config, pkgs, lib, ... }:
{
  config = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      sharedModules = [
        ./home/default.nix
      ];
    };

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    nixpkgs.config.allowUnfree = true;

    fonts.fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];
    environment = {
      pathsToLink = [ "/share/zsh" ];
      variables.EDITOR = "nvim";
      systemPackages = with pkgs; [
        git
        tailscale
        tokyo-night-gtk
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

    users = {
      defaultUserShell = pkgs.zsh;
      users.tornax = {
        isNormalUser = true;
        description = "tornax";
        extraGroups = [ "wheel" "audio" "lp" "video" ];
      };
    };

    security.sudo.extraConfig = "Defaults insults\n%wheel ALL=(ALL:ALL) NOPASSWD:/bin/reboot,/bin/poweroff";

    services = {
      openssh.enable = true;
      tailscale.enable = true;
    };

    programs = import ./programs.nix { inherit lib; };

    system.stateVersion = "22.11";
  };
}
