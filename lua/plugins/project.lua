return {
	"ahmedkhalf/project.nvim",
	config = function()
		require("telescope").load_extension("projects")
		require("project_nvim").setup({})
	end,
}
