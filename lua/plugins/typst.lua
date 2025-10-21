return {
	{
		"chomosuke/typst-preview.nvim",
		lazy = false, -- or ft = 'typst'
		version = "1.*",
		opts = {
			port = 57182,
			-- open_cmd = "",
		}, -- lazy.nvim will implicitly calls `setup {}`
	},
}
