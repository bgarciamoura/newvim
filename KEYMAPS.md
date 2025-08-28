# Neovim Keymaps Reference

Este arquivo documenta todos os keymaps organizados e centralizados na configuração.

## Estrutura de Arquivos

- `lua/core/keymaps.lua` - Keymaps básicos e fundamentais
- `lua/core/keymaps-central.lua` - Keymaps específicos de plugins (centralizados)
- `lua/core/lsp-keymaps.lua` - Keymaps LSP específicos
- `lua/plugins/ui/which-key.lua` - Documentação completa de todos os keymaps

## Conflitos Resolvidos

### ✅ `<leader>sw` - RESOLVIDO
- **Telescope**: `<leader>sw` → Word search (Root Dir) - MANTIDO
- **Spectre**: Mudou para `<leader>sW` → Search current word/selection

## Principais Grupos de Keymaps

### Leader Key: `<Space>`
- `<leader>b` - Bruno/Buffer operations
- `<leader>c` - Code/LSP operations  
- `<leader>d` - Debug operations
- `<leader>f` - File/Find operations
- `<leader>g` - Git operations
  - `<leader>gh` - Git hunks
- `<leader>m` - Markdown/Todos
- `<leader>n` - NPM/Packages
- `<leader>s` - Search operations
- `<leader>t` - Test/Terminal
- `<leader>u` - UI/Toggles
- `<leader>w` - Workspace/Windows
- `<leader>x` - Diagnostics/Quickfix

### Navigation
- `]`/`[` groups - Next/Previous operations
- `g` group - Goto operations
- `z` group - Fold operations

### Modes Específicos
- **Insert Mode**: Tab (Copilot), Ctrl+S (Save), Copilot shortcuts
- **Visual Mode**: Indenting, line movement, comment toggle
- **Terminal Mode**: Window navigation

## Status da Centralização

### ✅ Centralizados
- **Spectre**: Keymaps movidos para `keymaps-central.lua`
- **Copilot**: Keymaps movidos para `keymaps-central.lua`
- **Which-key**: Completamente documentado e atualizado

### ✅ Bem Organizados (mantidos nos plugins)
- **Bruno**: Buffer-specific keymaps via FileType autocmd
- **Telescope**: Keys table no plugin  
- **GitSigns**: on_attach keymaps no plugin
- **LSP**: on_attach keymaps em `lsp-keymaps.lua`

### 📍 Buffer/Context Specific
- **Bruno**: `<CR>`, `<leader><CR>` (apenas em arquivos .bru)
- **LSP**: Keymaps ativados apenas em buffers com LSP ativo
- **GitSigns**: Keymaps de hunks apenas em repos git

## Como Usar

1. **Ver todos os keymaps**: `<leader>?` (which-key buffer keymaps)
2. **Ver keymaps globais**: Which-key ativa automaticamente ao pressionar leader
3. **Buscar keymaps**: `:Telescope keymaps` ou `<leader>sk`
4. **Modo hydra windows**: `<C-w><space>` para navegação contínua

## Validação ✅ COMPLETA

Todos os keymaps foram verificados para:
- ✅ **Conflitos resolvidos** (`<leader>sw` Telescope vs `<leader>sW` Spectre)
- ✅ **100% documentados no which-key** (incluindo modo terminal, Copilot panel, `<leader>lg`)
- ✅ **Organização centralizada** (`keymaps-central.lua` criado)
- ✅ **Preservação de funcionalidade** (nenhum keymap removido)
- ✅ **Testes passaram** (sintaxe e carregamento validados)

### Keymaps Finalizados
- **277 keymaps** documentados no which-key
- **Todos os modos** cobertos: normal, visual, insert, terminal
- **Todos os grupos** organizados com ícones e descrições
- **Buffer-specific** keymaps mantidos apropriadamente