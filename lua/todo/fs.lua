local Path = require("plenary.path")

local M = {}

function M.read_config(local_config)
   return vim.fn.json_decode(Path:new(local_config):read())
end

function M.write_config(path, config)
    -- @TODO: Refresh?
    Path:new(path):write(vim.fn.json_encode(config), "w")
end

return M
