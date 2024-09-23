{ pkgs, ... }:
let
  image-puller = pkgs.writeShellScriptBin "image-puller" ''
      images=$(${pkgs.sudo-rs}/bin/sudo ${pkgs.podman}/bin/podman ps -a --format '{{.Image}}' | sort -u)

    for image in $images
    do
      ${pkgs.sudo-rs}/bin/sudo ${pkgs.podman}/bin/podman pull "$image"
    done
  '';
in
{
  systemd = {
    services.image-updater = {
      description = "Pulls all images of each docker container.";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.bash}/bin/bash ${image-puller}/bin/image-puller";
      };
    };

    timers.image-updater = {
      description = "Starts image-updater.service weekly.";
      wantedBy = [ "multi-user.target" ];
      timerConfig = {
        OnCalendar = "weekly";
        Unit = "image-updater.service";
      };
    };
  };
}

