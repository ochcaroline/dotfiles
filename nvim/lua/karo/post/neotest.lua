local status_ok, neotest = pcall(require, "neotest")
if not status_ok then
	return
end

neotest.setup({
	summary = {
		open = "botright vsplit",
	},
	status = { virtual_text = true },
	output = { open_on_run = true },
	adapters = {
		require("neotest-golang")({
			go_test_args = { "-v", "-race", "-count=1", "-timeout=60s" },
		}),
		require("neotest-python")({
			dap = { justMyCode = false },
		}),
	},
	log_level = vim.log.levels.DEBUG, -- Temporary: for debugging
})
