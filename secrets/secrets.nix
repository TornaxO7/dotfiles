let
  pc = "age1yubikey1qf6ayy20lu92v5vymvf4yrwwcr8a9krlmmf87lj98cf57xpy25yj2t9wtsg";

  all = [pc];
in
{
  "test.age".publicKeys = [pc];
}
