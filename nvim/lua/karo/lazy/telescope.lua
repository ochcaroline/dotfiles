return {
	"nvim-telescope/telescope.nvim",

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
		local function get_files()
			local ok = pcall(builtin.git_files)

			if not ok then
				builtin.find_files()
			end
		end
		vim.keymap.set("n", "<leader><leader>", get_files, { desc = "Get git files or all files if not git repo" })
		vim.keymap.set("n", "<leader>/", builtin.live_grep, {})
		vim.keymap.set("n", "gr", builtin.lsp_references, {})
		vim.keymap.set("n", "gd", builtin.lsp_definitions, {})
		vim.keymap.set("n", "gf", function()
			builtin.lsp_document_symbols({ symbols = { "function", "class", "method", "struct" } })
		end, {})
	end,
}
