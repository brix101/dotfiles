local diagnostic_icons = {
  Error = " ",
  Warn = " ",
  Hint = " ",
  Info = " ",
}
local kind_filter = {
  "Class",
  "Constructor",
  "Enum",
  "Field",
  "Function",
  "Interface",
  "Method",
  "Module",
  "Namespace",
  "Package",
  "Property",
  "Struct",
  "Trait",
}

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

    { "j-hui/fidget.nvim" },
    "saghen/blink.cmp",
  },
  ---@class PluginLspOpts
  opts = {
    ---@type vim.diagnostic.Opts
    diagnostics = {
      underline = true,
      update_in_insert = false,
      virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "●",
      },
      severity_sort = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = diagnostic_icons.Error,
          [vim.diagnostic.severity.WARN] = diagnostic_icons.Warn,
          [vim.diagnostic.severity.HINT] = diagnostic_icons.Hint,
          [vim.diagnostic.severity.INFO] = diagnostic_icons.Info,
        },
      },
    },
    inlay_hints = {
      enabled = true,
      exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
    },
    -- Enable the following language servers
    ---@type table<string, vim.lsp.Config>
    servers = {
      ["*"] = {
        capabilities = {
          workspace = {
            fileOperations = {
              didRename = true,
              willRename = true,
            },
          },
        },
        -- stylua: ignore
        keys = {
          { "<leader>cl", function() Snacks.picker.lsp_config() end, desc = "Lsp Info" },
          { "gd", vim.lsp.buf.definition, desc = "Goto Definition", has = "definition" },
          { "gr", vim.lsp.buf.references, desc = "References", nowait = true },
          { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
          { "gy", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition" },
          { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
          { "K", function() return vim.lsp.buf.hover({ border = "rounded" }) end, desc = "Hover" },
          { "<C-k>", function() return vim.lsp.buf.signature_help({ border = "rounded" }) end, mode = "i", desc = "Signature Help", has = "signatureHelp" },
          { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "x" }, has = "codeAction" },
          { "<leader>rn", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
          { "gd", function() require('telescope.builtin').lsp_definitions() end, desc = "Goto Definition" },
          { "gr", function() require('telescope.builtin').lsp_references() end, nowait = true, desc = "References" },
          { "gI", function() require('telescope.builtin').lsp_implementations() end, desc = "Goto Implementation" },
          { "gt", function() require('telescope.builtin').lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
          { "<leader>ss", function() require('telescope.builtin').lsp_document_symbols({ filter = kind_filter }) end, desc = "LSP Symbols" },
          { "<leader>sS", function() require('telescope.builtin').lsp_dynamic_workspace_symbols({ filter = kind_filter }) end, desc = "LSP Workspace Symbols" },
        },
      },
      bashls = {},
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
        usePlaceholders = true,
        completeUnimported = true,
        staticcheck = true,
        directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
        semanticTokens = true,
      },
      html = {},
      jsonls = {},
      lua_ls = {
        -- mason = false, -- set to false if you don't want this server to be installed with mason
        -- Use this to add any additional keymaps
        -- for specific lsp servers
        -- ---@type LazyKeysSpec[]
        -- keys = {},
        settings = {
          Lua = {
            workspace = {
              checkThirdParty = false,
            },
            codeLens = {
              enable = true,
            },
            completion = {
              callSnippet = "Replace",
            },
            doc = {
              privateName = { "^_" },
            },
            hint = {
              enable = true,
              setType = false,
              paramType = true,
              paramName = "Disable",
              semicolon = "Disable",
              arrayIndex = "Disable",
            },
          },
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
      biome = {},
      prettierd = {},
      stylua = {},
      goimports = {},
      gofumpt = {},
      sqlfluff = {},
    },
  },
  config = function(_, opts)
    ---@param filter vim.lsp.get_clients.Filter
    ---@param spec LazyKeysLspSpec[]
    local function keymap_set(filter, spec)
      local Keys = require("lazy.core.handler.keys")
      for _, keys in pairs(Keys.resolve(spec)) do
        ---@cast keys LazyKeysLsp
        local filters = {} ---@type vim.lsp.get_clients.Filter[]
        if keys.has then
          local methods = type(keys.has) == "string" and { keys.has } or keys.has --[[@as string[] ]]
          for _, method in ipairs(methods) do
            method = method:find("/") and method or ("textDocument/" .. method)
            filters[#filters + 1] = vim.tbl_extend("force", vim.deepcopy(filter), { method = method })
          end
        else
          filters[#filters + 1] = filter
        end

        for _, f in ipairs(filters) do
          local opts = Keys.opts(keys)
          ---@cast opts snacks.keymap.set.Opts
          opts.lsp = f
          opts.enabled = keys.enabled
          Snacks.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
        end
      end
    end

    for server, server_opts in pairs(opts.servers) do
      if type(server_opts) == "table" and server_opts.keys then
        keymap_set({ name = server ~= "*" and server or nil }, server_opts.keys)
      end
    end

    -- diagnostics
    vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

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

    if opts.servers["*"] then
      vim.lsp.config("*", opts.servers["*"])
    end

    -- LSP servers and clients are able to communicate to each other what features they support.
    --  By default, Neovim doesn't support everything that is in the LSP specification.
    --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
    --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- Use Blink.cmp capabilities if available, fallback to cmp_nvim_lsp
    local has_blink, blink = pcall(require, "blink.cmp")
    if has_blink then
      capabilities = vim.tbl_deep_extend("force", capabilities, blink.get_lsp_capabilities())
    end

    local install = vim.tbl_filter(function(server)
      return server ~= "*"
    end, vim.tbl_keys(opts.servers))

    require("mason-tool-installer").setup({
      auto_update = true,
      run_on_start = true,
      start_delay = 3000,
      debounce_hours = 12,
      ensure_installed = vim.list_extend(install, vim.tbl_keys(opts.formatters)),
    })

    for name, config in pairs(opts.servers) do
      if name ~= "*" then
        -- Configure the server
        vim.lsp.config(name, {
          cmd = config.cmd,
          capabilities = capabilities,
          filetypes = config.filetypes,
          settings = config.settings,
          root_dir = config.root_dir,
          root_markers = config.root_markers,
        })

        -- Enable the server (with autostart setting if specified)
        if config.autostart == false then
          -- Don't auto-enable servers with autostart = false
          -- Users can manually enable with :lua vim.lsp.enable(name)
        else
          vim.lsp.enable(name)
        end
      end
    end

    -- Setup Mason for managing external LSP servers
    require("mason").setup({ ui = { border = "rounded" } })
    require("mason-lspconfig").setup()
  end,
}
