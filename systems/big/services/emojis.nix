{ config, pkgs, lib, root-domain, ... }:
let
  domain = "emojis.${root-domain}";
  port = 49192;
in
{
  users = {
    users = {
      emojis = {
        isSystemUser = true;
        home = "/var/lib/emojis";
        createHome = true;
        group = "emojis";
      };

      tornax.extraGroups = [ "emojis" ];
    };

    groups.emojis = { };
  };

  systemd = {
    tmpfiles.settings.emojis = {
      "/var/lib/emojis".d = {
        user = "emojis";
        group = "emojis";
        mode = "0770";
      };

      "/var/lib/emojis/files".d = {
        user = "emojis";
        group = "emojis";
        mode = "0770";
      };
    };

    services.emojis = {
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = "emojis";
        Group = "emojis";

        DynamicUser = true;
        ProtectHome = true;
        PrivateDevices = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = "strict";
        ProtectProc = "invisible";

        LockPersonality = true;
        RestrictRealtime = true;
        RestrictNamespaces = true;

        SystemCallFilter = [ "@system-service" ];

        SystemCallErrorNumber = "EPERM";
        SystemCallArchitectures = "native";
        RestrictAddressFamilies = [ ];

        ReadOnlyPaths = [ "/var/lib/emojis/files" ];

        Type = "simple";
        ExecStart = "${lib.getExe pkgs.caddy} file-server --browse --root ${config.users.users.emojis.home}/files --listen 127.0.0.1:${toString port}";
      };
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.emojis = {
      rule = "Host(`${domain}`)";
      service = "emojis";
    };

    services.emojis.loadbalancer.servers = [
      {
        url = "http://127.0.0.1:${toString port}";
      }
    ];
  };
}
