local null_ls = require("null-ls")
local code_actions = null_ls.builtins.code_actions
local diagnostics = null_ls.builtins.diagnostics
-- formatting sources
local formatting = null_ls.builtins.formatting
null_ls.setup({
	sources = {
		code_actions.refactoring,

		diagnostics.checkmake,
		diagnostics.chktex,
		diagnostics.clang_check,
		diagnostics.cmake_lint,

		formatting.rustfmt,
		formatting.stylua,
		formatting.prettier,
		formatting.autopep8,
		formatting.clang_format,
	},
})
