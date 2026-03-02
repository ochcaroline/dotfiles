return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"https://github.com/nvim-telescope/telescope-ui-select.nvim",
	},

	config = function()
		local telescope = require("telescope")

		telescope.setup({
			defaults = {
				file_ignore_patterns = {
					"node_modules",
					".git",
					"venv",
					".venv",
					"go.mod",
					"go.sum",
					".env",
				},
			},
		})
		telescope.load_extension("ui-select")

		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>fg", builtin.git_files, { desc = "Get git files or all files if not git repo" })
		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Get all files in the dir" })
		vim.keymap.set("n", "<leader>/", builtin.live_grep, {})
		vim.keymap.set("n", "gr", builtin.lsp_references, {})
		vim.keymap.set("n", "gd", builtin.lsp_definitions, {})
		vim.keymap.set("n", "gs", function()
			builtin.lsp_document_symbols({ symbols = { "function", "class", "method", "struct" } })
		end, {})
		vim.keymap.set("n", "<leader>of", builtin.oldfiles, {})
	end,
}
