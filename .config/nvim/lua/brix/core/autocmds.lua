local group = vim.api.nvim_create_augroup("UserGroup", {})

vim.api.nvim_create_autocmd("ColorScheme", {
	group = group,
	desc = "Brighter window separator",
	callback = function()
		vim.api.nvim_set_hl(0, "WinSeparator", { bg = "NONE", fg = "#aaaaaa" })
		vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE", fg = "#aaaaaa" })
		vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE", fg = "#aaaaaa" })
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = group,
	desc = "Highlight words when a yank (y) is performed",
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
	end,
})
