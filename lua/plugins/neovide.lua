vim.g.neovide_floating_corner_radius = 0.5
vim.g.neovide_opacity = 0.94
vim.g.neovide_normal_opacity = 0.96

vim.g.neovide_scale_factor = 1

local function change_scale(delta)
	vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + delta
end

vim.keymap.set("n", "<C-=>", function()
	change_scale(0.1)
end)
vim.keymap.set("n", "<C-->", function()
	change_scale(-0.1)
end)

return {}
