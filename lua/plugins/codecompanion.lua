local function get_api_key()
	local f = io.open("/home/filip/.secrets/nvim-codecompanion.key", "r")

	if f == nil then
		return ""
	end

	local content = f:read("*a")
	f:close()
	content = content:gsub("%s+$", "")
	return content
end

return {
	{
		"olimorris/codecompanion.nvim",
		keys = {
			{ "<leader>aa", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "Show CodeCompanion prompt" },
			{ "<leader>ac", "<cmd>CodeCompanionChat<cr>", desc = "Show CodeCompanion chat" },
		},
		config = function()
			require("codecompanion").setup({
				adapters = {
					glama_gpt = function()
						return require("codecompanion.adapters").extend("openai_compatible", {
							formatted_name = "glama gpt",
							env = {
								url = "https://glama.ai/api/gateway/openai",
								api_key = get_api_key(),
								chat_url = "/v1/chat/completions",
							},
							headers = {
								["Content-Type"] = "application/json",
								Authorization = "Bearer ${api_key}",
							},
							schema = {
								model = {
									default = "gpt-5-mini",
								},
							},
						})
					end,
				},
				strategies = {
					chat = {
						adapter = "glama_gpt",
					},
					inline = {
						adapter = "glama_gpt",
					},
					cmd = {
						adapter = "glama_gpt",
					},
				},
			})
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
	},
}
