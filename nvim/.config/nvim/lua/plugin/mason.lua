local util = require("core.util")

function setup()
	require("mason").setup({})
end

util:load_from_cmd("mason.nvim", { "Mason", "MasonUpdate" }, setup)
util:load_from_event("mason.nvim", { "BufReadPre", "BufNewFile" }, setup)


vim.keymap.set("n", "<leader>cm", "<cmd>Mason<cr>", { desc = "Load Mason UI" })
