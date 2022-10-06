local todo = require("todo")

local M = {}

function M.add_todo(todoStr)
  todo.get_todos_config().todos = table.insert(todo.get_todos_config().todos, 1, todoStr)
end

return M 

