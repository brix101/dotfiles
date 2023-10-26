return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VimEnter",
		config = function()
			local lualine = require("lualine")

			lualine.setup({
				options = {
					theme = "nightfly",
				},
			})
		end,
	},
}
