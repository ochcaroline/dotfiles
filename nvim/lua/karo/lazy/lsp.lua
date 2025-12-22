vim.lsp.config.go = {
	cmd = { "gopls" },
	filetypes = { "go" },
	root_markers = {
		"go.mod",
		".git",
	},
	settings = {},
}

return {
	{
		"mason-org/mason.nvim",
		opts = { ensure_installed = { "goimports", "gofumpt" } },
	},
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			{ "neovim/nvim-lspconfig" },
		},
		opts = {
			ensure_installed = {
				"bashls", -- also used for zsh
				"html",
				"cssls",
				"ts_ls",
				"stylua", -- lua formatter
				"lua_ls",
				"gopls", -- Go LSP with formatting and diagnostics
				"basedpyright", -- Python LSP with type checking
				"ruff", -- python linter & formatter
				"marksman", -- Markdown LSP
			},
		},
	},
}
-- vim: ts=2 sts=2 sw=2 et
