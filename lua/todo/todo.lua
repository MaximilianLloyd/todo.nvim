local root = require("todo")
local utils = require("todo.utils")

local M = {}

function M.add_todo(todoStr)
  TodoConfig.projects[utils.project_key()].todos[todoStr] = {
		done = false,
		created = os.date("%c"),
		updated = os.date("%c"),
	}
  root.save()
end

return M

