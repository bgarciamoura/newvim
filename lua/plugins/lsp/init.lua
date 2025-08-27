return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"saghen/blink.cmp",
	},
	opts = function()
		return {
			diagnostics = {
				underline = true,
				update_in_insert = false,
				virtual_text = {
					spacing = 4,
					source = "if_many",
					prefix = "●",
				},
				severity_sort = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚",
						[vim.diagnostic.severity.WARN] = "󰀪",
						[vim.diagnostic.severity.HINT] = "󰌶",
						[vim.diagnostic.severity.INFO] = "󰋽",
					},
				},
			},
			inlay_hints = {
				enabled = true,
			},
			capabilities = {
				workspace = {
					fileOperations = {
						didRename = true,
						willRename = true,
					},
				},
			},
			format = {
				formatting_options = nil,
				timeout_ms = nil,
			},
			servers = {
				lua_ls = {
					settings = {
						Lua = {
							workspace = {
								checkThirdParty = false,
							},
							codeLens = {
								enable = true,
							},
							completion = {
								callSnippet = "Replace",
							},
							doc = {
								privateName = { "^_" },
							},
							hint = {
								enable = true,
								setType = false,
								paramType = true,
								paramName = "Disable",
								semicolon = "Disable",
								arrayIndex = "Disable",
							},
						},
					},
				},
				-- TypeScript/JavaScript LSP
				ts_ls = {
					-- Explicitly set filetypes to ensure tsx/jsx support
					filetypes = {
						"javascript",
						"javascriptreact",
						"javascript.jsx",
						"typescript",
						"typescriptreact",
						"typescript.tsx",
					},
					-- Improve root directory detection
					root_dir = function(fname)
						local util = require("lspconfig.util")
						return util.root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git")(fname)
							or util.path.dirname(fname)
					end,
					-- Initialize options for better project detection
					init_options = {
						hostInfo = "neovim",
						preferences = {
							includePackageJsonAutoImports = "auto",
							includeCompletionsForModuleExports = true,
							includeCompletionsWithInsertText = true,
						},
					},
					settings = {
						typescript = {
							inlayHints = {
								includeInlayParameterNameHints = "all",
								includeInlayParameterNameHintsWhenArgumentMatchesName = true,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = true,
								includeInlayVariableTypeHintsWhenTypeMatchesName = true,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
							suggest = {
								includeCompletionsForModuleExports = true,
								includeCompletionsWithInsertText = true,
								includeAutomaticOptionalChainCompletions = true,
							},
							preferences = {
								includePackageJsonAutoImports = "auto",
								importModuleSpecifier = "relative",
								allowTextChangesInNewFiles = true,
							},
							-- Enable project-wide IntelliSense
							workspaceSymbols = {
								scope = "allOpenProjects",
							},
						},
						javascript = {
							inlayHints = {
								includeInlayParameterNameHints = "all",
								includeInlayParameterNameHintsWhenArgumentMatchesName = true,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = true,
								includeInlayVariableTypeHintsWhenTypeMatchesName = true,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
							suggest = {
								includeCompletionsForModuleExports = true,
								includeCompletionsWithInsertText = true,
								includeAutomaticOptionalChainCompletions = true,
							},
							preferences = {
								includePackageJsonAutoImports = "auto",
								importModuleSpecifier = "relative",
								allowTextChangesInNewFiles = true,
							},
						},
					},
				},
				-- ESLint LSP
				eslint = {
					settings = {
						workingDirectories = { mode = "auto" },
						experimental = {
							useFlatConfig = true,
						},
					},
					on_attach = function(client, bufnr)
						-- Only set up auto-fix if ESLint is properly configured
						if client.server_capabilities.executeCommandProvider then
							-- Check if EslintFixAll command is available
							local commands = client.server_capabilities.executeCommandProvider.commands or {}
							local has_eslint_fix = false
							for _, cmd in ipairs(commands) do
								if cmd == "eslint.executeAutofix" then
									has_eslint_fix = true
									break
								end
							end

							if has_eslint_fix then
								vim.api.nvim_create_autocmd("BufWritePre", {
									buffer = bufnr,
									callback = function()
										local params = {
											command = "eslint.executeAutofix",
											arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
										}
										local result = vim.lsp.buf_request_sync(bufnr, "workspace/executeCommand", params, 1000)
										if not result or vim.tbl_isempty(result) then
											-- Silently handle case where ESLint fix fails
											vim.notify("ESLint auto-fix not available for this file", vim.log.levels.DEBUG)
										end
									end,
								})
							else
								vim.notify("ESLint server started but auto-fix commands not available", vim.log.levels.WARN)
							end
						end
					end,
				},
				-- TailwindCSS LSP
				tailwindcss = {
					settings = {
						tailwindCSS = {
							experimental = {
								classRegex = {
									{ "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
									{ "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
									{ "cn\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
								},
							},
							validate = true,
							lint = {
								cssConflict = "warning",
								invalidApply = "error",
								invalidConfigPath = "error",
								invalidScreen = "error",
								invalidTailwindDirective = "error",
								invalidVariant = "error",
								recommendedVariantOrder = "warning",
							},
							classAttributes = {
								"class",
								"className",
								"class:list",
								"classList",
								"ngClass",
							},
						},
					},
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
					},
				},
			},
		}
	end,
	config = function(_, opts)
		-- Setup diagnostics
		vim.diagnostic.config(vim.deepcopy(opts.diagnostics))
		-- Setup completion
		local capabilities = vim.tbl_deep_extend(
			"force",
			vim.lsp.protocol.make_client_capabilities(),
			require("blink.cmp").get_lsp_capabilities(),
			opts.capabilities or {}
		)
		-- Setup servers
		local function setup_server(server_name, server_opts)
			server_opts = server_opts or {}
			server_opts.capabilities = vim.tbl_deep_extend("force", capabilities, server_opts.capabilities or {})

			-- Add LSP keymaps
			server_opts.on_attach = function(client, bufnr)
				require("core.lsp-keymaps").on_attach(client, bufnr)
				if server_opts.on_attach then
					server_opts.on_attach(client, bufnr)
				end
			end

			if server_opts.setup then
				server_opts.setup(server_name, server_opts)
			else
				require("lspconfig")[server_name].setup(server_opts)
			end
		end

		-- Auto-install and setup servers
		local servers = opts.servers or {}
		local ensure_installed = vim.tbl_keys(servers)

		require("mason-lspconfig").setup({
			ensure_installed = ensure_installed,
			handlers = {
				function(server_name)
					-- NUCLEAR: Block any Biome LSP attempts
					if server_name == "biome" then
						-- Kill any existing Biome clients
						for _, client in pairs(vim.lsp.get_clients()) do
							if client.name == "biome" then
								vim.lsp.stop_client(client.id, true)
							end
						end
						return -- Never setup Biome
					end
					setup_server(server_name, servers[server_name])
				end,
			},
		})
		
		-- NUCLEAR: Global Biome LSP killer - runs on every LSP event
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(event)
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client.name == "biome" then
					-- Immediately stop any Biome client that tries to attach
					vim.lsp.stop_client(client.id, true)
					vim.notify("Biome LSP blocked - using ESLint + Prettier instead", vim.log.levels.WARN)
				end
			end,
		})
	end,
}
