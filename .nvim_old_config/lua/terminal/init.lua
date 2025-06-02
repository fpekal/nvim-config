-- Terminal plugin
-- Opens a terminal window after running a command.
-- And then, after running the same command, previous buffer will be opened.


local function get_terminal_buffer()
	if vim.w.TERM_terminal_buffer ~= 0 then
		print(vim.w.TERM_terminal_buffer)
		return vim.w.TERM_terminal_buffer
	end

	vim.w.TERM_terminal_buffer = vim.api.nvim_create_buf(false, {})
	vim.api.nvim_set_current_buf(vim.w.TERM_terminal_buffer)
	vim.cmd.edit("term://bash")

		print(vim.w.TERM_terminal_buffer)
	return vim.w.TERM_terminal_buffer
end

local function toggle_terminal()
	if vim.w.TERM_terminal_buffer == nil then
		vim.w.TERM_terminal_buffer = 0
	end

	if vim.w.TERM_previous_buffer == nil then
		vim.w.TERM_previous_buffer = -1
	end

	if vim.w.TERM_previous_buffer == -1 then
		vim.w.TERM_previous_buffer = vim.api.nvim_get_current_buf()
		vim.api.nvim_set_current_buf(get_terminal_buffer())
	else
		vim.api.nvim_set_current_buf(vim.w.TERM_previous_buffer)
		vim.w.TERM_previous_buffer = -1
	end
end

vim.keymap.set('n', '<Plug>ToggleTerminal', toggle_terminal)
