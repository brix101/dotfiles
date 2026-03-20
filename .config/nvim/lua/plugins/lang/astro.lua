return {
  -- depends on the typescript extra
  { import = "plugins.lang.typescript" },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "astro", "css" } },
  },

  -- LSP Servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        astro = {},
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local mason_path = vim.fn.stdpath("data") .. "/mason/packages/"

      -- table.insert(opts.servers.vtsls.filetypes, "astro")
      require("utils").extend(opts.servers.vtsls, "settings.vtsls.tsserver.globalPlugins", {
        {
          name = "@astrojs/ts-plugin",
          location = mason_path .. "astro-language-server" .. "/node_modules/@astrojs/ts-plugin",
          enableForWorkspaceTypeScriptVersions = true,
        },
      })
    end,
  },

  {
    "conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.astro = { "oxfmt", "prettierd", stop_after_first = true }
    end,
  },
}
