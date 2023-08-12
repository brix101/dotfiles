-- import lspconfig plugin safely
local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
	return
end

-- import cmp-nvim-lsp plugin safely
local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
	return
end

-- import typescript plugin safely
local typescript_setup, typescript = pcall(require, "typescript")
if not typescript_setup then
	return
end

local keymap = vim.keymap -- for conciseness

-- enable keybinds only for when lsp server available
local on_attach = function(client, bufnr)
	-- keybind options
	local opts = { noremap = true, silent = true, buffer = bufnr }

	local bufmap = function(keys, func)
		keymap.set("n", keys, func, opts)
	end

	-- set keybinds
	-- bufmap("gf", "<cmd>Lspsaga lsp_finder<CR>") -- show definition, references
	-- bufmap("gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>") -- got to declaration
	-- bufmap("gd", "<cmd>Lspsaga peek_definition<CR>") -- see definition and make edits in window
	-- bufmap("gi", "<cmd>lua vim.lsp.buf.implementation()<CR>") -- go to implementation
	-- bufmap("<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>") -- show  diagnostics for line
	-- bufmap("<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>") -- show diagnostics for cursor
	-- bufmap("[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>") -- jump to previous diagnostic in buffer
	-- bufmap("]d", "<cmd>Lspsaga diagnostic_jump_next<CR>") -- jump to next diagnostic in buffer
	bufmap("<leader>o", "<cmd>LSoutlineToggle<CR>") -- see outline on right hand side

	bufmap("<leader>ca", "<cmd>Lspsaga code_action<CR>") -- see available code actions
	bufmap("<leader>rn", "<cmd>Lspsaga rename<CR>") -- smart rename

	bufmap("gd", vim.lsp.buf.definition)
	bufmap("gD", vim.lsp.buf.declaration)
	bufmap("gI", vim.lsp.buf.implementation)
	bufmap("<leader>D", vim.lsp.buf.type_definition)

	bufmap("gr", require("telescope.builtin").lsp_references)
	bufmap("<leader>s", require("telescope.builtin").lsp_document_symbols)
	bufmap("<leader>S", require("telescope.builtin").lsp_dynamic_workspace_symbols)

	bufmap("K", "<cmd>Lspsaga hover_doc<CR>") -- show documentation for what is under cursor
	-- typescript specific keymaps (e.g. rename file and update imports)
	if client.name == "tsserver" then
		bufmap("<leader>rf", ":TypescriptRenameFile<CR>") -- rename file and update imports
		bufmap("<leader>oi", ":TypescriptOrganizeImports<CR>") -- organize imports (not in youtube nvim video)
		bufmap("<leader>ru", ":TypescriptRemoveUnused<CR>") -- remove unused variables (not in youtube nvim video)
	end
end

-- used to enable autocompletion (assign to every lsp server config)
local capabilities = cmp_nvim_lsp.default_capabilities()

local util = require("lspconfig/util")

-- Change the Diagnostic symbols in the sign column (gutter)
-- (not in youtube nvim video)
local signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- configure html server
lspconfig["html"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure typescript server with plugin
typescript.setup({
	server = {
		capabilities = capabilities,
		on_attach = on_attach,
	},
})

-- configure css server
lspconfig["cssls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure tailwindcss server
lspconfig["tailwindcss"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure emmet language server
lspconfig["emmet_ls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
})

-- configure lua server (with special settings)
lspconfig["lua_ls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = { -- custom settings for lua
		Lua = {
			-- make the language server recognize "vim" global
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				-- make language server aware of runtime files
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
})

lspconfig["gopls"].setup({
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_dir = util.root_pattern("go.work", "go.mod", ".git"),
	settings = {
		gopls = {
			completeUnimported = true,
			usePlaceholders = true,
			analyses = {
				unusedparams = true,
			},
		},
	},
})
