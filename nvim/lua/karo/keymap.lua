vim.keymap.set("n", "<leader>e", vim.cmd.Ex, { noremap = true })

vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete Buffer" })

vim.keymap.set("n", "<leader>ee", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>")

vim.keymap.set("i", "<c-space>", function()
	vim.lsp.completion.get()
end)

vim.keymap.set({ "n", "v" }, "d", '"_d', { noremap = true })
vim.keymap.set("n", "dd", '"_dd', { noremap = true })

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "U", "<C-r>", { desc = "Redo" })

vim.keymap.set({ "n" }, "gd", vim.lsp.buf.definition)
vim.keymap.set({ "n" }, "gr", vim.lsp.buf.references)
vim.keymap.set({ "n" }, "gi", vim.lsp.buf.implementation)
vim.keymap.set({ "n" }, "K", vim.lsp.buf.hover)
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action)
vim.keymap.set({ "n" }, "gf", vim.diagnostic.open_float)
