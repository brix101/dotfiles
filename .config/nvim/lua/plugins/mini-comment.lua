return {
    {
      "echasnovski/mini.comment",
      event = { "BufReadPre", "BufNewFile" },
      dependencies = {
        "JoosepAlviste/nvim-ts-context-commentstring",
        "nvim-treesitter/nvim-treesitter",
      },
      opts = {
        options = {
          custom_commentstring = function()
            return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
          end,
        },
      },
    },
  }