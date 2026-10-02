return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- use latest release, remove to use latest commit
  ft = "markdown",
  cmd = "Obsidian",
  keys = {
    { "<leader>on", "<cmd>Obsidian new<cr>", desc = "Obsidian: New note" },
    { "<leader>oo", "<cmd>Obsidian quick_switch<cr>", desc = "Obsidian: Quick switch" },
    { "<leader>os", "<cmd>Obsidian search<cr>", desc = "Obsidian: Search" },
    { "<leader>od", "<cmd>Obsidian today<cr>", desc = "Obsidian: Today" },
    { "<leader>oy", "<cmd>Obsidian yesterday<cr>", desc = "Obsidian: Yesterday" },
    { "<leader>ot", "<cmd>Obsidian tomorrow<cr>", desc = "Obsidian: Tomorrow" },
    { "<leader>ow", "<cmd>Obsidian workspace<cr>", desc = "Obsidian: Switch workspace" },
    { "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "Obsidian: Backlinks" },
    { "<leader>oc", "<cmd>Obsidian toc<cr>", desc = "Obsidian: Table of contents" },
    { "<leader>of", "<cmd>Obsidian follow_link<cr>", desc = "Obsidian: Follow link" },
    { "<leader>oT", "<cmd>Obsidian template<cr>", desc = "Obsidian: Insert template" },
    { "<leader>oN", "<cmd>Obsidian new_from_template<cr>", desc = "Obsidian: New note from template" },
    {
      "<leader>oD",
      function()
        local path = vim.api.nvim_buf_get_name(0)
        if path == "" or vim.fn.filereadable(path) == 0 then
          vim.notify("No file to delete", vim.log.levels.WARN)
          return
        end
        local name = vim.fn.fnamemodify(path, ":t")
        if vim.fn.confirm("Move " .. name .. " to Trash?", "&Yes\n&No", 2) ~= 1 then
          return
        end
        -- macOS ships /usr/bin/trash (14+), which moves files to ~/.Trash with "Put Back" support
        local result = vim.system({ "trash", path }):wait()
        if result.code ~= 0 then
          vim.notify("Failed to trash " .. name .. ": " .. vim.trim(result.stderr or ""), vim.log.levels.ERROR)
          return
        end
        Snacks.bufdelete({ force = true })
        vim.notify("Moved " .. name .. " to Trash")
      end,
      desc = "Obsidian: Delete note",
    },
  },
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    legacy_commands = false, -- this will be removed in 4.0.0
    -- Put new notes in "<vault>/notes" instead of the current buffer's directory
    notes_subdir = "notes",
    new_notes_location = "notes_subdir",
    -- Human-readable slug filenames, e.g. "My Note" -> "my-note.md"
    note_id_func = function(title, path)
      return require("obsidian.builtin").title_id(title, path)
    end,
    picker = {
      name = "snacks.picker",
    },
    templates = {
      folder = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
      substitutions = {
        -- optional custom vars like {{yesterday}}, {{tomorrow}} can go here
      },
    },
    workspaces = {
      {
        name = "work",
        path = "~/vaults/work",
      },
      {
        name = "personal",
        path = "~/vaults/personal",
      },
    },
    sources = {
      -- NOTE: no need if you don't have custom markdown stuff
      per_filetype = {
        markdown = {
          "lsp", -- NOTE: explicitly enable lsp
          -- inherit_defaults = true, -- NOTE: if your defaults include lsp
          "dictionary",
        },
      },
    },
    daily_notes = {
      enabled = true,
      folder = "daily",
      date_format = "YYYY-MM (MMM)/YYYY-MM-DD",
      default_tags = { "journal", "daily" },
      template = "daily.md",
    },
  },
  config = function(_, opts)
    require("obsidian").setup(opts)

    vim.api.nvim_create_autocmd("User", {
      pattern = "ObsidianNoteEnter",
      desc = "Disable render-markdown when entering an Obsidian note",
      callback = function()
        vim.cmd("RenderMarkdown disable")
      end,
    })
  end,
}
