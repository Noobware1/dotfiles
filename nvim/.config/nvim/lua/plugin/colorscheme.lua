local util = require("core.util")

vim.g.colorschemes = {
	"rose-pine",
	"kanagawa"
}

util:load_from_event(
	"kanagawa",
	"User",
	{
		pattern = "kanagawa",
		config = function()
			require("kanagawa").setup({
				variant = "main",
				dark_variant = "main",
			})
		end
	}
)



util:load_from_event(
	"rose-pine",
	"User",
	{
		pattern = "rose-pine",
		config = function()
			require("rose-pine").setup({
				variant = "main",
				dark_variant = "main",
			})
		end
	}
)

vim.schedule(function()
	local file = io.open(vim.g.color_file, "r")
	if file then
		vim.g.colorscheme = file:read("a")
		vim.api.nvim_exec_autocmds("User", { pattern = "ColorschemeChanged" })
	end
end)
