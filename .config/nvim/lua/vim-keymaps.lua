vim.g.mapleader = " "

-- default vim
vim.keymap.set("i", "?", "\\")
vim.keymap.set("i", "\\", "?")

-- Neotree keymap
vim.keymap.set("n", "<C-q>", ":Neotree filesystem reveal left<CR>", {})

-- lsp keymap
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
