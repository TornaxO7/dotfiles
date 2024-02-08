let
  pc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwQ1FO2lkd7ecYc/3GCo2yTWgo1V86uYUpX87bzFPhU tornax@pc";
  laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB+jyIDy4aQ8KuJ2sJk3lnMYkE/8wDI7Vy9anrvRIKDL tornax@laptop";

  all = [ pc laptop ];
in
{
  "paperless.age".publicKey = all;
}
