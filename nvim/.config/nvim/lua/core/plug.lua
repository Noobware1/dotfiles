local data_dir = vim.fn.stdpath('data') .. "/site"
if vim.fn.empty(vim.fn.glob(data_dir .. '/autoload/plug.vim')) == 1 then
	vim.cmd("silent !curl -fLo " ..
		data_dir ..
		"/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim")
	vim.o.runtimepath = vim.o.runtimepath
	vim.cmd("autocmd VimEnter * PlugInstall --sync | source $MYVIMRC")
end


local Plug = vim.fn["plug#"]

function LazyPlug(src, opts)
	Plug(src, vim.tbl_extend("keep", {
		["on"] = {},
		["for"] = {},
	}, opts or {}))
end

vim.call("plug#begin")

-- ColorSchemes
LazyPlug("rose-pine/neovim", { ["as"] = "rose-pine" })
LazyPlug("rebelot/kanagawa.nvim", { ["as"] = "kanagawa" })
LazyPlug("ellisonleao/gruvbox.nvim", { ["as"] = "gruvbox" })

-- Comments
LazyPlug("folke/ts-comments.nvim")

-- TreeSitter
LazyPlug("nvim-treesitter/nvim-treesitter", {
	["do"] = ":TSUpdate"
})

-- Telescope
LazyPlug("nvim-lua/plenary.nvim")
LazyPlug("nvim-telescope/telescope.nvim")

-- LSP
LazyPlug("mason-org/mason.nvim", {
	["do"] = ":MasonUpdate"
})

-- Undotree
Plug("mbbill/undotree")

-- Oil nvim
Plug("stevearc/oil.nvim")

vim.call("plug#end")
