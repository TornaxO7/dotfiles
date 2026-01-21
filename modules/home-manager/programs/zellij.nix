{ unstable, ... }:
{
  config = {
    programs.zellij = {
      enable = true;
      package = unstable.zellij;

      settings = {
        scrollback_editor = "hx";
        show_startup_tips = false;


      };

      extraConfig = ''
        plugins {
            tab-bar { path "tab-bar"; }
            status-bar { path "status-bar"; }
            strider { path "strider"; }
            compact-bar { path "compact-bar"; }
        }

        keybinds clear-defaults=true {
            normal { }
            locked {
                bind "Ctrl g" { SwitchToMode "Normal"; }
            }
            resize {
                bind "Ctrl r" { SwitchToMode "Normal"; }

                bind "=" "+" { Resize "Increase"; }
                bind "-" { Resize "Decrease"; }

                bind "h" { Resize "Increase Left"; }
                bind "j" { Resize "Increase Down"; }
                bind "k" { Resize "Increase Up"; }
                bind "l" { Resize "Increase Right"; }
            }
            pane {
                bind "Ctrl n" { SwitchToMode "Normal"; }

                bind "n" { EditScrollback; SwitchToMode "Normal"; }
                bind "r" { TogglePaneFrames; SwitchToMode "Normal"; }
                bind "s" { DumpScreen "/tmp/zellij-dump.txt"; SwitchToMode "Normal"; }

                bind "h" { MovePane "Left"; }
                bind "j" { MovePane "Down"; }
                bind "k" { MovePane "Up"; }
                bind "l" { MovePane "Right"; }

                bind "j" { ScrollDown; }
                bind "k" { ScrollUp; }

                bind "Ctrl d" { HalfPageScrollDown; }
                bind "Ctrl u" { HalfPageScrollUp; }

                bind "/" { SwitchToMode "EnterSearch"; SearchInput 0; }
                bind "G" { ScrollToBottom; SwitchToMode "Normal"; }
            }
            search {
                bind "j" { ScrollDown; }
                bind "k" { ScrollUp; }
                bind "Ctrl d" { HalfPageScrollDown; }
                bind "Ctrl u" { HalfPageScrollUp; }
                bind "n" { Search "down"; }
                bind "p" { Search "up"; }
                bind "c" { SearchToggleOption "CaseSensitivity"; }
                bind "w" { SearchToggleOption "Wrap"; }
                bind "o" { SearchToggleOption "WholeWord"; }

                bind "/" { SwitchToMode "EnterSearch"; SearchInput 0; }
            }
            entersearch {
                bind "Ctrl c" "Esc" { SwitchToMode "Scroll"; }
                bind "Enter" { SwitchToMode "Search"; }
            }
            session {
                bind "Ctrl s" { SwitchToMode "Normal"; }
    
                bind "d" { Detach; }
            }

            shared {
                bind "Alt L" { GoToNextTab; }
                bind "Alt H" { GoToPreviousTab; }

                bind "Alt N" { NewTab; }
                bind "Alt b" { BreakPane; SwitchToMode "Normal"; }

                bind "Alt h" { MoveFocusOrTab "Left"; }
                bind "Alt l" { MoveFocusOrTab "Right"; }
                bind "Alt j" { MoveFocus "Down"; }
                bind "Alt k" { MoveFocus "Up"; }

                bind "Alt d" { CloseFocus; SwitchToMode "Normal"; }
                bind "Alt D" { CloseTab; SwitchToMode "Normal"; }

                bind "Alt +" { Resize "Increase"; }
                bind "Alt -" { Resize "Decrease"; }

                bind "Alt n" { NewPane; }

                bind "Alt [" { PreviousSwapLayout; }
                bind "Alt ]" { NextSwapLayout; }
            }

            shared_except "locked" {
                bind "Ctrl g" { SwitchToMode "Locked"; }
                bind "Ctrl q" { Quit; }
            }

            shared_except "normal" "locked" {
                bind "Enter" "Esc" { SwitchToMode "Normal"; }
            }

            shared_except "pane" "locked" {
                bind "Ctrl n" { SwitchToMode "Pane"; }
            }
            shared_except "resize" "locked" {
                bind "Ctrl r" { SwitchToMode "Resize"; }
            }
            shared_except "session" "locked" {
                bind "Ctrl s" { SwitchToMode "Session"; }
            }
        }
      '';
    };
  };
}
