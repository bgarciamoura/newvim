local capabilities = require("blink.cmp").get_lsp_capabilities()
local lsp_keymaps = require("core.lsp-keymaps")

vim.lsp.enable({
	"lua_ls",
	"pyright", -- Python LSP
	"vtsls",
	"eslint", -- ESLint LSP for code actions and auto-fix
	"jsonls",
	"html",
	"cssls",
})

vim.lsp.config("*", {
	capabilities = capabilities,
	on_attach = lsp_keymaps.on_attach,
})

-- Disable Biome LSP (we use it only as formatter/linter, not as LSP)
-- We need to prevent it from being enabled by setting a root_dir that always returns nil
vim.lsp.config("biome", {
	enabled = false,
	root_dir = function()
		-- Always return nil to prevent Biome LSP from starting
		return nil
	end,
})

-- Additional safety: disable Biome via autocmd
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client.name == "biome" then
			vim.lsp.stop_client(client.id)
			vim.notify("Biome LSP was blocked (use conform/nvim-lint instead)", vim.log.levels.WARN)
		end
	end,
})

-- ESLint LSP specific configuration for better code actions
vim.lsp.config("eslint", {
	capabilities = capabilities,
	on_attach = lsp_keymaps.on_attach,
	settings = {
		codeAction = {
			disableRuleComment = {
				enable = true,
				location = "separateLine",
			},
			showDocumentation = {
				enable = true,
			},
		},
		-- Conform é a fonte de verdade para formatar e corrigir no save
		codeActionOnSave = {
			enable = false,
			mode = "all",
		},
		format = false,
		nodePath = "",
		onIgnoredFiles = "off",
		packageManager = "npm",
		quiet = false,
		rulesCustomizations = {},
		run = "onType",
		useESLintClass = false,
		validate = "on",
		workingDirectory = {
			mode = "auto",
		},
	},
})

-- Pyright Python LSP configuration
vim.lsp.config("pyright", {
	capabilities = capabilities,
	on_attach = function(client, bufnr)
		lsp_keymaps.on_attach(client, bufnr)

		-- Update Python path when venv changes
		if vim.g.python3_host_prog then
			client.config.settings.python.pythonPath = vim.g.python3_host_prog
			client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
		end
	end,
	settings = {
		python = {
			pythonPath = vim.g.python3_host_prog,
			analysis = {
				typeCheckingMode = "basic", -- "off", "basic", "strict"
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				autoImportCompletions = true,
				diagnosticMode = "workspace", -- "openFilesOnly", "workspace"
				stubPath = vim.fn.stdpath("data") .. "/lazy/python-type-stubs",
			},
		},
	},
	on_new_config = function(new_config, new_root_dir)
		local python_path = vim.g.python3_host_prog
		if python_path then
			new_config.settings.python.pythonPath = python_path
		end
	end,
})

-- POPUP de diagnósticos (erro/aviso) completos da linha/cursor
vim.diagnostic.config({
	virtual_text = { spacing = 2, prefix = "●", severity = nil }, -- pode deixar ligado
	severity_sort = true,
	float = {
		border = "rounded",
		source = "if_many", -- mostra a origem (vtsls, eslint_d, etc.)
		header = "",
		prefix = "",
		focusable = false,
		style = "minimal",
		max_width = 80,
		wrap = true, -- <- evita corte de mensagem longa
	},
})
