# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a modular Neovim configuration built with Lazy.nvim as the plugin manager. The configuration follows a structured approach:

- **Core initialization**: `init.lua` loads core modules in sequence: options, diagnostics, autocmds, and lazy plugin manager
- **Plugin management**: Uses Lazy.nvim with automatic plugin installation and checking
- **Keymap system**: Custom engine-based keymap system that loads `*_spec.lua` files from `lua/core/keymaps/` directory
- **LSP setup**: Comprehensive LSP configuration with Mason, blink.cmp for completion, and Roslyn for C# support

## Key Components

### Keymap Engine (`lua/core/keymaps/engine.lua`)
- Automatically loads all `*_spec.lua` files from the keymaps directory
- Supports both global and buffer-local mappings
- Event-driven keymap loading (e.g., on LSP attach, VeryLazy event)
- Each spec file returns a table with `mappings` array and optional `event`/`buffer_local` properties

### LSP Configuration (`lua/plugins/lsp.lua`)
- Uses Mason for LSP server management with custom registry support
- blink.cmp for completion with multiple sources (LSP, snippets, buffer, etc.)
- Custom diagnostic configuration with icons and virtual lines
- Roslyn integration for C# development

### Plugin Structure
- All plugins are defined in `lua/plugins/` directory
- Colorschemes have their own subdirectory
- Lazy.nvim imports both `plugins` and `plugins.colorschemes` specs

## Development Workflow

### Configuration Testing
```bash
# Test configuration by starting Neovim
nvim

# Check plugin status
:Lazy

# Check LSP status
:LspInfo

# Check Mason installations
:Mason
```

### Keymap Development
- Create new keymap specs in `lua/core/keymaps/` with `*_spec.lua` naming
- Use the engine system rather than direct vim.keymap.set calls
- Follow the existing pattern of returning a table with mappings array

### Plugin Development
- Add new plugins as separate files in `lua/plugins/`
- Use Lazy.nvim's lazy loading patterns (event, cmd, ft, keys)
- Check `lazy-lock.json` for current plugin versions

## Configuration Notes

- Leader key is set to space (`<Space>`)
- Local leader is backslash (`\`)
- Uses Kanagawa colorscheme by default
- Treesitter folding is enabled
- 2-space indentation throughout
- LSP inlay hints are enabled globally