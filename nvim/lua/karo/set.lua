vim.opt.updatetime = 250

vim.opt.winborder = "rounded"
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.scrolloff = 999

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.inccommand = "split"

vim.opt.confirm = true

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.clipboard = "unnamed"

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_user_command("W", "w", {})
