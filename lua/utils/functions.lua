local M = {}

M.map = function(mode, lhs, rhs, opts)
	local default_options = {
		noremap = true,
		silent = true,
		buffer = false,
		-- Outras opções como nowait, script, unique etc., podem ser definidas aqui se necessário
	}

	local final_options = default_options

	if opts then
		final_options = vim.tbl_extend("force", final_options, opts)

		if final_options.desc then
			final_options.desc = "keymaps.lua: " .. final_options.desc
		end
	end

	vim.keymap.set(mode, lhs, rhs, final_options)
end

return M
