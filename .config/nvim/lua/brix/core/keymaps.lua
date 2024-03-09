-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps -------------------

-- open netrw
keymap.set("n", "<leader>en", vim.cmd.Ex)

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

keymap.set("n", "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", { desc = "Close Other Buffers" }) --
keymap.set("n", "<leader>bl", "<cmd>BufferLineCloseLeft<CR>", { desc = "Close Buffers To Left" }) --
keymap.set("n", "<leader>br", "<cmd>BufferLineCloseRight<CR>", { desc = "Close Buffers To Right" }) --
keymap.set("n", "<leader>bc", "<cmd>bd<CR>", { desc = "Close Current Buffer" }) --

keymap.set("n", "<leader>bn", "<cmd>BufferLineCycleNext<CR>", { desc = "Go To Next" }) --
keymap.set("n", "<leader>bp", "<cmd>BufferLineCyclePrev<CR>", { desc = "Go To Prev" }) --
