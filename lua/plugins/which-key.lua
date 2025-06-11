return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts or {})

        local specs = require("core.keymaps.engine").get_specs()
        for _, spec in ipairs(specs) do
            if spec.group_name and spec.group_prefix then
                wk.register({ [spec.group_prefix] = { name = spec.group_name } })
            end
        end
    end,
}
