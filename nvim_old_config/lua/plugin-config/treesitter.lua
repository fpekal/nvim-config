require'nvim-treesitter.configs'.setup {
	ensure_installed = {"c", "lua", "vim", "vimdoc", "query", "cpp"},

	-- CRASH -- 06.12.2023
	-- Gdy uruchamialem nvim podajac od razu plik wejsciowy nvim crashowal
	--highlight = {
	--	enable = true
	--}
}
