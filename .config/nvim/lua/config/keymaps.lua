local set = vim.keymap.set

-- TIP: Disable arrow keys in normal mode
set("n", "<left>", '<cmd>echo "Use h to move left!!"<CR>')
set("n", "<right>", '<cmd>echo "Use l to move right!!"<CR>')
set("n", "<up>", '<cmd>echo "Use k to move up!!"<CR>')
set("n", "<down>", '<cmd>echo "Use j to move down!!"<CR>')

-- better up/down
set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
set("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
set("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
set("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
set("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Move Lines
set("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
set("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
set("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })
set("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })

-- Save and Quit
set("n", "<leader>ws", "<cmd>w<cr>", { silent = false, desc = "Save current buffer" })
set("n", "<leader>qq", "<cmd>q<cr>", { silent = false, desc = "Quit all" })

-- Clear search and stop snippet on escape
set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Escape and Clear hlsearch" })

-- Insert Mode --
set("i", "jj", "<esc>", { desc = "Exit insert mode (jj)" })
set("i", "JJ", "<esc>", { desc = "Exit insert mode (JJ)" })

-- diagnostic
local diagnostic_goto = function(next, severity)
  return function()
    vim.diagnostic.jump({
      count = (next and 1 or -1) * vim.v.count1,
      severity = severity and vim.diagnostic.severity[severity] or nil,
      float = true,
    })
  end
end
local open_float = function()
  vim.diagnostic.open_float({ border = "rounded" })
end

set("n", "<leader>d", open_float, { desc = "Line Diagnostics" })
-- set("n", "<leader>cd", open_float, { desc = "Line Diagnostics" })
set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
set("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- better indenting
set("v", "<", "<gv")
set("v", ">", ">gv")

set("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
set("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
set("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
