-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local function paste()
	return {
		vim.fn.split(vim.fn.getreg(""), "\n"),
		vim.fn.getregtype(""),
	}
end

-- if vim.fn.exists("g:neovide") == 0 then
-- 	vim.g.clipboard = {
-- 		name = "OSC 52",
-- 		copy = {
-- 			["+"] = require("vim.ui.clipboard.osc52").copy("+"),
-- 			["*"] = require("vim.ui.clipboard.osc52").copy("*"),
-- 		},
-- 		paste = {
-- 			["+"] = paste,
-- 			["*"] = paste,
-- 		},
-- 	}
-- end

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
