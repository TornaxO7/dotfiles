{ ... }:
{
  services = {
    fail2ban = {
      enable = true;
      maxretry = 5;
      ignoreIP = [
        "100.64.0.0/10"
      ];
      bantime = "512h";
    };

    # traefik = {
    #   staticConfigOptions = {
    #     experimental.plugins.fail2ban = {
    #       moduleName = "github.com/tomMoulard/fail2ban";
    #       version = "v0.8.3";
    #     };

    #     entryPoints.https.http.middlewares = [ "fail2ban@file" ];
    #   };

    #   dynamicConfigOptions.http.middlewares = {
    #     fail2ban.plugin.fail2ban = {
    #       rules = {
    #         bantime = "512h";
    #         enabled = true;
    #         findtime = "10m";
    #         maxretry = 4;
    #       };
    #     };
    #   };
    # };
  };
}
