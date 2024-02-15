{ config, ... }:
{
  services.paperless = {
    enable = true;
    passwordFile = config.age.secrets.paperless.path;
    address = "pc.tail5bf2.ts.net";
  };
}
