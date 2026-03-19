return {
  {
    "saghen/blink.cmp",
    event = "VimEnter",
    version = "1.*",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "L3MON4D3/LuaSnip",
      "fang2hou/blink-copilot",
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "super-tab",
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_and_accept()
            end
          end,
          "snippet_forward",
          function()
            return require("sidekick").nes_jump_or_apply()
          end,
          function()
            if vim.g.ai_cmp and require("copilot.suggestion").is_visible() then
              require("copilot.suggestion").accept()
              return true
            end
          end,
          "fallback",
        },
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
                    copilot = "[Copilot]",
                  }
                  return (source_names[ctx.source_name] or "[") .. ctx.source_name .. "]"
                end,
                highlight = "CmpItemMenu",
              },
            },
            treesitter = { "lsp", "copilot" },
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
          enabled = true,
        },
        list = {
          selection = {
            preselect = function()
              return not require("blink.cmp").snippet_active({ direction = 1 })
            end,
            -- auto_insert = true,
          },
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "copilot" },
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
          copilot = {
            -- name = "copilot",
            module = "blink-copilot",
            score_offset = 100,
            async = true,
          },
        },
      },
    },
  },
}
