return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {},
	-- Optional dependencies
	-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
	lazy = false,
	config = function()
		local oil = require("oil")

		oil.setup({
			default_file_explorer = true,
			delete_to_trash = true,
			skip_confirm_for_simple_edits = true,
			view_options = {
				show_hidden = true,
				natural_order = true,
				is_always_hidden = function(name)
					return name == ".git"
						or name == "node_modules"
						or name == ".venv"
						or name == "venv"
						or name == "__pycache__"
						or name == ".mypy_cache"
						or name == ".pytest_cache"
						or name == ".ruff_cache"
						or name == "dist"
						or name == ".next"
						or name == ".nuxt"
						or name == "vendor"
						or name == ".DS_Store"
				end,
			},
		})
	end,
}
