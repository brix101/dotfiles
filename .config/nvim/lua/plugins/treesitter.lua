return {
    {
      "nvim-treesitter/nvim-treesitter",
      main = "nvim-treesitter.configs",
      event = { "BufReadPost", "BufNewFile" },
      cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
      -- build = ":TSUpdate",
      init = function(plugin)
        -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
        -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
        -- no longer trigger the **nvim-treeitter** module to be loaded in time.
        -- Luckily, the only thins that those plugins need are the custom queries, which we make available
        -- during startup.
        -- CODE FROM LazyVim (thanks folke!) https://github.com/LazyVim/LazyVim/commit/1e1b68d633d4bd4faa912ba5f49ab6b8601dc0c9
        require("lazy.core.loader").add_to_rtp(plugin)
        pcall(require, "nvim-treesitter.query_predicates")
      end,
      opts_extend = { "ensure_installed" },
      ---@type TSConfig
      ---@diagnostic disable-next-line: missing-fields
      opts = {
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
        ensure_installed = {
          "bash",
          "c",
          "diff",
          "go",
          "gomod",
          "gowork",
          "gosum",
          "html",
          "javascript",
          "jsdoc",
          "json",
          "jsonc",
          "lua",
          "luadoc",
          "luap",
          "markdown",
          "markdown_inline",
          "printf",
          "python",
          "query",
          "regex",
          "toml",
          "tsx",
          "typescript",
          "vim",
          "vimdoc",
          "xml",
          "yaml",
        },
      },
      ---@param opts TSConfig
      config = function(plugin, opts)
        require(plugin.main).setup(opts)
      end,
    },
  
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      lazy = true,
      config = function()
        require("nvim-treesitter.configs").setup({
          textobjects = {
            select = {
              enable = true,
              lookahead = true,
              keymaps = {
                ["ak"] = { query = "@block.outer", desc = "around block" },
                ["ik"] = { query = "@block.inner", desc = "inside block" },
                ["ac"] = { query = "@class.outer", desc = "around class" },
                ["ic"] = { query = "@class.inner", desc = "inside class" },
                ["a?"] = { query = "@conditional.outer", desc = "around conditional" },
                ["i?"] = { query = "@conditional.inner", desc = "inside conditional" },
                ["af"] = { query = "@function.outer", desc = "around function " },
                ["if"] = { query = "@function.inner", desc = "inside function " },
                ["ao"] = { query = "@loop.outer", desc = "around loop" },
                ["io"] = { query = "@loop.inner", desc = "inside loop" },
                ["aa"] = { query = "@parameter.outer", desc = "around argument" },
                ["ia"] = { query = "@parameter.inner", desc = "inside argument" },
              },
            },
            move = {
              enable = true,
              set_jumps = true,
              goto_next_start = {
                ["]k"] = { query = "@block.outer", desc = "Next block start" },
                ["]f"] = { query = "@function.outer", desc = "Next function start" },
                ["]a"] = { query = "@parameter.inner", desc = "Next argument start" },
              },
              goto_next_end = {
                ["]K"] = { query = "@block.outer", desc = "Next block end" },
                ["]F"] = { query = "@function.outer", desc = "Next function end" },
                ["]A"] = { query = "@parameter.inner", desc = "Next argument end" },
              },
              goto_previous_start = {
                ["[k"] = { query = "@block.outer", desc = "Previous block start" },
                ["[f"] = { query = "@function.outer", desc = "Previous function start" },
                ["[a"] = { query = "@parameter.inner", desc = "Previous argument start" },
              },
              goto_previous_end = {
                ["[K"] = { query = "@block.outer", desc = "Previous block end" },
                ["[F"] = { query = "@function.outer", desc = "Previous function end" },
                ["[A"] = { query = "@parameter.inner", desc = "Previous argument end" },
              },
            },
            swap = {
              enable = true,
              swap_next = {
                [">K"] = { query = "@block.outer", desc = "Swap next block" },
                [">F"] = { query = "@function.outer", desc = "Swap next function" },
                [">A"] = { query = "@parameter.inner", desc = "Swap next argument" },
              },
              swap_previous = {
                ["<K"] = { query = "@block.outer", desc = "Swap previous block" },
                ["<F"] = { query = "@function.outer", desc = "Swap previous function" },
                ["<A"] = { query = "@parameter.inner", desc = "Swap previous argument" },
              },
            },
          },
        })
  
        -- When in diff mode, we want to use the default
        -- vim text objects c & C instead of the treesitter ones.
        local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
        local configs = require("nvim-treesitter.configs")
        for name, fn in pairs(move) do
          if name:find("goto") == 1 then
            move[name] = function(q, ...)
              if vim.wo.diff then
                local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
                for key, query in pairs(config or {}) do
                  if q == query and key:find("[%]%[][cC]") then
                    vim.cmd("normal! " .. key)
                    return
                  end
                end
              end
              return fn(q, ...)
            end
          end
        end
      end,
    },
  
    {
      "windwp/nvim-ts-autotag",
      event = { "BufReadPost", "BufNewFile", "BufWritePre" },
      opts = {},
    },
  }