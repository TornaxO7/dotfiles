{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # fix pcscd
    pcscliteWithPolkit.out
  ];

  services = {
    udev.packages = with pkgs; [
      # yubikey-personalization
    ];

    pcscd.enable = true;
  };
}
