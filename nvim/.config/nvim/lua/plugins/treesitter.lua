return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	lazy = false,
	init = function()
		vim.api.nvim_create_autocmd('FileType', {
			callback = function()
				-- Enable treesitter highlighting and disable regex syntax
				pcall(vim.treesitter.start)
				-- Enable treesitter-based indentation
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})

		local ensureInstalled = {
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

		local alreadyInstalled = require('nvim-treesitter').get_installed()
		local parsersToInstall = vim.iter(ensureInstalled)
		    :filter(function(parser)
			    return not vim.tbl_contains(alreadyInstalled, parser)
		    end)
		    :totable()

		if not vim.tbl_isempty(parsersToInstall) then
			require('nvim-treesitter').install(parsersToInstall)
		end
	end,


}
