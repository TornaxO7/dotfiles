{ config, ... }:
{
  services.paperless = {
    enable = true;
    passwordFile = config.age.secrets.paperless.path;
    address = "100.84.194.151";
  };
}
