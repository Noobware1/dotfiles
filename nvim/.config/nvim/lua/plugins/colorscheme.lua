return {
	{
		"ellisonleao/gruvbox.nvim",
		name = "gruvbox",
		opts = {},
		config = function(_,otps) 
			require("gruvbox").setup(otps)
			-- vim.cmd("colorscheme gruvbox")
		end
	},
	{
		"rose-pine/neovim",
		name = 	"rose-pine",
		opts = {
			variant = "main",
			dark_variant = "main",

		}

	},
	{
		"rebelot/kanagawa.nvim",
		name = "kanagawa",
		opts = {
			variant = "main",
			dark_variant = "main",

		},
		config = function(_,opts) 
			require("kanagawa").setup(opts)
			vim.cmd("colorscheme kanagawa")
		end
	},

}
