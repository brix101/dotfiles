return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      transparent_background = false,
      color_overrides = {
        mocha = {
          -- base = "#1e1e2e",
          -- mantle = "#181825",
          -- crust = "#11111b",
          -- base = "#010105",
          -- mantle = "#0e0e1b",
          -- crust = "#070711",
        },
      },
      integrations = {
        blink_cmp = true,
        diffview = true,
        fidget = true,
        gitsigns = true,
        harpoon = true,
        illuminate = true,
        indent_blankline = {
          enabled = false,
          scope_color = "sapphire",
          colored_indent_levels = false,
        },
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        noice = true,
        snacks = {
          enabled = true,
          indent_scope_color = "mauve",
        },
        telescope = true,
        semantic_tokens = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },
}
