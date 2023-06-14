{config, pkgs, lib, ...}:
{
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];
  environment.pathsToLink = [ "/share/zsh" ];
  environment.systemPackages = with pkgs; [
    tailscale
    neovim
  ];

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

  users.defaultUserShell = pkgs.zsh;
  users.users.tornax = {
    isNormalUser = true;
    description = "tornax";
    extraGroups = [ "wheel" "audio" "lp" "video"];
  };

  security.sudo.extraConfig = "Defaults insults\n%wheel ALL=(ALL:ALL) NOPASSWD:/bin/reboot,/bin/poweroff";

  services = {
    openssh.enable = true;
    tailscale.enable = true;
  };

  programs = {
    zsh.enable = true;
    git = {
      enable = true;
      package = pkgs.gitoxide;
    };
  };

  system.stateVersion = "22.11";
}
