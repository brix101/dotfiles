return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    -- build = ":Copilot auth",
    event = "BufReadPost",
    opts = {
      suggestion = {
        enabled = vim.g.ai_cmp,
        auto_trigger = true,
        hide_during_completion = vim.g.ai_cmp,
        keymap = {
          accept = false, -- handled by  blink.cmp
          next = "<M-]>",
          prev = "<M-[>",
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },
  vim.g.ai_cmp and {
    {
      "saghen/blink.cmp",
      dependencies = { "giuxtaposition/blink-cmp-copilot" },
      opts = {
        sources = {
          default = { "copilot" },
          providers = {
            copilot = {
              name = "copilot",
              module = "blink-cmp-copilot",
              kind = "Copilot",
              score_offset = 100,
              async = true,
            },
          },
        },
      },
    },
  } or nil,
}
