vim.lsp.config["javalsp"] = {
  filetypes = { 'java' },
  root_markers = { 'build.gradle', 'build.gradle.kts', 'pom.xml', '.git' },
}

vim.lsp.enable("javalsp")
