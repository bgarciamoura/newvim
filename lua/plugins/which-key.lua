return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts or {})

        local specs = require("core.keymaps.engine").get_specs()
        local registrations = {}
        for _, spec in ipairs(specs) do
            if spec.group_name and spec.group_prefix then
                table.insert(registrations, { spec.group_prefix, group = spec.group_name })
            end
        end

        wk.register(registrations)
    end,
}
