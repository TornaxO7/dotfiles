{pkgs, lib}:
{
  bat.enable = true;

  bottom.enable = true;

  exa = {
    enable = true;
    enableAliases = true;
    icons = true;
    git = true;
  };

  fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "rg --files --engine=pcre2";
    defaultOptions = [
      "--prompt='> '"
      "--cycle"
      "--preview='bat --color always {}'"
      "+i"
      "--bind=ctrl-j:preview-half-page-down,ctrl-k:preview-half-page-up"
    ];
  };

  git = {
    enable = true;
    package = pkgs.gitoxide;
    delta.enable = true;
    signing = {
      key = "7559 3129 41F8 AAAD 9EB6  D913 F652 0002 D62D 6194";
      signByDefault = true;
    };
    userEmail = "tornax@pm.me";
    userName = "TornaxO7";
  };

  gpg.enable = true;

  jq.enable = true;

  less.enable = true;

  man.enable = true;

  neovim = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      gcc13
    ];
    withPython3 = true;
    vimdiffAlias = true;
  };

  password-store.enable = true;

  ssh = {
    enable = true;
  };

  starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;

      format = lib.concatStrings [
        "┌─ $os$all"
        # "[└─](bold green)"
      ];
      right_format = "$battery";

      directory.style = "bold fg:#00affa";

      os.disabled = false;

      battery.display = [{
        threshold = 100;
        style = "bold #dbcf00";
      }];

      git_status = {
        style = "bold fg:#ffcb00";

        format = "([\\[$all_status$ahead_behind\\]]($style) )";
        staged = "+$count";
        deleted = "-$count";
        modified = "!$count";
      };

      git_branch.style = "bold fg:#00da00";
    };
  };

  tealdeer = {
    enable = true;
    settings.updates.auto_update = true;
  };

  zellij.enable = true;

  zoxide.enable = true;

  zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    enableCompletion = true;
    shellAliases = import ./shell_aliases.nix;
    sessionVariables = import ./session_variables.nix;
    initExtra = "bindkey '^ ' autosuggest-accept; eval \"$(zoxide init --cmd cd zsh)\"";
    oh-my-zsh = {
      enable = true;
      plugins = [
        "aliases"
        "git"
      ];
    };
  };
}
