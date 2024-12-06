return { -- Useful plugin to show you pending keybinds.
	"folke/which-key.nvim",
	event = "VimEnter", -- Sets the loading event to 'VimEnter'
	config = function() -- This is the function that runs, AFTER loading
		local wk = require("which-key")

		wk.setup()

		wk.add({
			{ "<leader>c", group = "[C]ode" },
			{ "<leader>d", group = "[D]ocument" },
			{ "<leader>f", group = "[F]ind" },
			{ "<leader>g", group = "[G]" },
			{ "<leader>r", group = "[R]ename" },
			{ "<leader>s", group = "[S]urround" },
			{ "<leader>t", group = "[T]oggle" },
			{ "<leader>w", group = "[W]orkspace" },
		}, {
			-- Nested mappings are allowed and can be added in any order
			-- Most attributes can be inherited or overridden on any level
			-- There's no limit to the depth of nesting
			mode = { "n", "v" }, -- NORMAL and VISUAL mode
			{ "<leader>h", group = "Git [H]unk" },
		})
	end,
}
