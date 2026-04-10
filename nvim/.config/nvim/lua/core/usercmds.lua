vim.api.nvim_create_user_command("LspInfo", "checkhealth vim.lsp", {})

vim.api.nvim_create_user_command("Color", function(cmd)
	local arg = string.match(cmd.args, "^(%S+)")
	if arg == "list" then
		for i, name in ipairs(vim.g.colorschemes) do
			vim.notify(("%d: %s"):format(i, name))
		end

		local ok, selected = pcall(
			function()
				return vim.g.colorschemes[tonumber(vim.fn.input("Enter colorscheme index: "))]
			end
		)

		if not ok then
			vim.notify("Invalid index number. No colorscheme selected", vim.log.levels.ERROR)
		else
			local file = io.open(vim.g.color_file, "w")
			if file then file:write(selected) end
			vim.g.colorscheme = selected
			vim.api.nvim_exec_autocmds("User", { pattern = "ColorschemeChanged" })
		end
	else
		vim.g.colorscheme = vim.fn.input("Colorscheme: ") or "default"
		vim.api.nvim_exec_autocmds("User", { pattern = "ColorschemeChanged" })
	end
end, {
	nargs = 1
})

-- Restart lsp
vim.api.nvim_create_user_command("RestartLsp", function()
	for _, c in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
		vim.lsp.enable(c.name, false)
		vim.lsp.enable(c.name, true)
		vim.notify(("Restarted %s"):format(c.name))
	end
end, {
	nargs = 0
})
