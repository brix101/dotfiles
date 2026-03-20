return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tailwindcss = {
          filetypes_exclude = { "markdown" },
          filetypes = { "typescriptreact", "javascriptreact", "html", "svelte", "astro", "vue" },
        },
      },
    },
  },
}
