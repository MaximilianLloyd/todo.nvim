local popup = require("plenary.popup")
local utils = require("todo.utils")

local M = {}

Todo_win_id = nil
Todo_bufh = nil

local config = {
	borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
	width = 60,
	height = 10,
}

local function close_menu()
	vim.api.nvim_win_close(Todo_win_id, true)

	Harpoon_win_id = nil
	Harpoon_bufh = nil
end

function M.create_window()
	local buf = vim.api.nvim_create_buf(false, false)

	local Todo_win_id, win = popup.create(buf, {
		title = "Todo",
		highlight = "TodoWindow",
		line = utils.getCenterLine(config.height),
		col = utils.getCenterCol(config.width),
		minwidth = config.width,
		minheight = config.height,
		borderchars = config.borderchars,
	})

	vim.api.nvim_win_set_option(win.border.win_id, "winhl", "Normal:TodoBorder")

	return {
		bufnr = buf,
		win_id = Todo_win_id,
	}
end

function M.toggle_quick_menu()
	if Todo_win_id ~= nil and vim.api.nvim_win_is_valid(Todo_win_id) then
		close_menu()
		return
	end


	local win_info = M.create_window()
	-- Set global variables
	Todo_win_id = win_info.win_id
	Todo_bufh = win_info.bufnr

	local contents = {  "First Todo", "Second Todo", "Thid Todo", }

	utils.set_buf_and_win_options(Todo_win_id, Todo_bufh)
	utils.set_buf_content(Todo_bufh, contents)
	-- local global_nfig = harpoon.get_global_settings()
end

vim.keymap.set("n", "<leader>td", M.toggle_quick_menu, { noremap = true, silent = true })

return M
