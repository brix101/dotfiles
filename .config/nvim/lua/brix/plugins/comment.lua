return {
	"numToStr/Comment.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		pre_hook = function(...)
			require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()(...)
		end,
	},
}
