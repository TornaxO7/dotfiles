{ ... }:
{
  config = {
    services.matrix-conduit = {
      enable = true;

      settings.global = {
        port = 8080;
        server_name = "nas";
        address = "100.88.51.57";
      };
    };
  };
}
