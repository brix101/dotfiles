return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		require("mason").setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})
		-- You can add other tools here that you want Mason to install
		-- for you, so that they are available from within Neovim.
		local lsp_servers = require("brix.plugins.lsp.servers")

		local servers = {
			"python-lsp-server",
		}

		local formatters = {
			"prettierd",
			"prettier", -- prettier formatter
			"stylua", -- lua formatter
			"isort", -- python formatter
			"black", -- python formatter
		}

		local linters = {
			"pylint",
			"eslint_d",
		}

		local ensure_installed = vim.tbl_keys(lsp_servers or {})
		vim.list_extend(ensure_installed, servers)
		vim.list_extend(ensure_installed, formatters)
		vim.list_extend(ensure_installed, linters)

		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
	end,
}
