{ config, ... }:
{
  containers.redox-os = {
    bindMounts = {
      "/home/tornax/redox" = {
        hostPath = "/home/tornax/Programming/redox";
        isReadOnly = false;
      };
    };

    config = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        helix
        git
        fuse3
        qemu
        gnumake
        wget
        pkg-config
      ];

      virtualisation.podman.enable = true;

      system.stateVersion = config.system.stateVersion;

      programs.fish.enable = true;

      users = {
        defaultUserShell = pkgs.fish;

        users.tornax = {
          name = "tornax";
          isNormalUser = true;
          password = "yeet";
          extraGroups = [
            "wheel"
          ];
        };
      };
    };
  };
}
