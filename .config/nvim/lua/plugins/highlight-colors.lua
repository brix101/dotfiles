return {
  "brenoprata10/nvim-highlight-colors",
  event = "InsertEnter",
  cmd = "HighlightColors",
  keys = {
    {
      "<leader>uz",
      function()
        vim.cmd.HighlightColors("Toggle")
      end,
      desc = "Toggle color highlight",
    },
  },
  opts = { enabled_named_colors = false, virtual_symbol = "󱓻" },
}
