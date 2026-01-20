let
  pc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwQ1FO2lkd7ecYc/3GCo2yTWgo1V86uYUpX87bzFPhU tornax@pc";
  laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB+jyIDy4aQ8KuJ2sJk3lnMYkE/8wDI7Vy9anrvRIKDL tornax@laptop";
  nas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPL8dets3tSpj6vvCqDgpudVWnDkYos2SRZEiys3eqSK tornax@nas";
  server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMsm8adwS6SbUwBDhOTqpmzbC+s9oqmtkNAP7DO/txos root@server";

  main = [ pc laptop nas ];
  all = main ++ [ server ];
in
{
  "deepl.age".publicKeys = main;
  "gotify-token.age".publicKeys = main;
  "paperless.age".publicKeys = main;

  "linkwarden/nextauth.age".publicKeys = main;
  "linkwarden/postgres_password.age".publicKeys = main;
  "linkwarden/meili_master_key.age".publicKeys = main;

  "grafana.age".publicKeys = all;
  "crowdsec.age".publicKeys = all;

  "authelia-jwt.age".publicKeys = all;
  "authelia-session.age".publicKeys = all;
  "authelia-storage.age".publicKeys = all;

  "homarr.age".publicKeys = all;

  "github-runner/TornaxO7.token.age".publicKeys = all;
}
