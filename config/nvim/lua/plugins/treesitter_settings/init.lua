local treesitter = require("nvim-treesitter.configs")
-- local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

-- parser_config.xml = {
-- 	install_info = {
-- 		url = "https://github.com/Trivernis/tree-sitter-xml",
-- 		files = { "src/parser.c" },
-- 		generate_requires_npm = true,
-- 		branch = "main",
-- 	},
-- }
--
-- parser_config.d2 = {
--     install_info = {
--       url = 'https://github.com/pleshevskiy/tree-sitter-d2',
--       revision = 'main',
--       files = { 'src/parser.c', 'src/scanner.cc' },
--     },
--     filetype = 'd2',
-- };

treesitter.setup({
	ensure_installed = "all",

	highlight = {
		enable = true, -- false will disable the whole extension
		disable = { "latex", "dap-repl"},
	},

	indent = { enable = false },

	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gs",
			node_incremental = "<C-k>",
			-- scope_incremental = "<C-j>",
			node_decremental = "<C-j>",
		},
	},

	query_linter = {
		enable = true,
		use_virtual_text = true,
		lint_events = { "BufWrite", "CursorHold" },
	},

	autotag = {
		enable = true,
	},
})
