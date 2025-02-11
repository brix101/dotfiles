return {
  -- Rename with cmdpreview
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    opts = {
      -- input_buffer_type = "dressing",
    },
  },

  -- LSP Keymaps
  {
    "neovim/nvim-lspconfig",
    opts = function()
      local keys = require("plugins.lsp.keymaps").get()
      keys[#keys + 1] = {
        "<leader>rn",
        function()
          local inc_rename = require("inc_rename")
          return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand("<cword>")
        end,
        expr = true,
        desc = "Rename (inc-rename.nvim)",
        has = "rename",
      }
    end,
  },

  --- Noice integration
  {
    "folke/noice.nvim",
    optional = true,
    opts = {
      presets = { inc_rename = true },
    },
  },
}
