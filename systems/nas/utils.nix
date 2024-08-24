{
  # Create directories with the paths provided in `dir-paths` with the user-owner `username`.
  createDirs = username: dir-paths: builtins.listToAttrs (map (dir: { name = "${dir}"; value = { d.user = username; }; }) dir-paths);

  # Create a systemd service and timer for the given service name which
  # creates daily snapshots of the given dateset-path.
  createSystemdZfsSnapshot = pkgs: service-name: dataset-path:
    let
      snapshot-service-name = "${service-name}-zfs-snapshot-creator";

      snapshotScriptName = "${service-name}-snapshot-script";
      snapshotScript = pkgs.writeScriptBin snapshotScriptName ''
        ${pkgs.zfs}/bin/zfs destroy ${dataset-path}@7daysago
        ${pkgs.zfs}/bin/zfs rename ${dataset-path}@6daysago @7daysago
        ${pkgs.zfs}/bin/zfs rename ${dataset-path}@5daysago @6daysago
        ${pkgs.zfs}/bin/zfs rename ${dataset-path}@4daysago @5daysago
        ${pkgs.zfs}/bin/zfs rename ${dataset-path}@3daysago @4daysago
        ${pkgs.zfs}/bin/zfs rename ${dataset-path}@2daysago @3daysago
        ${pkgs.zfs}/bin/zfs rename ${dataset-path}@yesterday @2daysago
        ${pkgs.zfs}/bin/zfs rename ${dataset-path}@today @yesterday
        ${pkgs.zfs}/bin/zfs snapshot ${dataset-path}@today
      '';
    in
    {
      services."${snapshot-service-name}" = {
        description = "ZFS snapshot creator service for ${dataset-path}";
        serviceConfig = {
          ExecStart = "${pkgs.bash}/bin/bash ${snapshotScript}/bin/${snapshotScriptName}";
          Type = "oneshot";
        };
      };

      timers."${snapshot-service-name}" = {
        description = "Timer for ${snapshot-service-name}.service";
        wantedBy = [ "multi-user.target" ];
        timerConfig = {
          OnCalendar = "daily";
          Persistent = true;
        };
      };
    };

  # Create a podman network with the given network-name and the wanted-by list
  # to ensure it's created before any of the services in `wantedBy` want to access it.
  createPodmanNetworkService = pkgs: network-name: wantedBy:
    let
      scriptName = "${network-name}-create-script";
      scriptBin = pkgs.writeScriptBin scriptName ''
        ${pkgs.podman}/bin/podman network exists ${network-name}

        if [[ $? -ne 0 ]]; then
          ${pkgs.podman}/bin/podman network create ${network-name}
        fi
      '';
    in
    {
      inherit wantedBy;
      serviceConfig = {
        ExecStart = "${pkgs.bash}/bin/bash ${scriptBin}/bin/${scriptName}";
        Type = "oneshot";
      };
    };
}
