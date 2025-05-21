return {
	"nvim-neo-tree/neo-tree.nvim",
	lazy = false,
	dependencies = {
		-- "DaikyXendo/nvim-material-icon",
		"nvim-tree/nvim-web-devicons",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"s1n7ax/nvim-window-picker",
	},
	config = function()
		require("neo-tree").setup({
			-- === Aparência da Janela ===
			close_if_last_window = false,
			popup_border_style = "rounded",
			window = {
				position = "left", -- Posição padrão: "left", "right", "float", "current"
				width = 35, -- Largura da sidebar
				mappings = {
					["<cr>"] = "open", -- Enter para abrir arquivo/pasta
					["<bs>"] = "navigate_up", -- Backspace para navegar para diretório pai
					["."] = "set_root", -- '.' para definir o diretório atual como raiz
					["H"] = "toggle_hidden", -- H para mostrar/esconder arquivos ocultos (dotfiles)
					["/"] = "fuzzy_finder", -- / para busca fuzzy de arquivos na árvore
					["f"] = "filter_on_submit", -- f para filtrar arquivos (digite e Enter)
					["<c-x>"] = "clear_filter", -- Ctrl+X para limpar filtro
					["a"] = "add", -- a para adicionar arquivo
					["A"] = "add_directory", -- A para adicionar diretório
					["d"] = "delete", -- d para deletar
					["r"] = "rename", -- r para renomear
					["c"] = "copy_to_clipboard", -- y para copiar caminho
					["x"] = "cut_to_clipboard", -- x para cortar (mover)
					["v"] = "paste_from_clipboard", -- p para colar (mover)
					["y"] = "copy", -- c para copiar arquivo/pasta (requer destino)
					["m"] = "move", -- m para mover (requer destino)
					["q"] = "close_window", -- q para fechar a janela do Neo-tree
					["?"] = "show_help", -- ? para ajuda (mostra todos os mapeamentos)
					["P"] = { "toggle_preview", config = { use_float = true } }, -- P para preview flutuante
					["S"] = "open_split", -- S para abrir em split horizontal
					["s"] = "open_vsplit", -- s para abrir em split vertical
					-- Adicione ou modifique mapeamentos conforme sua preferência
				},
			},
			-- === Ícones, Git e Diagnósticos ===
			enable_git_status = true, -- Mostrar status do Git (requer Git CLI)
			enable_diagnostics = true, -- Mostrar diagnósticos LSP (erros, avisos)
			default_component_configs = {
				-- Configuração dos ícones (geralmente funciona automaticamente com o plugin de ícones)
				icon = {
					folder_closed = "", -- Ícone para pasta fechada (pode variar com seu plugin/fonte)
					folder_open = "", -- Ícone para pasta aberta
					folder_empty = "󰜌", -- Ícone para pasta vazia
					provider = function(icon, node, state)
						if node.type == "file" or node.type == "terminal" then
							local success, web_devicons = pcall(require, "nvim-web-devicons") -- Continua usando esse nome!
							local name = node.type == "terminal" and "terminal" or node.name
							if success then
								local devicon, hl = web_devicons.get_icon(name)
								icon.text = devicon or icon.text
								icon.highlight = hl or icon.highlight
							end
						end
					end,
					highlight = "NeoTreeFileIcon",
				},
				-- Configuração da indentação
				indent = {
					indent_size = 2,
					padding = 1, -- Espaço extra à esquerda
					with_markers = true, -- Mostrar linhas de indentação
					indent_marker = "│",
					last_indent_marker = "└",
					highlight = "NeoTreeIndentMarker",
					with_expanders = true, -- Mostrar setas para expandir/recolher
					expander_collapsed = "",
					expander_expanded = "",
					expander_highlight = "NeoTreeExpander",
				},
				-- Configuração do nome do arquivo/pasta
				name = {
					trailing_slash = false, -- Não mostrar '/' após pastas
					use_git_status_colors = true, -- Usar cores do Git no nome do arquivo
					highlight = "NeoTreeFileName",
				},
				-- Símbolos para status do Git (podem ser redundantes se use_git_status_colors=true)
				git_status = {
					symbols = {
						added = "✚",
						modified = "",
						deleted = "✖",
						renamed = "󰁕",
						untracked = "",
						ignored = "",
						unstaged = "󰄱",
						staged = "",
						conflict = "",
					},
				},
			},
			-- === Comportamento do Filesystem ===
			filesystem = {
				filtered_items = {
					visible = false,
					hide_dotfiles = true,
					hide_gitignored = true, -- Esconder arquivos/pastas do .gitignore
					hide_hidden = true, -- Esconder arquivos ocultos (funciona melhor no Windows)
					hide_by_name = {
						"node_modules", -- Exemplo: descomente para esconder node_modules
					},
					hide_by_pattern = { -- Padrões glob
						"*.meta",
						"*/.git", -- Normalmente já coberto por hide_dotfiles ou hide_gitignored
					},
					never_show = { -- Nunca mostrar, mesmo se 'visible' for true
						".DS_Store",
						"Thumbs.db",
					},
					always_show = { -- Sempre mostrar, mesmo se 'visible' for false
						".storybook",
						".gitignore",
						".env.*",
						".env",
						".husky",
						".prettierignore",
						".prettierrc",
						".editorconfig",
					},
				},
				follow_current_file = {
					enabled = true, -- Fazer o Neo-tree seguir o arquivo ativo no buffer
					leave_dirs_open = true, -- Fechar diretórios abertos automaticamente ao mudar de arquivo
				},
				group_empty_dirs = false, -- Agrupar diretórios vazios
				hijack_netrw_behavior = "open_default", -- O que fazer ao abrir um diretório (:edit .):
				-- "open_default": Abre o Neo-tree na posição configurada (ex: 'left')
				-- "open_current": Abre o Neo-tree na janela atual (como o netrw)
				-- "disabled": Deixa o netrw cuidar disso (não recomendado se usar Neo-tree)
				use_libuv_file_watcher = true, -- Usar observador de arquivos do sistema (melhor performance, requer libuv)
			},
			diagnostic_symbols = {
				error = "",
				warn = "",
				info = "",
				hint = "󰌵",
			},
		})

		vim.keymap.set("n", "<Leader>e", "<Cmd>Neotree toggle reveal<CR>", { desc = "Neo-tree: Toggle/Reveal" })
		vim.keymap.set("n", "<Leader>fe", "<Cmd>Neotree filesystem focus<CR>", { desc = "Neo-tree: Focus Filesystem" })
		vim.keymap.set("n", "<Leader>fb", "<Cmd>Neotree buffers focus<CR>", { desc = "Neo-tree: Focus Buffers" })
		vim.keymap.set("n", "<Leader>fg", "<Cmd>Neotree git_status focus<CR>", { desc = "Neo-tree: Focus Git Status" })
	end,
}
