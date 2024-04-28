return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-telescope/telescope-ui-select.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local builtin = require("telescope.builtin")

		telescope.setup({
			defaults = {
				path_display = { "truncate " },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					},
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
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
		})

		telescope.load_extension("fzf")
		telescope.load_extension("ui-select")

		-- set keymaps
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { desc = "Telescope: " .. desc })
		end

		map("<leader>fa", "<cmd>Telescope find_files hidden=true<cr>", "[F]ind [A]ll files")
		map("<leader>ff", builtin.find_files, "[F]ind [F]iles")
		map("<leader>fr", builtin.oldfiles, '[F]ind Recent Files ("." for repeat)')
		map("<leader>fs", builtin.live_grep, "[F]ind by [G]rep")
		map("<leader>fw", builtin.grep_string, "[F]ind [W]ord")
		map("<leader>fb", builtin.buffers, "[F]ind existing buffers")
	end,
}
