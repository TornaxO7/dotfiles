{ ... }:
{
  config.programs.nushell = {
    enable = false;

    environmentVariables = {
      EDITOR = "hx";
      # MANPAGER = "${lib.getExe pkgs.neovim} +Man!";
    };

    configFile.source = ./config/nushell/config.nu;
    envFile.source = ./config/nushell/env.nu;
  };
}
