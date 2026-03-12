local set = vim.keymap.set
local M = {}

-- TIP: Disable arrow keys in normal mode
set("n", "<left>", '<cmd>echo "Use h to move left!!"<CR>')
set("n", "<right>", '<cmd>echo "Use l to move right!!"<CR>')
set("n", "<up>", '<cmd>echo "Use k to move up!!"<CR>')
set("n", "<down>", '<cmd>echo "Use j to move down!!"<CR>')

-- better up/down
set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
-- set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
-- set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

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
set("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
set("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- Clear search and stop snippet on escape
set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Escape and Clear hlsearch" })

-- Escape from insert mode with jk
set("i", "jk", "<Esc>", { desc = "Escape" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
set(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / Clear hlsearch / Diff Update" }
)

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Add undo break-points
set("i", ",", ",<c-g>u")
set("i", ".", ".<c-g>u")
set("i", ";", ";<c-g>u")

-- better indenting
set("v", "<", "<gv")
set("v", ">", ">gv")

M.map_lsp_keymaps = function(bufnr)
  local kind_filter = {
    "Class",
    "Constructor",
    "Enum",
    "Field",
    "Function",
    "Interface",
    "Method",
    "Module",
    "Namespace",
    "Package",
    "Property",
    "Struct",
    "Trait",
  }

  local map = function(keys, func, desc, mode)
    mode = mode or "n"
    vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
  end

  map("<leader>rn", vim.lsp.buf.rename, "Rename")
  map("<leader>ca", vim.lsp.buf.code_action, "Goto Code Action", { "n", "x" })
  map("gD", vim.lsp.buf.declaration, "Goto Declaration")

  map("K", function()
    return vim.lsp.buf.hover({ border = "rounded" })
  end, "Signature help")
  map("C-k", function()
    return vim.lsp.buf.signature_help({ border = "rounded" })
  end, "Signature help")
  map("<leader>d", function()
    return vim.diagnostic.open_float({ border = "rounded" })
  end, "Open Diagnostics")

  map("gd", function()
    require("telescope.builtin").lsp_definitions({ reuse_win = true })
  end, "Goto Definition")
  map("gr", require("telescope.builtin").lsp_references, "Goto References")
  map("gI", function()
    require("telescope.builtin").lsp_implementations({ reuse_win = true })
  end, "Goto Implementation")
  map("gt", function()
    require("telescope.builtin").lsp_type_definitions({ reuse_win = true })
  end, "Goto Type Definition")
  map("gO", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")
  map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")

  map("<leader>ss", function()
    require("telescope.builtin").lsp_document_symbols({
      symbols = kind_filter,
    })
  end, "Goto Symbol")
  map("<leader>sS", function()
    require("telescope.builtin").lsp_dynamic_workspace_symbols({
      symbols = kind_filter,
    })
  end, "Goto Symbol (Workspace)")
end

return M
