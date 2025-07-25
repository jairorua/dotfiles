-- Leader key
vim.g.mapleader = " "

-- Define local variable for conciseness
local keymap = vim.keymap

keymap.set("i", "jk", "<Esc>", {desc = "Exit insert mode with jk"})

keymap.set("n", "<leader>nh", ":nohl<CR>", {desc = "Clear search highlights"})

-- Window management
keymap.set("n", "<leader>sv", "<C-w>v", {desc = "Split window vertically"})
keymap.set("n", "<leader>sh", "<C-w>s", {desc = "Split window horizontally"})
keymap.set("n", "<leader>se", "<C-w>=", {desc = "Make splits equal size"})
keymap.set("n", "<leader>sx", "<cmd>close<CR>", {desc = "Close current split"})

-- Tab management
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", {desc = "Open new tab"})
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", {desc = "Close new tab"})
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", {desc = "Go to next tab"})
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", {desc = "Go to previous tab"})
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", {desc = "Open current buffer in new tab"})

-- Move lines together in visual mode
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Half page jumping centering the cursor
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")

-- Keep search terms in the middle
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")

