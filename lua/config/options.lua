-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.mouse = ""
vim.opt.spelllang = {}
vim.opt.wrap = true
vim.opt.expandtab = false

vim.g.root_spec = { { ".git", "lua", ".jj", "pack.mcmeta" }, "cwd" }

vim.filetype.add({
	extension = {
		mcfunction = "mcfunction",
	},
})
