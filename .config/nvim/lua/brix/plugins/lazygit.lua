return {
  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("telescope").load_extension("lazygit")
      -- set keymaps
      local keymap = vim.keymap -- for conciseness

      keymap.set("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "Lazygit" })
    end,
  },
}
