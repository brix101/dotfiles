return {
  -- depends on the typescript extra
  { import = "plugins.lang.typescript" },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "vue", "css" } },
  },

  -- Add LSP servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vue_ls = {},
        vtsls = {},
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local mason_path = vim.fn.stdpath("data") .. "/mason/packages/"

      table.insert(opts.servers.vtsls.filetypes, "vue")
      require("utils").extend(opts.servers.vtsls, "settings.vtsls.tsserver.globalPlugins", {
        {
          name = "@vue/typescript-plugin",
          location = mason_path .. "vue-language-server" .. "/node_modules/@vue/language-server",
          languages = { "vue" },
          configNamespace = "typescript",
          enableForWorkspaceTypeScriptVersions = true,
        },
      })
    end,
  },
  -- conform
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.vue = { "oxfmt", "prettierd", stop_after_first = true }
    end,
  },
}
