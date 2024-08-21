{ config, pkgs, ... }:
let
  zpool-name = "hdds";

  zfsCheckScript = ''
    POOL_STATUS=$(${pkgs.zfs}/bin/zpool status -x ${zpool-name})
    DISCORD_HOOK=$(${pkgs.coreutils}/bin/cat ${config.age.secrets.discord-webhook.path})

    if [[ $POOL_STATUS == *"errors" ]]; then
      ${pkgs.curl}/bin/curl -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST --data "{\"content\": \"zpool contains errors\"}" $DISCORD_HOOK
    else
      ${pkgs.curl}/bin/curl -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST --data "{\"content\": \"zpool is healthy\"}" $DISCORD_HOOK
    fi
  '';

  zfsCheckScriptPath = pkgs.writeScriptBin "zfs-check-script" zfsCheckScript;
in
{
  config = {
    boot = {
      kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
      supportedFilesystems = [ "zfs" ];
      zfs.extraPools = [ zpool-name ];
    };

    systemd = {
      services."zpool-check" = {
        description = "ZFS Pool check";
        serviceConfig = {
          ExecStart = "${pkgs.bash}/bin/bash ${zfsCheckScriptPath}/bin/zfs-check-script";
          Type = "oneshot";
        };
      };

      timers.check-zfs-timer = {
        description = "RUn ZFS status check daily";
        wants = [ "zpool-check.service" ];
        timerConfig = {
          OnCalendar = "daily";
          Persistent = true;
        };
      };
    };

    services = {
      zfs = {
        autoScrub = {
          enable = true;
          interval = "daily";
        };

        trim = {
          enable = true;
          interval = "quarterly";
        };
      };
    };
  };
}
