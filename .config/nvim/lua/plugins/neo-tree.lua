return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  config = function()
    vim.keymap.set("n", "<C-q>", ":Neotree filesystem reveal left<CR>", {})
  end;
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
}
