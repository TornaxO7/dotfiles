{ pkgs, zpool-name, lib, ... }:
let
  utils = import ../utils.nix;
  prefix = "appflowy-";
  network-name = "appflowy-network";

  container-names =
    let
      names = [ "minio" "postgres" "redis" "gotrue" "cloud" "admin-frontend" "history" ];
      values = map (name: { name = "${name}"; value = "${prefix}{name}"; }) names;
    in
    builtins.listToAttrs values;

  service-prefixes = builtins.mapAttrs (name: value: "podman-${value}") container-names;
  service-full-names = builtins.mapAttrs (name: value: "${value}.service") service-prefixes;

  requires-and-after = services: {
    requires = services;
    after = services;
  };
in
{

  systemd = lib.attrsets.recursiveUpdate {

    services = {
      create-appflowy-network = utils.createPodmanNetworkService pkgs network-name (builtins.attrValues service-full-names);

      "${service-prefixes.gotrue}" = requires-and-after [ service-full-names.postgres ];
      "${service-prefixes.cloud}" = requires-and-after (with service-full-names; [ gotrue admin-frontend ]);
      "${service-prefixes.admin-frontend}" = requires-and-after (with service-full-names; [ gotrue ]);
      "${service-prefixes.history}" = requires-and-after [ service-full-names.postgres ];
    }
      (utils.createSystemdZfsSnapshot pkgs "appflowy" "${zpool-name}/appflowy");
  };

  virutalisation.oci-containers.containers = { };
}
