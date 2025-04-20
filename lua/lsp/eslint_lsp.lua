vim.lsp.config['eslint'] = {
  cmd = { 'vscode-eslint-language-server', '--stdio' },
  filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx', 'vue', 'svelte', 'astro' },
  root_markers = { '.eslintrc', '.eslintrc.js', '.eslintrc.json', '.eslintrc.cjs', '.eslintrc.yaml', '.eslintrc.yml', 'package.json', '.git' },
  settings = {
    validate = 'on',
    packageManager = 'npm',
    useESLintClass = false,
    codeActionOnSave = {
      enable = false,
      mode = 'all',
    },
    experimental = {
      useFlatConfig = false,
    },
    format = true,
    quiet = false,
    onIgnoredFiles = 'off',
    rulesCustomizations = {},
    run = 'onType',
    nodePath = '',
    workingDirectory = { mode = 'location' },
    codeAction = {
      disableRuleComment = {
        enable = true,
        location = 'separateLine',
      },
      showDocumentation = {
        enable = true,
      },
    },
  },
}

vim.lsp.enable('eslint')
