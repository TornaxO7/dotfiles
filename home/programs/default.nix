{ inputs, system, age, pkgs, lib, ... }:
{
  imports = [
    ./yazi.nix
    ./helix.nix
    ./zathura.nix
    ./bugstalker.nix
  ];

  config.programs = {
    bat.enable = true;

    bottom.enable = true;

    eza = {
      enable = true;
      icons = true;
      git = true;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
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

    gtt = {
      enable = true;
      package = inputs.gtt.packages.${system}.default;
      settings.api_key.DeepL.file = age.secrets.deepl.path;
      keymap = {
        clear = "C-l";

        translate = "C-n";
        copy_destination = "C-r";
        exit = "C-s";
        swap_language = "C-z";
      };
    };

    home-manager.enable = true;

    git = {
      enable = true;
      package = pkgs.gitoxide;
      delta.enable = true;
      signing = {
        key = "7559 3129 41F8 AAAD 9EB6  D913 F652 0002 D62D 6194";
        signByDefault = true;
      };
      userEmail = "tornax@proton.me";
      userName = "TornaxO7";
      extraConfig = {
        core = {
          editor = "hx";
        };

        merge.tool = "nvimdiff";

        mergetool = {
          vimdiff.layout = "(LOCAL,REMOTE)/MERGED";
          keepBackup = false;
        };

        push.autoSetupRemote = true;
        pull.rebase = false;
      };
    };

    gpg = {
      enable = true;

      scdaemonSettings = {
        disable-ccid = true;
        reader-port = "Yubico Yubi";
      };
    };

    jq = {
      enable = true;
      package = pkgs.jaq;
    };

    less.enable = true;

    man.enable = true;

    neovim = {
      enable = false;
      defaultEditor = false;
      extraPackages = with pkgs; [
        gcc13
        deno
      ];
      withPython3 = true;
      vimdiffAlias = true;
    };

    password-store.enable = true;

    ssh = {
      enable = true;
      forwardAgent = true;
    };

    starship = {
      enable = true;
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

    fish = {
      enable = true;
      shellAliases = import ../shell_aliases.nix;
      interactiveShellInit = ''
        bind -k nul accept-autosuggestion
      '';
    };

    nushell = {
      enable = false;

      environmentVariables = {
        EDITOR = "hx";
        # MANPAGER = "${lib.getExe pkgs.neovim} +Man!";
      };

      configFile.source = ../../config/nushell/config.nu;
      envFile.source = ../../config/nushell/env.nu;
    };

    zsh = {
      enable = false;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      shellAliases = import ../shell_aliases.nix;
      sessionVariables = import ../session_variables.nix;
      initExtra = ''
        bindkey '^ ' autosuggest-accept
        eval "$(zoxide init zsh)"
      '';
      oh-my-zsh = {
        enable = true;
        plugins = [
          "aliases"
          "git"
        ];
      };
    };
  };
}
