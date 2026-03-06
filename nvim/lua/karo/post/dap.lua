local dap_ok, dap = pcall(require, "dap")
if not dap_ok then
	return
end

-- VS Code style breakpoint signs
vim.fn.sign_define("DapBreakpoint", {
	text = "●",
	texthl = "DapBreakpoint",
	linehl = "DapBreakpointLine",
	numhl = "DapBreakpoint",
})
vim.fn.sign_define("DapBreakpointCondition", {
	text = "◆",
	texthl = "DapBreakpointCondition",
	linehl = "DapBreakpointLine",
	numhl = "DapBreakpointCondition",
})
vim.fn.sign_define("DapLogPoint", {
	text = "◆",
	texthl = "DapLogPoint",
	linehl = "DapLogPointLine",
	numhl = "DapLogPoint",
})
vim.fn.sign_define("DapStopped", {
	text = "▶",
	texthl = "DapStopped",
	linehl = "DapStoppedLine",
	numhl = "DapStopped",
})
vim.fn.sign_define("DapBreakpointRejected", {
	text = "●",
	texthl = "DapBreakpointRejected",
	linehl = "",
	numhl = "DapBreakpointRejected",
})

vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#e51400" })
vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#f5a623" })
vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#61afef" })
vim.api.nvim_set_hl(0, "DapStopped", { fg = "#98c379" })
vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = "#888888" })
vim.api.nvim_set_hl(0, "DapBreakpointLine", { bg = "#2e1a1a" })
vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#1a2e1a" })
vim.api.nvim_set_hl(0, "DapLogPointLine", { bg = "#1a1e2e" })

-- UI: layout with watches, breakpoints, console
local dapui_ok, dapui = pcall(require, "dapui")
if dapui_ok then
	dapui.setup({
		layouts = {
			{
				elements = {
					{ id = "scopes", size = 0.40 },
					{ id = "watches", size = 0.30 },
					{ id = "breakpoints", size = 0.30 },
				},
				size = 40,
				position = "left",
			},
			{
				elements = {
					{ id = "console", size = 0.6 },
					{ id = "repl", size = 0.4 },
				},
				size = 12,
				position = "bottom",
			},
		},
	})

	dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open()
	end
	dap.listeners.before.event_terminated["dapui_config"] = function()
		dapui.close()
	end
	dap.listeners.before.event_exited["dapui_config"] = function()
		dapui.close()
	end
end

-- Go (uses delve)
local dap_go_ok, dap_go = pcall(require, "dap-go")
if dap_go_ok then
	dap_go.setup()
end

-- Python (uses debugpy installed via mason)
local dap_python_ok, dap_python = pcall(require, "dap-python")
if dap_python_ok then
	local debugpy_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
	dap_python.setup(debugpy_path)
end

-- TypeScript / JavaScript (uses vscode-js-debug via js-debug-adapter from mason)
local dap_vscode_ok, dap_vscode = pcall(require, "dap-vscode-js")
if dap_vscode_ok then
	dap_vscode.setup({
		debugger_cmd = { "js-debug-adapter" },
		adapters = { "pwa-node", "pwa-chrome", "node-terminal" },
	})
	for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
		dap.configurations[language] = {
			{
				type = "pwa-node",
				request = "launch",
				name = "Launch file",
				program = "${file}",
				cwd = "${workspaceFolder}",
				sourceMaps = true,
			},
			{
				type = "pwa-node",
				request = "attach",
				name = "Attach to process",
				processId = require("dap.utils").pick_process,
				cwd = "${workspaceFolder}",
			},
		}
	end
end

-- Track which configs came from the project file so we can reload cleanly
local project_config_names = {}

-- Helper available in .nvim/dap.lua as DapLoadEnv("path/to/.env")
function DapLoadEnv(path)
	path = path or (vim.fn.getcwd() .. "/.env")
	local env = {}
	local f = io.open(path, "r")
	if not f then
		vim.notify("DAP: env file not found: " .. path, vim.log.levels.WARN)
		return env
	end
	for line in f:lines() do
		-- skip comments and blank lines
		if not line:match("^%s*#") and not line:match("^%s*$") then
			local k, v = line:match("^%s*([%w_]+)%s*=%s*(.-)%s*$")
			if k then
				-- strip surrounding quotes if present
				v = v:match('^"(.*)"$') or v:match("^'(.*)'$") or v
				env[k] = v
			end
		end
	end
	f:close()
	return env
end

local function load_project_dap_config()
	-- Remove previously loaded project configs
	for language, names in pairs(project_config_names) do
		if dap.configurations[language] then
			dap.configurations[language] = vim.tbl_filter(function(c)
				return not vim.tbl_contains(names, c.name)
			end, dap.configurations[language])
		end
	end
	project_config_names = {}

	local root = vim.fn.getcwd()
	local config_path = root .. "/.nvim/dap.lua"
	if vim.fn.filereadable(config_path) == 0 then
		return
	end
	local ok, project_configs = pcall(dofile, config_path)
	if not ok or type(project_configs) ~= "table" then
		vim.notify("DAP: failed to load " .. config_path, vim.log.levels.WARN)
		return
	end
	for language, configs in pairs(project_configs) do
		dap.configurations[language] = dap.configurations[language] or {}
		project_config_names[language] = project_config_names[language] or {}
		for _, config in ipairs(configs) do
			table.insert(dap.configurations[language], config)
			table.insert(project_config_names[language], config.name)
		end
	end
	vim.notify("DAP: loaded project config from .nvim/dap.lua", vim.log.levels.INFO)
end

-- Show picker of all configs for the current filetype
local function pick_debug_config()
	local ft = vim.bo.filetype
	local configs = dap.configurations[ft]
	if not configs or #configs == 0 then
		vim.notify("DAP: no configurations for filetype '" .. ft .. "'", vim.log.levels.WARN)
		return
	end
	vim.ui.select(configs, {
		prompt = "Select debug configuration:",
		format_item = function(config)
			local source = vim.tbl_contains(project_config_names[ft] or {}, config.name) and " [project]"
				or " [default]"
			return config.name .. source
		end,
	}, function(config)
		if config then
			dap.run(config)
		end
	end)
end

load_project_dap_config()

-- Keymaps
vim.keymap.set("n", "<F5>", function()
	pick_debug_config()
end, { desc = "DAP Continue / Pick config" })

vim.keymap.set("n", "<F10>", function()
	dap.step_over()
end, { desc = "DAP Step Over" })

vim.keymap.set("n", "<leader>dsi", function()
	dap.step_into()
end, { desc = "DAP Step Into" })

vim.keymap.set("n", "<leader>dsv", function()
	dap.step_out()
end, { desc = "DAP Step Out" })

vim.keymap.set("n", "<F9>", function()
	dap.toggle_breakpoint()
end, { desc = "Toggle Breakpoint" })

vim.keymap.set("n", "<leader>dB", function()
	dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Conditional Breakpoint" })

vim.keymap.set("n", "<leader>du", function()
	if dapui_ok then
		dapui.toggle()
	end
end, { desc = "Toggle DAP UI" })
vim.keymap.set("n", "<leader>dR", function()
	if dapui_ok then
		dapui.open({ reset = true })
	end
end, { desc = "Reset DAP UI Layout" })

vim.keymap.set("n", "<leader>dx", function()
	dap.terminate()
	if dapui_ok then
		dapui.close()
	end
end, { desc = "Terminate DAP session" })

vim.keymap.set("n", "<leader>dl", function()
	load_project_dap_config()
end, { desc = "Reload project DAP config" })
