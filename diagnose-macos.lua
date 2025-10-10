-- Diagnostic script for macOS vim.fs issues
-- Run this with: nvim --headless -c "luafile diagnose-macos.lua" -c "quit"

print("=== macOS Neovim Diagnostic ===\n")

-- 1. Check Neovim version
print("1. Neovim version:")
local version = vim.version()
print(string.format("   v%d.%d.%d%s", version.major, version.minor, version.patch, version.prerelease and "-dev" or ""))

-- 2. Check if fs-compat is loaded
print("\n2. Checking fs-compat patch:")
local fs_compat_loaded = package.loaded["core.fs-compat"] ~= nil
print("   core.fs-compat loaded:", fs_compat_loaded)

-- 3. Test vim.fs.root behavior
print("\n3. Testing vim.fs.root():")
local test_result = vim.fs.root(0, { ".git", "package.json" })
print("   Type:", type(test_result))
print("   Value:", vim.inspect(test_result))

-- 4. Test with explicit path
print("\n4. Testing vim.fs.root() with explicit path:")
local cwd = vim.loop.cwd()
print("   CWD:", cwd)
local test_result2 = vim.fs.root(cwd, { ".git" })
print("   Type:", type(test_result2))
print("   Value:", vim.inspect(test_result2))

-- 5. Check if original functions are accessible
print("\n5. Checking function overrides:")
print("   vim.fs._original_root exists:", vim.fs._original_root ~= nil)
print("   vim.fs._original_find exists:", vim.fs._original_find ~= nil)

-- 6. Test lspconfig util
print("\n6. Testing lspconfig.util:")
local ok, util = pcall(require, "lspconfig.util")
if ok then
	print("   lspconfig.util loaded: OK")
	local root_pattern = util.root_pattern("package.json", ".git")
	local test_root = root_pattern(cwd)
	print("   root_pattern result type:", type(test_root))
	print("   root_pattern result:", vim.inspect(test_root))
else
	print("   lspconfig.util ERROR:", util)
end

-- 7. Check vim.fs.find behavior
print("\n7. Testing vim.fs.find():")
local find_result = vim.fs.find(".git", { path = cwd, upward = true, type = "directory" })
print("   Type:", type(find_result))
print("   Result:", vim.inspect(find_result))

-- 8. Test internal vim.fs behavior with table path
print("\n8. Testing vim.fs internals:")
local status, err = pcall(function()
	-- This should NOT crash even if path is a table
	local fake_table = { cwd }
	local result = vim.fs.find(".git", { path = fake_table, upward = true })
	print("   Table path handling: OK")
	return result
end)
if not status then
	print("   Table path handling ERROR:", err)
end

print("\n=== Diagnostic Complete ===")
print("\nIf you see any ERRORs above, please share this output!")
