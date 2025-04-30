return {
    {
    "catppuccin/nvim",
    -- lazy = true,
    name = "catppuccin",
    opts = {
      transparent_background = false,
      color_overrides = {
        mocha = {
          -- base = "#1e1e2e",
          -- mantle = "#181825",
          -- crust = "#11111b",
          base = "#010105",
          mantle = "#0e0e1b",
          crust = "#070711",
        },
      },
      integrations = {
        cmp = true,
        flash = true,
        fzf = true,
        grug_far = true,
        gitsigns = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        lsp_trouble = true,
        mason = true,
        markdown = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        neotest = true,
        neotree = true,
        notify = true,
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
