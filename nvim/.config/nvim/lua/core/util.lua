local M = {}

M.group = vim.api.nvim_create_augroup("lazy_load_on_event", { clear = true })

---@param name string
---@param config function|nil
M.load = function(name, config)
	vim.fn["plug#load"](name)
	if config ~= nil then
		config()
	end
end

--- @class LazyEventSpec
--- @field pattern string[]|string|nil
--- @field config function|nil

---@param name string
---@param event string[]|string
---@param opts LazyEventSpec|function|nil
function M:load_from_event(name, event, opts)
	vim.api.nvim_create_autocmd(event, {
		group = self.group,
		pattern = (type(opts) == "table" and opts.pattern) or nil,
		once = true,
		callback = function()
			local config = (type(opts) == "table" and opts.config) or opts

			--- @cast config function|nil
			self.load(name, config)
		end
	})
end

---@param name string
---@param cmd string[]|string
---@param config function|nil
function M:load_from_cmd(name, cmd, config)
	if type(cmd) == "table" then
		for _, c in ipairs(cmd) do
			self:load_from_cmd(name, c, config)
		end
	else
		vim.api.nvim_create_user_command(cmd, function(event)
				local command = {
					cmd = cmd,
					bang = event.bang or nil,
					mods = event.smods,
					args = event.fargs,
					count = event.count >= 0 and event.range == 0 and event.count or nil,
				}

				if event.range == 1 then
					command.range = { event.line1 }
				elseif event.range == 2 then
					command.range = { event.line1, event.line2 }
				end
				self.load(name, config)

				local info = vim.api.nvim_get_commands({})[cmd] or
				    vim.api.nvim_buf_get_commands(0, {})[cmd]
				if not info then
					vim.schedule(function()
						vim.notify("Command `" .. cmd .. "` not found", vim.log.levels.ERROR)
					end)
				end
				command.nargs = info.nargs
				if event.args and event.args ~= "" and info.nargs and info.nargs:find("[1?]") then
					command.args = { event.args }
				end
				vim.cmd(command)
			end,
			{
				bang = true,
				range = true,
				nargs = "*",
				complete = function(_, line)
					vim.api.nvim_del_user_command(cmd)
					return vim.fn.getcompletion(line, "cmdline")
				end
			}


		)
	end
end

return M
