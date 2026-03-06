local status_ok, neotest = pcall(require, "neotest")
if not status_ok then
	return
end

local adapters = {}

local go_ok, go_adapter = pcall(require, "neotest-golang")
if go_ok then
	table.insert(adapters, go_adapter({ go_test_args = { "-v", "-race", "-count=1", "-timeout=60s" } }))
end

local python_ok, python_adapter = pcall(require, "neotest-python")
if python_ok then
	table.insert(adapters, python_adapter({ dap = { justMyCode = false } }))
end

local vitest_ok, vitest_adapter = pcall(require, "neotest-vitest")
if vitest_ok then
	table.insert(adapters, vitest_adapter)
end

local jest_ok, jest_adapter = pcall(require, "neotest-jest")
if jest_ok then
	table.insert(adapters, jest_adapter({}))
end

neotest.setup({
	summary = { open = "botright vsplit" },
	status = { virtual_text = true },
	output = { open_on_run = true },
	adapters = adapters,
})
