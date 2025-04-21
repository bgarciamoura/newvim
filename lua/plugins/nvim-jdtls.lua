return {
	"mfussenegger/nvim-jdtls",
	ft = { "java" },
	dependencies = {
		"neovim/nvim-lspconfig",
		"williamboman/mason.nvim",
	},
	config = function()
		-- Configuração para melhor suporte ao Spring Boot
		local jdtls_setup = function()
			local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
			local workspace_dir = vim.fn.expand("~/.cache/jdtls/workspace/") .. project_name

			-- Encontra o caminho da extensão Spring Boot
			local spring_boot_extension = vim.fn.glob(
				vim.fn.stdpath("data") .. "/mason/packages/jdtls/extension/server/com.microsoft.java.spring.extension-*.jar"
			)

			local config = {
				cmd = {
					"jdtls",
					"--jvm-arg=-javaagent:" .. vim.fn.expand("~/.local/share/nvim/mason/packages/jdtls/lombok.jar"),
					"-data",
					workspace_dir,
				},
				root_dir = require("jdtls.setup").find_root({
					".git",
					"mvnw",
					"gradlew",
					"pom.xml",
					"build.gradle",
				}),
				settings = {
					java = {
						-- Mesmo settings que você configurou no lspconfig
					},
				},
				init_options = {
					bundles = {
						spring_boot_extension,
					},
				},
			}

			require("jdtls").start_or_attach(config)
		end

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "java",
			callback = jdtls_setup,
		})
	end,
}
