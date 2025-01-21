return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
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

    local mr = require("mason-registry")
    mr:on("package:install:success", function()
      vim.defer_fn(function()
        -- trigger FileType event to possibly load this newly installed LSP server
        require("lazy.core.handler.event").trigger({
          event = "FileType",
          buf = vim.api.nvim_get_current_buf(),
        })
      end, 100)
    end)

    mr.refresh(function()
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end)

    -- You can add other tools here that you want Mason to install
    -- for you, so that they are available from within Neovim.
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
    vim.list_extend(ensure_installed, lsp)
    vim.list_extend(ensure_installed, formatters)
    vim.list_extend(ensure_installed, linters)

    require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
  end,
}
