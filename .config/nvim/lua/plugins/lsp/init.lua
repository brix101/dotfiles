return {
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    version = "*",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    dependencies = {
      "mason.nvim", -- NOTE: Must be loaded before dependants
      { "williamboman/mason-lspconfig.nvim", config = function() end },
      { "j-hui/fidget.nvim", config = function() end },
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
      }
      return ret
    end,
    ---@param opts PluginLspOpts
    config = function(_, opts)
      -- diagnostic
      local diagnostic_goto = function(next, severity)
        local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
        severity = severity and vim.diagnostic.severity[severity] or nil
        return function()
          go({ severity = severity })
        end
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("brix-lsp-attach", { clear = true }),
        --stylua: ignore
        callback = function(args)
          local buffer = args.buf ---@type number
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = buffer, desc = "LSP: " .. desc })
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
          map("<leader>cd", vim.diagnostic.open_float, "Line Diagnostics")

          map("]d", diagnostic_goto(true),  "Next Diagnostic" )
          map("[d", diagnostic_goto(false), "Prev Diagnostic" )
          map("]e", diagnostic_goto(true, "ERROR"), "Next Error" )
          map("[e", diagnostic_goto(false, "ERROR"),"Prev Error" )
          map("]w", diagnostic_goto(true, "WARN"),  "Next Warning" )
          map("[w", diagnostic_goto(false, "WARN"), "Prev Warning" )

          if client then
            if client.name == "eslint"then
              map("<leader>cf", "<cmd>EslintFixAll<cr>", "Eslint [F]ixAll")
            end
          end
        end,
      })

      local blink_cmp = require("blink.cmp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        blink_cmp.get_lsp_capabilities(),
        opts.capabilities or {}
      )

      local have_mason, mlsp = pcall(require, "mason-lspconfig")

      local servers = require("plugins.lsp.servers")
      if have_mason then
        mlsp.setup_handlers({
          function(server_name)
            local server_opts = vim.tbl_deep_extend("force", {
              capabilities = vim.deepcopy(capabilities),
            }, servers[server_name] or {})

            require("lspconfig")[server_name].setup(server_opts)
          end,
        })
      end
    end,
  },
}
