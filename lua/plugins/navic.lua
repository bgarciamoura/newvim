return {
	"SmiteshP/nvim-navic",
	dependencies = { "neovim/nvim-lspconfig" },
	event = "LspAttach",
	config = function()
		local navic = require("nvim-navic")
		navic.setup()
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if client and client.server_capabilities.documentSymbolProvider then
					navic.attach(client, args.buf)
				end
			end,
		})
	end,
}
