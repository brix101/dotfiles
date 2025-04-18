-- you can do any additional lsp server setup here
-- return true if you don't want this server to be setup with lspconfig
---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
return {
  ts_ls = function()
    -- disable tsserver
    return true
  end,
  -- vtsls = function(_, opts)
  --   require("util.lsp").on_attach(function(client, buffer)
  --     client.commands["_typescript.moveToFileRefactoring"] = function(command, ctx)
  --       ---@type string, string, lsp.Range
  --       local action, uri, range = unpack(command.arguments)
  --
  --       local function move(newf)
  --         client.request("workspace/executeCommand", {
  --           command = command.command,
  --           arguments = { action, uri, range, newf },
  --         })
  --       end
  --
  --       local fname = vim.uri_to_fname(uri)
  --       client.request("workspace/executeCommand", {
  --         command = "typescript.tsserverRequest",
  --         arguments = {
  --           "getMoveToRefactoringFileSuggestions",
  --           {
  --             file = fname,
  --             startLine = range.start.line + 1,
  --             startOffset = range.start.character + 1,
  --             endLine = range["end"].line + 1,
  --             endOffset = range["end"].character + 1,
  --           },
  --         },
  --       }, function(_, result)
  --         ---@type string[]
  --         local files = result.body.files
  --         table.insert(files, 1, "Enter new path...")
  --         vim.ui.select(files, {
  --           prompt = "Select move destination:",
  --           format_item = function(f)
  --             return vim.fn.fnamemodify(f, ":~:.")
  --           end,
  --         }, function(f)
  --           if f and f:find("^Enter new path") then
  --             vim.ui.input({
  --               prompt = "Enter move destination:",
  --               default = vim.fn.fnamemodify(fname, ":h") .. "/",
  --               completion = "file",
  --             }, function(newf)
  --               return newf and move(newf)
  --             end)
  --           elseif f then
  --             move(f)
  --           end
  --         end)
  --       end)
  --     end
  --   end, "vtsls")
  --   -- copy typescript settings to javascript
  --   opts.settings.javascript =
  --     vim.tbl_deep_extend("force", {}, opts.settings.typescript, opts.settings.javascript or {})
  -- end,
  -- gopls = function(_, opts)
  --   -- workaround for gopls not supporting semanticTokensProvider
  --   -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
  --   require("util.lsp").on_attach(function(client, _)
  --     if not client.server_capabilities.semanticTokensProvider then
  --       local semantic = client.config.capabilities.textDocument.semanticTokens
  --       client.server_capabilities.semanticTokensProvider = {
  --         full = true,
  --         legend = {
  --           tokenTypes = semantic.tokenTypes,
  --           tokenModifiers = semantic.tokenModifiers,
  --         },
  --         range = true,
  --       }
  --     end
  --   end, "gopls")
  --   -- end workaround
  -- end,
  ruff = function()
    require("util.lsp").on_attach(function(client, _)
      -- Disable hover in favor of Pyright
      client.server_capabilities.hoverProvider = false
    end, "ruff")
  end,
}
