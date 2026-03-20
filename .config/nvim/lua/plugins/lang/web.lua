return {
  -- Add LSP servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        cssls = {},
        html = {},
        graphql = {
          filetypes = { "graphql", "gql", "typescriptreact", "javascriptreact" },
        },
      },
    },
  },
}
