let
  keys = import ../../../modules/ssh-keys.nix;

  main = with keys; [ pc laptop mini ];
in
{
  "homer-config.age".publicKeys = main;
}
