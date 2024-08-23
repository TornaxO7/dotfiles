{
  # Create directories with the paths provided in `dir-paths` with the user-owner `username`.
  createDirs = username: dir-paths: builtins.listToAttrs (map (dir: { name = "${dir}"; value = { d.user = username; }; }) dir-paths);
}
