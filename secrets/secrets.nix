let
  keys = import ../modules/ssh-keys.nix;

  main = with keys; [ pc laptop nas ];
  all = main ++ (with keys; [ mini small big ]);
in
{
  "deepl.age".publicKeys = main;
  "gotify-token.age".publicKeys = main;
  "paperless.age".publicKeys = main;

  "crowdsec-enrollkey.age".publicKeys = with keys; [ pc laptop small big ];

  "linkwarden/nextauth.age".publicKeys = main;
  "linkwarden/postgres_password.age".publicKeys = main;
  "linkwarden/meili_master_key.age".publicKeys = main;

  "homarr.age".publicKeys = with keys; [ pc laptop mini ];

  "grafana/admin-password.age".publicKeys = all;
  "grafana/secret-key.age".publicKeys = all;

  "n8n-runners-auth-token.age".publicKeys = with keys; [ pc laptop nas ];

  "crowdsec.age".publicKeys = all;

  "authelia-jwt.age".publicKeys = all;
  "authelia-session.age".publicKeys = all;
  "authelia-storage.age".publicKeys = all;

  "traefik-dns-challenge.age".publicKeys = all;

  "github-runner/TornaxO7.token.age".publicKeys = all;
}
