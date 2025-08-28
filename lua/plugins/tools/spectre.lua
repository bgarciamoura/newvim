return {
	"nvim-pack/nvim-spectre",
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- ou "echasnovski/mini.icons"
	},
	config = function()
		local spectre = require("spectre")

		-- detectar binários disponíveis (Windows-friendly)
		local function has(cmd)
			return vim.fn.executable(cmd) == 1
		end

		-- escolha do engine de replace:
		-- 1) sd (mais simples no Windows)  2) oxi (mais rápido, requer build)  3) sed (default)
		local replace_engine = "sed"
		if has("sd") then
			replace_engine = "sd"
		elseif has("oxi") then
			replace_engine = "oxi"
		end

		spectre.setup({
			color_devicons = true,
			lnum_for_results = true,
			-- evita re-executar a busca a cada write globalmente
			live_update = false,
			default = {
				replace = { cmd = replace_engine },
			},
			find_engine = {
				rg = {
					cmd = "rg",
					args = { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column" },
					options = {
						["ignore-case"] = { value = "--ignore-case", icon = "[I]", desc = "ignore case" },
						["hidden"] = { value = "--hidden", desc = "search hidden files" },
					},
				},
			},
		})

		-- Keymaps moved to lua/core/keymaps-central.lua for better organization
		-- This avoids conflicts and centralizes all keymaps in one place
	end,
}
