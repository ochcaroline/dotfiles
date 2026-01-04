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

vim.lsp.config.ts_ls = {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact", "javascript.jsx" },
	root_markers = { "package.json", "tsconfig.json", "jsconfig.json" },
}
vim.lsp.enable({ "ts_ls", "cssls" })

vim.lsp.config.pylsp = {
	cmd = { "basedpyright" },
	filetypes = { "python" },
	root_markers = { ".git", ".pylintrc", "setup.py", "setup.cfg", "pyproject.toml" },
}
vim.lsp.enable("basedpyright")

vim.lsp.inlay_hint.enable()

vim.lsp.config("*", {
	on_attach = function(client, bufnr)
		-- overwrites omnifunc/tagfunc set by some Python plugins to the
		-- default values for LSP
		vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })
		vim.api.nvim_set_option_value("tagfunc", "v:lua.vim.lsp.tagfunc", { buf = bufnr })

		vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
			signs = true,
			underline = true,
			virtual_text = true,
		})
	end,
})
