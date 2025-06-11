return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts or {})

        -- Register keymap groups automatically from core specs
        local specs = require("core.keymaps.engine").get_specs()
        local registrations = {}
        for _, spec in ipairs(specs) do
            if spec.group_name and spec.group_prefix then
                table.insert(registrations, { spec.group_prefix, group = spec.group_name })
            end
        end

        -- Use the new which-key v2 format for groups
        wk.register(registrations, { mode = "n" })
    end,
}
