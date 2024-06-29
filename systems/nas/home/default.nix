{ inputs, pkgs, ... }:
{
  config = {
    services.syncthing = {
      enable = true;
      extraOptions = [
        "--gui-address=100.88.51.57:8040"
      ];
    };

    home.packages = with pkgs; [
      zfs
    ] ++ [
      inputs.deploy-rs.packages.${pkgs.system}.default
    ];
  };
}
