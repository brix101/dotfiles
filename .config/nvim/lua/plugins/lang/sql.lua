return {
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = { ensure_installed = { "sql" } },
  },
  -- Linters & formatters
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "sqlfluff" } },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        sqls = {},
      },
    },
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters.sqlfluff = {
        -- args = { "format", "--dialect=ansi", "-" },
        args = { "format", "--dialect=postgres", "-" },
        cwd = function()
          return vim.fn.getcwd()
        end,
      }
      opts.formatters_by_ft.sql = { "sqlfluff" }
    end,
  },
}
