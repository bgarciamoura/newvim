return {
	init_options = {
		experimentalFeatures = {
			prefillRequiredFields = true, -- Preencher automaticamente campos obrigatórios
			validateOnSave = true, -- Validar ao salvar
		},
	},
	settings = {
		terraform = {
			codelens = {
				referenceCount = true, -- Mostrar contagem de referências
			},
			telemetry = {
				enabled = false, -- Desativar telemetria por padrão
			},
			experimentalFeatures = {
				validateOnSave = true,
				prefillRequiredFields = true,
			},
			-- Opções de formatação
			format = {
				enable = true, -- Habilitar formatação
				defaultFormatter = "terraform", -- Usar formatador integrado
			},
			-- Opções de validação
			validation = {
				enableEnhancedValidation = true, -- Validação aprimorada
				moduleValidation = true, -- Validação de módulos
			},
		},
	},
	-- Detecção moderna da raiz do projeto
	root_dir = function(fname)
		local startpath = vim.fn.fnamemodify(fname, ":p:h")

		-- Buscar arquivos específicos do Terraform
		local terraform_files = {
			"*.tf",
			"main.tf",
			".terraform",
			".terraform.lock.hcl",
			"terraform.tfstate",
		}

		local root_file = vim.fs.find(terraform_files, { path = startpath, upward = true })[1]

		if root_file then
			return vim.fs.dirname(root_file)
		end

		-- Fallback para .git
		root_file = vim.fs.find({ ".git" }, { path = startpath, upward = true })[1]

		if root_file then
			return vim.fs.dirname(root_file)
		end

		return startpath
	end,
	-- Tipos de arquivo suportados
	filetypes = { "terraform", "terraform-vars", "hcl" },
	-- Suporte a arquivos individuais
	single_file_support = true,
	-- Comandos personalizados
	commands = {
		-- Comando para inicializar o Terraform
		TerraformInit = {
			function()
				local cwd = vim.fn.getcwd()
				vim.cmd("TermExec cmd='cd " .. cwd .. " && terraform init'")
			end,
			description = "Terraform Init",
		},
		-- Comando para validar a configuração
		TerraformValidate = {
			function()
				local cwd = vim.fn.getcwd()
				vim.cmd("TermExec cmd='cd " .. cwd .. " && terraform validate'")
			end,
			description = "Terraform Validate",
		},
		-- Comando para formatar todos os arquivos
		TerraformFormat = {
			function()
				local cwd = vim.fn.getcwd()
				vim.cmd("TermExec cmd='cd " .. cwd .. " && terraform fmt -recursive'")
			end,
			description = "Terraform Format",
		},
	},
}
