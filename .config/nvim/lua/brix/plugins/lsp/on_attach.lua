M = {}
M.on_attach = function(_, bufnr)
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.nmap("n", keys, func, { buffer = bufnr, desc = desc })
	end

	nmap("gd", "<Cmd>Lspsaga goto_definition<CR>", "LSP go to definition")
	nmap("gt", "<Cmd>Lspsaga peek_type_definition<CR>", "LSP go to type definition")
	nmap("gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", "LSP go to declaration")
	nmap("gi", "<Cmd>lua vim.lsp.buf.implementation()<CR>", "LSP go to implementation")
	nmap("gw", "<Cmd>Lspsaga lsp_finder<CR>", "LSP document symbols")
	nmap("gW", "<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>", "LSP Workspace symbols")
	nmap("gr", "<Cmd>lua vim.lsp.buf.references()<CR>", "LSP show references")
	nmap("K", "<Cmd>Lspsaga hover_doc<CR>", "LSP hover documentation")
	nmap("<c-k>", "<Cmd>lua vim.lsp.buf.signature_help()<CR>", "LSP signature help")
	nmap("<leader>ca", "<Cmd>Lspsaga code_action<CR>", "LSP show code actions")
	nmap("<leader>rn", "<Cmd>Lspsaga rename<CR>", "LSP rename word")
	nmap("<leader>dn", "<Cmd>Lspsaga diagnostic_jump_next<CR>", "LSP go to next diagnostic")
	nmap("<leader>dp", "<Cmd>Lspsaga diagnostic_jump_prev<CR>", "LSP go to previous diagnostic")
	nmap("<leader>ds", "<Cmd>Lspsaga show_line_diagnostics<CR>", "LSP show diagnostic under cursor")
	nmap("<leader>rs", "<Cmd>LspRestart<CR>", "Restart LSP")
end

return M
