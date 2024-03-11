return {
	"numToStr/Comment.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter,
	},
	opts = {
		ignore = "^$",
		pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
	},
}
