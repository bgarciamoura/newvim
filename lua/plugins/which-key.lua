return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts or {})

        local specs = require("core.keymaps.engine").get_specs()
        local groups = {}
        for _, spec in ipairs(specs) do
            if spec.group_name and spec.group_prefix then
                groups[spec.group_prefix] = groups[spec.group_prefix] or {}
                table.insert(groups[spec.group_prefix], spec.group_name)
            end
        end

        for prefix, names in pairs(groups) do
            wk.register({ [prefix] = { name = table.concat(names, ", ") } })
        end
    end,
}
