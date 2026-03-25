local prettierd = {
  "css",
  "graphql",
  "handlebars",
  "html",
  "markdown",
  "markdown.mdx",
  "yaml",
}

local oxc = {
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
  "json",
  "jsonc",
  "vue",
  "svelte",
  "astro",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "javascript", "jsdoc", "typescript", "tsx" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        eslint = {
          cmd = { "vscode-eslint-language-server", "--stdio", "--max-old-space-size=12288" },
          settings = { format = false },
        },
        vtsls = {
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
              },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = {
                completeFunctionCalls = true,
                -- Enable auto imports
                includeCompletionsForModuleExports = true,
                includeCompletionsForImportStatements = true,
                autoImports = true, -- Adding this as it is the standard VS Code/vtsls equivalent
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
          keys = {
            {
              "gD",
              function()
                local win = vim.api.nvim_get_current_win()
                local params = vim.lsp.util.make_position_params(win, "utf-16")
                require("utils").lsp_execute({
                  command = "typescript.goToSourceDefinition",
                  arguments = { params.textDocument.uri, params.position },
                  open = true,
                })
              end,
              desc = "Goto Source Definition",
            },
            {
              "gR",
              function()
                require("utils").lsp_execute({
                  command = "typescript.findAllFileReferences",
                  arguments = { vim.uri_from_bufnr(0) },
                  open = true,
                })
              end,
              desc = "File References",
            },
            {
              "<leader>co",
              function()
                require("utils").lsp_action["source.organizeImports"]()
              end,
              desc = "Organize Imports",
            },
            {
              "<leader>cM",
              function()
                require("utils").lsp_action["source.addMissingImports.ts"]()
              end,
              desc = "Add missing imports",
            },
            {
              "<leader>cu",
              function()
                require("utils").lsp_action["source.removeUnused.ts"]()
              end,
              desc = "Remove unused imports",
            },
            {
              "<leader>cD",
              function()
                require("utils").lsp_action["source.fixAll.ts"]()
              end,
              desc = "Fix all diagnostics",
            },
            {
              "<leader>cV",
              function()
                require("utils").lsp_execute({
                  title = "Select TypeScript Version",
                  filter = "vtsls",
                  command = "typescript.selectTypeScriptVersion",
                })
              end,
              desc = "Select TS workspace version",
            },
          },
        },
        oxlint = {},
        --- disable the oxfmt lsp server since we use conform for formatting
        oxfmt = { enabled = false },
      },
      setup = {
        vtsls = function(_, opts)
          Snacks.util.lsp.on({ name = "vtsls" }, function(buffer, client)
            client.commands["_typescript.moveToFileRefactoring"] = function(command, ctx)
              ---@type string, string, lsp.Range
              local action, uri, range = unpack(command.arguments)

              local function move(newf)
                client:request("workspace/executeCommand", {
                  command = command.command,
                  arguments = { action, uri, range, newf },
                })
              end

              local fname = vim.uri_to_fname(uri)
              client:request("workspace/executeCommand", {
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
          end)

          -- copy typescript settings to javascript
          opts.settings.javascript =
            vim.tbl_deep_extend("force", {}, opts.settings.typescript, opts.settings.javascript or {})
        end,
      },
    },
  },

  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "prettierd", "oxfmt" } },
  },
  -- conform
  {
    "stevearc/conform.nvim",
    optional = true,
    ---@param opts ConformOpts
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      for _, ft in ipairs(oxc) do
        opts.formatters_by_ft[ft] = { "oxfmt", "prettierd", stop_after_first = true }
      end

      for _, ft in ipairs(prettierd) do
        opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
        table.insert(opts.formatters_by_ft[ft], "prettierd")
      end

      opts.formatters = opts.formatters or {}
      opts.formatters.prettierd = {
        condition = function(_, ctx)
          return vim.fs.find({
            ".prettierrc",
            ".prettierrc.json",
            ".prettierrc.js",
            ".prettierrc.cjs",
            ".prettierrc.mjs",
            "prettier.config.js",
            "prettier.config.cjs",
            "prettier.config.mjs",
          }, {
            path = ctx.filename,
            upward = true,
            stop = vim.uv.os_homedir(),
          })[1] ~= nil
        end,
      }

      opts.formatters.oxfmt = {
        condition = function(_, ctx)
          return vim.fs.find({ ".oxfmtrc.json", ".oxfmtrc.jsonc" }, {
            path = ctx.filename,
            upward = true,
            stop = vim.uv.os_homedir(),
          })[1] ~= nil
        end,
      }
    end,
  },

  {
    "dmmulroy/ts-error-translator.nvim",
    event = "VeryLazy",
    config = function()
      require("ts-error-translator").setup()
    end,
  },

  -- Filetype icons
  {
    "nvim-mini/mini.icons",
    opts = {
      file = {
        [".eslintrc.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
        [".node-version"] = { glyph = "", hl = "MiniIconsGreen" },
        [".prettierrc"] = { glyph = "", hl = "MiniIconsPurple" },
        [".yarnrc.yml"] = { glyph = "", hl = "MiniIconsBlue" },
        ["eslint.config.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
        ["package.json"] = { glyph = "", hl = "MiniIconsGreen" },
        ["tsconfig.json"] = { glyph = "", hl = "MiniIconsAzure" },
        ["tsconfig.build.json"] = { glyph = "", hl = "MiniIconsAzure" },
        ["yarn.lock"] = { glyph = "", hl = "MiniIconsBlue" },
      },
    },
  },
}
