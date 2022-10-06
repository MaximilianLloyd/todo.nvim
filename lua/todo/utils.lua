local M = {}

function M.project_key()
  return vim.loop.cwd()
end

function M.getCenterLine(height)
	return math.floor(((vim.o.lines - height) / 2) - 1)
end

function M.getCenterCol(width)
	return math.floor((vim.o.columns - width) / 2)
end

function M.set_buf_and_win_options(Harpoon_win_id, bufnr)
    vim.api.nvim_win_set_option(Harpoon_win_id, "number", true)
    vim.api.nvim_buf_set_name(bufnr, "todo-menu")
    vim.api.nvim_buf_set_option(bufnr, "filetype", "todo")
    vim.api.nvim_buf_set_option(bufnr, "buftype", "acwrite")
    vim.api.nvim_buf_set_option(bufnr, "bufhidden", "delete")
end

function M.set_buf_content(bufnr, contents)
    vim.api.nvim_buf_set_lines(bufnr, 0, #contents, false, contents)
end

local function merge_table_impl(t1, t2)
    for k, v in pairs(t2) do
        if type(v) == "table" then
            if type(t1[k]) == "table" then
                merge_table_impl(t1[k], v)
            else
                t1[k] = v
            end
        else
            t1[k] = v
        end
    end
end

function M.merge_tables(...)
    local out = {}
    for i = 1, select("#", ...) do
        merge_table_impl(out, select(i, ...))
    end
    return out
end

return M
