local is_win = vim.loop.os_uname().version:match("Windows")
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/"
local vtsls = is_win and (mason_bin .. "vtsls.cmd") or (mason_bin .. "vtsls")

return {
  -- força stdio e evita o shim do mise usando o binário do Mason
  cmd = { vtsls, "--stdio" },

  -- (opcional) filetypes padrão
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },

  -- (opcional) root_dir — pode omitir se quiser o padrão
  -- root_dir = require("lspconfig.util").root_pattern("pnpm-workspace.yaml", "package.json", "tsconfig.json", ".git"),

  -- (opcional) ajustes de TS
  settings = {
    typescript = {
      tsserver = { useSyntaxServer = "auto" },
      inlayHints = {
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
      },
    },
  },
}
