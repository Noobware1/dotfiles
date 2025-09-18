local keymap = vim.keymap

keymap.set({ "n", "i", "s" }, "<C-h>", "<cmd>noh<cr>", { desc = "Close hlsearch" })

keymap.set("n", "<leader>e", "<cmd>Ex<cr>", { desc = "Open explorer" })

keymap.set({ "n", "v" }, "<C-s>", "<cmd>w<cr>", { desc = "Write to buffer" })

keymap.set("n", "<leader>r", "<cmd>restart<cr>", { desc = "Restart neovim" })

-- Move line down
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down", silent = true })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down", silent = true })

-- Move line up
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up", silent = true })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up", silent = true })

keymap.set("n", "<C-k>", "<C-W>k", { desc = "Move cursor to Nth window above current one" })
keymap.set("n", "<C-j>", "<C-W>j", { desc = "Move cursor to Nth window below current one" })
keymap.set("n", "<C-l>", "<C-W>l", { desc = "Move cursor to Nth window left current one" })
keymap.set("n", "<C-h>", "<C-W>h", { desc = "Move cursor to Nth window right current one" })

keymap.set({ "n", "v" }, "<C-q>", "<cmd>close<cr>", { desc = "Close current window" })

local comment_text = function()
	if vim.api.nvim_get_mode() == "v" and vim.api.nvim_get_line("'>") > vim.api.nvim_get_line("'<") then
		vim.cmd("normal gc")
	else
		vim.cmd("normal gcc")
	end
end

keymap.set({ "n", "v" }, "<C-_>", comment_text, { desc = "Comment line" })
keymap.set({ "n", "v" }, "<C-/>", comment_text, { desc = "Comment line" })


keymap.set("n", "<leader>s", "<cmd>update | source<cr>", { desc = "Source current buffer" })
