-- BufWriteCmd	BufWritePre	BufWritePost	writing the whole buffer
-- 		FilterWritePre	FilterWritePost	writing to filter temp file
-- FileAppendCmd	FileAppendPre	FileAppendPost	appending to a file
-- FileWriteCmd	FileWritePre	FileWritePost	any other file write
-- local group = "CustomCmd"

local group = vim.api.nvim_create_augroup("CustomCmd", { clear = true })

vim.api.nvim_create_autocmd(
	"BufWritePre", {
		group = group,
		callback = function(event)
			vim.lsp.buf.format({ bufnr = event.buf })
		end
	}
)

vim.api.nvim_create_autocmd(
	"TextYankPost", {
		group = group,
		callback = function(event)
			vim.highlight.on_yank()
		end
	}
)
vim.api.nvim_create_autocmd(
	"User", {
		group = group,
		pattern = "ColorschemeChanged",
		callback = function()
			vim.api.nvim_exec_autocmds("User", { pattern = vim.g.colorscheme })
			vim.schedule(function() vim.cmd.colorscheme(vim.g.colorscheme) end)
		end
	}
)
