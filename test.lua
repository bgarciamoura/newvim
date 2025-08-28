-- Test file for Lua LSP validation
local M = {}

function M.hello(name)
  return "Hello, " .. (name or "World") .. "!"
end

function M.add_numbers(a, b)
  if type(a) ~= "number" or type(b) ~= "number" then
    error("Both arguments must be numbers")
  end
  return a + b
end

return M