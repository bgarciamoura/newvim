local spec = {
    "mason-org/mason.nvim",
}
function spec.config()
local mason =    require("mason")
  mason.setup()
    local packages = {
      luals = "lua-language-server",
      bashls = "bash-language-server",
      biome = "biome",
      cssls = "css-lsp"
    }
    for cmd, pkg in pairs(packages) do
        if vim.fn.executable(cmd) == 0 then
            vim.cmd("MasonInstall " .. pkg)
        end
    end
end

return spec
