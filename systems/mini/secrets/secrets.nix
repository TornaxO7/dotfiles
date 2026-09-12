let
  keys = import ../../../modules/ssh-keys.nix;

  main = with keys; [ pc laptop mini ];
in
{
  "traefik-dns-challenge.age".publicKeys = main;
  "homer-config.age".publicKeys = main;
}
