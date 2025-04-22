return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Gerenciador de servidores LSP
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"folke/neodev.nvim", -- Importante para desenvolvimento em Lua com Neovim
			"hrsh7th/cmp-nvim-lsp", -- Integração com nvim-cmp
		},
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			-- Configuração de capacidades para o LSP
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.completion.completionItem.snippetSupport = true
			capabilities.textDocument.completion.completionItem.resolveSupport = {
				properties = {
					"documentation",
					"detail",
					"additionalTextEdits",
				},
			}

			-- Usar cmp_nvim_lsp para aprimorar capacidades (se disponível)
			local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
			if has_cmp then
				capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
			end

			-- Setup Mason
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})

			-- Setup mason-lspconfig
			require("mason-lspconfig").setup({
				-- Servidores para instalar automaticamente (baseado nos seus arquivos)
				ensure_installed = {
					"lua_ls",
					"html",
					"cssls",
					"jsonls",
					"emmet_ls",
					"tailwindcss",
					"eslint",
					"marksman",
					"yamlls",
					"dockerls",
					"docker_compose_language_service",
					"prismals",
					"terraformls",
					"sqlls",
					"bashls",
					"biome",
				},
				automatic_installation = true,
			})

			-- Mapeamentos de teclas globais para LSP
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
			vim.keymap.set("n", "grt", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
			vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Find references" })
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
			vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
			vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Open diagnostic float" })
			vim.keymap.set("n", "<leader>gq", function()
				vim.lsp.buf.format({ async = true })
			end, { desc = "Format buffer (async)" })

			-- Customização para lint e formatação com Biome/ESLint
			local function setup_biome_eslint_integration()
				-- Função para determinar a raiz do projeto
				local function get_project_root()
					local root_files = { ".git", "package.json", "biome.json" }
					return vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1])
				end

				-- Função para verificar se 'biome.json' existe na raiz do projeto
				local function has_biome_config(root)
					return root and vim.fn.filereadable(vim.fs.joinpath(root, "biome.json")) == 1
				end

				-- Autocomando para aplicar correções ao salvar arquivos
				vim.api.nvim_create_autocmd("BufWritePre", {
					pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.vue", "*.svelte", "*.astro" },
					callback = function()
						local root = get_project_root()
						if has_biome_config(root) then
							-- Aplicar correções com o Biome
							vim.fn.jobstart({
								"biome",
								"check",
								"--apply",
								"--quiet",
								"--no-errors-on-exit",
								"--no-format-on-error",
								vim.api.nvim_buf_get_name(0),
							}, {
								cwd = root,
								on_exit = function(_, _)
									-- Ignoramos códigos de erro para não bloquear o salvamento
									-- Simplesmente continuamos com o salvamento do arquivo
								end,
							})
						else
							-- Aplicar correções com o ESLint
							vim.lsp.buf.execute_command({
								command = "eslint.applyAllFixes",
								arguments = {
									{
										uri = vim.uri_from_bufnr(0),
										version = vim.lsp.util.buf_versions[0],
									},
								},
							})
						end
					end,
				})
			end

			-- Eventos LSP
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					local bufnr = args.buf

					-- LSP Inlay hints
					if client.server_capabilities.inlayHintProvider then
						vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
					end

					-- LSP Highlight
					if client.server_capabilities.documentHighlightProvider then
						local group = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = false })
						vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })

						vim.api.nvim_create_autocmd("CursorHold", {
							group = group,
							buffer = bufnr,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd("CursorMoved", {
							group = group,
							buffer = bufnr,
							callback = vim.lsp.buf.clear_references,
						})
					end

					-- Buffer-specific keymaps, se necessário
					if client.server_capabilities.completionProvider then
						vim.keymap.set("i", "<C-Space>", function()
							vim.lsp.buf.completion()
						end, { buffer = bufnr, desc = "Trigger completion" })
					end
				end,
			})

			-- Configuração dos servidores LSP
			local servers = {
				-- Servidor Lua para Neovim
				lua_ls = {
					settings = {
						Lua = {
							runtime = {
								version = "LuaJIT",
							},
							diagnostics = {
								globals = { "vim" },
							},
							workspace = {
								library = vim.api.nvim_get_runtime_file("", true),
								checkThirdParty = false,
							},
							telemetry = {
								enable = false,
							},
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
				-- HTML
				html = {
					settings = {
						html = {
							format = {
								indentInnerHtml = true,
								wrapLineLength = 120,
								wrapAttributes = "auto",
							},
							suggest = {
								html5 = true,
							},
						},
					},
					init_options = {
						configurationSection = { "html", "css", "javascript" },
						embeddedLanguages = {
							css = true,
							javascript = true,
						},
						provideFormatter = true,
					},
				},
				-- CSS
				cssls = {
					settings = {
						css = { validate = true },
						scss = { validate = true },
						less = { validate = true },
					},
				},
				-- JSON
				jsonls = {
					settings = {
						json = {
							schemas = {
								{
									fileMatch = { "package.json" },
									url = "https://json.schemastore.org/package.json",
								},
								{
									fileMatch = { "tsconfig*.json" },
									url = "https://json.schemastore.org/tsconfig.json",
								},
								{
									fileMatch = { ".prettierrc", ".prettierrc.json" },
									url = "https://json.schemastore.org/prettierrc",
								},
								{
									fileMatch = { ".eslintrc", ".eslintrc.json" },
									url = "https://json.schemastore.org/eslintrc",
								},
								{
									fileMatch = { "biome.json" },
									url = "https://biomejs.dev/schemas/1.0.0/schema.json",
								},
							},
							validate = { enable = true },
							format = { enable = true },
						},
					},
				},
				-- YAML
				yamlls = {
					settings = {
						yaml = {
							schemaStore = {
								enable = true,
								url = "https://www.schemastore.org/api/json/catalog.json",
							},
							schemas = {
								["https://json.schemastore.org/github-workflow.json"] = ".github/workflows/*.{yml,yaml}",
								["https://json.schemastore.org/gitlab-ci.json"] = { ".gitlab-ci.yml", "ci/*.yml" },
								["https://json.schemastore.org/kustomization.json"] = "kustomization.{yml,yaml}",
								["https://json.schemastore.org/helmfile.json"] = "helmfile.{yml,yaml}",
								["https://json.schemastore.org/docker-compose.json"] = "docker-compose*.{yml,yaml}",
							},
						},
					},
				},
				-- Biome
				biome = {},
				-- TypeScript/JavaScript
				tsserver = {},
				-- ESLint
				eslint = {
					settings = {
						packageManager = "npm",
						codeActionOnSave = {
							enable = false,
							mode = "all",
						},
						format = true,
						run = "onType",
					},
				},
				-- TailwindCSS
				tailwindcss = {
					settings = {
						tailwindCSS = {
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
							includeLanguages = {
								heex = "html",
								eelixir = "html",
								elixir = "html",
								php = "html",
								blade = "html",
							},
						},
					},
				},
				-- Docker
				dockerls = {},
				-- Docker Compose
				docker_compose_language_service = {
					filetypes = { "yaml.docker-compose" },
					settings = {},
				},
				-- Emmet
				emmet_ls = {
					filetypes = {
						"astro",
						"css",
						"eruby",
						"html",
						"htmldjango",
						"javascriptreact",
						"less",
						"pug",
						"sass",
						"scss",
						"svelte",
						"typescriptreact",
						"vue",
						"htmlangular",
					},
				},
				-- Prisma
				prismals = {
					settings = {
						prisma = {
							prismaFmtBinPath = "",
						},
					},
				},
				-- Terraform
				terraformls = {
					init_options = {
						experimentalFeatures = {
							prefillRequiredFields = true,
						},
					},
				},
				-- SQL
				sqlls = {},
				-- Bash
				bashls = {
					settings = {
						bashIde = {
							globPattern = "*@(.sh|.inc|.bash|.command)",
						},
					},
				},
				-- Markdown
				marksman = {},
				-- Configuração do Kotlin
				kotlin_language_server = {
					settings = {
						kotlin = {
							compiler = {
								jvm = {
									target = "17", -- Você pode ajustar para a versão do JDK que está usando
								},
							},
							completion = {
								snippets = {
									enabled = true,
								},
							},
							debugAdapter = {
								enabled = true,
							},
							externalSources = {
								autoConvertToKotlin = true,
								useKlsScheme = true,
							},
							linting = {
								enabled = true,
							},
						},
					},
					before_init = function(initialize_params, config)
						-- Força o uso do JAVA_HOME correto no macOS
						initialize_params.initializationOptions = initialize_params.initializationOptions or {}
						initialize_params.initializationOptions.javaHome = vim.fn.expand("$JAVA_HOME")
					end,
					root_markers = {
						"settings.gradle",
						"settings.gradle.kts",
						"build.gradle",
						"build.gradle.kts",
						"pom.xml",
						".git",
						".gradlew",
						"gradlew",
						"gradlew.bat",
						"src/main/kotlin", -- Diretório típico de código Kotlin
						"src/main/resources/application.properties", -- Arquivo de configuração Spring Boot
						"src/main/resources/application.yml", -- Alternativa YAML para configuração Spring Boot
					},
				},
				-- Java/Spring Boot (usando JDTLS)
				jdtls = {
					settings = {
						java = {
							configuration = {
								updateBuildConfiguration = "automatic",
								maven = {
									downloadSources = true,
									updateSnapshots = true,
								},
								gradle = {
									downloadSources = true,
									wrapper = {
										enabled = true,
									},
								},
							},
							eclipse = {
								downloadSources = true,
							},
							maven = {
								downloadSources = true,
							},
							implementationsCodeLens = {
								enabled = true,
							},
							referencesCodeLens = {
								enabled = true,
							},
							format = {
								enabled = true,
							},
							signatureHelp = {
								enabled = true,
							},
							contentProvider = {
								preferred = "fernflower",
							},
							completion = {
								favoriteStaticMembers = {
									"org.junit.Assert.*",
									"org.junit.Assume.*",
									"org.junit.jupiter.api.Assertions.*",
									"org.junit.jupiter.api.Assumptions.*",
									"org.junit.jupiter.api.DynamicContainer.*",
									"org.junit.jupiter.api.DynamicTest.*",
									"org.assertj.core.api.Assertions.*",
									"org.mockito.Mockito.*",
									"org.mockito.ArgumentMatchers.*",
									"org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*",
									"org.springframework.test.web.servlet.result.MockMvcResultMatchers.*",
									"jakarta.servlet.http.HttpServletResponse.*",
									"jakarta.validation.Validation.*",
									"jakarta.validation.Validator.*",
									"jakarta.validation.ConstraintViolation.*",
									"jakarta.validation.ConstraintViolationException.*",
									"jakarta.validation.constraints.*",
								},
								importOrder = {
									"java",
									"javax",
									"org",
									"com",
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
								hashCodeEquals = {
									useJava7Objects = true,
								},
								useBlocks = true,
							},
							inlayHints = {
								parameterNames = {
									enabled = "all", -- Exibir dicas de parâmetros inline
								},
							},
						},
					},
					root_markers = {
						".git",
						"mvnw",
						"gradlew",
						"pom.xml",
						"build.gradle",
						"settings.gradle",
						"build.gradle.kts",
						"settings.gradle.kts",
					},
				},
			}

			-- Configuração adicional para suporte a Docker Compose
			vim.filetype.add({
				filename = {
					["docker-compose.yml"] = "yaml.docker-compose",
					["docker-compose.yaml"] = "yaml.docker-compose",
					["compose.yml"] = "yaml.docker-compose",
					["compose.yaml"] = "yaml.docker-compose",
				},
			})

			-- Configuração para GitHub Actions
			vim.filetype.add({
				pattern = {
					[".*/%.github/workflows/.*%.ya?ml"] = "yaml.github",
				},
			})

			-- Configurar servidores LSP após Mason
			require("mason-lspconfig").setup_handlers({
				function(server_name)
					local server_config = servers[server_name] or {}
					server_config.capabilities = capabilities

					require("lspconfig")[server_name].setup(server_config)
				end,
			})

			-- Configurar diagnósticos
			vim.diagnostic.config({
				virtual_text = {
					prefix = "●",
					spacing = 4,
					severity = vim.diagnostic.severity.WARN,
					current_line = true,
				},
				update_in_insert = true,
				float = false,
			})

			-- Configurar integração Biome/ESLint
			setup_biome_eslint_integration()
		end,
	},
}
