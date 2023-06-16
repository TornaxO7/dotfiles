{pkgs, ...}: {
  services = {
    udev.packages = with pkgs; [
      yubikey-personalization
    ];

    pcscd.enable = true;
  };
}
