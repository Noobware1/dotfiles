return {
	cmd = { 'qmlls6', '-E' },
	filetypes = { 'qml', 'qmljs' },
	root_markers = { '.qmlls.ini', '.git' },
	on_attach = function(client)
		client.server_capabilities.semanticTokensProvider = nil
	end
}
