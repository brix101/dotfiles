return {
  -- depends on the typescript extra
  { import = "plugins.lang.typescript" },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "svelte" } },
  },

  -- LSP Servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        svelte = {
          keys = {
            {
              "<leader>co",
              function()
                require("utils").lsp_action["source.organizeImports"]()
              end,
              desc = "Organize Imports",
            },
          },
        },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local mason_path = vim.fn.stdpath("data") .. "/mason/packages/"

      table.insert(opts.servers.vtsls.filetypes, "svelte")
      require("utils").extend(opts.servers.vtsls, "settings.vtsls.tsserver.globalPlugins", {
        {
          name = "typescript-svelte-plugin",
          location = mason_path .. "svelte-language-server" .. "/node_modules/typescript-svelte-plugin",
          enableForWorkspaceTypeScriptVersions = true,
        },
      })
    end,
  },

  {
    "conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.svelte = { "oxfmt", "prettierd", stop_after_first = true }
    end,
  },
}
