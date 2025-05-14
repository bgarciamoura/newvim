return {
	dir = vim.fn.stdpath("config") .. "/lua/core/keymaps", -- path local; qualquer dir
	name = "core-keymaps-engine",
	lazy = false, -- carrega no startup
	config = function()
		require("core.keymaps.engine").setup()
	end,
}
