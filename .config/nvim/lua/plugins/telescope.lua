return {
  {
    "nvim-telescope/telescope.nvim",
    enabled = true,
    event = "VimEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      { "nvim-telescope/telescope-ui-select.nvim" },
      { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
    },
    config = function()
      local actions = require("telescope.actions")

      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<C-k>"] = actions.move_selection_previous, -- move to prev result
              ["<C-j>"] = actions.move_selection_next, -- move to next result
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            },
          },
          file_ignore_patterns = {
            "node_modules",
            -- "yarn.lock",
            -- ".git",
            -- ".sl",
            "_build",
            ".next",
          },
          hidden = true,
          path_display = {
            "filename_first",
          },
        },
        pickers = {
          oldfiles = {
            cwd_only = true,
          },
          find_files = {
            hidden = true,
          },
          live_grep = {
            additional_args = function()
              return { "--hidden", "--glob", "!**/.git/*" }
            end,
          },
          grep_string = {
            additional_args = function()
              return { "--hidden", "--glob", "!**/.git/*" }
            end,
          },
        },
        extensions = {
          ["ui-select"] = { require("telescope.themes").get_dropdown() },
        },
      })

      -- Enable Telescope extensions if they are installed
      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "ui-select")

      -- See `:help telescope.builtin`
      local builtin = require("telescope.builtin")

      -- find
      vim.keymap.set(
        "n",
        "<leader>fb",
        "<cmd>Telescope buffers sort_mru=true sort_lastused=true ignore_current_buffer=true<cr>",
        { desc = "Buffers" }
      )
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
      vim.keymap.set("n", "<leader>fg", builtin.git_files, { desc = "Find Files (git-files)" })
      vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
      vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[F]ind [K]eymaps" })
      -- search
      vim.keymap.set("n", "<leader>s", builtin.registers, { desc = "Registers" })
      vim.keymap.set("n", "<leader>s/", builtin.search_history, { desc = "Search History" })
      vim.keymap.set("n", "<leader>sa", builtin.autocommands, { desc = "Auto Commands" })
      vim.keymap.set("n", "<leader>sc", builtin.command_history, { desc = "Command History" })
      vim.keymap.set("n", "<leader>sC", builtin.commands, { desc = "Commands" })
      vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "Diagnostics" })
      vim.keymap.set("n", "<leader>sD", "<cmd>Telescope diagnostics bufnr=0<cr>", { desc = "Buffer Diagnostics" })
      vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "Grep" })
      vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Help" })
      vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Keymaps" })
      vim.keymap.set("n", "<leader>sm", builtin.marks, { desc = "Jump to Mark" })
      vim.keymap.set("n", "<leader>sq", builtin.quickfix, { desc = "Quickfix List" })
      vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "Grep Word" })
    end,
  },
}
