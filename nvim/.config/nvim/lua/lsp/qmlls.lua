vim.lsp.config("qmlls", {
	cmd = { 'qmlls', '-E' },
	filetypes = { 'qml', 'qmljs' },
	root_markers = { '.git' },
})

vim.lsp.enable("qmlls")
