-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps
---------------------
-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>")

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>")

-- delete single character without copying into register
keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>") -- increment
keymap.set("n", "<leader>-", "<C-x>") -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v") -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s") -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=") -- make split windows equal width & height
keymap.set("n", "<leader>sx", ":close<CR>") -- close current split window

keymap.set("n", "<leader>to", ":tabnew<CR>") -- open new tab
keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close current tab
keymap.set("n", "<leader>tn", ":tabn<CR>") --  go to next tab
keymap.set("n", "<leader>tp", ":tabp<CR>") --  go to previous tab

----------------------
-- Plugin Keybinds
--------------------
-- vim-maximizer
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>")

-- nvim-tree
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

-- telescope
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>")
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>")
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")

-- telescope git commands
keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>")
keymap.set("n", "<leader>gfc", "<cmd>Telescope git_bcommits<cr>")
keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>")
keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>")

-- restart lsp server
keymap.set("n", "<leader>rs", ":LspRestart<CR>")

-- Aider keymaps
keymap.set('n', '<leader>aa', '<cmd>lua AiderOpen()<CR>', { noremap = true, silent = true, desc = "Open Aider" })
keymap.set('n', '<leader>ab', '<cmd>lua AiderBackground()<CR>', { noremap = true, silent = true, desc = "Aider Background" })
keymap.set('n', '<leader>a3', '<cmd>lua AiderOpen("-3")<CR>', { noremap = true, silent = true, desc = "Open Aider GPT-3.5" })

-- Toggle indent guides
keymap.set("n", "<leader>ti", ":IndentToggle<CR>", { noremap = true, silent = true, desc = "Toggle indent guides" })
