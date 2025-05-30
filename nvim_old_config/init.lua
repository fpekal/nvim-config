vim.cmd("let mapleader=\" \"")
vim.g.maplocalleader = "  "
-- Naprawa kolorów
vim.o.termguicolors = true

require "plugins"
require "plugin-config"
require "terminal"

require('lean').setup {
	mappings = true
}
vim.api.nvim_set_keymap('n', '<leader>t', '<Plug>ToggleTerminal', {})

vim.o.scrolloff = 6

require("catppuccin").setup({
	transparent_background = true,
})
vim.cmd.color("catppuccin")

vim.opt.guicursor = ""
--vim.o.t_TI = ""
--vim.o.t_TE = ""

vim.g.netrw_banner = 0 -- Explorer

vim.cmd("tnoremap <ESC><ESC> <c-\\><c-n>")
--vim.cmd("highlight ColorColumn ctermbg=234")
--vim.o.colorcolumn = 80
vim.cmd("set colorcolumn=80")

-- Naprawienie monitorowania plików
vim.o.backupcopy = "yes"

vim.o.expandtab = false
vim.o.tabstop = 2
vim.o.shiftwidth = 2

vim.o.number = true
vim.o.relativenumber = true

--vim.o.showtabline = 0

vim.o.mouse = ""

--vim.cmd("highlight CursorLine ctermbg=NONE ctermfg=NONE")
--vim.o.t_ut = ""

vim.cmd("augroup init")
vim.cmd("autocmd!")
vim.cmd("autocmd InsertEnter * set cursorline")
vim.cmd("autocmd InsertLeave * set nocursorline")
vim.cmd("augroup END")

vim.cmd("nnoremap <leader>s :call v:lua.scratch()<cr>")

local scratch_buf_handle = -1

function scratch()
	if scratch_buf_handle == -1 then
		scratch_buf_handle = vim.api.nvim_create_buf(true, true)
	end

	vim.cmd("b " .. scratch_buf_handle)
end

vim.api.nvim_set_keymap("n", "<Up>", "<c-w>+", {noremap = true})
vim.api.nvim_set_keymap("n", "<Down>", "<c-w>-", {noremap = true})
vim.api.nvim_set_keymap("n", "<Right>", "<c-w>>", {noremap = true})
vim.api.nvim_set_keymap("n", "<Left>", "<c-w><", {noremap = true})
