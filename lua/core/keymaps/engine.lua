local vim = vim
local map = require("utils.functions").map
local api, fn = vim.api, vim.fn

local M = {}

-- Carrega todos os *_spec.lua da pasta
local specs = {}

for _, file in ipairs(fn.globpath(fn.stdpath("config") .. "/lua/core/keymaps", "*_spec.lua", false, true)) do
	local chunk, err = loadfile(file)
	if not chunk then
		vim.notify("Erro ao carregar o arquivo (loadfile): " .. file .. "\n" .. err, vim.log.levels.ERROR)
	else
		setfenv(chunk, _G)
		local ok, mod = pcall(chunk)
		if not ok then
			vim.notify("Erro ao executar o arquivo: " .. file .. "\n" .. mod, vim.log.levels.ERROR)
		elseif type(mod) ~= "table" then
			vim.notify("Arquivo não retornou uma tabela válida: " .. file, vim.log.levels.WARN)
		else
			table.insert(specs, mod)
			-- vim.notify("Arquivo sem erro" .. file, vim.log.levels.INFO)
		end
	end
end

-- Aplica maps (global ou buffer-local)
local function apply(spec, bufnr)
	for _, m in ipairs(spec.mappings) do
		local mode, lhs, rhs, desc, opts = unpack(m)
		opts = vim.tbl_extend("force", opts or {}, {
			desc = "⟪KM⟫ " .. desc,
			buffer = spec.buffer_local and bufnr or nil,
		})
		map(mode, lhs, rhs, opts)
	end
end

local function normalize(ev)
	if ev == "VeryLazy" then
		return { event = "User", pattern = "VeryLazy" }
	end
	return { event = ev }
end

function M.setup()
	for _, spec in ipairs(specs) do
		if spec.event then
			local cfg = normalize(spec.event)
			api.nvim_create_autocmd(cfg.event, { -- <── era spec.event
				pattern = cfg.pattern,
				group = api.nvim_create_augroup("CoreKeymaps_" .. cfg.event, {}),
				callback = function(args)
					apply(spec, args.buf)
				end,
			})
		else
			apply(spec)
		end
	end
end

return M
