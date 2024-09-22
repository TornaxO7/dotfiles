let
  pc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwQ1FO2lkd7ecYc/3GCo2yTWgo1V86uYUpX87bzFPhU tornax@pc";
  laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB+jyIDy4aQ8KuJ2sJk3lnMYkE/8wDI7Vy9anrvRIKDL tornax@laptop";
  nas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA8MZMcbVs9Wr6f1VMUcYq1Aftbz8e/hekpto4yhwPIO tornax@nas";

  all = [ pc laptop nas ];
in
{
  "deepl.age".publicKeys = all;
  "harmonia.age".publicKeys = all;
}
