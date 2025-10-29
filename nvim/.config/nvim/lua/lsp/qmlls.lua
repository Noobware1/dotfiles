vim.lsp.config("qmlls", {
	cmd = { 'qmlls6', '-E' },
	filetypes = { 'qml', 'qmljs' },
	root_markers = { '.git' },
})

vim.lsp.enable("qmlls")
