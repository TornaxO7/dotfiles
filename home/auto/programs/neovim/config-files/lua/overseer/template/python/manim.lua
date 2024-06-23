local overseer = require("overseer")

return {
  -- Required fields
  name = "manim -pql /tmp/test.py",
  builder = function(params)
    print(vim.inspect(params))
    -- This must return an overseer.TaskDefinition
    return {
      -- cmd is the only required field
      cmd = {'manim'},
      -- additional arguments for the cmd
      args = {"-pql", "test.py"},
      cwd = "/tmp",
    }
  end,
  desc = "Simply run the current python file",
  tags = {overseer.TAG.BUILD},
  priority = 0,
  condition = {
    filetype = {"python"},
    dir = "/tmp",
  }
}
