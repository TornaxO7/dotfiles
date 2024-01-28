if status is-interactive
    # Commands to run in interactive sessions can go here
end

# == exports ==
set EDITOR "helix"
set MANPAGER $EDITOR

# == alias ==
alias p "python"
alias pac "paru -Slq | fzf -m --preview \"paru -Si {1}\"| xargs -ro paru -S"

alias ch "chezmoi"
alias che "chezmoi edit"
alias cha "chezmoi apply"

alias ze "zellij"
alias hx "helix"
alias ls "eza"

alias v "vifm ."
alias y "yazi"

alias em "$EDITOR /tmp/test.md"
alias et "$EDITOR /tmp/test.txt"
alias ec "$EDITOR /tmp/test.c"
alias ed "$EDITOR /tmp/test.dot"
alias ep "$EDITOR /tmp/test.py"
alias elu "$EDITOR /tmp/test.lua"
alias ejs "$EDITOR /tmp/test.json"
alias ev "$EDITOR /tmp/test.vim"
alias ela "$EDITOR /tmp/test.tex"
alias eja "$EDITOR /tmp/Test.java"
alias ea "$EDITOR /tmp/test.s"
alias en "$EDITOR /tmp/test.norg"

alias cc "cargo check"
alias ct "cargo test"
alias cr "cargo run"
alias cb "cargo build"

alias rx "redshift -orx"
alias r1 "redshift -or -b 0.8:0.6 -l 52.52:13.4 -l manual -t 5700:1000"
alias r2 "redshift -or -b 0.8:0.6 -l 52.52:13.4 -l manual -t 5700:1500"
alias r3 "redshift -or -b 0.8:0.6 -l 52.52:13.4 -l manual -t 5700:2000"

alias ew "wiki-tui"

alias nd "nix develop"

# git
alias gaa "git add -A"
alias gc "git commit --verbose"
alias gca "git commit --verbose --amend"

alias gsw "git switch"
alias gswc "git switch -c"

alias gst "git status"
alias grhh "git reset --hard"
alias gl "git pull"
alias gp "git push"
alias gpf "git push --force-with-lease"

alias gd "git diff"
alias gf "git fetch"

alias gm "git merge"
alias gr "git remote"

alias gwt "git worktree"

alias gb "git branch"
alias gbd "git branch --delete"
alias gbD "git branch -D"

alias trans "deepl text"

# == keybindings ==
bind -k nul accept-autosuggestion

# == inits ==
starship init fish | source
zoxide init fish | source
