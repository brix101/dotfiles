return {
	jsonls = {
		settings = {
			json = {
				schema = require("schemastore").json.schemas(),
				validate = { enable = true },
			},
		},
	},
	lua_ls = {
		-- cmd = {...},
		-- filetypes = { ...},
		-- capabilities = {},
		settings = {
			Lua = {
				completion = {
					callSnippet = "Replace",
				},
				-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
				-- diagnostics = { disable = { 'missing-fields' } },
			},
		},
	},
	-- tsserver = {},
	gopls = {},
	tailwindcss = {},
	html = {},
	cssls = {},
	rust_analyzer = {},
	pyright = {},
}
