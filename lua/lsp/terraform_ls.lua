if not vim.lsp.config then
	vim.lsp.config = {}
end

vim.lsp.config["terraformls"] = {
	cmd = { "terraform-ls", "serve" },
	filetypes = { "terraform", "terraform-vars", "tf" },
	root_markers = { ".terraform", ".git", "*.tf", "*.tfvars" },
	single_file_support = true,
	init_options = {
		experimentalFeatures = {
			prefillRequiredFields = true,
			validateOnSave = true,
		},
	},
	settings = {
		terraform = {
			-- Configurações adicionais específicas do servidor
			codelens = {
				enable = true,
			},
			telemetry = {
				enable = false,
			},
		},
	},
	capabilities = (function()
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = true
		return capabilities
	end)(),
}

-- Configurar filetypes adicionais específicos para terraform
local filetype_added = pcall(function()
	vim.filetype.add({
		extension = {
			tf = "terraform",
			tfvars = "terraform-vars",
		},
	})
end)

if not filetype_added then
	vim.notify(
		"Aviso: A função vim.filetype.add não está disponível, filetypes do Terraform podem não funcionar corretamente",
		vim.log.levels.WARN
	)
end

-- Ativa o servidor com tratamento de erro
local success, err = pcall(function()
	vim.lsp.enable("terraformls")
end)

if not success then
	vim.notify("Falha ao habilitar o servidor Terraform: " .. tostring(err), vim.log.levels.ERROR)
end
