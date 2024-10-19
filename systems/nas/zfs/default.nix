{ config, pkgs, zpool-name, ... }:
let
  zfsCheckScript = ''
    POOL_STATUS=$(${pkgs.zfs}/bin/zpool status -x ${zpool-name})
    TOKEN=$(cat ${config.age.secrets.gotify-token.path})

    if [[ $POOL_STATUS == *"errors" ]]; then
      ${pkgs.curl}/bin/curl "https://gotify.tornaxo7.de/message?token=$TOKEN" -F "title=ZFS Status" -F "message=zpool contains errors!" -F "priority=5"
    else
      ${pkgs.curl}/bin/curl "https://gotify.tornaxo7.de/message?token=$TOKEN" -F "title=ZFS Status" -F "message=zpool is clean" -F "priority=5"
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

      timers."zpool-check" = {
        description = "Run ZFS status check daily";
        wantedBy = [ "multi-user.target" ];
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
