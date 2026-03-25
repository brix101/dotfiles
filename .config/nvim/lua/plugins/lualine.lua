local icons = {
  diagnostics = {
    Error = " ",
    Warn = " ",
    Hint = " ",
    Info = " ",
  },
  git = {
    added = " ",
    modified = " ",
    removed = " ",
  },
}

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      local harpoon = require("harpoon")

      local function truncate_branch_name(branch)
        if not branch or branch == "" then
          return ""
        end

        -- Match the branch name to the specified format
        local user, team, ticket_number = string.match(branch, "^(%w+)/(%w+)%-(%d+)")

        -- If the branch name matches the format, display {user}/{team}-{ticket_number}, otherwise display the full branch name
        if ticket_number then
          return user .. "/" .. team .. "-" .. ticket_number
        else
          return branch
        end
      end

      local vcs_cache = { result = nil, cwd = nil }

      local function get_vcs_info()
        local cwd = vim.fn.getcwd()
        if vcs_cache.cwd == cwd and vcs_cache.result then
          return vcs_cache.result
        end

        local branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("%s+$", "")
        if vim.v.shell_error == 0 and branch ~= "" then
          vcs_cache = { result = truncate_branch_name(branch), cwd = cwd }
          return vcs_cache.result
        end

        vcs_cache = { result = "", cwd = cwd }
        return ""
      end

      vim.api.nvim_create_autocmd({ "DirChanged", "BufEnter", "FocusGained" }, {
        callback = function()
          vcs_cache = { result = nil, cwd = nil }
        end,
      })

      local function harpoon_component()
        local list = harpoon:list()
        local total_marks = list:length()
        if total_marks == 0 then
          return ""
        end

        local current_file = vim.api.nvim_buf_get_name(0)
        local current_index = "—"

        for i, item in ipairs(list.items) do
          if item and item.value then
            local mark_path = vim.fn.fnamemodify(item.value, ":p")

            if mark_path == current_file then
              current_index = tostring(i)
              break
            end
          end
        end

        return string.format("󱡅 %s/%d", current_index, total_marks)
      end

      local opts = {
        options = {
          theme = "auto",
          globalstatus = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "█", right = "█" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            { get_vcs_info, icon = "" },
            harpoon_component,
            {
              "diff",
              -- symbols = {
              --   added = icons.git.added,
              --   modified = icons.git.modified,
              --   removed = icons.git.removed,
              -- },
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added or 0,
                    modified = gitsigns.changed or 0,
                    removed = gitsigns.removed or 0,
                  }
                end
              end,
            },
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
          },
          lualine_c = {
            { "filename", path = 1 },
          },
          lualine_x = {
            -- stylua: ignore
            {
              function() return require("noice").api.status.command.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
              color = function() return { fg = Snacks.util.color("Statement") } end,
            },
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              color = function() return { fg = Snacks.util.color("Constant") } end,
            },
          },
          lualine_y = {
            { "filetype" },
          },
          lualine_z = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
        },
        extensions = { "lazy", "oil", "trouble" },
      }

      return opts
    end,
  },
}
