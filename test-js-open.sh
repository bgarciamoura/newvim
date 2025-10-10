#!/bin/bash
# Test script to open a JS file and check for errors on macOS

echo "=== Testing JS file opening on macOS ==="

# Create a test JS file
cat > /tmp/test-macos.js << 'EOF'
const hello = () => {
  console.log("Hello from macOS test");
};

export default hello;
EOF

echo "1. Created test file: /tmp/test-macos.js"
echo ""

# Try to open it with nvim
echo "2. Opening file with Neovim..."
nvim --headless \
  -c "edit /tmp/test-macos.js" \
  -c "sleep 2" \
  -c "lua print('Filetype:', vim.bo.filetype)" \
  -c "lua print('Treesitter language:', require('nvim-treesitter.parsers').get_buf_lang(0))" \
  -c "lua local clients = vim.lsp.get_clients({bufnr=0}); print('LSP clients:', #clients); for _, c in ipairs(clients) do print('  -', c.name) end" \
  -c "quit" 2>&1

echo ""
echo "3. Cleaning up..."
rm -f /tmp/test-macos.js

echo "=== Test complete ==="
