vim.api.nvim_create_autocmd("FileType", {
  pattern = "oil",
  callback = function()
    vim.opt_local.colorcolumn = ""
  end,
})

return {
  {
    "stevearc/oil.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "refractalize/oil-git-status.nvim",
    },
    ---@type oil.SetupOpts
    opts = {
      columns = { "icon" },
      confirmation = {
        border = "rounded",
      },
      float = {
        border = "rounded",
      },
      keymaps = {
        ["<C-h>"] = false,
        ["<M-h>"] = "actions.select_split",
      },
      view_options = {
        show_hidden = true,
      },
      win_options = {
        signcolumn = "yes:2",
      },
    },
    -- stylua: ignore
    keys = {
      { "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
      { "<leader>e", function() require("oil").toggle_float() end, desc = "Open Oil file explorer" },
    },
    config = function(_, opts)
      require("oil").setup(opts)
      require("oil-git-status").setup({
        -- show_ignored = false,
        -- symbols = {
        --   index = {
        --     ["!"] = " ", -- Ignored
        --     ["?"] = " ", -- Untracked
        --     ["A"] = " ", -- Added
        --     ["C"] = " ", -- Copied
        --     ["D"] = " ", -- Deleted
        --     ["M"] = "󰄗 ", -- Modified
        --     ["R"] = "󰁯 ", -- Renamed
        --     ["T"] = "󰉺 ", -- Type changed
        --     ["U"] = "󰇼 ", -- Unmerged
        --     [" "] = " ", -- Unchanged
        --   },
        --   working_tree = {
        --     ["!"] = " ",
        --     ["?"] = " ",
        --     ["A"] = "󰐖 ",
        --     ["C"] = " ",
        --     ["D"] = " ",
        --     ["M"] = " ", -- Subtle dot for unstaged changes
        --     ["R"] = "󰁯 ",
        --     ["T"] = "󰉺 ",
        --     ["U"] = "󰇼 ",
        --     [" "] = " ",
        --   },
        -- },
      })
    end,
  },
}
