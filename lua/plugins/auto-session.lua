return {
	"rmagatti/auto-session",
	config = function()
		require("auto-session").setup({
			suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
			auto_restore = false,
		})
	end,
}
