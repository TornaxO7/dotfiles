{ pkgs, ... }:
{
  services.udev.packages = with pkgs; [ rwedid ];
  environment.systemPackages = with pkgs; [ ugreen-leds-cli ];
  boot.kernelModules = [ "i2c-dev" ];
}
