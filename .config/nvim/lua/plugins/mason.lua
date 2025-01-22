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

    local lsp = require("plugins.lsp.servers")

    -- TODO move this to conform
    local formatters = {
      "stylua",
      "shfmt",
      "prettier", -- prettier formatter
      "isort", -- python formatter
      "black", -- python formatter
    }

    -- TODO move this to nvim lint
    local linters = {}

    local ensure_installed = vim.tbl_keys(lsp)
    local additional_tools = vim.tbl_flatten({ lsp, formatters, linters })
    vim.list_extend(ensure_installed, additional_tools)

    require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
  end,
}
