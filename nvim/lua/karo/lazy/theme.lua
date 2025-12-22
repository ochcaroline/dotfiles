return {
	{
		"vague-theme/vague.nvim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other plugins
		config = function()
			require("vague").setup({
				transparent = true,
			})
			vim.cmd("colorscheme vague")
		end,
	},
	-- {
	-- 	"projekt0n/github-nvim-theme",
	-- 	name = "github-theme",
	-- 	lazy = false, -- make sure we load this during startup if it is your main colorscheme
	-- 	priority = 1000, -- make sure to load this before all the other start plugins
	-- 	config = function()
	-- 		require("github-theme").setup({
	-- 			options = {
	-- 				transparent = true,
	-- 				styles = {
	-- 					comments = "italic",
	-- 					keywords = "bold",
	-- 					types = "italic,bold",
	-- 				},
	-- 			},
	-- 		})
	--
	-- 		vim.cmd("colorscheme github_dark_default")
	-- 	end,
	-- },
}
