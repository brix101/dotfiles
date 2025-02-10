return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    -- branch = "main",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    config = function()
      require("CopilotChat").setup({
        debug = true,
        -- See Configuration section for all options
        window = {
          layout = "float",
        },
      })

      -- set keymaps
      local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { desc = "CopilotChat: " .. desc })
      end

      map("<C-i>", "<cmd>CopilotChat<cr>", "[F]ind [A]ll files")
    end,
    -- See Commands section for default commands if you want to lazy load on them
  },
}
