return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  cmd = "Mason",
  keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
  opts = {
    ensure_installed = {
      "stylua",
      "shfmt",
    },
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  },
  config = function(_, opts)
    require("mason").setup(opts)

    -- TODO move this connected with the lsp servers config
    local lsp = {
      "lua_ls",
      "ts_ls",
      "vtsls",
      "eslint",
      "tailwindcss",
      "gopls",
      "marksman",
      "graphql",
    }
    -- TODO move this to conform
    local formatters = {
      "prettier", -- prettier formatter
      "isort", -- python formatter
      "black", -- python formatter
    }

    -- TODO move this to nvim lint
    local linters = {
      "pylint",
    }

    local ensure_installed = vim.tbl_keys(opts.ensure_installed or {})
    local additional_tools = vim.tbl_flatten({ lsp, formatters, linters })
    vim.list_extend(ensure_installed, additional_tools)

    require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
  end,
}
