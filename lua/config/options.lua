-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local function paste()
	return {
		vim.fn.split(vim.fn.getreg(""), "\n"),
		vim.fn.getregtype(""),
	}
end

if not vim.g.neovide then
	vim.g.clipboard = {
		name = "OSC 52",
		copy = {
			["+"] = require("vim.ui.clipboard.osc52").copy("+"),
			["*"] = require("vim.ui.clipboard.osc52").copy("*"),
		},
		paste = {
			["+"] = paste,
			["*"] = paste,
		},
	}
end

vim.opt.mouse = ""
vim.opt.spelllang = {}
vim.opt.wrap = true
vim.opt.expandtab = false
vim.opt.scrolloff = 7

vim.g.root_spec = { { ".git", "lua", ".jj", "pack.mcmeta" }, "cwd" }

vim.filetype.add({
	extension = {
		mcfunction = "mcfunction",
	},
})

if vim.g.neovide then
	vim.g.snacks_animate = false
else
	vim.g.snacks_animate = true
end

-- BC Sideline Calculator (minimal, per-buffer) -- wklej do init.lua

local bc_ns = vim.api.nvim_create_namespace("bc_sideline_ns")

local function sanitize(s)
	return s:gsub("^%s+", ""):gsub("%s+$", "")
end

local function eval_bc_multiline(lines)
	local input = table.concat(lines, "\n")
	local cmd = 'echo "' .. input:gsub('"', '\\"') .. '" | bc -l 2>&1'
	local out = vim.fn.systemlist(cmd)
	if vim.v.shell_error ~= 0 then
		return nil, table.concat(out, "\n")
	end
	return out, nil
end

local function clear(bufnr)
	vim.api.nvim_buf_clear_namespace(bufnr, bc_ns, 0, -1)
end

local function virt(bufnr, row, text)
	vim.api.nvim_buf_set_extmark(
		bufnr,
		bc_ns,
		row,
		-1,
		{ virt_text = { { text, "Comment" } }, virt_text_pos = "eol", hl_mode = "combine" }
	)
end

local function get_line_under_cursor()
	local bufnr = vim.api.nvim_get_current_buf()
	local row = vim.api.nvim_win_get_cursor(0)[1] - 1
	local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1] or ""
	return line, row
end

local function show_bc()
	local bufnr = vim.api.nvim_get_current_buf()
	local cursor_row = vim.api.nvim_win_get_cursor(0)[1] - 1
	clear(bufnr)
	if cursor_row < 0 then
		return
	end

	-- wszystkie linie od początku do kursora
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, cursor_row + 1, false)
	local results, err = eval_bc_multiline(lines)
	if not results then
		virt(bufnr, cursor_row, "bc error: " .. err)
		return
	end

	-- wynik dla bieżącej linii = ostatnia linia wyjścia bc
	if #results > 0 then
		virt(bufnr, cursor_row, " = " .. results[#results])
	end
end

local function show_hover()
	pcall(vim.lsp.buf.hover)
	show_bc()
end

vim.cmd([[augroup BcSideline; autocmd!; autocmd CursorHold * lua show_bc(); augroup END]])
vim.keymap.set("n", "<leader>k", show_hover, { silent = true, noremap = true })
