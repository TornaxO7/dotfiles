local overseer = require("overseer")

return {
    name = "nix flake check",
    builder = function(params)
        return {
            cmd = { "nix" },
            args = { "flake", "check" },
            name = "check",
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
