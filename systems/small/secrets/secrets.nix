let
  keys = import ../../../modules/ssh-keys.nix;

  main = with keys; [ pc laptop small ];
in
{
  "gokapi-config.age" = main;
}
