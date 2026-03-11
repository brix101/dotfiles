return {
  { -- Useful plugin to show you pending keybinds.
    "folke/which-key.nvim",
    event = "VimEnter",
    ---@module 'which-key'
    ---@type wk.Opts
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      delay = 400,
      icons = { mappings = vim.g.have_nerd_font },
      preset = "classic",

      -- Document existing key chains
      spec = {
        { "<leader>b", group = "Buffer" },
        { "<leader>c", group = "Code" },
        { "<leader>f", group = "Find", mode = { "n", "v" } },
        { "<leader>t", group = "Toggle" },
        { "<leader>g", group = "Git" },
        { "<leader>gh", group = "Git Hunk", mode = { "n", "v" } },
        { "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
        { "gr", group = "LSP Actions", mode = { "n" } },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
        { "gs", group = "Surround" },
        { "z", group = "fold" },
      },
    },
  },
}
