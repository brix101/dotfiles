-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/init.lua
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
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason.nvim",
      { "mason-org/mason-lspconfig.nvim", config = function() end },
      { "j-hui/fidget.nvim" },
      "saghen/blink.cmp",
    },
    ---@class PluginLspOpts
    opts = function()
      local mason_path = vim.fn.stdpath("data") .. "/mason/packages/"

      ---@class PluginLspOpts
      local ret = {
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
            -- enable = false,
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
            settings = {
              Lua = {
                runtime = {
                  version = "LuaJIT",
                },
                diagnostics = {
                  globals = { "vim" },
                },
                workspace = {
                  checkThirdParty = false,
                  library = vim.api.nvim_get_runtime_file("", true),
                },
                format = {
                  enable = false,
                },
                telemetry = {
                  enable = false,
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
            filetypes = { "typescriptreact", "javascriptreact", "html", "svelte", "astro", "vue" },
          },
          yamlls = {},
          svelte = {},
          vtsls = {
            enable = true,
            filetypes = {
              "javascript",
              "javascriptreact",
              "javascript.jsx",
              "typescript",
              "typescriptreact",
              "typescript.tsx",
              "vue",
            },
            settings = {
              complete_function_calls = true,
              vtsls = {
                enableMoveToFileCodeAction = true,
                autoUseWorkspaceTsdk = true,
                experimental = {
                  maxInlayHintLength = 30,
                  completion = {
                    enableServerSideFuzzyMatch = true,
                  },
                },
                tsserver = {
                  maxTsServerMemory = 12288,
                  globalPlugins = {
                    {
                      name = "@vue/typescript-plugin",
                      location = mason_path .. "vue-language-server" .. "/node_modules/@vue/language-server",
                      languages = { "vue" },
                      configNamespace = "typescript",
                    },
                  },
                },
              },
              typescript = {
                updateImportsOnFileMove = { enabled = "always" },
                suggest = {
                  completeFunctionCalls = true,
                },
                inlayHints = {
                  enumMemberValues = { enabled = true },
                  functionLikeReturnTypes = { enabled = true },
                  parameterNames = { enabled = "literals" },
                  parameterTypes = { enabled = true },
                  propertyDeclarationTypes = { enabled = true },
                  variableTypes = { enabled = false },
                },
              },
              javascript = {
                updateImportsOnFileMove = { enabled = "always" },
                suggest = {
                  completeFunctionCalls = true,
                },
                inlayHints = {
                  enumMemberValues = { enabled = true },
                  functionLikeReturnTypes = { enabled = true },
                  parameterNames = { enabled = "literals" },
                  parameterTypes = { enabled = true },
                  propertyDeclarationTypes = { enabled = true },
                  variableTypes = { enabled = false },
                },
              },
            },
            keys = {},
          },
          vue_ls = {},
        },
      }

      return ret
    end,
    config = function(_, opts)
      for server, server_opts in pairs(opts.servers) do
        if type(server_opts) == "table" and server_opts.keys then
          require("utils").lsp_keymap({ name = server ~= "*" and server or nil }, server_opts.keys)
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

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- Use Blink.cmp capabilities if available, fallback to cmp_nvim_lsp
      local has_blink, blink = pcall(require, "blink.cmp")
      if has_blink then
        capabilities = vim.tbl_deep_extend("force", capabilities, blink.get_lsp_capabilities())
      end

      local have_mason, mlsp = pcall(require, "mason-lspconfig")
      local mason_all = have_mason
          and vim.tbl_keys(require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package)
        or {} --[[ @as string[] ]]
      local mason_exclude = {} ---@type string[]

      ---@return boolean? exclude automatic setup
      local function configure(server)
        if server == "*" then
          return false
        end
        local sopts = opts.servers[server]
        sopts = sopts == true and {} or (not sopts) and { enabled = false } or sopts --[[@as lazyvim.lsp.Config]]

        if sopts.enabled == false then
          mason_exclude[#mason_exclude + 1] = server
          return
        end

        vim.lsp.config(server, sopts) -- configure the server
        if not use_mason then
          vim.lsp.enable(server)
        end

        local use_mason = sopts.mason ~= false and vim.tbl_contains(mason_all, server)
        return use_mason
      end

      local install = vim.tbl_filter(configure, vim.tbl_keys(opts.servers))
      if have_mason then
        require("mason-lspconfig").setup({
          ensure_installed = install,
          automatic_enable = { exclude = mason_exclude },
        })
      end
    end,
  },

  -- cmdline tools and lsp servers
  {

    "mason-org/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        "biome",
        "goimports",
        "gofumpt",
        "prettierd",
        "stylua",
        "shfmt",
        "sqlfluff",
      },
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
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
    end,
  },
}
