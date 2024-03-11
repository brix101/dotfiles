return {
	"rmagatti/auto-session",
	config = function()
		local auto_session = require("auto-session")
		local function restore_nvim_tree()
			local nvim_tree = require('nvim-tree')
			nvim_tree.change_dir(vim.fn.getcwd())
			nvim_tree.refresh()
		end

		auto_session.setup({
			auto_restore_enabled = true,
			auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
			post_restore_cmds = {restore_nvim_tree}
		})

		local keymap = vim.keymap

		keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" }) -- restore last workspace session for current directory
		keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session for auto session root dir" }) -- save workspace session for current working directory
	end,
}
