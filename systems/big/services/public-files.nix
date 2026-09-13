{ config, pkgs, lib, root-domain, ... }:
let
  domain = "public-files.${root-domain}";
  port = 49193;
in
{
  users = {
    users = {
      public-files = {
        isSystemUser = true;
        home = "/var/lib/public-files";
        createHome = true;
        group = "public-files";
      };

      tornax.extraGroups = [ "public-files" ];
    };

    groups.public-files = { };
  };

  systemd = {
    tmpfiles.settings.public-files = {
      "/var/lib/public-files".d = {
        user = "public-files";
        group = "public-files";
        mode = "0770";
      };

      "/var/lib/public-files/files".d = {
        user = "public-files";
        group = "public-files";
        mode = "0770";
      };
    };

    services.public-files = {
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = "public-files";
        Group = "public-files";

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

        ReadOnlyPaths = [ "/var/lib/public-files/files" ];

        Type = "simple";
        ExecStart = "${lib.getExe pkgs.dufs} -b 127.0.0.1 -p ${toString port} --allow-search ${config.users.users.public-files.home}/files";
      };
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.public-files = {
      rule = "Host(`${domain}`)";
      service = "public-files";
    };

    services.public-files.loadbalancer.servers = [
      {
        url = "http://127.0.0.1:${toString port}";
      }
    ];
  };
}
