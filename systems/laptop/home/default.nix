{ pkgs, ... }:
{
  home-manager.users.tornax = { ... }: {
    imports = [
      ./i3.nix
      ./i3status-rs.nix
      ./services.nix

      ../../../home/client.nix
    ];

    config = {
      home.packages = with pkgs; [
        cacert
        finamp
        font-awesome
        xournalpp
        rnote
        github-cli
        nixpkgs-review
      ];
    };
  };
}
