return {
  "neovim/nvim-lspconfig",
  dependencies = {
    {
      "mason-org/mason.nvim",
      ---@module 'mason.settings'
      ---@type MasonSettings
      ---@diagnostic disable-next-line: missing-fields
      opts = {},
    },
    "mason-org/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",

    { "j-hui/fidget.nvim", opts = {} },

    "saghen/blink.cmp",
  },
  ---@class PluginLspOpts
  opts = {
    diagnostics = {
      underline = true,
      update_in_insert = false,
      virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "●",
        -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
        -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
        -- prefix = "icons",
      },
      severity_sort = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.HINT] = " ",
          [vim.diagnostic.severity.INFO] = " ",
        },
      },
    },
    inlay_hints = {
      enabled = false,
      exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
    },
    -- Enable the following language servers
    ---@type table<string, vim.lsp.Config>
    servers = {
      bashls = {},
      biome = {},
      cssls = {},
      eslint = {
        autostart = false,
        cmd = { "vscode-eslint-language-server", "--stdio", "--max-old-space-size=12288" },
        settings = { format = false },
      },
      graphql = {
        filetypes = { "graphql", "gql", "typescriptreact", "javascriptreact" },
      },
      gopls = {
        analyses = {
          fieldalignment = false,
          nilness = true,
          unusedparams = true,
          unusedwrite = true,
          useany = true,
        },
        codelenses = {
          gc_details = false,
          generate = true,
          regenerate_cgo = true,
          run_govulncheck = true,
          test = true,
          tidy = true,
          upgrade_dependency = true,
          vendor = true,
        },
        experimentalPostfixCompletions = true,
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
        gofumpt = true,
        semanticTokens = true,
        -- staticcheck = true,
        usePlaceholders = true,
      },
      html = {},
      jsonls = {},
      lua_ls = {
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if
              path ~= vim.fn.stdpath("config")
              and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
            then
              return
            end
          end

          ---@diagnostic disable-next-line: param-type-mismatch
          client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
              version = "LuaJIT",
              path = { "lua/?.lua", "lua/?/init.lua" },
            },
            workspace = {
              checkThirdParty = false,
              -- NOTE: this is a lot slower and will cause issues when working on your own configuration.
              --  See https://github.com/neovim/nvim-lspconfig/issues/3189
              library = vim.tbl_extend("force", vim.api.nvim_get_runtime_file("", true), {
                "${3rd}/luv/library",
                "${3rd}/busted/library",
              }),
            },
          })
        end,
        settings = {
          Lua = {},
        },
      },
      marksman = {},
      oxlint = {
        root_markers = { ".oxlintrc.json" },
      },
      sqls = {},
      tailwindcss = {
        filetypes = { "typescriptreact", "javascriptreact", "html", "svelte", "astro" },
      },
      yamlls = {},
      svelte = {},
      vue_ls = {},
    },
    formatters = {
      prettierd = {},
      stylua = {},
    },
  },
  config = function(_, opts)
    local map_lsp_keymaps = require("config.keymaps").map_lsp_keymaps

    -- inlay hints
    if opts.inlay_hints.enabled then
      Snacks.util.lsp.on({ method = "textDocument/inlayHint" }, function(buffer)
        if
          vim.api.nvim_buf_is_valid(buffer)
          and vim.bo[buffer].buftype == ""
          and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
        then
          vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
        end
      end)
    end

    -- diagnostics
    if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
      local diagnostic_icons = opts.diagnostics.signs.text
      opts.diagnostics.virtual_text.prefix = function(diagnostic)
        return diagnostic_icons[diagnostic.severity] or "●"
      end
    end

    vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
      callback = function(event)
        local bufnr = event.buf
        local bufname = vim.api.nvim_buf_get_name(bufnr)

        -- Detach from non-file buffers (diffview, fugitive, etc.)
        if bufname == "" or bufname:match("^diffview://") or bufname:match("^fugitive://") then
          vim.schedule(function()
            vim.lsp.buf_detach_client(bufnr, event.data.client_id)
          end)
          return
        end

        map_lsp_keymaps(bufnr)

        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method("textDocument/documentHighlight", event.buf) then
          local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd("LspDetach", {
            group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
            end,
          })
        end
      end,
    })

    local ensure_installed = vim.tbl_keys(vim.tbl_deep_extend("force", {}, opts.servers, opts.formatters))

    require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

    for name, server in pairs(opts.servers) do
      vim.lsp.config(name, server)
      vim.lsp.enable(name)
    end
  end,
}
