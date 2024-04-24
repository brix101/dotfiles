return {
	"nvim-lua/plenary.nvim", -- lua functions that many plugins use

	"christoomey/vim-tmux-navigator", -- tmux & split window navigation

	"inkarkat/vim-ReplaceWithRegister", -- replace with register contents using motion (gr + motion)

	{
		"nvim-tree/nvim-web-devicons",
		config = function()
			require("nvim-web-devicons").set_icon({
				gql = {
					icon = "",
					color = "#e535ab",
					cterm_color = "199",
					name = "GraphQL",
				},
			})
		end,
	},

	-- Neovim plugin to improve the default vim.ui interfaces
	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",
		-- dependencies = { "MunifTanjim/nui.nvim" },
		opts = {},
	},
}
