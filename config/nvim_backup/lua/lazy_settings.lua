-- vim.keymap.set("i", "a", function()
--     local vimscript_code = [[getline('.')[col('.')-1] =~? '[]>)}]' || getline('.')[col('.')-1] =~? '[''"`]' && synIDattr(synID(line("."), col(".")+1, 1), "name") !~? 'string' ]]
--
--     if vim.api.nvim_eval(vimscript_code) == 1 then
--         vim.cmd('norm <Right>')
--     end
-- end, {})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--single-branch",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup("plugins", {
    rtp = {
        disabled_plugins = {
        }
    },
})
