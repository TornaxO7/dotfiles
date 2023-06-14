local overseer = require("overseer")

return {
    name = "sudo nixos-rebuild switch --flake",
    builder = function(params)
        return {
            cmd = { "sudo" },
            args = { "nixos-rebuild", "switch", "--flake" },
            name = "switch",
            cwd = "."
        }
    end,
    tags = { overseer.TAG.BUILD },
    params = {},
    priority = 50,
    condition = {
        filetype = { "nix" },
        dir = "/home/tornax/Programming/projects/dotfiles",
    },
}
