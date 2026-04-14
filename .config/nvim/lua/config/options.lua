-- This file is automatically loaded by plugins.core
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- vim.g.have_nerd_font = true

-- if the completion engine supports the AI source,
-- use that instead of inline suggestions
vim.g.ai_cmp = false

local opt = vim.opt

opt.autoindent = true -- copy indent from current line when starting new one
opt.autowrite = true -- Enable auto write
-- only set clipboard if not in ssh, to make sure the OSC 52
-- integration works automatically.
opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus" -- Sync with system clipboard
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.colorcolumn = "80" -- Highlight column 80
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  --   fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
opt.foldlevel = 99
-- opt.foldmethod = "indent"
opt.foldtext = ""
-- opt.grepformat = "%f:%l:%c:%m"
-- opt.grepprg = "rg --vimgrep"
opt.ignorecase = true -- Ignore case
opt.inccommand = "nosplit" -- preview incremental substitute
opt.jumpoptions = "view" -- Keep the cursor vertically centered when jumping to a different location in the file
opt.laststatus = 3 -- global statusline
opt.linebreak = true -- Wrap lines at convenient points
opt.list = true -- Show some invisible characters (tabs...
opt.mouse = "a" -- Enable mouse mode
opt.number = true -- Print line number
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.relativenumber = true -- Relative line numbers
opt.ruler = false -- Disable the default ruler
opt.scrolloff = 8 -- Lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" } -- Save all the things
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.shortmess:append({ W = true, I = false, c = true, C = true }) -- W: Don't show "written" when writing, I: Don't show the intro message when starting Vim, c: Don't show completion messages, C: Don't show completion messages in command line
opt.showmode = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.smoothscroll = true -- Smooth scrolling
opt.spelllang = { "en" } -- Set the languages for spell checking
opt.splitbelow = true -- Put new windows below current
opt.splitkeep = "screen" -- Keep the text on the same screen line when splitting
opt.splitright = true -- Put new windows right of current
opt.tabstop = 2 -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true -- Enable persistent undo
opt.undolevels = 10000 -- Number of undo levels
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false -- Disable line wrap

-- Experimental UI2: floating cmdline and messages
-- vim.o.cmdheight = 1
-- require("vim._core.ui2").enable({
--   enable = true, -- Whether to enable or disable the UI.
--   msg = {
--     targets = {
--       [""] = "msg",
--       empty = "cmd",
--       bufwrite = "msg",
--       confirm = "cmd",
--       emsg = "pager",
--       echo = "msg",
--       echomsg = "msg",
--       echoerr = "pager",
--       completion = "cmd",
--       list_cmd = "pager",
--       lua_error = "pager",
--       lua_print = "msg",
--       progress = "pager",
--       rpc_error = "pager",
--       quickfix = "msg",
--       search_cmd = "cmd",
--       search_count = "cmd",
--       shell_cmd = "pager",
--       shell_err = "pager",
--       shell_out = "pager",
--       shell_ret = "msg",
--       undo = "msg",
--       verbose = "pager",
--       wildlist = "cmd",
--       wmsg = "msg",
--       typed_cmd = "cmd",
--     },
--     cmd = { -- Options related to messages in the cmdline window.
--       height = 0.5, -- Maximum height while expanded for messages beyond 'cmdheight'.
--     },
--     dialog = { -- Options related to dialog window.
--       height = 0.5, -- Maximum height.
--     },
--     msg = { -- Options related to msg window.
--       height = 0.5, -- Maximum height.
--       timeout = 4000, -- Time a message is visible in the message window.
--     },
--     pager = { -- Options related to message window.
--       height = 1, -- Maximum height.
--     },
--   },
-- })
