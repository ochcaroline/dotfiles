local utils = require("karo.utils")

vim.diagnostic.config({
	virtual_text = true,
	--virtual_lines = true, -- a bit too invasive
})

vim.lsp.config.gopls = {
	cmd = { "gopls" },
	filetypes = { "go", "gomod" },
	root_markers = { ".git", "go.mod" },
	settings = {
		gopls = {
			gofumpt = true,
			codelenses = {
				gc_details = false,
				generate = true,
				regenerate_cgo = true,
				run_govulncheck = true,
				test = true,
				tidy = true,
				upgrade_dependency = true,
				vendor = true,
			},
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
			analyses = {
				nilness = true,
				unusedparams = true,
				unusedwrite = true,
				useany = true,
			},
			usePlaceholders = true,
			completeUnimported = true,
			staticcheck = true,
			directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
			semanticTokens = true,
		},
	},
}

-- javascript, typescript and all that shit
local tsserver_filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" }
local vue_plugin = {
	name = "@vue/typescript-plugin",
	location = utils.get_pkg_path("vue-language-server", "/node_modules/@vue/language-server"),
	languages = { "vue" },
	configNamespace = "typescript",
	enableForWorkspaceTypeScriptVersions = true,
}

local ts_ls_config = {
	init_options = {
		plugins = {
			vue_plugin,
		},
	},
	filetypes = tsserver_filetypes,
}

local vue_ls_config = {}
vim.lsp.config("vue_ls", vue_ls_config)
vim.lsp.config("ts_ls", ts_ls_config)
vim.lsp.enable({ "vue_ls", "ts_ls", "cssls" })

-- python
vim.lsp.config.pylsp = {
	cmd = { "basedpyright" },
	filetypes = { "python" },
	root_markers = { ".git", ".pylintrc", "setup.py", "setup.cfg", "pyproject.toml" },
}
vim.lsp.enable("basedpyright")

-- helm
vim.lsp.config.helm_ls = {
	filetypes = { "helm" },
	root_markers = { "Chart.yaml", "values.yaml" },
}

-- and generic :D
vim.lsp.inlay_hint.enable()

vim.lsp.config("*", {
	on_attach = function(client, bufnr)
		-- overwrites omnifunc/tagfunc set by some Python plugins to the
		-- default values for LSP
		vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })
		vim.api.nvim_set_option_value("tagfunc", "v:lua.vim.lsp.tagfunc", { buf = bufnr })
	end,
})
