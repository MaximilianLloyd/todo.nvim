local fs = require("todo.fs")
local Path = require("plenary.path")
local utils = require("todo.utils")

local config_path = vim.fn.stdpath("config")
local data_path = vim.fn.stdpath("data")

TodoConfig = {}
-- Not sure if it is nessecary to store config
-- local user_config = string.format("%s/todo.json", config_path)
local cache_config = string.format("%s/todo.json", data_path)

local M = {}

local function ensure_correct_config(config)
    local projects = config.projects
    local mark_key = utils.project_key()

    if projects[mark_key] == nil then
        projects[mark_key] = {
			todos = {}
        }
    end

    -- local proj = projects[mark_key]
    -- if proj.mark == nil then
    --     proj.mark = { marks = {} }
    -- end
    --
    -- local marks = proj.mark.marks
    --
    -- for idx, mark in pairs(marks) do
    --     if type(mark) == "string" then
    --         mark = { filename = mark }
    --         marks[idx] = mark
    --     end
    --
    --     marks[idx].filename = utils.normalize_path(mark.filename)
    -- end

    return config
end
function M.setup(config)
	if not config then
		config = {}
	end

	local ok, stored_data = pcall(fs.read_config, cache_config)

	if ok then
		print("Found config")
	end

	if not ok then
		print("No config present at " .. cache_config)
		stored_data = {}
	end

	-- Default settings
	local complete_config = utils.merge_tables({
		projects = {},
		global_setings = {
			["save_on_toggle"] = false,
		},
	}, stored_data)

	TodoConfig = ensure_correct_config(complete_config)
	-- fs.write_config(cache_config, TodoConfig)
end


function M.refresh_projects()
	local cwd = utils.project_key()
	local current_project_config = {
		projects = {
			[cwd] = TodoConfig.projects[cwd]
		}
	}

	TodoConfig.projects = nil

	local ok, c_config = pcall(fs.read_config, cache_config)

	if not ok then
		print("No config present at " .. cache_config)
		c_config = { projects = {} }
	end

  c_config = { projects = c_config.projects }
  c_config.projects[cwd] = nil

  local complete_config = utils.merge_tables(TodoConfig, c_config, current_project_config)
  TodoConfig = complete_config
end

function M.get_todos_config()
    return ensure_correct_config(TodoConfig).projects[utils.project_key()].todos
end

function M.save()
    -- first refresh from disk everything but our project
    M.refresh_projects()
	print("Saving config")

    Path:new(cache_config):write(vim.fn.json_encode(TodoConfig), "w")
end
-- Perhaps usefull later
-- local config_path = vim.fn.stdpath("config")
-- local data_path = vim.fn.stdpath("data")
-- local user_config = string.format("%s/harpoon.json", config_path)
-- local cache_config = string.format("%s/harpoon.json", data_path)

M.setup()

M.save()

return M
