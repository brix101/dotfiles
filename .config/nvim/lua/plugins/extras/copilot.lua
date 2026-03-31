return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        copilot = {
          -- stylua: ignore
          keys = {
            {
              "<M-]>",
              function() vim.lsp.inline_completion.select({ count = 1 }) end,
              desc = "Next Copilot Suggestion",
              mode = { "i", "n" },
            },
            {
              "<M-[>",
              function() vim.lsp.inline_completion.select({ count = -1 }) end,
              desc = "Prev Copilot Suggestion",
              mode = { "i", "n" },
            },
          },
        },
      },
      setup = {
        copilot = function()
          vim.schedule(function()
            vim.lsp.inline_completion.enable()
          end)
          -- Accept inline suggestions or next edits
          require("utils").cmp_actions.ai_accept = function()
            return vim.lsp.inline_completion.get()
          end
        end,
      },
    },
  },
}
