{ inputs, self, pkgs, ... }:
{
  config = {
    nix.settings = {
      extra-substituters = [ "https://yazi.cachix.org" ];
      extra-trusted-public-keys = [ "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k=" ];
    };

    programs = {
      yazi = {
        enable = true;
        package = inputs.yazi.packages.${pkgs.stdenv.hostPlatform.system}.default;
        # extraPackages = with pkgs; [
        #   ouch
        # ];
        shellWrapperName = "y";

        initLua = ''
          local bookmarks = {}
          table.insert(bookmarks, {
            tag = "home",
            path = os.getenv("HOME"),
            key = "h"
          })

          require("yamb"):setup {
            bookmarks = bookmarks
          }
        '';

        flavors = {
          tokyo-night = ./tokyo-night.yazi;
        };

        plugins = {
          yamb = self.packages.${pkgs.stdenv.hostPlatform.system}.yamb;
          smart-enter = pkgs.yaziPlugins.smart-enter;
          jump-to-char = pkgs.yaziPlugins.jump-to-char;
        };

        settings = {
          mgr = {
            ratio = [ 1 4 3 ];
            sort_by = "natural";
            sort_sensitive = true;
            sort_reverse = false;
            sort_dir_first = true;
            linemode = "size";
            show_hidden = false;
            show_symlink = true;
            scrolloff = 7;
          };
          preview = {
            tab_size = 2;
            max_width = 600;
            max_height = 900;
            cache_dir = "";
            ueberzug_scale = 1;
            ueberzug_offset = [ 0 0 0 0 ];
          };
          opener = {
            evince = [{ run = "evince %s"; block = false; orphan = true; }];
            helix = [{ run = "$EDITOR %s"; block = true; }];
            xdg-open = [{ run = "xdg-open %s"; }];
            ouch = [{ run = "ouch d -y %s"; desc = "Extract with ouch"; }];
            # for debugging purposes;
            # test = [{ run = "notify-send \"he\llo"" }];
            vimiv = [{ run = "vimiv %s"; block = false; orphan = true; }];
            xournalpp = [{ run = "xournalpp %s"; block = false; orphan = true; }];
            ffplay = [{ run = "ffplay %s"; block = false; orphan = true; }];
            vlc = [{ run = "vlc %s"; block = false; orphan = true; }];
            rnote = [{ run = "rnote %s"; block = false; orphan = true; }];
          };
          # mime types: https://developer.mozilla.org/en-US/docs/Web/HTTP/MIME_types/Common_types
          open.rules = [
            { mime = "text/*"; use = [ "helix" ]; }
            { mime = "image/*"; use = [ "vimiv" ]; }
            { mime = "video/*"; use = [ "vlc" ]; }
            { mime = "audio/*"; use = [ "ffplay" ]; }
            { url = "*.xopp"; use = [ "xournalpp" ]; }
            # workarounds since mime types don't work here :
            { url = "*.zip"; use = [ "ouch" ]; }
            { url = "*.gz"; use = [ "ouch" ]; }
            { url = "*.tar"; use = [ "ouch" ]; }
            { url = "*.bz"; use = [ "ouch" ]; }
            { url = "*.bz2"; use = [ "ouch" ]; }
            { url = "*.rnote"; use = [ "rnote" ]; }
            { mime = "application/pdf"; use = [ "evince" ]; }
          ];
          tasks = {
            micro_workers = 10;
            macro_workers = 25;
            bizarre_retry = 5;
            image_alloc = 536870912; # 512MB
            image_bound = [ 0 0 ];
            suppress_preload = false;
          };
          plugins = {
            preloaders = [
              # Image
              { mime = "image/vnd.djvu"; run = "noop"; }
              { mime = "image/*"; run = "image"; }
              # Video
              { mime = "video/*"; run = "video"; }
              # PDF
              { mime = "application/pdf"; run = "pdf"; }
            ];
            previewers = [
              { url = "*/"; run = "folder"; sync = true; }
              # Code
              { mime = "text/*"; run = "code"; }
              { mime = "*/xml"; run = "code"; }
              { mime = "*/javascript"; run = "code"; }
              { mime = "*/x-wine-extension-ini"; run = "code"; }
              # JSON
              { mime = "application/json"; run = "json"; }
              # Image
              # { mime = "image/vnd.djvu"; run = "noop"; }
              # { mime = "image/*"; run = "image"; }
              # Video
              # { mime = "video/*"; run = "video"; }
              # PDF
              # { mime = "application/pdf"; run = "pdf"; }
              # Archive
              { mime = "application/zip"; run = "ouch l"; }
              { mime = "application/gzip"; run = "ouch l"; }
              { mime = "application/x-tar"; run = "ouch l"; }
              { mime = "application/x-bzip"; run = "ouch l"; }
              { mime = "application/x-bzip2"; run = "ouch l"; }
              { mime = "application/x-7z-compressed"; run = "ouch l"; }
              { mime = "application/x-rar"; run = "ouch l"; }
              { mime = "application/xz"; run = "ouch l"; }
              # Fallback
              { url = "*"; run = "file"; }
            ];
          };
          input = {
            cd_title = "Change directory:";
            cd_origin = "top-center";

            create_title = [ "Create:" "Create (dir):" ];
            create_origin = "center";

            rename_origin = "center";

            trash_title = "Move {n} selected file{s} to trash? (y/N)";
            trash_origin = "center";

            delete_title = "Delete {n} selected file{s} permanently? (y/N)";
            delete_origin = "center";

            filter_title = "Filter:";
            filter_origin = "center";

            find_title = [ "Find next:" "Find previous:" ];
            find_origin = "center";

            search_title = "Search:";
            search_origin = "center";

            shell_title = [ "Shell:" "Shell (block):" ];
            shell_origin = "center";

            overwrite_title = "Overwrite an existing file? (y/N)";
            overwrite_origin = "center";

            quit_title = "{n} task{s} running, sure to quit? (y/N)";
            quit_origin = "center";
          };
        };

        keymap = {
          mgr = {
            keymap = [
              { on = [ "<Esc>" ]; run = "escape"; desc = "Exit visual mode, clear selected, or cancel search"; }
              { on = [ "q" ]; run = "close"; desc = "Close tab"; }
              { on = [ "Q" ]; run = "quit"; desc = "Close yazi"; }
              # navigation
              { on = [ "k" ]; run = "arrow -1"; desc = "Move cursor up"; }
              { on = [ "j" ]; run = "arrow 1"; desc = "Move cursor down"; }
              { on = [ "<C-u>" ]; run = "arrow -50%"; desc = "Move cursor up half page"; }
              { on = [ "<C-d>" ]; run = "arrow 50%"; desc = "Move cursor down half page"; }
              { on = [ "h" ]; run = [ "leave" "escape --visual --select" ]; desc = "Go back to the parent directory"; }
              { on = [ "l" ]; run = "plugin smart-enter"; desc = "Enter the child directory"; }
              { on = [ "<C-o>" ]; run = "back"; desc = "Go back to the previous directory"; }
              { on = [ "<C-i>" ]; run = "forward"; desc = "Go forward to the next directory"; }
              # selection
              { on = [ "<Space>" ]; run = [ "toggle --state=none" "arrow 1" ]; desc = "Toggle the current selection state"; }
              { on = [ "v" ]; run = "visual_mode"; desc = "Enter visual mode (selection mode)"; }
              { on = [ "V" ]; run = "visual_mode --unset"; desc = "Enter visual mode (unset mode)"; }
              # yank/delete
              { on = [ "y" "y" ]; run = [ "yank" "escape --visual --select" ]; desc = "Copy the selected files"; }
              { on = [ "y" "f" ]; run = "copy path"; desc = "Copy the absolute path"; }
              { on = [ "y" "d" ]; run = "copy dirname"; desc = "Copy the path of the parent directory"; }
              { on = [ "y" "x" ]; run = [ "yank --cut" "escape --visual --select" ]; desc = "Cut the selected files"; }
              { on = [ "p" ]; run = "paste"; desc = "Paste the files"; }
              { on = [ "P" ]; run = "paste --force"; desc = "Paste the files (overwrite if the destination exists)"; }
              { on = [ "-" ]; run = "link"; desc = "Symlink the absolute path of files"; }
              { on = [ "_" ]; run = "link --relative"; desc = "Symlink the relative path of files"; }
              { on = [ "d" "D" ]; run = [ "remove --permanently" "escape --visual --select" ]; desc = "Permanently delete the files"; }
              { on = [ "a" ]; run = "create"; desc = "Create a file"; }
              { on = [ "A" ]; run = "create --dir"; desc = "Create a directory"; }
              { on = [ "r" ]; run = "rename --cursor=before_ext"; desc = "Rename a file or directory"; }
              { on = [ ":" ]; run = "shell --block --interactive"; desc = "Run a shell command (block the UI until the command finishes)"; }
              { on = [ "." ]; run = "hidden toggle"; desc = "Toggle the visibility of hidden files"; }
              # search/filter
              { on = [ "e" "n" ]; run = "search fd"; desc = "Search files by name using fd"; }
              { on = [ "e" "r" ]; run = "search rg"; desc = "Search files by content using ripgrep"; }
              { on = [ "e" "s" ]; run = "filter --smart"; desc = "Filter the files"; }
              { on = [ "z" ]; run = "plugin zoxide"; desc = "Jump to a directory using zoxide"; }
              # find
              { on = [ "/" ]; run = "find --smart"; desc = "Find next file"; }
              { on = [ "n" ]; run = "find_arrow"; desc = "Go to next found file"; }
              { on = [ "N" ]; run = "find_arrow --previous"; desc = "Go to previous found file"; }
              # sorting
              { on = [ "s" "m" ]; run = "sort modified --dir-first"; desc = "Sort by modified time"; }
              { on = [ "s" "M" ]; run = "sort modified --reverse --dir-first"; desc = "Sort by modified time (reverse)"; }
              { on = [ "s" "c" ]; run = "sort created --dir-first"; desc = "Sort by created time"; }
              { on = [ "s" "C" ]; run = "sort created --reverse --dir-first"; desc = "Sort by created time (reverse)"; }
              { on = [ "s" "e" ]; run = "sort extension --dir-first"; desc = "Sort by extension"; }
              { on = [ "s" "E" ]; run = "sort extension --reverse --dir-first"; desc = "Sort by extension (reverse)"; }
              { on = [ "s" "a" ]; run = "sort alphabetical --dir-first"; desc = "Sort alphabetically"; }
              { on = [ "s" "A" ]; run = "sort alphabetical --reverse --dir-first"; desc = "Sort alphabetically (reverse)"; }
              { on = [ "s" "n" ]; run = "sort natural --dir-first"; desc = "Sort naturally"; }
              { on = [ "s" "N" ]; run = "sort natural --reverse --dir-first"; desc = "Sort naturally (reverse)"; }
              { on = [ "s" "s" ]; run = "sort size --dir-first"; desc = "Sort by size"; }
              { on = [ "s" "S" ]; run = "sort size --reverse --dir-first"; desc = "Sort by size (reverse)"; }
              # tasks
              { on = [ "w" ]; run = "tasks:show"; desc = "Show the tasks manager"; }
              # actions
              { on = [ "c" "d" ]; run = "cd --interactive"; desc = "Go to a directory interactively"; }
              { on = [ "g" "g" ]; run = "arrow top"; desc = "Move cursor to the top"; }
              { on = [ "g" "e" ]; run = "arrow bot"; desc = "Move cursor to the bottom"; }
              # help
              { on = [ "?" ]; run = "help"; desc = "Open help"; }
              # tabs
              { on = [ "<C-t>" ]; run = "tab_create"; desc = "Create tab"; }
              { on = [ "<C-h>" ]; run = "tab_switch -1 --relative"; desc = "Switch to prev tab"; }
              { on = [ "<C-l>" ]; run = "tab_switch 1 --relative"; desc = "Switch to next tab"; }
            ];

            prepend_keymap = [
              { on = [ "m" "a" ]; run = "plugin yamb -- save"; desc = "Save current position as a bookmark"; }
              { on = [ "m" "d" ]; run = "plugin yamb -- delete_by_key"; desc = "Delete bookmark"; }
              { on = [ "'" ]; run = "plugin yamb -- jump_by_key"; desc = "Jump to a bookmark"; }
              { on = [ "f" ]; run = "plugin jump-to-char"; desc = "Jump to char"; }
            ];
          };

          tasks.keymap = [
            { on = [ "<Esc>" ]; run = "close"; desc = "Hide the task manager"; }
            { on = [ "<C-q>" ]; run = "close"; desc = "Hide the task manager"; }
            { on = [ "w" ]; run = "close"; desc = "Hide the task manager"; }
            { on = [ "k" ]; run = "arrow -1"; desc = "Move cursor up"; }
            { on = [ "j" ]; run = "arrow 1"; desc = "Move cursor down"; }
            { on = [ "<Enter>" ]; run = "inspect"; desc = "Inspect the task"; }
            { on = [ "d" "d" ]; run = "cancel"; desc = "Cancel the task"; }
            { on = [ "~" ]; run = "help"; desc = "Open help"; }
          ];
          input.keymap = [
            { on = [ "<C-q>" ]; run = "close"; desc = "Cancel input"; }
            { on = [ "<Enter>" ]; run = "close --submit"; desc = "Submit the input"; }
            { on = [ "<Esc>" ]; run = "escape"; desc = "Go back the normal mode; or cancel input"; }
            # mode
            { on = [ "i" ]; run = "insert"; desc = "Enter insert mode"; }
            { on = [ "a" ]; run = "insert --append"; desc = "Enter append mode"; }
            { on = [ "I" ]; run = [ "move -999" "insert" ]; desc = "Move to the BOL; and enter insert mode"; }
            { on = [ "A" ]; run = [ "move 999" "insert --append" ]; desc = "Move to the EOL; and enter append mode"; }
            { on = [ "v" ]; run = "visual"; desc = "Enter visual mode"; }
            { on = [ "V" ]; run = [ "move -999" "visual" "move 999" ]; desc = "Enter visual mode and select all"; }
            # Character-wise movement
            { on = [ "h" ]; run = "move -1"; desc = "Move back a character"; }
            { on = [ "l" ]; run = "move 1"; desc = "Move forward a character"; }
            # word wise movement
            { on = [ "b" ]; run = "backward"; desc = "Move back to the start of the current or previous word"; }
            { on = [ "w" ]; run = "forward"; desc = "Move forward to the start of the next word"; }
            { on = [ "e" ]; run = "forward --end-of-word"; desc = "Move forward to the end of the current or next word"; }
            # Line-wise movemen
            { on = [ "g" "h" ]; run = "move -999"; desc = "Move to the BOL"; }
            { on = [ "g" "s" ]; run = "move -999"; desc = "Move to the BOL"; }
            { on = [ "g" "l" ]; run = "move 999"; desc = "Move to the EOL"; }
            # Delete
            { on = [ "<Backspace>" ]; run = "backspace"; desc = "Delete the character before the cursor"; }
            # Kill
            { on = [ "<C-u>" ]; run = "kill bol"; desc = "Kill backwards to the BOL"; }
            { on = [ "<C-k>" ]; run = "kill eol"; desc = "Kill forwards to the EOL"; }
            { on = [ "<C-w>" ]; run = "kill backward"; desc = "Kill backwards to the start of the current word"; }
            { on = [ "<A-d>" ]; run = "kill forward"; desc = "Kill forwards to the end of the current word"; }
            # Cut/Yank/Paste
            { on = [ "d" ]; run = [ "delete --cut" "move 1 --in-operating" ]; desc = "Cut the selected characters"; }
            { on = [ "D" ]; run = [ "delete --cut" "move 999" ]; desc = "Cut until the EOL"; }
            { on = [ "c" ]; run = "delete --cut --insert"; desc = "Cut the selected characters; and enter insert mode"; }
            { on = [ "C" ]; run = [ "delete --cut --insert" "move 999" ]; desc = "Cut until the EOL; and enter insert mode"; }
            { on = [ "y" ]; run = "yank"; desc = "Copy the selected characters"; }
            { on = [ "p" ]; run = "paste"; desc = "Paste the copied characters after the cursor"; }
            { on = [ "P" ]; run = "paste --before"; desc = "Paste the copied characters before the cursor"; }
            # Undo/Redo
            { on = [ "u" ]; run = "undo"; desc = "Undo the last operation"; }
            { on = [ "U" ]; run = "redo"; desc = "Redo the last operation"; }
            # Help
            { on = [ "~" ]; run = "help"; desc = "Open help"; }
          ];

          cmp.keymap = [
            { on = [ "<C-q>" ]; run = "close"; desc = "Cancel completion"; }
            { on = [ "<Enter>" ]; run = "close --submit"; desc = "Submit the completion"; }
            { on = [ "<Backtab>" ]; run = "arrow -1"; desc = "Move cursor up"; }
            { on = [ "<Tab>" ]; run = "arrow 1"; desc = "Move cursor down"; }
            { on = [ "~" ]; run = "help"; desc = "Open help"; }
          ];

          help.keymap = [
            { on = [ "<Esc>" ]; run = "escape"; desc = "Clear the filter; or hide the help"; }
            { on = [ "q" ]; run = "close"; desc = "Exit the process"; }
            { on = [ "<C-q>" ]; run = "close"; desc = "Hide the help"; }
            # Navigation
            { on = [ "k" ]; run = "arrow -1"; desc = "Move cursor up"; }
            { on = [ "j" ]; run = "arrow 1"; desc = "Move cursor down"; }
            { on = [ "<C-u>" ]; run = "arrow -50%"; desc = "Move cursor up half page"; }
            { on = [ "<C-d>" ]; run = "arrow 50%"; desc = "Move cursor down half page"; }
            # Filtering
            { on = [ "/" ]; run = "filter"; desc = "Apply a filter for the help items"; }
          ];
        };
      };
    };
  };
}
