{
  manager.keymap = [
    {
      on = [ "S" ];
      exec = "shell \"$SHELL\" --block --confirm";
      desc = "Open shell here";
    }
    {
      on = [ "<Esc>" ];
      exec = "escape";
      desc = "Exit visual mode; clear selected; or cancel search";
    }
    {
      on = [ "q" ];
      exec = "quit";
      desc = "Exit the process";
    }
    {
      on = [ "Q" ];
      exec = "quit --no-cwd-file";
      desc = "Exit the process without writing cwd-file";
    }
    {
      on = [ "<C-q>" ];
      exec = "close";
      desc = "Close the current tab; or quit if it is last tab";
    }

    # Navigation
    {
      on = [ "k" ];
      exec = "arrow -1";
      desc = "Move cursor up";
    }
    {
      on = [ "j" ];
      exec = "arrow 1";
      desc = "Move cursor down";
    }
    {
      on = [ "<C-u>" ];
      exec = "arrow -50%";
      desc = "Move cursor up half page";
    }
    {
      on = [ "<C-d>" ];
      exec = "arrow 50%";
      desc = "Move cursor down half page";
    }
    {
      on = [ "h" ];
      exec = [ "leave" "escape --visual --select" ];
      desc = "Go back to the parent directory";
    }
    {
      on = [ "l" ];
      exec = [ "enter" "escape --visual --select" ];
      desc = "Enter the child directory";
    }

    {
      on = [ "<C-o>" ];
      exec = "back";
      desc = "Go back to the previous directory";
    }
    {
      on = [ "<C-i>" ];
      exec = "forward";
      desc = "Go forward to the next directory";
    }

    {
      on = [ "<A-k>" ];
      exec = "seek -5";
      desc = "Seek up 5 units in the preview";
    }
    {
      on = [ "<A-j>" ];
      exec = "seek 5";
      desc = "Seek down 5 units in the preview";
    }
    # Selection
    {
      on = [ "<Space>" ];
      exec = [ "select --state=none" "arrow 1" ];
      desc = "Toggle the current selection state";
    }
    {
      on = [ "v" "n" ];
      exec = "visual_mode";
      desc = "Enter visual mode (selection mode)";
    }
    {
      on = [ "v" "r" ];
      exec = "visual_mode --unset";
      desc = "Enter visual mode (unset mode)";
    }
    {
      on = [ "v" "s" ];
      exec = "select_all --state=true";
      desc = "Select all files";
    }
    {
      on = [ "v" "g" ];
      exec = "select_all --state=none";
      desc = "Inverse selection of all files";
    }

    # Operation
    {
      on = [ "e" ];
      exec = "open";
      desc = "Open the selected files";
    }
    {
      on = [ "E" ];
      exec = "open --interactive";
      desc = "Open the selected files interactively";
    }
    {
      on = [ "<Enter>" ];
      exec = "open";
      desc = "Open the selected files";
    }
    {
      on = [ "<C-Enter>" ];
      exec = "open --interactive";
      desc = "Open the selected files interactively";
    }
    # yank
    {
      on = [ "y" "y" ];
      exec = [ "yank" "escape --visual --select" ];
      desc = "Copy the selected files";
    }

    {
      on = [ "y" "f" ];
      exec = "copy path";
      desc = "Copy the absolute path";
    }
    {
      on = [ "y" "d" ];
      exec = "copy dirname";
      desc = "Copy the path of the parent directory";
    }
    {
      on = [ "y" "x" ];
      exec = [ "yank --cut" "escape --visual --select" ];
      desc = "Cut the selected files";
    }
    {
      on = [ "p" ];
      exec = "paste";
      desc = "Paste the files";
    }
    {
      on = [ "P" ];
      exec = "paste --force";
      desc = "Paste the files (overwrite if the destination exists)";
    }
    {
      on = [ "-" ];
      exec = "link";
      desc = "Symlink the absolute path of files";
    }
    {
      on = [ "_" ];
      exec = "link --relative";
      desc = "Symlink the relative path of files";
    }
    {
      on = [ "d" "n" ];
      exec = [ "remove" "escape --visual --select" ];
      desc = "Move the files to the trash";
    }
    {
      on = [ "d" "r" ];
      exec = [ "remove --permanently" "escape --visual --select" ];
      desc = "Permanently delete the files";
    }
    {
      on = [ "a" ];
      exec = "create";
      desc = "Create a file or directory (ends with / for directories)";
    }
    {
      on = [ "r" ];
      exec = "rename --cursor=before_ext";
      desc = "Rename a file or directory";
    }
    {
      on = [ ";" ];
      exec = "shell";
      desc = "Run a shell command";
    }
    {
      on = [ ":" ];
      exec = "shell --block";
      desc = "Run a shell command (block the UI until the command finishes)";
    }
    {
      on = [ "." ];
      exec = "hidden toggle";
      desc = "Toggle the visibility of hidden files";
    }

    # searching/Filter
    {
      on = [ "f" "n" ];
      exec = "search fd";
      desc = "Search files by name using fd";
    }
    {
      on = [ "f" "r" ];
      exec = "search rg";
      desc = "Search files by content using ripgrep";
    }
    {
      on = [ "f" "s" ];
      exec = "filter --smart";
      desc = "Filter the files";
    }

    {
      on = [ "z" ];
      exec = "jump zoxide";
      desc = "Jump to a directory using zoxide";
    }
    {
      on = [ "Z" ];
      exec = "jump fzf";
      desc = "Jump to a directory; or reveal a file using fzf";
    }

    # Linemode
    {
      on = [ "m" "s" ];
      exec = "linemode size";
      desc = "Set linemode to size";
    }
    {
      on = [ "m" "p" ];
      exec = "linemode permissions";
      desc = "Set linemode to permissions";
    }
    {
      on = [ "m" "m" ];
      exec = "linemode mtime";
      desc = "Set linemode to mtime";
    }
    {
      on = [ "m" "n" ];
      exec = "linemode none";
      desc = "Set linemode to none";
    }

    # Find
    {
      on = [ "/" ];
      exec = "find --smart";
      desc = "Find next file";
    }
    {
      on = [ "?" ];
      exec = "find --previous --smart";
      desc = "Find previous file";
    }
    {
      on = [ "n" ];
      exec = "find_arrow";
      desc = "Go to next found file";
    }
    {
      on = [ "N" ];
      exec = "find_arrow --previous";
      desc = "Go to previous found file";
    }

    # Sorting
    {
      on = [ "s" "m" ];
      exec = "sort modified --dir-first";
      desc = "Sort by modified time";
    }
    {
      on = [ "s" "M" ];
      exec = "sort modified --reverse --dir-first";
      desc = "Sort by modified time (reverse)";
    }
    {
      on = [ "s" "c" ];
      exec = "sort created --dir-first";
      desc = "Sort by created time";
    }
    {
      on = [ "s" "C" ];
      exec = "sort created --reverse --dir-first";
      desc = "Sort by created time (reverse)";
    }
    {
      on = [ "s" "e" ];
      exec = "sort extension --dir-first";
      desc = "Sort by extension";
    }
    {
      on = [ "s" "E" ];
      exec = "sort extension --reverse --dir-first";
      desc = "Sort by extension (reverse)";
    }
    {
      on = [ "s" "a" ];
      exec = "sort alphabetical --dir-first";
      desc = "Sort alphabetically";
    }
    {
      on = [ "s" "A" ];
      exec = "sort alphabetical --reverse --dir-first";
      desc = "Sort alphabetically (reverse)";
    }
    {
      on = [ "s" "n" ];
      exec = "sort natural --dir-first";
      desc = "Sort naturally";
    }
    {
      on = [ "s" "N" ];
      exec = "sort natural --reverse --dir-first";
      desc = "Sort naturally (reverse)";
    }
    {
      on = [ "s" "s" ];
      exec = "sort size --dir-first";
      desc = "Sort by size";
    }
    {
      on = [ "s" "S" ];
      exec = "sort size --reverse --dir-first";
      desc = "Sort by size (reverse)";
    }

    # Tasks
    {
      on = [ "w" ];
      exec = "tasks_show";
      desc = "Show the tasks manager";
    }

    # Goto
    {
      on = [ "g" "h" ];
      exec = "cd ~";
      desc = "Go to the home directory";
    }
    {
      on = [ "g" "d" ];
      exec = "cd ~/dotfiles";
      desc = "Go to the dotfiles directory";
    }
    {
      on = [ "g" "t" ];
      exec = "cd /tmp";
      desc = "Go to the temporary directory";
    }
    {
      on = [ "g" "c" ];
      exec = "cd --interactive";
      desc = "Go to a directory interactively";
    }
    {
      on = [ "g" "g" ];
      exec = "arrow -99999999";
      desc = "Move cursor to the top";
    }
    {
      on = [ "g" "e" ];
      exec = "arrow 99999999";
      desc = "Move cursor to the bottom";
    }

    # Help
    {
      on = [ "~" ];
      exec = "help";
      desc = "Open help";
    }
  ];

  tasks.keymap = [
    {
      on = [ "<Esc>" ];
      exec = "close";
      desc = "Hide the task manager";
    }
    {
      on = [ "<C-q>" ];
      exec = "close";
      desc = "Hide the task manager";
    }
    {
      on = [ "w" ];
      exec = "close";
      desc = "Hide the task manager";
    }
    {
      on = [ "k" ];
      exec = "arrow -1";
      desc = "Move cursor up";
    }
    {
      on = [ "j" ];
      exec = "arrow 1";
      desc = "Move cursor down";
    }
    {
      on = [ "<Enter>" ];
      exec = "inspect";
      desc = "Inspect the task";
    }
    {
      on = [ "d" "d" ];
      exec = "cancel";
      desc = "Cancel the task";
    }

    {
      on = [ "~" ];
      exec = "help";
      desc = "Open help";
    }
  ];

  select.keymap = [
    {
      on = [ "<C-q>" ];
      exec = "close";
      desc = "Cancel selection";
    }
    {
      on = [ "<Esc>" ];
      exec = "close";
      desc = "Cancel selection";
    }
    {
      on = [ "<Enter>" ];
      exec = "close --submit";
      desc = "Submit the selection";
    }
    {
      on = [ "k" ];
      exec = "arrow -1";
      desc = "Move cursor up";
    }
    {
      on = [ "j" ];
      exec = "arrow 1";
      desc = "Move cursor down";
    }
    {
      on = [ "~" ];
      exec = "help";
      desc = "Open help";
    }
  ];

  input.keymap = [
    {
      on = [ "<C-q>" ];
      exec = "close";
      desc = "Cancel input";
    }
    {
      on = [ "<Enter>" ];
      exec = "close --submit";
      desc = "Submit the input";
    }
    {
      on = [ "<Esc>" ];
      exec = "escape";
      desc = "Go back the normal mode; or cancel input";
    }

    # Mode
    {
      on = [ "i" ];
      exec = "insert";
      desc = "Enter insert mode";
    }
    {
      on = [ "a" ];
      exec = "insert --append";
      desc = "Enter append mode";
    }
    {
      on = [ "I" ];
      exec = [ "move -999" "insert" ];
      desc = "Move to the BOL; and enter insert mode";
    }
    {
      on = [ "A" ];
      exec = [ "move 999" "insert --append" ];
      desc = "Move to the EOL; and enter append mode";
    }
    {
      on = [ "v" ];
      exec = "visual";
      desc = "Enter visual mode";
    }
    {
      on = [ "V" ];
      exec = [ "move -999" "visual" "move 999" ];
      desc = "Enter visual mode and select all";
    }

    # Character-wise movement
    {
      on = [ "h" ];
      exec = "move -1";
      desc = "Move back a character";
    }
    {
      on = [ "l" ];
      exec = "move 1";
      desc = "Move forward a character";
    }

    # Word-wise movement
    {
      on = [ "b" ];
      exec = "backward";
      desc = "Move back to the start of the current or previous word";
    }
    {
      on = [ "w" ];
      exec = "forward";
      desc = "Move forward to the start of the next word";
    }
    {
      on = [ "e" ];
      exec = "forward --end-of-word";
      desc = "Move forward to the end of the current or next word";
    }

    # Line-wise movement
    {
      on = [ "0" ];
      exec = "move -999";
      desc = "Move to the BOL";
    }
    {
      on = [ "$" ];
      exec = "move 999";
      desc = "Move to the EOL";
    }

    # Delete
    {
      on = [ "<Backspace>" ];
      exec = "backspace";
      desc = "Delete the character before the cursor";
    }

    # Kill
    {
      on = [ "<C-u>" ];
      exec = "kill bol";
      desc = "Kill backwards to the BOL";
    }
    {
      on = [ "<C-k>" ];
      exec = "kill eol";
      desc = "Kill forwards to the EOL";
    }
    {
      on = [ "<C-w>" ];
      exec = "kill backward";
      desc = "Kill backwards to the start of the current word";
    }
    {
      on = [ "<A-d>" ];
      exec = "kill forward";
      desc = "Kill forwards to the end of the current word";
    }

    # Cut/Yank/Paste
    {
      on = [ "d" ];
      exec = "delete --cut";
      desc = "Cut the selected characters";
    }
    {
      on = [ "D" ];
      exec = [ "delete --cut" "move 999" ];
      desc = "Cut until the EOL";
    }
    {
      on = [ "c" ];
      exec = "delete --cut --insert";
      desc = "Cut the selected characters; and enter insert mode";
    }
    {
      on = [ "C" ];
      exec = [ "delete --cut --insert" "move 999" ];
      desc = "Cut until the EOL; and enter insert mode";
    }
    {
      on = [ "x" ];
      exec = [ "delete --cut" "move 1 --in-operating" ];
      desc = "Cut the current character";
    }
    {
      on = [ "y" ];
      exec = "yank";
      desc = "Copy the selected characters";
    }
    {
      on = [ "p" ];
      exec = "paste";
      desc = "Paste the copied characters after the cursor";
    }
    {
      on = [ "P" ];
      exec = "paste --before";
      desc = "Paste the copied characters before the cursor";
    }

    # Undo/Redo
    {
      on = [ "u" ];
      exec = "undo";
      desc = "Undo the last operation";
    }
    {
      on = [ "<C-r>" ];
      exec = "redo";
      desc = "Redo the last operation";
    }

    # Help
    {
      on = [ "~" ];
      exec = "help";
      desc = "Open help";
    }
  ];

  completion.keymap = [
    {
      on = [ "<C-q>" ];
      exec = "close";
      desc = "Cancel completion";
    }
    {
      on = [ "<Tab>" ];
      exec = "close --submit";
      desc = "Submit the completion";
    }

    {
      on = [ "<A-k>" ];
      exec = "arrow -1";
      desc = "Move cursor up";
    }
    {
      on = [ "<A-j>" ];
      exec = "arrow 1";
      desc = "Move cursor down";
    }

    {
      on = [ "<Up>" ];
      exec = "arrow -1";
      desc = "Move cursor up";
    }
    {
      on = [ "<Down>" ];
      exec = "arrow 1";
      desc = "Move cursor down";
    }

    {
      on = [ "~" ];
      exec = "help";
      desc = "Open help";
    }
  ];

  help.keymap = [
    {
      on = [ "<Esc>" ];
      exec = "escape";
      desc = "Clear the filter; or hide the help";
    }
    {
      on = [ "q" ];
      exec = "close";
      desc = "Exit the process";
    }
    {
      on = [ "<C-q>" ];
      exec = "close";
      desc = "Hide the help";
    }

    # Navigation
    {
      on = [ "k" ];
      exec = "arrow -1";
      desc = "Move cursor up";
    }
    {
      on = [ "j" ];
      exec = "arrow 1";
      desc = "Move cursor down";
    }
    {
      on = [ "<C-u>" ];
      exec = "arrow -50%";
      desc = "Move cursor up half page";
    }
    {
      on = [ "<C-d>" ];
      exec = "arrow 50%";
      desc = "Move cursor down half page";
    }

    # Filtering
    {
      on = [ "/" ];
      exec = "filter";
      desc = "Apply a filter for the help items";
    }
  ];
}
