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
				"bashls",
				"helm_ls",
				"html",
				"cssls",
				"jsonls",
				"ts_ls",
				"stylua",
				"lua_ls",
				"gopls",
				"basedpyright",
				"ruff",
				"marksman",
				"vue_ls",
			},
		},
	},
}
