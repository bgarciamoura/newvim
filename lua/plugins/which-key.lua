return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts or {})

        local specs = require("core.keymaps.engine").get_specs()
        local groups = {}

        -- collect group names by their prefixes
        for _, spec in ipairs(specs) do
            if spec.group_name and spec.group_prefix then
                groups[spec.group_prefix] = groups[spec.group_prefix] or {}
                table.insert(groups[spec.group_prefix], spec.group_name)
            end
        end

        -- register the groups using the new which-key spec
        local registrations = {}
        for prefix, names in pairs(groups) do
            table.insert(registrations, {
                prefix,
                group = table.concat(names, ", "),
            })
        end

        -- `wk.add` is used for the new specification
        wk.add(registrations)
    end,
}
