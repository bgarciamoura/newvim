return {
	"L3MON4D3/LuaSnip",
	version = "v2.*",
	dependencies = {
		"rafamadriz/friendly-snippets",
	},
	build = "make install_jsregexp",
	config = function()
		require("luasnip.loaders.from_vscode").lazy_load()

		local ls = require("luasnip")

		-- Configuração de teclas para navegação nos snippets
		vim.keymap.set({ "i", "s" }, "<C-j>", function()
			if ls.jumpable(1) then
				ls.jump(1)
			end
		end, { silent = true })

		vim.keymap.set({ "i", "s" }, "<C-k>", function()
			if ls.jumpable(-1) then
				ls.jump(-1)
			end
		end, { silent = true })

		-- Habilitar snippets para Filetype específicos
		ls.filetype_extend("javascript", { "html" })
		ls.filetype_extend("typescript", { "javascript" })
		ls.filetype_extend("javascriptreact", { "javascript", "html" })
		ls.filetype_extend("typescriptreact", { "typescript", "javascriptreact" })
		ls.filetype_extend("htmlangular", { "html", "typescript" })
		ls.filetype_extend("vue", { "html", "javascript" })
		ls.filetype_extend("svelte", { "html", "javascript" })
		ls.filetype_extend("astro", { "html", "javascript" })
	end,
}
