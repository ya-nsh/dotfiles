-- VSCode/Cursor-style keymaps on top of LazyVim defaults
local map = vim.keymap.set

-- Save
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Undo / Redo
map({ "n", "i" }, "<C-z>", "<cmd>undo<cr>", { desc = "Undo" })
map({ "n", "i" }, "<C-S-z>", "<cmd>redo<cr>", { desc = "Redo" })
map("n", "<C-y>", "<cmd>redo<cr>", { desc = "Redo" })

-- Cut / Copy / Paste (system clipboard)
map({ "n", "v" }, "<C-c>", '"+y', { desc = "Copy to clipboard" })
map({ "n", "v" }, "<C-x>", '"+d', { desc = "Cut to clipboard" })
map({ "n", "i", "v" }, "<C-v>", '<cmd>set paste<cr>"+p<cmd>set nopaste<cr>', { desc = "Paste from clipboard" })

-- Select all
map({ "n", "i" }, "<C-a>", "<esc>ggVG", { desc = "Select all" })

-- Find in file
map("n", "<C-f>", "/", { desc = "Find in file" })

-- Find & replace
map("n", "<C-h>", ":%s/", { desc = "Find and replace" })

-- Comment toggle (VSCode Ctrl+/)
map({ "n", "v" }, "<C-/>", "gcc", { remap = true, desc = "Toggle comment" })
map("i", "<C-/>", "<esc>gcca", { remap = true, desc = "Toggle comment" })

-- Duplicate line (Alt+Shift+Down like Cursor)
map("n", "<A-S-Down>", "<cmd>t.<cr>", { desc = "Duplicate line down" })
map("i", "<A-S-Down>", "<esc><cmd>t.<cr>gi", { desc = "Duplicate line down" })

-- Move lines up/down (Alt+Up/Down like VSCode)
map("n", "<A-Down>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-Up>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("i", "<A-Down>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
map("i", "<A-Up>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
map("v", "<A-Down>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "<A-Up>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Go to definition (F12 like VSCode)
map("n", "<F12>", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "Go to definition" })

-- Peek definition (Alt+F12)
map("n", "<A-F12>", "<cmd>lua vim.lsp.buf.hover()<cr>", { desc = "Hover / peek" })

-- Rename symbol (F2)
map("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "Rename symbol" })

-- Quick fix / code actions (Ctrl+.)
map({ "n", "v" }, "<C-;>", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "Code action" })

-- Close tab/buffer (Ctrl+W like VSCode)
map("n", "<C-w>", "<cmd>bd<cr>", { desc = "Close buffer" })

-- New file (Ctrl+N)
map("n", "<C-n>", "<cmd>enew<cr>", { desc = "New file" })

-- Split editor right (Ctrl+\)
map("n", "<C-\\>", "<cmd>vsplit<cr>", { desc = "Split right" })

-- Terminal toggle (Ctrl+`)
map({ "n", "t" }, "<C-`>", "<cmd>terminal<cr>", { desc = "Open terminal" })

-- Multi-cursor next match (Ctrl+D like VSCode) — via vim-visual-multi if installed
map("n", "<C-d>", "*``", { desc = "Highlight word" })
