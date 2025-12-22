return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim", branch = "master" },
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = function()
			local user = vim.env.USER or "User"
			user = user:sub(1, 1):upper() .. user:sub(2)
			return {
				auto_insert_mode = true,
				headers = {
					user = "  " .. user .. " ",
					assistant = "  Copilot ",
					tool = "󰊳  Tool ",
				},
				window = {
					width = 0.4,
				},
				model = "gpt-4.1",
				resources = "buffer",
			}
		end,
		config = function(_, opts)
			vim.opt.splitright = true
			vim.keymap.set({ "n", "x" }, "<leader>aa", function()
				require("CopilotChat").toggle()
			end, { desc = "Toggle CopilotChat" })
			local chat = require("CopilotChat")

			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "copilot-chat",
				callback = function()
					vim.opt_local.relativenumber = false
					vim.opt_local.number = false
				end,
			})

			chat.setup(opts)
		end,
		-- See Commands section for default commands if you want to lazy load on them
	},
}
