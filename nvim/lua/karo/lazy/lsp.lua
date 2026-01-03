return {
	{
		"mason-org/mason.nvim",
		opts = { ensure_installed = { "goimports", "gofumpt", "prettier" } },
	},
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			{ "neovim/nvim-lspconfig" },
		},
		opts = {
			-- LSPs
			ensure_installed = {
				-- bash
				"bashls",
				-- web stuff
				"html",
				"cssls",
				"ts_ls",
				"vue_ls",
				-- lua
				"stylua",
				"lua_ls",
				-- go
				"gopls",
				-- python
				"basedpyright",
				"ruff",
				-- markdown
				"marksman",
				-- misc
				"jsonls",
				"helm_ls",
			},
		},
	},
}
