local M = {}

function M.get_pkg_path(pkg, path, opts)
	pcall(require, "mason") -- make sure Mason is loaded. Will fail when generating docs
	local root = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
	opts = opts or {}
	opts.warn = opts.warn == nil and true or opts.warn
	path = path or ""
	local ret = vim.fs.normalize(root .. "/packages/" .. pkg .. "/" .. path)
	if opts.warn then
		vim.schedule(function()
			if not vim.loop.fs_stat(ret) then
				vim.notify(
					("Mason package path not found for **%s**:\n- `%s`\nYou may need to force update the package."):format(
						pkg,
						path
					),
					vim.log.levels.WARN
				)
			end
		end)
	end
	return ret
end

return M
