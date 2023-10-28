{
  backup = ''
    borg delete --list --stats --progress /mnt::Previous2\
        && borg rename --progress /mnt::Previous1 Previous2\
        && borg rename --progress /mnt::Latest Previous1\
        && borg create --stats --progress /mnt::Latest /main
  '';

  p = "python";

  z = "zellij";
  za = "zellij a";
  zs = "zellij -s";
  zm = "zellij -s main";

  v = "vifm .";

  em = "$EDITOR /tmp/test.md";
  et = "$EDITOR /tmp/test.txt";
  ec = "$EDITOR /tmp/test.c";
  er = "if [ ! -d /tmp/rust_tmp ]; then cargo new /tmp/rust_tmp/; fi; $EDITOR
  /tmp/rust_tmp/src/main.rs";
  ed = "$EDITOR /tmp/test.dot";
  ep = "$EDITOR /tmp/test.py";
  elu = "$EDITOR /tmp/test.lua";
  ejs = "$EDITOR /tmp/test.json";
  ev = "$EDITOR /tmp/test.vim";
  ela = "$EDITOR /tmp/test.tex";
  ef = "fzf | read yeet; if [[ \$yeet != '' ]]; then $EDITOR \$yeet; fi";
  eja = "$EDITOR /tmp/Test.java";
  ea = "$EDITOR /tmp/test.s";
  # eplug = "$EDITOR ~/.config/nvim/init.vim";
  en = "$EDITOR /tmp/test.norg";

  sp = "sudo poweroff";

  cc = "cargo check";
  ct = "cargo test";
  cr = "cargo run";
  cb = "cargo build";

  rx = "redshift -orx";
  r1 = "redshift -or -b 0.8:0.6 -l 52.52:13.4 -l manual -t 5700:1000";
  r2 = "redshift -or -b 0.8:0.6 -l 52.52:13.4 -l manual -t 5700:1500";
  r3 = "redshift -or -b 0.8:0.6 -l 52.52:13.4 -l manual -t 5700:2000";

  ew = "wiki-tui";

  tm = "termusic ~/main/Music/rest";
  nsa = "nix-shell '<unstable>' --command 'zsh' -A";
  nsp = "nix-shell '<unstable>' --command 'zsh' -p";
  nd = "nix develop";
}
