return {
  {
    "folke/which-key.nvim",
    event = "VimEnter",
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      delay = 400,
      icons = { mappings = vim.g.have_nerd_font },
      preset = "classic",
      spec = {
        { "<leader>c", group = "code" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>gh", group = "hunks" },
        { "<leader>h", group = "harpoon", icon = { icon = "󱡅 ", color = "green" } },
        { "<leader>n", group = "notification" },
        { "<leader>q", group = "quit/session" },
        { "<leader>r", group = "rename" },
        { "<leader>s", group = "search" },
        { "<leader>u", group = "ui" },
        { "<leader>x", group = "diagnostics/quickfix" },
        { "gr", group = "lsp actions", mode = { "n" } },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
        { "gs", group = "surround" },
        { "z", group = "fold" },
        {
          "<leader>b",
          group = "buffer",
          expand = function()
            return require("which-key.extras").expand.buf()
          end,
        },
        {
          "<leader>w",
          group = "windows",
          proxy = "<c-w>",
          expand = function()
            return require("which-key.extras").expand.win()
          end,
        },
      },
    },
  },
}
