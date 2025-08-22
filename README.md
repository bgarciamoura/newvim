# 🚀 Professional Neovim Configuration

A modern, modular, and professionally crafted Neovim configuration optimized for full-stack JavaScript/TypeScript development. Built with performance in mind using lazy.nvim and organized following industry best practices.

## ✨ Features

- 🔥 **Modern Plugin Management** - lazy.nvim for fast startup and lazy loading
- 🎯 **Full-Stack Development** - Optimized for React, React Native, Node.js, NestJS
- 🧪 **Comprehensive Testing** - Neotest integration with Jest and Vitest
- 🐛 **Advanced Debugging** - DAP setup for Node.js, Chrome, and React Native
- 📦 **Package Management** - Real-time dependency tracking with package-info.nvim
- 🎨 **Beautiful UI** - Carefully curated colorschemes and status line
- ⚡ **Performance First** - Lazy loading, optimized configurations
- 🔍 **Powerful Search** - Telescope with fuzzy finding and live grep
- 🌳 **File Management** - Neo-tree with material icons
- 📝 **Smart Completion** - Blink.cmp with LSP, snippets, and buffer completion
- 🔧 **Code Intelligence** - Full LSP support with TypeScript, ESLint, TailwindCSS
- 📊 **Git Integration** - GitSigns, LazyGit, and advanced git workflows
- 🎯 **API Testing** - Bruno.nvim for REST API development
- ✅ **Todo Management** - Checkmate.nvim for project task tracking

## 📁 Project Structure

```
~/.config/nvim/
├── init.lua                    # Entry point
├── lua/
│   ├── core/
│   │   ├── autocmds.lua       # Auto commands
│   │   ├── keymaps.lua        # Global keymaps
│   │   ├── lazy.lua           # Plugin manager setup
│   │   ├── lsp-keymaps.lua    # LSP-specific keymaps
│   │   └── options.lua        # Vim options
│   └── plugins/
│       ├── colorschemes/
│       │   └── aura.lua       # Aura theme
│       ├── completion/
│       │   └── blink.lua      # Blink completion
│       ├── editor/
│       │   ├── neo-tree.lua   # File explorer
│       │   ├── telescope.lua  # Fuzzy finder
│       │   ├── treesitter.lua # Syntax highlighting
│       │   └── ...
│       ├── lsp/
│       │   ├── init.lua       # LSP configuration
│       │   └── mason.lua      # LSP/tool installer
│       ├── tools/
│       │   ├── bruno.lua      # API testing
│       │   ├── conform.lua    # Code formatting
│       │   ├── gitsigns.lua   # Git integration
│       │   ├── neotest.lua    # Testing framework
│       │   ├── nvim-dap.lua   # Debugging
│       │   ├── nvim-lint.lua  # Linting
│       │   ├── package-info.lua # Package management
│       │   └── ...
│       └── ui/
│           ├── lualine.lua    # Status line
│           ├── noice.lua      # Enhanced UI
│           └── which-key.lua  # Keymap helper
└── README.md                  # This file
```

## 🛠 Installation

### Prerequisites

- Neovim >= 0.9.0
- Git
- Node.js (for LSP servers and tools)
- A Nerd Font (for icons)
- ripgrep (for search)
- lazygit (optional, for git UI)

### Quick Install

```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.backup

# Clone this configuration
git clone https://github.com/your-username/nvim-config ~/.config/nvim

# Start Neovim (plugins will auto-install)
nvim
```

### Manual Setup

1. **Install dependencies:**
   ```bash
   # Ubuntu/Debian
   sudo apt install ripgrep fd-find

   # macOS
   brew install ripgrep fd lazygit

   # Windows (via Chocolatey)
   choco install ripgrep fd lazygit
   ```

