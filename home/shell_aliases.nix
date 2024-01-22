{
  p = "python";
  pac = "paru -Slq | fzf -m --preview \"paru -Si {1}\"| xargs -ro paru -S";

  ze = "zellij";

  v = "vifm .";
  y = "yazi";

  em = "$EDITOR /tmp/test.md";
  et = "$EDITOR /tmp/test.txt";
  ec = "$EDITOR /tmp/test.c";
  ed = "$EDITOR /tmp/test.dot";
  ep = "$EDITOR /tmp/test.py";
  elu = "$EDITOR /tmp/test.lua";
  ejs = "$EDITOR /tmp/test.json";
  ev = "$EDITOR /tmp/test.vim";
  ela = "$EDITOR /tmp/test.tex";
  eja = "$EDITOR /tmp/Test.java";
  ea = "$EDITOR /tmp/test.s";
  en = "$EDITOR /tmp/test.norg";

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
  nd = "nix develop";

  # git
  gaa = "git add -A";
  gc = "git commit --verbose";
  gca = "git commit --verbose --amend";

  gsw = "git switch";
  gswc = "git switch -c";

  gst = "git status";
  grhh = "git reset --hard";
  gl = "git pull";
  gp = "git push";
  gpf = "git push --force-with-lease";

  gd = "git diff";
  gf = "git fetch";

  gm = "git merge";
  gr = "git remote";

  gwt = "git worktree";

  gb = "git branch";
  gbd = "git branch --delete";
  gbD = "git branch -D";
}

