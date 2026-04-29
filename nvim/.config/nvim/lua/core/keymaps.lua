local keymap = vim.keymap

keymap.set({ "n" }, "<leader>h", "<cmd>noh<cr>", { desc = "Close hlsearch" })

keymap.set("n", "<leader>e", "<cmd>Ex<cr>", { desc = "Open explorer" })

keymap.set({ "n", "v" }, "<C-s>", "<cmd>w<cr>", { desc = "Write to buffer" })

-- keymap.set("n", "<leader>r", "<cmd>restart<cr>", { desc = "Restart neovim" })

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

vim.keymap.set("t", "<C-q>", [[<C-\><C-n><cmd>close<cr>]], { desc = "Exit terminal & close window" })
vim.keymap.set({ "n", "v" }, "<C-q>", "<cmd>close<cr>", { desc = "Close current window" })

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

keymap.set("n", "<leader>rr", "<cmd>RestartLsp<cr>", { desc = "Restart all active LSP for current buffer" })

keymap.set({ "n", "i" }, "<C-w>g", function()
	-- Get the current file name in uppercase
	local name = string.upper(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':t'))
	name = name:gsub('%.H$', '_H') -- Replace .H at the end with _H

	-- Create the header guard content
	local guard = {
		string.format("#ifndef %s", name),
		string.format("#define %s", name),
		"",
		"#endif // " .. name
	}

	-- Insert the lines at the current cursor position
	vim.api.nvim_put(guard, 'l', true, true) -- 'l' = linewise
end, { desc = "Insert header guard" })

keymap.set("n", "<leader>xp", function()
	vim.cmd("belowright vsplit")
end, { desc = "split verticallly" })
keymap.set("n", "<leader>cp", function()
	vim.cmd("belowright split")
end, { desc = "split below" })

keymap.set("n", "<C-w>h", "<cmd>vertical resize +5<cr>", { desc = "increase window width by 5" })
keymap.set("n", "<C-w>l", "<cmd>vertical resize -5<cr>", { desc = "decrease window width by 5" })
keymap.set("n", "<C-w>k", "<cmd>resize +5<cr>", { desc = "increase window height by 5" })
keymap.set("n", "<C-w>j", "<cmd>resize -5<cr>", { desc = "decrease window height by 5" })

keymap.set("n", "<leader>tt", function()
	vim.cmd("belowright split")
	vim.cmd("terminal")
	vim.cmd("startinsert")
end, { desc = "open terminal below" })

keymap.set({ "n", "t" }, "<leader>to", function()
	vim.cmd("resize")
end, { desc = "expand termial" })

keymap.set("t", "<esc>", "<C-\\><C-n>", { desc = "exit terminal mode" })
