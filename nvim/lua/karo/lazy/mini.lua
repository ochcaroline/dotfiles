return {
	"nvim-mini/mini.nvim",
	version = false,
	config = function()
		require("mini.ai").setup()
		require("mini.comment").setup()
		require("mini.icons").setup()
		require("mini.pairs").setup()
		require("mini.surround").setup()
		require("mini.notify").setup({
			window = {
				winblend = 0,
			},
		})
		require("mini.extra").setup()
	end,
}
