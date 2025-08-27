return {
	"saghen/blink.cmp",
	lazy = false, -- lazy loading handled internally
	dependencies = "rafamadriz/friendly-snippets",
	version = "v0.*",
	build = function()
		-- Only build if cargo is available
		if vim.fn.executable("cargo") == 1 then
			if vim.fn.has("win32") == 1 then
				return 'powershell -Command "cargo build --release"'
			else
				return "cargo build --release"
			end
		else
			vim.notify("Cargo not found. blink.cmp will use fallback mode.", vim.log.levels.WARN)
			return nil
		end
	end,
	opts = {
		keymap = {
			preset = "default",
			["<C-space>"] = { "show" },
			["<C-n>"] = { "show" },  -- Alternative: Ctrl+N
			["<M-space>"] = { "show" },  -- Alternative: Alt+Space (Windows-friendly)
			["<CR>"] = { "accept", "fallback" },
		},
		appearance = {
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "mono",
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
			providers = {
				lsp = {
					name = "LSP",
					module = "blink.cmp.sources.lsp",
					score_offset = 1000, -- Higher priority for LSP completions
					opts = {
						-- Increase max items for better TypeScript completions
						max_items = 200,
					},
				},
				buffer = {
					name = "Buffer",
					module = "blink.cmp.sources.buffer",
					score_offset = -3,
					opts = {
						get_bufnrs = function()
							return vim
								.iter(vim.api.nvim_list_wins())
								:map(function(win)
									return vim.api.nvim_win_get_buf(win)
								end)
								:filter(function(buf)
									return vim.bo[buf].buftype ~= "nofile"
								end)
								:totable()
						end,
					},
				},
				snippets = {
					score_offset = -1, -- Lower priority for snippets in TS files
				},
			},
		},
		completion = {
			accept = {
				auto_brackets = {
					enabled = true,
				},
			},
			menu = {
				draw = {
					treesitter = { "lsp" },
					columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 100, -- Faster documentation for better TypeScript experience
				treesitter_highlighting = true,
			},
			ghost_text = {
				enabled = true, -- Enable ghost text for better TypeScript autocomplete
			},
			-- Trigger completion automatically for TypeScript
			trigger = {
				completion = {
					keyword_length = 1, -- Trigger after 1 character for TS
					keyword_regex = "[%w_\\-\\.]", -- Include dots for method chaining
				},
			},
		},
		signature = {
			enabled = true,
		},
		fuzzy = {
			prebuilt_binaries = {
				download = true,
				force_version = nil,
			},
		},
	},
	opts_extend = { "sources.default" },
}
