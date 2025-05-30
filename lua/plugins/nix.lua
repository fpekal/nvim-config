return {
	-- Make the terminal interactive even in `nix develop` etc
	{
		"folke/snacks.nvim",
		---@type snacks.Config
		opts = {
			terminal = {
				shell = "/run/current-system/sw/bin/bash",
			},
		},
	},
}
