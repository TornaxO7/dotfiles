local mason_data_dir = vim.fn.expand("~/Apps/nvim_mason_dir")
local function exists(path)
	local file = io.open(path, "r")
	if file ~= nil then
		io.close(file)
		return true
	else
		return false
	end
end

require("which-key").register({
	M = {
		function()
			vim.api.nvim_command(":Mason")
		end,
		"Mason",
	},
}, { prefix = "<localleader>" })

if not exists(mason_data_dir) then
	os.execute("mkdir -p " .. mason_data_dir)
end

require("mason").setup({
	install_root_dir = vim.fn.expand(mason_data_dir),
})

require("mason-nvim-dap").setup({})
