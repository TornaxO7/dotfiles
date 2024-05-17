{ inputs, ... }:
{
  imports = [
    inputs.nixos-cosmic.nixosModules.default
  ];

  config = {
    nix.settings = {
      substituters = [ "https://cosmic.cachix.org/" ];
      trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
    };

    services = {
      desktopManager.cosmic.enable = true;
      # displayManager.cosmic-greeter.enable = true;
    };
  };
}
