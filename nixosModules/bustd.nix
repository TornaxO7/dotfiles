self: { config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.bustd;
  bustd = self.packages.${pkgs.stdenv.hostPlatform.system}.bustd;

  pkgs2 = pkgs // { inherit bustd; };
in
{
  options.services.bustd = {
    enable = mkEnableOption "Enable bustd";
    package = mkPackageOption pkgs2 "bustd" { };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.services.${bustd.pname} = {
      description = bustd.meta.description;

      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${lib.getExe bustd} --no-daemon";
      };
    };
  };
}
