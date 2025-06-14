-- This file is automatically loaded by plugins.core
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- if the completion engine supports the AI source,
-- use that instead of inline suggestions
vim.g.ai_cmp = true

local opt = vim.opt

opt.relativenumber = true -- Show relative line numbers

opt.mouse = "a" -- Enable mouse support in all modes
opt.showmode = false -- Don't show the mode, since it's already in the status line
opt.clipboard = "unnamedplus" -- Use the system clipboard for all yank, delete, change and put operations

-- Enable break indent
opt.breakindent = true

-- Save undo history
opt.swapfile = false
opt.backup = false
-- opt.undodir = string.format("%s/undodir", vim.fn.stdpath("cache"))
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
opt.ignorecase = true
opt.smartcase = true

-- Keep signcolumn on by default
opt.signcolumn = "yes"

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

opt.smoothscroll = true -- Smooth scrolling
opt.scrolloff = 8 -- maintain 8 lines of context when scrolling
opt.colorcolumn = "80" -- Highlight column 80

-- Show which line your cursor is on
opt.cursorline = true
-- Keep signcolumn on by default
opt.signcolumn = "yes"
-- Decrease update time
opt.updatetime = 250

-- Decrease mapped sequence wait time
opt.timeoutlen = 300

-- Configure how new splits should be opened
opt.splitright = true
opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-options-guide`
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
opt.inccommand = "split"

-- Show which line your cursor is on
opt.cursorline = true

-- Show which line your cursor is on
opt.cursorline = true
opt.confirm = true -- Confirm before closing modified buffers

