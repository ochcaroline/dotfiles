return {
	"ochcaroline/dum.nvim",
	config = function()
		require("dum").setup({
			model = "gpt-5.6-luna",
		})
	end,
}
-- return {
-- 	dir = "~/source/priv/dum.nvim/",
-- 	config = function()
-- 		require("dum").setup()
-- 	end,
-- }
