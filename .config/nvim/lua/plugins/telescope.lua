return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "debugloop/telescope-undo.nvim",
    "isak102/telescope-git-file-history.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  lazy = false,
  opts = {
    pickers = {
      find_files = {
        hidden = true,
      },
      git_files = {
        hidden = true,
      },
    },
    defaults = {
      file_ignore_patterns = {
        "node_modules/*",
      },
    },
    extensions = {
      fzf = {},
    },
  },
  config = function(_, opts)
    require("telescope").setup(opts)
    require("telescope").load_extension("undo")
    require("telescope").load_extension("fzf")
    require("telescope").load_extension("git_file_history")
  end,
  -- keys = {
  --   { "<Leader>ff", "<Cmd>Telescope find_files<CR>", desc = "Find files" },
  --   { "<Leader>fr", "<Cmd>Telescope oldfiles<CR>", desc = "Recent files" },
  --   { "<Leader>fs", "<Cmd>Telescope live_grep<CR>", desc = "Grep inside files" },
  --   { "<Leader>fh", "<Cmd>Telescope help_tags<CR>", desc = "Search in vim :help" },
  --   { "<Leader>fb", "<Cmd>Telescope buffers<CR>", desc = "List and search buffers" },
  --   { "<Leader>fq", "<Cmd>Telescope quickfix<CR>", desc = "List and search quickfix" },
  --   {
  --     "<Leader>fd",
  --     '<Cmd>lua require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })<CR>',
  --     desc = "Find files in config path",
  --   },
  --   {
  --     "<Leader>fw",
  --     '<Cmd>lua require("telescope.builtin").grep_string({ search = vim.fn.expand("<cword>") })<CR>',
  --     desc = "Grep word under cursor",
  --   },
  -- },
}
