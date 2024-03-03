return {
	"stevearc/conform.nvim",
	ft = { "lua", "typescript", "typescriptreact", "javascript", "json", "jsonc" },
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			typescript = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			javascript = { "eslint_d" },
			json = { "prettier" },
			jsonc = { "prettier" },
		},
	},
	config = function(_, opts)
		require("conform").setup(opts)

		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function(args)
				require("conform").format({ bufnr = args.buf })
			end,
		})
	end,
}
