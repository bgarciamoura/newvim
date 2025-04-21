if not vim.lsp.config then
	vim.lsp.config = {}
end

-- Determina o nome do binário com base no sistema operacional
local bin_name = "gradle-language-server"
if vim.fn.has("win32") == 1 then
	bin_name = bin_name .. ".bat"
end

vim.lsp.config["gradle_ls"] = {
	cmd = { bin_name },
	filetypes = { "groovy", "kotlin" },
	root_markers = {
		"settings.gradle",
		"settings.gradle.kts",
		"build.gradle",
		"build.gradle.kts",
		".git",
	},
	single_file_support = false, -- Geralmente precisa do contexto do projeto
	settings = {
		gradle = {
			wrapper = {
				enabled = true,
			},
			-- Você pode adicionar outras configurações específicas do Gradle aqui
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
	vim.lsp.enable("gradle_ls")
end)

if not success then
	vim.notify("Falha ao habilitar o servidor Gradle: " .. tostring(err), vim.log.levels.ERROR)
end
