return {
	"numToStr/Comment.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
		"nvim-treesitter/nvim-treesitter,
	},
	opts = {
		pre_hook = function()		
        		return vim.bo.commentstring
		end,
	},
}
