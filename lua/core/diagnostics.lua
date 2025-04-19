vim.diagnostic.config({
  virtual_text = {
    prefix = '●',
    spacing = 4,
    severity = vim.diagnostic.severity.WARN,
    current_line = true
  },
  update_in_insert = true,
  float = false,
})

