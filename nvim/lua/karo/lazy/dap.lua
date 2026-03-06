return {
	{
		"mfussenegger/nvim-dap",
		lazy = true,
		dependencies = {
			{ "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
			"leoluz/nvim-dap-go",
			"mfussenegger/nvim-dap-python",
			"mxsdev/nvim-dap-vscode-js",
		},
	},
}
