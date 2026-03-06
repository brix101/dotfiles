return {
  { -- Useful plugin to show you pending keybinds.
    "folke/which-key.nvim",
    event = "VimEnter",
    ---@module 'which-key'
    ---@type wk.Opts
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      delay = 0,
      icons = { mappings = vim.g.have_nerd_font },
      preset = "classic",

      -- Document existing key chains
      spec = {
        { "<leader>c", group = "[c]ode" },
        { "<leader>f", group = "[F]ind", mode = { "n", "v" } },
        { "<leader>t", group = "[T]oggle" },
        { "<leader>g", group = "[G]it" },
        { "<leader>gh", group = "[G]it Hunk", mode = { "n", "v" } },
        { "gr", group = "LSP Actions", mode = { "n" } },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
        { "gs", group = "surround" },
        { "z", group = "fold" },
      },
    },
  },
}
