local function get_api_key()
	local f = io.open("codecompanion.key", "r")

	if f == nil then
		return ""
	end

	local content = f:read("*a")
	f:close()
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
					gemini = function()
						local utils = require("codecompanion.utils.adapters")

						return require("codecompanion.adapters").extend("openai", {
							url = "https://glama.ai/api/gateway/openai/v1/chat/completions",
							env = {
								api_key = get_api_key(),
							},
							schema = {
								model = {
									default = "gpt-4.1-nano-2025-04-14",
								},
								stop = {
									default = "stop",
								},
							},
							handlers = {
								chat_output = function(self, data)
									local output = {}

									if data and data ~= "" then
										local data_mod = utils.clean_streamed_data(data)
										local ok, json = pcall(vim.json.decode, data_mod, { luanil = { object = true } })

										if ok and json.choices and #json.choices > 0 then
											local choice = json.choices[1]

											if choice.finish_reason then
												local reason = choice.finish_reason
												if reason ~= "stop" and reason ~= "STOP" and reason ~= "" then
													return {
														status = "error",
														output = "The stream was stopped with the a finish_reason of '" .. reason .. "'",
													}
												end
											end

											local delta = (self.opts and self.opts.stream) and choice.delta or choice.message

											if delta then
												if delta.role then
													output.role = delta.role
												else
													output.role = nil
												end

												-- Some providers may return empty content
												if delta.content then
													output.content = delta.content
												else
													output.content = ""
												end

												return {
													status = "success",
													output = output,
												}
											end
										end
									end
								end,
								form_messages = function(self, messages)
									messages = vim
										.iter(messages)
										:map(function(m)
											local model = self.schema.model.default
											if type(model) == "function" then
												model = model()
											end
											if m.role == "system" then
												m.role = self.roles.user
											end

											return {
												role = m.role,
												content = m.content,
											}
										end)
										:totable()

									return { messages = messages }
								end,
							},
						})
					end,
				},
				strategies = {
					chat = {
						adapter = "gemini",
					},
					inline = {
						adapter = "gemini",
					},
					cmd = {
						adapter = "gemini",
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
