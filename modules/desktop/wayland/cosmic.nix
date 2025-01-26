{ inputs, pkgs, ... }:
{
  imports = [ inputs.nixos-cosmic.nixosModules.default ];

  config = {
    nix.settings = {
      substituters = [ "https://cosmic.cachix.org/" ];
      trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
    };

    users.users.main.packages = with pkgs; [
      wl-clipboard-rs
    ];

    services = {
      desktopManager.cosmic.enable = true;
      # displayManager.cosmic-greeter.enable = true;
    };
  };
}
