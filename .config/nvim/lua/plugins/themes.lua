return {
	lazy = false,
	priority = 1000,
	terminal_colors = true,
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	{
		"baliestri/aura-theme",
		config = function(plugin)
			vim.opt.rtp:append(plugin.dir .. "/packages/neovim")
--      vim.cmd([[colorscheme aura-dark]])
		end,
	},
	{
		"Mofiqul/dracula.nvim",
		name = "dracula",
		config = function()
--      vim.cmd.colorscheme("dracula")
		end,
	},
	{
		"ellisonleao/gruvbox.nvim",
		config = function()
			vim.o.background = "dark"
			vim.cmd([[colorscheme gruvbox]])
		end,
	},
}
