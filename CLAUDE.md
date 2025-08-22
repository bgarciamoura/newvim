# Claude Code Configuration Notes

## Workflow Instructions

### TPope Expert Agents Protocol
Quando o usuário solicitar modificações no projeto Neovim, sempre seguir este protocolo:

1. **Lançar 2 agentes** com conhecimento completo do TPope sobre:
   - Neovim internals
   - Plugin development  
   - Best practices
   - Troubleshooting

2. **Processo de análise:**
   - Analisar estrutura atual do projeto
   - Refletir sobre o pedido do usuário
   - Avaliar melhores alternativas de implementação
   - Identificar possíveis conflitos ou problemas
   - Propor a melhor solução

3. **Apresentação:**
   - Expor as opções consideradas
   - Explicar a solução recomendada
   - Aguardar validação do usuário antes de implementar

## Project Structure
```
├── lua/
│   ├── core/
│   │   ├── autocmds.lua
│   │   ├── keymaps.lua
│   │   ├── lazy.lua
│   │   ├── lsp-keymaps.lua
│   │   └── options.lua
│   └── plugins/
│       ├── colorschemes/
│       ├── completion/
│       ├── editor/
│       ├── lsp/
│       ├── tools/
│       └── ui/
└── init.lua
```

## Current Plugins
- **Completion**: blink.cmp
- **LSP**: nvim-lspconfig, mason.nvim
- **File Explorer**: neo-tree.nvim
- **Fuzzy Finder**: telescope.nvim
- **Git**: gitsigns.nvim, lazygit.nvim
- **UI**: lualine.nvim, noice.nvim, nvim-notify
- **Formatting**: conform.nvim, nvim-lint
- **Treesitter**: nvim-treesitter
- **Icons**: nvim-material-icon
- **Cursor**: smear-cursor.nvim

## Key Configurations
- Leader key: `<Space>`
- Auto-format on save enabled
- Material icons configured
- Deprecation warnings disabled
- Windows-optimized settings