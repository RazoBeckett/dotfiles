return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  -- event = { "BufReadPre", "BufNewFile" },
  config = function()
    local config = require("nvim-treesitter.configs")
    config.setup({
      ensure_installed = { "dockerfile", "python", "javascript", "yaml" },
      auto_install = true,
      autotag = { enable = true },
      rainbow = { enable = true },
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}
