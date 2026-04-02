local filtered_message = { "No information available" }
local kind_filter = {
  default = {
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
  },
  markdown = false,
  help = false,
}

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      bufdelete = { enabled = true },
      dim = { enabled = true },
      gitbrowse = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 3000,
        style = "fancy",
      },
      picker = { enabled = true, ui_select = true },
      rename = { enabled = true },
      toggle = { enabled = true },
      scratch = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      _G.dd = function(...)
        Snacks.debug.inspect(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      _G.bt = function()
        Snacks.debug.backtrace()
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          local notify = Snacks.notifier.notify
          ---@diagnostic disable-next-line: duplicate-set-field
          Snacks.notifier.notify = function(message, level, opts)
            for _, msg in ipairs(filtered_message) do
              if message == msg then
                return nil
              end
            end
            return notify(message, level, opts)
          end
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "OilActionsPost",
        callback = function(event)
          if event.data.actions.type == "move" then
            Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
          end
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.treesitter():map("<leader>ut")

          if vim.lsp.inlay_hint then
            Snacks.toggle.inlay_hints():map("<leader>ui")
          end

          Snacks.toggle({
            name = "Highlight color",
            get = function()
              return require("nvim-highlight-colors").is_active()
            end,
            set = function()
              require("nvim-highlight-colors").toggle()
            end,
          }):map("<leader>uh")
        end,
      })
    end,
    -- stylua: ignore
    keys = {
      { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
      { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
      { "<leader>n",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
       -- find
      { "<leader>fc", function() Snacks.picker.files({ cwd = "~/.config/nvim" }) end, desc = "Find Config File" },
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
      { "<leader>fr", function() Snacks.picker.recent({ filter={ cwd = true }}) end, desc = "Recent" },
      -- git
      { "<leader>gc", function() Snacks.picker.git_log() end, desc = "Git Log" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
      { "<leader>gb", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
      { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File History" },
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit Log (cwd)" },
      -- Grep
      { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
      -- search
      { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
      { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
      { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
      { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
      { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
      { "<leader>su", function() Snacks.picker.undo() end, desc = "Undotree" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          -- stylua: ignore
          keys = {
            { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition", has = "definition" },
            { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
            { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
            { "gt", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto Type Definition" },
            { "<leader>ss", function() Snacks.picker.lsp_symbols({ filter = kind_filter }) end, desc = "LSP Symbols", has = "documentSymbol" },
            { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols({ filter = kind_filter }) end, desc = "LSP Workspace Symbols", has = "workspace/symbols" },
            { "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming", has = "callHierarchy/incomingCalls" },
            { "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing", has = "callHierarchy/outgoingCalls" },
          },
        },
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    optional = true,
    -- stylua: ignore
    keys = {
      { "<leader>st", function() Snacks.picker.todo_comments() end, desc = "Todo" },
      { "<leader>sT", function () Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Todo/Fix/Fixme" },
    },
  },
}
