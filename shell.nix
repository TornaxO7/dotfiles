{ pkgs ? import <nixpkgs> {} }: pkgs.mkShell {
    packages = with pkgs; [
      alacritty
      bat
      bear
      bottom
      dhcpcd
      du-dust
      exa
      fd
      fzf
      git
      highlight
      man
      man-db
      man-pages
      neovim
      ripgrep
      ripgrep-all
      rsync
      rustup
      sd
      tokei
      vifm
      zoxide
      zsh
    ];

    shellHook = ''
    '';
}
