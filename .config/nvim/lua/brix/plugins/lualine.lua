return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VimEnter",
		dependencies = {
			{ "f-person/git-blame.nvim" },
		},
		config = function()
			local lualine = require("lualine")
			local git_blame = require("gitblame")

			lualine.setup({
				options = {
					theme = "auto",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_c = {
						{
							git_blame.get_current_blame_text,
							cond = git_blame.is_blame_text_available,
							color = { fg = "#ABABAB", gui = "italic" },
						},
					},
				},
			})
		end,
	},
}
