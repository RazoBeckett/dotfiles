return {
  "MarcHamamji/runner.nvim",
  config = function()
    require("runner").setup({
      position = 'right',
      width = 75,
      height = 10,
    })
    vim.keymap.set('n', '<F5>', require('runner').run)
  end,
}
