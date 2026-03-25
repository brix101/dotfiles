return {
  {
    "saghen/blink.cmp",
    event = "VimEnter",
    version = "1.*",
    opts_extend = {
      "sources.completion.enabled_providers",
      "sources.default",
    },
    dependencies = {
      "rafamadriz/friendly-snippets",
      "L3MON4D3/LuaSnip",
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "super-tab",
        -- ["<CR>"] = { "accept", "fallback" },
        -- ["<CR>"] = { "select_and_accept" },
        ["<C-y>"] = { "select_and_accept" },
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      snippets = {
        preset = "luasnip",
      },
      signature = {
        enabled = true,
        trigger = {
          show_on_trigger_character = false,
          show_on_insert_on_trigger_character = false,
        },
        window = {
          border = "rounded",
          show_documentation = true,
        },
      },
      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          border = "rounded",
          max_height = 10,
          draw = {
            columns = {
              { "kind_icon" },
              { "label", "label_description", gap = 1 },
              { "source_name" },
            },
            components = {
              -- Native icon support (no lspkind needed)
              source_name = {
                text = function(ctx)
                  local source_names = {
                    lsp = "[LSP]",
                    buffer = "[Buffer]",
                    path = "[Path]",
                    snippets = "[Snippet]",
                  }
                  return (source_names[ctx.source_name] or "[") .. ctx.source_name .. "]"
                end,
                highlight = "CmpItemMenu",
              },
            },
            treesitter = { "lsp" },
          },
          auto_show = true,
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            border = "rounded",
          },
        },
        ghost_text = {
          enabled = vim.g.ai_cmp,
        },
        -- list = {
        --   selection = {
        --     preselect = function()
        --       return not require("blink.cmp").snippet_active({ direction = 1 })
        --     end,
        --     -- auto_insert = true,
        --   },
        -- },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          lsp = {
            score_offset = 1000, -- Extreme priority to override fuzzy matching
          },
          path = {
            score_offset = 3, -- File paths moderate priority
          },
          snippets = {
            score_offset = -100, -- Much lower priority
            max_items = 2, -- Limit snippet suggestions
            min_keyword_length = 3, -- Don't show for single chars
          },
          buffer = {
            score_offset = -150, -- Lowest priority
            min_keyword_length = 3, -- Only show after 3 chars
          },
        },
      },
    },
    ---@param opts blink.cmp.Config | { sources: { compat: string[] } }
    config = function(_, opts)
      -- -- setup compat sources
      -- local enabled = opts.sources.default
      -- for _, source in ipairs(opts.sources.compat or {}) do
      --   opts.sources.providers[source] = vim.tbl_deep_extend(
      --     "force",
      --     { name = source, module = "blink.compat.source" },
      --     opts.sources.providers[source] or {}
      --   )
      --   if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then
      --     table.insert(enabled, source)
      --   end
      -- end

      opts.keymap["<Tab>"] = {
        require("blink.cmp.keymap.presets").get("super-tab")["<Tab>"][1],
        require("utils").cmp_map({ "snippet_forward", "ai_nes", "ai_accept" }),
        "fallback",
      }

      require("blink.cmp").setup(opts)
    end,
  },
}
