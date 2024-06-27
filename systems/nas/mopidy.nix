{ username, ... }:
let
  music-dir = "/hdds/music";
  mopidy-paths = {
    songs = "${music-dir}/songs";
    mopidy = "${music-dir}/mopidy";
  };
in
{
  config = {
    systemd.tmpfiles.settings.mopidy = {
      "${mopidy-paths.songs}".d.user = username;
      "${mopidy-paths.mopidy}".d.user = username;
    };

    virtualisation.oci-containers.containers.mopidy = {
      user = username;
      image = "docker.io/wernight/mopidy";
      ports = [ "8300:6680" ];
      volumes = [
        "${mopidy-paths.songs}:/var/lib/mopidy"
        "${mopidy-paths.mopidy}:/var/lib/mopidy/local"
      ];
    };
  };
}
