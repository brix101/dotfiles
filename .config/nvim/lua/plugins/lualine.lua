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

        -- Check jj first (priority over git for colocated repos)
        vim.fn.system("jj root 2>/dev/null")
        if vim.v.shell_error == 0 then
          local bookmark = vim.fn.system("jj log -r @ --no-graph -T 'bookmarks'"):gsub("%s+$", "")
          if bookmark == "" then
            local change_id = vim.fn.system("jj log -r @ --no-graph -T 'change_id.shortest(8)'"):gsub("%s+$", "")
            vcs_cache = { result = change_id, cwd = cwd }
          else
            local first = bookmark:match("^(%S+)") or bookmark
            vcs_cache = { result = truncate_branch_name(first), cwd = cwd }
          end
          return vcs_cache.result
        end

        -- Fallback: git branch
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

      local function copilot_status()
        local clients = package.loaded["copilot"] and vim.lsp.get_clients({ name = "copilot", bufnr = 0 }) or {}
        if #clients == 0 then
          return nil
        end
        return require("copilot.status").data.status or ""
      end

      -- Use Copilot's native status strings as keys
      local copilot_colors = {
        [""] = "Comment",
        Normal = "DiagnosticOk",
        Warning = "DiagnosticError",
        InProgress = "DiagnosticWarn",
      }

      local copilot_icons = {
        [""] = " ",
        Normal = " ",
        Warning = " ",
        InProgress = " ",
      }

      local copilot_component = {
        function()
          local status = copilot_status()
          return copilot_icons[status] or copilot_icons[""]
        end,
        cond = function()
          return copilot_status() ~= nil
        end,
        color = function()
          local status = copilot_status()
          local hl_group = copilot_colors[status] or copilot_colors[""]
          return { fg = Snacks.util.color(hl_group) }
        end,
      }

      local lsp_servers_component = {
        function()
          local clients = vim.lsp.get_clients({ bufnr = 0 })
          if #clients == 0 then
            return ""
          end

          local names = {}
          local seen = {}

          for _, client in ipairs(clients) do
            if client.name ~= "copilot" and not seen[client.name] then
              table.insert(names, client.name)
              seen[client.name] = true
            end
          end

          if #names == 0 then
            return ""
          end

          return table.concat(names, ",")
        end,
      }

      local opts = {
        options = {
          theme = "catppuccin",
          globalstatus = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "█", right = "█" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            { get_vcs_info, icon = "" },
            harpoon_component,
          },
          lualine_c = {
            { "filename", path = 1 },
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
              source = function()
                local bufnr = vim.api.nvim_get_current_buf()
                local summary = vim.b[bufnr].vcsigns_summary
                if summary then
                  return {
                    added = summary.added or 0,
                    modified = summary.modified or 0,
                    removed = summary.removed or 0,
                  }
                end
                return nil
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
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          },
          lualine_x = {
            copilot_component,
          },
          lualine_y = {
            lsp_servers_component,
          },
          lualine_z = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
        },
        extensions = { "lazy", "fzf" },
      }

      -- do not add trouble symbols if aerial is enabled
      -- And allow it to be overriden for some buffer types (see autocmds)
      local trouble = require("trouble")
      local symbols = trouble.statusline({
        mode = "symbols",
        groups = {},
        title = false,
        filter = { range = true },
        format = "{kind_icon}{symbol.name:Normal}",
        hl_group = "lualine_c_normal",
      })
      table.insert(opts.sections.lualine_c, {
        symbols and symbols.get,
        cond = function()
          return vim.b.trouble_lualine ~= false and symbols.has()
        end,
      })

      return opts
    end,
  },
}
