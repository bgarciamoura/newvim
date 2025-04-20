vim.lsp.config['tailwindcss'] = {
  cmd = { 'tailwindcss-language-server', '--stdio' },
  filetypes = {
    'html', 'css', 'scss', 'javascript', 'javascriptreact',
    'typescript', 'typescriptreact', 'vue', 'svelte', 'astro',
    'php', 'blade', 'heex', 'elixir', 'eelixir'
  },
  root_markers = {
    'tailwind.config.js', 'tailwind.config.cjs', 'tailwind.config.ts',
    'postcss.config.js', 'postcss.config.cjs', 'postcss.config.ts',
    'package.json', '.git'
  },
  settings = {
    tailwindCSS = {
      includeLanguages = {
        heex = 'html',
        eelixir = 'html',
        elixir = 'html',
        php = 'html',
        blade = 'html',
      },
      experimental = {
        classRegex = {
          { 'class[:]\\s*"([^"]*)"',     1 },
          { 'className[:]\\s*"([^"]*)"', 1 },
          { 'class=\\s*"([^"]*)"',       1 },
          { 'class=\\s*\'([^\']*)\'',    1 },
          { 'class:\\s*"([^"]*)"',       1 },
          { 'class:\\s*\'([^\']*)\'',    1 },
          { 'tw\\(([^)]*)\\)',           1 },
        },
      },
    },
  },
}

vim.lsp.enable('tailwindcss')
