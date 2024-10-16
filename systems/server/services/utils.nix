{
  # Create directories with the paths provided in `dir-paths` with the user-owner `username`.
  createDirs = config: dir-paths:
    let
      username = config.users.users.main.name;
    in
    builtins.listToAttrs (map (dir: { name = "${dir}"; value = { d.user = username; }; }) dir-paths);

  # Create a podman network with the given network-name and the wanted-by list
  # to ensure it's created before any of the services in `before` want to access it.
  createPodmanNetworkService = pkgs: network-name: before:
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
      inherit before;
      # create network at bootup
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.bash}/bin/bash ${scriptBin}/bin/${scriptName}";
        Type = "oneshot";
      };
    };

  # Example:
  # ```
  # createContainerNames "pika" ["yes" "no"] = { yes = "pika-yes"; no = "pika-no"; }
  # ```
  createContainerNames = prefix: names:
    let
      container-names-attrset = map (name: { name = "${name}"; value = "${prefix}-${name}"; }) names;
    in
    rec {
      containers = builtins.listToAttrs container-names-attrset;
      service-prefixes = builtins.mapAttrs (name: value: "podman-${value}") containers;
      service-full = builtins.mapAttrs (name: value: "${value}.service") service-prefixes;
    };
}
