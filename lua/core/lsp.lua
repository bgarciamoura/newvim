local capabilities = require("blink.cmp").get_lsp_capabilities()

vim.lsp.enable({
  "lua_ls",
  "vtsls",
  "jsonls",
  "html",
  "cssls"
})

vim.diagnostic.config({ virtual_text = { prefix = "●" }, severity_sort = true })

vim.lsp.config("*", {
  capabilities = capabilities,
})
