return {
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    version = "*",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    dependencies = {
      "mason.nvim", -- NOTE: Must be loaded before dependants
      { "williamboman/mason-lspconfig.nvim", config = function() end },
      {
        "j-hui/fidget.nvim",
        opts = {},
      },
    },
    opts = function()
      ---@class PluginLspOpts
      local ret = {
        -- options for vim.diagnostic.config()
        ---@type vim.diagnostic.Opts
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
        -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the inlay hints.
        inlay_hints = {
          enabled = true,
          -- exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
        },
        -- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the code lenses.
        codelens = {
          enabled = false,
        },
        -- add any global capabilities here
        capabilities = {
          workspace = {
            fileOperations = {
              didRename = true,
              willRename = true,
            },
          },
        },
        -- options for vim.lsp.buf.format
        -- `bufnr` and `filter` is handled by the LazyVim formatter,
        -- but can be also overridden when specified
        format = {
          formatting_options = nil,
          timeout_ms = nil,
        },
        servers = {
          lua_ls = {
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
          ts_ls = {},
          vtsls = {
            -- explicitly add default filetypes, so that we can extend
            -- them in related extras
            filetypes = {
              "javascript",
              "javascriptreact",
              "javascript.jsx",
              "typescript",
              "typescriptreact",
              "typescript.tsx",
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
            },
            ---@type LazyKeysSpec[]
            keys = {
              {
                "gD",
                function()
                  local params = vim.lsp.util.make_position_params()
                  -- LazyVim.lsp.execute({
                  --   command = "typescript.goToSourceDefinition",
                  --   arguments = { params.textDocument.uri, params.position },
                  --   open = true,
                  -- })
                end,
                desc = "Goto Source Definition",
              },
              -- {
              --   "gR",
              --   function()
              --     LazyVim.lsp.execute({
              --       command = "typescript.findAllFileReferences",
              --       arguments = { vim.uri_from_bufnr(0) },
              --       open = true,
              --     })
              --   end,
              --   desc = "File References",
              -- },
              {
                "<leader>co",
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    only = { "source.organizeImports" },
                    diagnostics = {},
                  },
                }),
                desc = "Organize Imports",
              },
              -- {
              --   "<leader>cM",
              --   LazyVim.lsp.action["source.addMissingImports.ts"],
              --   desc = "Add missing imports",
              -- },
              -- {
              --   "<leader>cu",
              --   LazyVim.lsp.action["source.removeUnused.ts"],
              --   desc = "Remove unused imports",
              -- },
              -- {
              --   "<leader>cD",
              --   LazyVim.lsp.action["source.fixAll.ts"],
              --   desc = "Fix all diagnostics",
              -- },
              -- {
              --   "<leader>cV",
              --   function()
              --     LazyVim.lsp.execute({ command = "typescript.selectTypeScriptVersion" })
              --   end,
              --   desc = "Select TS workspace version",
              -- },
            },
          },
          eslint = {
            settings = {
              workingDirectories = { mode = "auto" },
              format = true,
            },
            keys = {
              { "<leader>cf", "<cmd>EslintFixAll<cr>", desc = "EslintFixAll" },
            },
          },
          tailwindcss = {
            filetypes = { "typescriptreact", "javascriptreact", "html", "markdown" },
          },
          gopls = {
            settings = {
              gopls = {
                gofumpt = true,
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
                hints = {
                  assignVariableTypes = true,
                  compositeLiteralFields = true,
                  compositeLiteralTypes = true,
                  constantValues = true,
                  functionTypeParameters = true,
                  parameterNames = true,
                  rangeVariableTypes = true,
                },
                analyses = {
                  fieldalignment = true,
                  nilness = true,
                  unusedparams = true,
                  unusedwrite = true,
                  useany = true,
                },
                usePlaceholders = true,
                completeUnimported = true,
                staticcheck = true,
                directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
                semanticTokens = true,
              },
            },
          },
          marksman = {},
        },
        -- you can do any additional lsp server setup here
        -- return true if you don't want this server to be setup with lspconfig
        ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
        setup = {
          ts_ls = function()
            -- disable tsserver
            return true
          end,
          vtsls = function(_, opts)
            require("util.lsp").on_attach(function(client, buffer)
              client.commands["_typescript.moveToFileRefactoring"] = function(command, ctx)
                ---@type string, string, lsp.Range
                local action, uri, range = unpack(command.arguments)

                local function move(newf)
                  client.request("workspace/executeCommand", {
                    command = command.command,
                    arguments = { action, uri, range, newf },
                  })
                end

                local fname = vim.uri_to_fname(uri)
                client.request("workspace/executeCommand", {
                  command = "typescript.tsserverRequest",
                  arguments = {
                    "getMoveToRefactoringFileSuggestions",
                    {
                      file = fname,
                      startLine = range.start.line + 1,
                      startOffset = range.start.character + 1,
                      endLine = range["end"].line + 1,
                      endOffset = range["end"].character + 1,
                    },
                  },
                }, function(_, result)
                  ---@type string[]
                  local files = result.body.files
                  table.insert(files, 1, "Enter new path...")
                  vim.ui.select(files, {
                    prompt = "Select move destination:",
                    format_item = function(f)
                      return vim.fn.fnamemodify(f, ":~:.")
                    end,
                  }, function(f)
                    if f and f:find("^Enter new path") then
                      vim.ui.input({
                        prompt = "Enter move destination:",
                        default = vim.fn.fnamemodify(fname, ":h") .. "/",
                        completion = "file",
                      }, function(newf)
                        return newf and move(newf)
                      end)
                    elseif f then
                      move(f)
                    end
                  end)
                end)
              end
            end, "vtsls")
            -- copy typescript settings to javascript
            opts.settings.javascript =
              vim.tbl_deep_extend("force", {}, opts.settings.typescript, opts.settings.javascript or {})
          end,
          eslint = function()
            vim.api.nvim_create_autocmd("BufWritePre", {
              callback = function(event)
                local client = vim.lsp.get_clients({ name = "eslint", bufnr = event.buf })[1]
                if client then
                  vim.cmd("EslintFixAll")
                end
              end,
            })
          end,
          -- tailwindcss = function(_, opts)
          --   local tw = require("util.lsp").get_raw_config("tailwindcss")
          --   opts.filetypes = opts.filetypes or {}
          --
          --   -- Add default filetypes
          --   vim.list_extend(opts.filetypes, tw.default_config.filetypes)
          --
          --   -- Remove excluded filetypes
          --   --- @param ft string
          --   opts.filetypes = vim.tbl_filter(function(ft)
          --     return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
          --   end, opts.filetypes)
          --
          --   -- Add additional filetypes
          --   vim.list_extend(opts.filetypes, opts.filetypes_include or {})
          -- end,
          gopls = function(_, opts)
            -- workaround for gopls not supporting semanticTokensProvider
            -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
            require("util.lsp").on_attach(function(client, _)
              if not client.server_capabilities.semanticTokensProvider then
                local semantic = client.config.capabilities.textDocument.semanticTokens
                client.server_capabilities.semanticTokensProvider = {
                  full = true,
                  legend = {
                    tokenTypes = semantic.tokenTypes,
                    tokenModifiers = semantic.tokenModifiers,
                  },
                  range = true,
                }
              end
            end, "gopls")
            -- end workaround
          end,
        },
      }
      return ret
    end,
    ---@param opts PluginLspOpts
    config = function(_, opts)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("brix-lsp-attach", { clear = true }),
        --stylua: ignore
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end
          local builtin = require("fzf-lua")
          map("<leader>cl", "<cmd>LspInfo<cr>", "[L]sp Info")
          map("gd", "<cmd>FzfLua lsp_definitions     jump_to_single_result=true ignore_current_line=true<cr>", "[G]oto [D]efinition")
          map("gr", "<cmd>FzfLua lsp_references      jump_to_single_result=true ignore_current_line=true<cr>", "[G]oto [R]eferences")
          map("gI", "<cmd>FzfLua lsp_implementations jump_to_single_result=true ignore_current_line=true<cr>", "[G]oto [I]mplementation")
          map("gy", "<cmd>FzfLua lsp_typedefs        jump_to_single_result=true ignore_current_line=true<cr>", "[G]oto T[y]pe Definition")
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
          map("<leader>ds", builtin.lsp_document_symbols, "[D]ocument [S]ymbols")
          map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
          map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "v" })
          map("K", vim.lsp.buf.hover, "Hover Documentation")
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
        end,
      })

      local servers = opts.servers
      local blink_cmp = require("blink.cmp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        blink_cmp.get_lsp_capabilities(),
        opts.capabilities or {}
      )

      local function setup(server_name)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server_name] or {})

        if opts.setup[server_name] then
          if opts.setup[server_name](server_name, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server_name, server_opts) then
            return
          end
        end
        require("lspconfig")[server_name].setup(server_opts)
      end
      -- get all the servers that are available through mason-lspconfig
      local have_mason, mlsp = pcall(require, "mason-lspconfig")
      local all_mslp_servers = {}
      if have_mason then
        all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
      end

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          if server_opts.enabled ~= false then
            -- if this is a server that cannot be installed with mason-lspconfig
            if not vim.tbl_contains(all_mslp_servers, server) then
              setup(server)
            else
              ensure_installed[#ensure_installed + 1] = server
            end
          end
        end
      end

      if have_mason then
        mlsp.setup({
          automatic_installation = true,
          ensure_installed = vim.tbl_deep_extend(
            "force",
            ensure_installed,
            require("util").opts("mason-lspconfig.nvim").ensure_installed or {}
          ),
          handlers = { setup },
        })
      end
    end,
  },
}