2. **Install a Nerd Font:**
   - Download from [Nerd Fonts](https://www.nerdfonts.com/)
   - Recommended: JetBrainsMono Nerd Font, FiraCode Nerd Font

3. **First Launch:**
   - Launch Neovim: `nvim`
   - Wait for lazy.nvim to install all plugins
   - Restart Neovim
   - Run `:Mason` to verify LSP servers are installed

## 🎯 Key Bindings

### Global Leader Key: `<Space>`

#### File Operations
| Key | Action |
|-----|---------|
| `<leader>e` | Toggle Neo-tree |
| `<leader>ff` | Find files |
| `<leader>fg` | Find git files |
| `<leader>fr` | Recent files |
| `<leader>fb` | Find buffers |

#### Code & LSP
| Key | Action |
|-----|---------|
| `<leader>ca` | Code action |
| `<leader>cf` | Format code |
| `<leader>cR` | Rename symbol |
| `<leader>cd` | Line diagnostics |
| `gd` | Go to definition |
| `gr` | Go to references |
| `K` | Hover documentation |

#### Testing (Neotest)
| Key | Action |
|-----|---------|
| `<leader>tt` | Run file tests |
| `<leader>tT` | Run all tests |
| `<leader>tr` | Run nearest test |
| `<leader>ts` | Toggle test summary |
| `<leader>tw` | Toggle watch mode |

#### Debugging (DAP)
| Key | Action |
|-----|---------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dc` | Continue |
| `<leader>di` | Step into |
| `<leader>do` | Step out |
| `<leader>dO` | Step over |
| `<leader>dr` | Toggle REPL |

#### Package Management
| Key | Action |
|-----|---------|
| `<leader>ns` | Show package versions |
| `<leader>nu` | Update package |
| `<leader>ni` | Install package |
| `<leader>nf` | Find new package |
| `<leader>nc` | Check outdated |

#### Git
| Key | Action |
|-----|---------|
| `<leader>gg` | LazyGit |
| `<leader>gs` | Git status |
| `<leader>gc` | Git commits |
| `<leader>ghs` | Stage hunk |
| `<leader>ghr` | Reset hunk |

#### Search
| Key | Action |
|-----|---------|
| `<leader>sg` | Live grep |
| `<leader>sw` | Search word |
| `<leader>sb` | Search buffers |
| `<leader>sh` | Search help |

## 📦 Plugin List

### Core & Performance
- **lazy.nvim** - Modern plugin manager
- **plenary.nvim** - Lua utility library

### LSP & Completion
- **nvim-lspconfig** - LSP configurations
- **mason.nvim** - LSP/tool installer
- **mason-lspconfig.nvim** - Mason-LSP bridge
- **blink.cmp** - Modern completion engine
- **friendly-snippets** - Snippet collection

### Code Quality
- **conform.nvim** - Code formatting (Prettier, Biome)
- **nvim-lint** - Linting integration
- **nvim-treesitter** - Syntax highlighting
- **nvim-ts-autotag** - Auto close HTML/JSX tags
- **ts-comments.nvim** - Smart commenting

### File Management & Navigation
- **neo-tree.nvim** - File explorer
- **telescope.nvim** - Fuzzy finder
- **nvim-window-picker** - Window selection
- **nvim-material-icon** - File type icons

### Git Integration
- **gitsigns.nvim** - Git signs and hunks
- **lazygit.nvim** - LazyGit integration
- **diffview.nvim** - Git diff viewer

### Testing & Debugging
- **neotest** - Testing framework
- **neotest-jest** - Jest adapter
- **neotest-vitest** - Vitest adapter
- **nvim-dap** - Debug Adapter Protocol
- **nvim-dap-ui** - Debug UI
- **nvim-dap-virtual-text** - Debug virtual text
- **mason-nvim-dap** - DAP tool manager

### Development Tools
- **package-info.nvim** - Package version info
- **bruno.nvim** - API testing
- **checkmate.nvim** - Todo management
- **toggleterm.nvim** - Terminal integration

### UI & Experience
- **which-key.nvim** - Keymap helper
- **lualine.nvim** - Status line
- **noice.nvim** - Enhanced UI messages
- **nvim-colorizer.lua** - Color highlighting
- **smear-cursor.nvim** - Cursor animation
- **indent-blankline.nvim** - Indent guides

### Colorschemes
- **aura-theme** - Modern colorscheme
- Multiple colorscheme support

## ⚙️ Configuration

### LSP Servers (Auto-installed)
- **TypeScript** - typescript-language-server
- **ESLint** - eslint-lsp
- **TailwindCSS** - tailwindcss-language-server
- **Lua** - lua_ls

### Formatters (Auto-installed)
- **JavaScript/TypeScript** - Prettier, Biome
- **Lua** - stylua
- **Shell** - shfmt
- **Python** - black, isort

### Debug Adapters (Auto-installed)
- **Node.js** - node-debug2-adapter
- **Chrome** - chrome-debug-adapter

## 🚀 Usage Examples

### Testing Workflow
```bash
# Open a test file
nvim src/components/__tests__/Button.test.tsx

# Run specific test
<leader>tr

# Watch mode for continuous testing
<leader>tw

# View test summary
<leader>ts
```

### Debugging React Application
```bash
# Set breakpoints with <leader>db
# Start your React app: npm start
# Attach debugger with <leader>dc
# Use Chrome debug configuration for frontend debugging
```

### Package Management
```bash
# Open package.json
nvim package.json

# View package versions (auto-shown)
<leader>ns

# Update outdated package
<leader>nu

# Check all outdated packages
<leader>nc
```

## 🎨 Customization

### Adding New Plugins
Create a new file in `lua/plugins/category/plugin-name.lua`:

```lua
return {
  "author/plugin-name",
  event = "VeryLazy",
  opts = {
    -- plugin configuration
  },
}
```

### Custom Keymaps
Add to `lua/core/keymaps.lua`:

```lua
vim.keymap.set("n", "<leader>custom", function()
  -- your custom function
end, { desc = "Custom action" })
```

### LSP Configuration
Extend `lua/plugins/lsp/init.lua` servers table:

```lua
servers = {
  your_lsp = {
    settings = {
      -- LSP specific settings
    }
  }
}
```

## 🔧 Troubleshooting

### Plugin Issues
```bash
# Clear plugin cache
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim

# Reinstall plugins
nvim --headless -c 'autocmd User VeryLazy quitall' -c 'Lazy! sync'
```

### LSP Problems
```bash
# Check Mason installations
:Mason

# Restart LSP
:LspRestart

# Check LSP status
:LspInfo
```

### Performance Issues
```bash
# Profile startup time
nvim --startuptime startup.log

# Check plugin load times
:Lazy profile
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

MIT License - see LICENSE file for details

## 🙏 Acknowledgments

- Tim Pope for Neovim best practices inspiration
- LazyVim for configuration patterns
- The amazing Neovim community
- All plugin authors for their incredible work

---

**Happy coding! 🎉**

For questions or issues, please open an issue on GitHub.