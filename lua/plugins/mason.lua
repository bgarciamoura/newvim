local spec = {
	"mason-org/mason.nvim",
}
function spec.config()
	local mason = require("mason")
	local mason_registry = require("mason-registry")

	mason.setup()

	local packages = {
		"lua-language-server",
		"bash-language-server",
		"biome",
		"css-lsp",
		"html-lsp",
		"emmet-language-server",
		"docker-compose-language-service",
		"dockerfile-language-server",
		"json-lsp",
		"typescript-language-server",
		"prettierd",
		"eslint_d",
		"stylua",
	}

	for _, pkg in ipairs(packages) do
		-- Verifica se o pacote já está instalado
		if not mason_registry.is_installed(pkg) then
			-- Instala o pacote se ele não estiver instalado
			vim.cmd("MasonInstall " .. pkg)
		end
	end
end

return spec
