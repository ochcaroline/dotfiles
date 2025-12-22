vim.keymap.set("n", "<leader>tr", function()
	require("neotest").run.run()
end)

vim.keymap.set("n", "<leader>tt", function()
	require("neotest").run.run(vim.fn.expand("%"))
end)

return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"nvim-neotest/neotest-go",
			"nvim-neotest/neotest-python",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-go")({
						experimental = { test_table = true },
						args = { "--count=1", "--timeout=60s" },
						dap_adapter = "go",
					}),
				},
			})
		end,
	},
}
