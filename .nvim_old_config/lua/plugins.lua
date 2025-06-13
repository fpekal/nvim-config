return require("packer").startup(function(use)
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})
	use({ "nvim-telescope/telescope.nvim", requires = {
		{ "nvim-lua/plenary.nvim" },
	} })
	use("vigoux/oak")
	use({ "catppuccin/nvim", as = "catppuccin" })
	use("nvim-tree/nvim-web-devicons")
	use("famiu/feline.nvim")
	--use {
	--	'Exafunction/codeium.vim',
	--	config = function ()
	--		-- Change '<C-g>' here to any keycode you like.
	--		vim.keymap.set('i', '<C-g>', function () return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
	--		vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, silent = true })
	--		vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true })
	--		vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
	--	end
	--}

	use({
		"olimorris/codecompanion.nvim",
		config = function()
			require("codecompanion").setup({
				adapters = {
					glama = function()
						return require("codecompanion.adapters").extend("openai", {
							url = "https://glama.ai/api/gateway/openai/v1/chat/completions",
							env = {
								api_key = "[REDACTED]",
							},
							schema = {
								model = {
									default = "gemini-2.0-pro-exp-02-05",
								},
								stop = {
									default = { "STOP", "stop" },
								},
							},
						})
					end,
				},
				strategies = {
					-- Change the default chat adapter
					chat = {
						adapter = "glama",
					},
					inline = {
						adapter = "glama",
					},
					cmd = {
						adapter = "glama",
					},
				},
			})
		end,
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
	})

	use("Julian/lean.nvim")
	use("neovim/nvim-lspconfig")
end)
