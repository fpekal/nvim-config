return {
	"neovim/nvim-lspconfig",
	event = "LazyFile",
	dependencies = {
		"mason.nvim",
		{ "mason-org/mason-lspconfig.nvim", config = function() end },
	},
	opts = {
		servers = {
			nil_ls = {
				settings = {
					["nil"] = {
						formatting = {
							command = { "alejandra", "--" },
						},
					},
				},
			},
			spyglassmc_language_server = {
				cmd = { "spyglassmc-language-server", "--stdio" },
				filetypes = { "mcfunction" },
				root_markers = { "pack.mcmeta" },
			},
			lua_ls = {
				-- mason = false, -- set to false if you don't want this server to be installed with mason
				-- Use this to add any additional keymaps
				-- for specific lsp servers
				-- ---@type LazyKeysSpec[]
				-- keys = {},
				settings = {
					Lua = {
						workspace = {
							checkThirdParty = false,
						},
						codeLens = {
							enable = true,
						},
						completion = {
							callSnippet = "Replace",
						},
						doc = {
							privateName = { "^_" },
						},
						hint = {
							enable = true,
							setType = false,
							paramType = true,
							paramName = "Disable",
							semicolon = "Disable",
							arrayIndex = "Disable",
						},
					},
				},
			},
			clangd = {
				cmd = {
					"clangd",
					"--all-scopes-completion",
					"--background-index",
					"--clang-tidy",
					"--compile_args_from=filesystem", -- lsp-> does not come from compie_commands.json
					"--completion-parse=always",
					"--completion-style=bundled",
					"--cross-file-rename",
					"--debug-origin",
					"--enable-config", -- clangd 11+ supports reading from .clangd configuration file
					"--fallback-style=Qt",
					"--folding-ranges",
					"--function-arg-placeholders",
					"--header-insertion=iwyu",
					"--pch-storage=memory", -- could also be disk
					"--suggest-missing-includes",
					"-j=4", -- number of workers
					"--log=error",
					"--query-driver=/**/*",
				},
			},
		},
	},
}
