return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  opts = {
    menu = {
      width = vim.api.nvim_win_get_width(0) - 4,
    },
    settings = {
      save_on_toggle = true,
    },
  },
  keys = function()
    local keys = {
      {
        "<leader>ha",
        function()
          require("harpoon"):list():add()
        end,
        desc = "add file",
      },
      {
        "<leader>hl",
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "quick menu",
      },
      {
        "<leader>hr",
        function()
          require("harpoon"):list():remove()
        end,
        desc = "remove file",
      },
      {
        "<leader>hc",
        function()
          require("harpoon"):list():clear()
        end,
        desc = "clear files",
      },
    }

    for i = 1, 4 do
      table.insert(keys, {
        "<leader>" .. i,
        function()
          require("harpoon"):list():select(i)
        end,
        desc = "harpoon " .. i,
      })
    end
    return keys
  end,
  -- config = function()
  --   local harpoon = require("harpoon")
  --
  --   local conf = require("telescope.config").values
  --   local function toggle_telescope(harpoon_files)
  --     local file_paths = {}
  --     for _, item in ipairs(harpoon_files.items) do
  --       table.insert(file_paths, item.value)
  --     end
  --
  --     require("telescope.pickers")
  --       .new({}, {
  --         prompt_title = "Harpoon",
  --         finder = require("telescope.finders").new_table({
  --           results = file_paths,
  --         }),
  --         previewer = conf.file_previewer({}),
  --         sorter = conf.generic_sorter({}),
  --       })
  --       :find()
  --   end
  --
  --   vim.keymap.set("n", "<leader>ht", function()
  --     toggle_telescope(harpoon:list())
  --   end, { desc = "telescope" })
  -- end,
}
