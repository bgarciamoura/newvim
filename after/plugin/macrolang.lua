-- Create command to manually set macro syntax
vim.api.nvim_create_user_command('MacroSyntax', function()
  vim.bo.filetype = 'macrolang'
  print('Macro syntax highlighting activated')
end, { desc = 'Set macro language syntax highlighting' })