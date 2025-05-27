local function remove_all_comments()
	local bufnr = 0 -- buffer atual
	-- pega o parser para o buffer (usa o filetype atual)
	local parser = vim.treesitter.get_parser(bufnr)
	if not parser then
		vim.notify("Tree-sitter parser não disponível para este buffer", vim.log.levels.ERROR)
		return
	end

	-- obtém a árvore sintática e o nó raiz
	local tree = parser:parse()[1]
	local root = tree:root()

	-- importa a API de queries e define uma query genérica
	local ts_query = require("vim.treesitter.query")
	local lang = vim.bo.filetype
	local ok, query = pcall(
		ts_query.parse,
		lang,
		[[
    (comment) @comment
  ]]
	)
	if not ok then
		vim.notify("Falha ao compilar Tree-sitter query para " .. lang, vim.log.levels.ERROR)
		return
	end

	-- coleta todos os nós de comentário
	local comments = {}
	for id, node in query:iter_captures(root, bufnr, 0, -1) do
		if query.captures[id] == "comment" then
			table.insert(comments, node)
		end
	end

	-- ordena de trás pra frente (para não invalidar ranges anteriores)
	table.sort(comments, function(a, b)
		local ar, ac = a:start()
		local br, bc = b:start()
		if ar == br then
			return ac > bc
		else
			return ar > br
		end
	end)

	-- remove cada nó de comentário
	for _, node in ipairs(comments) do
		local sr, sc, er, ec = node:range()
		vim.api.nvim_buf_set_text(bufnr, sr, sc, er, ec, { "" })
	end

	vim.notify("Removidos " .. #comments .. " comentários", vim.log.levels.INFO)
end

-- cria o comando :RemoveAllComments
vim.api.nvim_create_user_command(
	"RemoveAllComments",
	remove_all_comments,
	{ desc = "Remove todos os comentários do buffer usando Tree-sitter" }
)
