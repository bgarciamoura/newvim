return {
    "saghen/blink.cmp",
    event = "InsertEnter",
    version = "1.*",
    dependencies = {
        { "disrupted/blink-cmp-conventional-commits" },
        { "rafamadriz/friendly-snippets" },
        { "Kaiser-Yang/blink-cmp-avante" },
        { "bydlw98/blink-cmp-env" },
        { "jdrupal-dev/css-vars.nvim" },
        { "MahanRahmati/blink-nerdfont.nvim" },
        { "L3MON4D3/LuaSnip", version = "v2.*" },
    },
    config = function()
        require("blink.cmp").setup({
            keymap = {
                preset = "enter",
                ["<C-space>"] = {
                    function(cmp)
                        cmp.show()
                    end,
                },
                ["<C-d>"] = {
                    function(cmp)
                        cmp.show_documentation()
                    end,
                },
                ["<C-n>"] = {
                    function(cmp)
                        cmp.snippet_forward()
                    end,
                },
                ["<C-p>"] = {
                    function(cmp)
                        cmp.snippet_backward()
                    end,
                },
                ["<C-e>"] = {
                    function(cmp)
                        cmp.hide()
                    end,
                },
                ["<C-u>"] = {
                    function(cmp)
                        cmp.scroll_docs(-4)
                    end,
                },
                ["<C-f>"] = {
                    function(cmp)
                        cmp.scroll_docs(4)
                    end,
                },
            },
            completion = {
                documentation = {
                    auto_show = true,
                },
                list = {
                    selection = {
                        preselect = true,
                        auto_insert = false,
                    },
                },
            },
            snippets = {
                preset = "luasnip",
            },
            sources = {
                default = { "lsp", "path", "luasnip", "buffer", "conventional_commits", "avante", "env", "nerdfont" },
                providers = {
                    lsp = {
                        name = "LSP",
                        module = "blink.cmp.sources.lsp",
                        fallbacks = { "buffer" },
                        opts = {},
                    },
                    conventional_commits = {
                        name = "Conventional Commits",
                        module = "blink-cmp-conventional-commits",
                        enabled = function()
                            return vim.bo.filetype == "gitcommit"
                        end,
                        opts = {},
                    },
                    avante = {
                        module = "blink-cmp-avante",
                        name = "Avante",
                        opts = {},
                    },
                    env = {
                        name = "Env",
                        module = "blink-cmp-env",
                        opts = {
                            show_braces = false,
                            show_documentation_window = true,
                        },
                    },
                    css_vars = {
                        name = "css-vars",
                        module = "css-vars.blink",
                        opts = {
                            search_extensions = { ".js", ".ts", ".jsx", ".tsx" },
                        },
                    },
                    nerdfont = {
                        module = "blink-nerdfont",
                        name = "Nerd Fonts",
                        score_offset = 15,
                        opts = { insert = true },
                    },
                    luasnip = {
                        name = "LuaSnip",
                        module = "blink.cmp.sources.luasnip",
                    },
                },
            },
            signature = {
                enabled = true,
                window = {
                    border = "rounded",
                },
            },
        })

        local luasnip_status, _ = pcall(require, "luasnip")
        if luasnip_status then
            require("luasnip.loaders.from_vscode").lazy_load()
            require("luasnip.loaders.from_vscode").lazy_load({
                paths = { vim.fn.stdpath("config") .. "/snippets" },
            })
        end
    end,
}
