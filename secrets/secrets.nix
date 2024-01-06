let
  pc = "age1yubikey1qf6ayy20lu92v5vymvf4yrwwcr8a9krlmmf87lj98cf57xpy25yj2t9wtsg";
  laptop = "age1yubikey1qgwhj5a4pk99u38e26dwgmuz7m2vhqkhfh82s8ff8mfagd4k7amfzeunsam";

  all = [ pc laptop ];
in
{
  "paperless.age".publicKey = all;
}
