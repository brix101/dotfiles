-- import neo-tree plugin safely
local setup, neo_tree = pcall(require, "neo-tree")
if not setup then
	return
end

neo_tree.setup({
	filesystem = {
		filtered_items = {
			visible = false,
			show_hidden_count = true,
			hide_dotfiles = false,
			hide_gitignored = false,
			hide_by_name = {
				".git",
				-- '.DS_Store',
				-- 'thumbs.db',
			},
			never_show = {},
			always_show = { -- remains visible even if other settings would normally hide it
				"*.env",
				".env*",
			},
			never_show_by_pattern = { -- uses glob style patterns
				".null-ls_*",
			},
		},
	},
	follow_current_file = {
		enabled = false, -- This will find and focus the file in the active buffer every time
		--               -- the current file is changed while the tree is open.
		leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
	},
})
