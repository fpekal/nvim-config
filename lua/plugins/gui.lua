return {
	--[[
	-- Scrolluj dalej niż koniec pliku
	{
		"Aasim-A/scrollEOF.nvim",
		event = { "CursorMoved", "WinScrolled" },
		opts = {
			disabled_filetypes = {
				"snacks_terminal",
			},
		},
	},
	--]]
}
