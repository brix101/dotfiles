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
	gopls = {
		analyses = {
			fieldalignment = false, -- find structs that would use less memory if their fields were sorted
			nilness = true,
			unusedparams = true,
			unusedwrite = true,
			useany = true,
		},
		codelenses = {
			gc_details = false,
			generate = true,
			regenerate_cgo = true,
			run_govulncheck = true,
			test = true,
			tidy = true,
			upgrade_dependency = true,
			vendor = true,
		},
		experimentalPostfixCompletions = true,
		hints = {
			assignVariableTypes = true,
			compositeLiteralFields = true,
			compositeLiteralTypes = true,
			constantValues = true,
			functionTypeParameters = true,
			parameterNames = true,
			rangeVariableTypes = true,
		},
		gofumpt = true,
		semanticTokens = true,
		-- DISABLED: staticcheck
		--
		-- gopls doesn't invoke the staticcheck binary.
		-- Instead it imports the analyzers directly.
		-- This means it can report on issues the binary can't.
		-- But it's not a good thing (like it initially sounds).
		-- You can't then use line directives to ignore issues.
		--
		-- Instead of using staticcheck via gopls.
		-- We have golangci-lint execute it instead.
		--
		-- For more details:
		-- https://github.com/golang/go/issues/36373#issuecomment-570643870
		-- https://github.com/golangci/golangci-lint/issues/741#issuecomment-1488116634
		--
		-- staticcheck = true,
		usePlaceholders = true,
	},
	tailwindcss = {
		filetypes = { "svelte", "typescriptreact", "javascriptreact" },
	},
	html = {},
	cssls = {},
	rust_analyzer = {},
	pylsp = {
		plugins = {
			pyright = {
				pyright = { enabled = false },
				-- jedi = true,
				-- pylsp_mypy = true,
				black = true,
				-- pylsp_flake8 = true,
				isort = true,
				pycodestyle = { enabled = false },
				-- pylsp_pydocstyle = true,
				-- pylsp_pylint = true,
			},
		},
	},
	svelte = {},
	graphql = {
		filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
	},
}
