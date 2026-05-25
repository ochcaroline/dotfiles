return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"fredrikaverpil/neotest-golang",
			"nvim-neotest/neotest-python",
			"marilari88/neotest-vitest",
		},
		config = function()
			local neotest_ns = vim.api.nvim_create_namespace("neotest")
			vim.diagnostic.config({
				virtual_text = {
					format = function(diagnostic)
						local message =
							diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
						return message
					end,
				},
			}, neotest_ns)
		end,
		keys = {
			{
				"<leader>tr",
				function()
					require("neotest").run.run()
				end,
				desc = "Run Nearest (Neotest)",
			},
			{
				"<leader>tt",
				function()
					require("neotest").run.run(vim.fn.expand("%"))
				end,
				desc = "Run File (Neotest)",
			},
			{
				"<leader>ts",
				function()
					require("neotest").summary.toggle()
				end,
				desc = "Toggle Summary (Neotest)",
			},
			{
				"<leader>to",
				function()
					require("neotest").output_panel.toggle()
				end,
				desc = "Toggle Output (Neotest)",
			},
			{
				"<leader>td",
				function()
					require("neotest").run.run({ strategy = "dap" })
				end,
				desc = "Debug Nearest (Neotest)",
			},
			{
				"<leader>tx",
				function()
					require("dap").terminate()
					pcall(function() require("dapui").close() end)
					require("neotest").summary.close()
					require("neotest").output_panel.close()
				end,
				desc = "Stop Debug Session (Neotest)",
			},
			{
				"<F9>",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle Breakpoint (DAP)",
			},
			{
				"<F10>",
				function()
					require("dap").step_over()
				end,
				desc = "Step Over (DAP)",
			},
			{
				"<F11>",
				function()
					require("dap").step_into()
				end,
				desc = "Step Into (DAP)",
			},
		},
	},
}
