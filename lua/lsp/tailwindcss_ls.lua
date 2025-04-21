if not vim.lsp.config then
	vim.lsp.config = {}
end

vim.lsp.config["tailwindcss"] = {
	cmd = { "tailwindcss-language-server", "--stdio" },
	filetypes = {
		"html",
		"css",
		"scss",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
		"svelte",
		"astro",
		"php",
		"blade",
		"heex",
		"elixir",
		"eelixir",
	},
	root_markers = {
		"tailwind.config.js",
		"tailwind.config.cjs",
		"tailwind.config.ts",
		"postcss.config.js",
		"postcss.config.cjs",
		"postcss.config.ts",
		"package.json",
		".git",
	},
	single_file_support = false,
	settings = {
		tailwindCSS = {
			includeLanguages = {
				heex = "html",
				eelixir = "html",
				elixir = "html",
				php = "html",
				blade = "html",
			},
			experimental = {
				classRegex = {
					{ 'class[:]\\s*"([^"]*)"', 1 },
					{ 'className[:]\\s*"([^"]*)"', 1 },
					{ 'class=\\s*"([^"]*)"', 1 },
					{ "class=\\s*'([^']*)'", 1 },
					{ 'class:\\s*"([^"]*)"', 1 },
					{ "class:\\s*'([^']*)'", 1 },
					{ "tw\\(([^)]*)\\)", 1 },
				},
			},
			validate = true,
		},
	},
	capabilities = (function()
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = true
		return capabilities
	end)(),
}

-- Ativa o servidor com tratamento de erro
local success, err = pcall(function()
	vim.lsp.enable("tailwindcss")
end)

if not success then
	vim.notify("Falha ao habilitar o servidor TailwindCSS: " .. tostring(err), vim.log.levels.ERROR)
end
