return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	opts = {
		options = {
			hover = {
				enabled = true,
				delay = 200,
				reveal = { "close" },
			},
			offsets = {
				{
					filetype = "NvimTree",
					text = "File Explorer",
					separator = true,
					text_align = "center",
				},
			},
			diagnostics = "nvim_lsp",
			-- mode = "tabs",
			-- separator_style = "slant",
			modified_icon = "●",
			show_close_icon = false,
			show_buffer_close_icons = false,
		},
	},
}
