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
      {
        "malewicz1337/oil-git.nvim",
        dependencies = { "stevearc/oil.nvim" },
        opts = {
          show_file_highlights = true,
          show_directory_highlights = false,
          show_ignored_files = true,
        },
      },
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
  },
}
