local util = require("core.util")

function setup()
	require("nvim-treesitter.configs").setup({
		highlight        = { enable = true },
		indent           = { enable = true },
		ensure_installed = {
			"c",
			"cpp",
			"diff",
			"html",
			"javascript",
			"jsdoc",
			"json",
			"jsonc",
			"lua",
			"luadoc",
			"luap",
			"markdown",
			"markdown_inline",
			"printf",
			"python",
			"query",
			"regex",
			"toml",
			"tsx",
			"typescript",
			"vim",
			"vimdoc",
			"xml",
			"yaml",
			"rust",
			"dart",
			"qmljs",
		}
	})
end

util:load_from_event(
	"nvim-treesitter",
	{ "BufReadPre", "BufNewFile" },
	setup
)
util:load_from_cmd(
	"nvim-treesitter",
	{ "TSUpdate", "TSUpdateSync", "TSInstall" },
	setup
)
