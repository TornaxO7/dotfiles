{ config, unstable, ... }:
{
  config = {
    nix.settings = {
      extra-substituters = [ "https://yazi.cachix.org" ];
      extra-trusted-public-keys = [ "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k=" ];
    };

    programs = {
      fish.functions.y = ''
          set tmp (mktemp -t "yazi-cwd.XXXXXX")
        	yazi $argv --cwd-file="$tmp"
        	if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        		builtin cd -- "$cwd"
        	end
        	rm -f -- "$tmp"
      '';

      yazi = {
        enable = true;
        package = unstable.yazi;
      };
    };

    xdg.configFile.yazi = {
      enable = config.programs.yazi.enable;
      recursive = true;
      source = config.lib.file.mkOutOfStoreSymlink /home/tornax/dotfiles/config/yazi;
      target = "yazi";
    };
  };
}
