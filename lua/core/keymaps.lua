local vim = vim

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Basic keymaps
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
vim.keymap.set("n", "<leader>X", "<cmd>x<cr>", { desc = "Save and quit" })
vim.keymap.set("n", "<C-s>", "<Esc>:w!<cr>", { desc = "Save file", silent = true })
vim.keymap.set("i", "<C-s>", "<Esc>:w!<cr>", { desc = "Save file", silent = true })
vim.keymap.set("n", "<C-z>", "<Esc>:undo<cr>", { desc = "Undo", silent = true })
vim.keymap.set("i", "<C-z>", "<Esc>:undo<cr>", { desc = "Undo", silent = true })
vim.keymap.set("v", "<leader>c", '"+y', { desc = "Copy selection", silent = true, nowait = true })
vim.keymap.set("n", "<C-a>", "<Cmd>keepjumps normal! ggVG<CR>", { desc = "Select the entire text", silent = true })

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Buffer navigation
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- Clear search highlighting
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlighting" })

-- Better indenting
vim.keymap.set("v", "<", "<gv", { desc = "Indent left" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right" })

-- Move lines
vim.keymap.set("n", "<A-j>", ":m .+1<cr>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<cr>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Windows/terminal fallback: some terminals don't send <A-j>/<A-k>
vim.keymap.set("n", "<A-Down>", ":m .+1<cr>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-Up>", ":m .-2<cr>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-Down>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-Up>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Terminal mode navigation
vim.keymap.set("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
vim.keymap.set("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
vim.keymap.set("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
vim.keymap.set("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })

-- React/JSX specific keymaps (work with Comment.nvim)
-- Note: gcc, gc, gbc, gb are automatically provided by Comment.nvim
-- Additional useful keymaps for React development
vim.keymap.set("n", "<leader>/", "gcc", { desc = "Toggle comment", remap = true })
vim.keymap.set("v", "<leader>/", "gc", { desc = "Toggle comment", remap = true })

-- Macro language syntax highlighting
vim.keymap.set("n", "<leader>sm", "<cmd>set filetype=macrolang<cr>", { desc = "Set macro syntax" })

-- OpenKore config syntax highlighting
vim.keymap.set("n", "<leader>sc", "<cmd>set filetype=okconfig<cr>", { desc = "Set config syntax" })

-- Fix line endings (convert CRLF to LF)
vim.keymap.set("n", "<leader>fx", "<cmd>FixLineEndings<cr>", { desc = "Fix line endings" })
