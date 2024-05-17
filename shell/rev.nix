{ pkgs }:
pkgs.mkShell {
  packages = with pkgs; [
    ghidra-bin
  ];

  shellHook =
    ''
      echo "Execute \"dbc\" to create a default arch-vm."

      alias db="distrobox"
      alias dbc="distrobox create --name rev --image quay.io/toolbx/arch-toolbox:latest --yes --additional-packages 'pwndbg gdb python-pwntools tmux python fish starship exa' --init-hooks \"echo 'source /usr/share/pwndbg/gdbinit.py' >> ~/.gdbinit\""
    '';
}
