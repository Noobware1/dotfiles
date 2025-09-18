-- Config
require("config.globals")
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.user_cmds")

-- Core
require("core.util")
require("core.plug")

-- Plugin
require("plugin.colorscheme")
require("plugin.comments")
require("plugin.treesitter")
require("plugin.mason")
require("plugin.telescope")

-- Lsp
require("lsp.config")
require("lsp.lua_ls")
require("lsp.dart_ls")
require("lsp.rust_analyzer")
