if not vim.lsp.config then
	vim.lsp.config = {}
end

vim.lsp.config["javalsp"] = {
	-- Nota: Substitua o cmd pelo executável correto do seu Java Language Server
	-- Esta configuração presume que você está usando o Eclipse JDT LS ou semelhante
	cmd = {
		"jdtls",
		"--stdio",
	},
	filetypes = { "java" },
	root_markers = { "build.gradle", "build.gradle.kts", "pom.xml", ".git", "mvnw", "gradlew" },
	single_file_support = false, -- Java geralmente requer contexto de projeto
	settings = {
		java = {
			signatureHelp = { enabled = true },
			contentProvider = { preferred = "fernflower" },
			completion = {
				favoriteStaticMembers = {
					"org.junit.Assert.*",
					"org.junit.Assume.*",
					"org.junit.jupiter.api.Assertions.*",
					"org.junit.jupiter.api.Assumptions.*",
					"org.junit.jupiter.api.DynamicTest.*",
				},
				importOrder = {
					"java",
					"javax",
					"com",
					"org",
				},
			},
			sources = {
				organizeImports = {
					starThreshold = 9999,
					staticStarThreshold = 9999,
				},
			},
			codeGeneration = {
				toString = {
					template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
				},
				useBlocks = true,
			},
			configuration = {
				runtimes = {
					-- Você pode especificar diferentes JDKs aqui
					-- Exemplo:
					-- {
					--   name = "JavaSE-11",
					--   path = "/path/to/jdk-11",
					-- },
					-- {
					--   name = "JavaSE-17",
					--   path = "/path/to/jdk-17",
					-- }
				},
			},
		},
	},
	capabilities = (function()
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = true
		capabilities.textDocument.completion.completionItem.resolveSupport = {
			properties = {
				"documentation",
				"detail",
				"additionalTextEdits",
			},
		}
		return capabilities
	end)(),
}

-- Ativa o servidor com tratamento de erro
local success, err = pcall(function()
	vim.lsp.enable("javalsp")
end)

if not success then
	vim.notify("Falha ao habilitar o servidor Java: " .. tostring(err), vim.log.levels.ERROR)
end
