return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v4.x",
  config = function()
    git_status = {
      symbols = {
        conflict = "",
        unstaged = "✗",
        staged = "✓",
        unmerged = "",
        renamed = "➜",
        untracked = "★",
        deleted = "",
        ignored = "◌",
      },
    }
    vim.keymap.set("n", "<C-q>", ":Neotree focus<CR>", {})
    vim.keymap.set("n", "<C-tab>", ":Neotree toggle<CR>", {})
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
}
