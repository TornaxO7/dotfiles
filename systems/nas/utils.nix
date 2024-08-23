{
  # Create directories with the paths provided in `dir-paths` with the user-owner `username`.
  createDirs = username: dir-paths: builtins.listToAttrs (map (dir: { name = "${dir}"; value = { d.user = username; }; }) dir-paths);

  # Create a zfs snapshot with the given dataset-path
  createSnapshotScript = pkgs: script-name: dataset-path: pkgs.writeScriptBin script-name ''
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
}
