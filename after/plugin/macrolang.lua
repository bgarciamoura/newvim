-- Create command to manually set macro syntax
vim.api.nvim_create_user_command('MacroSyntax', function()
  vim.bo.filetype = 'macrolang'
  print('Macro syntax highlighting activated')
end, { desc = 'Set macro language syntax highlighting' })

-- Create command to manually set OpenKore config syntax
vim.api.nvim_create_user_command('ConfigSyntax', function()
  vim.bo.filetype = 'okconfig'
  print('OpenKore config syntax highlighting activated')
end, { desc = 'Set OpenKore config syntax highlighting' })

-- Create command to fix line endings (convert CRLF to LF)
vim.api.nvim_create_user_command('FixLineEndings', function()
  -- Save current cursor position
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  
  -- Convert CRLF to LF
  vim.cmd('silent! %s/\r$//')
  
  -- Set file format to unix
  vim.bo.fileformat = 'unix'
  
  -- Restore cursor position
  vim.api.nvim_win_set_cursor(0, cursor_pos)
  
  print('Line endings converted to Unix format (CRLF → LF)')
end, { desc = 'Convert Windows line endings to Unix format' })