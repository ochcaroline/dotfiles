local ensureInstalled = {
	"zsh",
	"javascript",
	"typescript",
	"tsx",
	"jsx",
	"go",
	"gomod",
	"gosum",
	"gowork",
	"lua",
	"python",
	"ruby", -- used by `Brewfile`
	"sql",
	"vim",
	"vue",
	"json",
	"toml",
	"xml", -- also used by .plist and .svg files, since they are basically xml
	"yaml",
	"css",
	"html",
	"helm",
	"markdown",
	"markdown_inline",
	"diff",
	"dockerfile",
	"editorconfig",
	"git_config",
	"git_rebase",
	"gitattributes",
	"gitcommit",
	"gitignore",
	"requirements", -- python's `requirements.txt`
	"vimdoc", -- `:help` files
	"jsdoc",
	"luadoc",
	"luap", -- lua patterns
	"regex",
	"bash", -- embedded in GitHub Actions, etc.
	"powershell",
}

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	opts = {
		install_dir = vim.fn.stdpath("data") .. "/treesitter",
	},
	init = function()
		-- auto-install parsers
		if vim.fn.executable("tree-sitter") == 1 then
			vim.defer_fn(function()
				require("nvim-treesitter").install(ensureInstalled)
			end, 2000)
		else
			local msg = "`tree-sitter-cli` not found. Skipping auto-install of parsers."
			vim.notify(msg, vim.log.levels.WARN, { title = "Treesitter" })
		end

		-- auto-start highlights & indentation
		vim.api.nvim_create_autocmd("FileType", {
			desc = "User: enable treesitter highlighting",
			callback = function(ctx)
				-- highlights
				local hasStarted = pcall(vim.treesitter.start, ctx.buf) -- errors for filetypes with no parser

				-- indent
				local dontUseTreesitterIndent = { "zsh", "bash", "markdown", "javascript" }
				if hasStarted and not vim.list_contains(dontUseTreesitterIndent, ctx.match) then
					vim.bo[ctx.buf].indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
				end
			end,
		})

		-- comments parser
		vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
			desc = "User: highlights for the Treesitter `comments` parser",
			callback = function()
				-- FIX todo-comments in languages where LSP overwrites their highlight
				-- https://github.com/stsewd/tree-sitter-comment/issues/22
				-- https://github.com/LuaLS/lua-language-server/issues/1809
				vim.api.nvim_set_hl(0, "@lsp.type.comment", {})

				-- Define `@comment.bold` for `queries/comment/highlights.scm`
				vim.api.nvim_set_hl(0, "@comment.bold", { bold = true })
			end,
		})

		-- `ts_query_ls`: use the custom directory set in the treesitter config
		local tsDir = require("nvim-treesitter.config").get_install_dir("parser")
		vim.lsp.config("ts_query_ls", {
			init_options = { parser_install_directories = { tsDir } },
		})
	end,
}
