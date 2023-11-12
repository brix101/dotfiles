return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VimEnter",
		config = function()
			local lualine = require("lualine")

			lualine.setup({
				options = {
					theme = "auto",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_c = {},
				},
			})
		end,
	},
}
