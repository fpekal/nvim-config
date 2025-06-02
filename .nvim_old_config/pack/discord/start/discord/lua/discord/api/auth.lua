local curl = require("plenary.curl")

local mod = {}

mod.access_token = ""

mod.get_access_token = function()
	if mod.access_token ~= "" then return mod.access_token end

	vim.ui.input({prompt="Type your token: "}, function(token)
		if token then
			mod.access_token = token
			print("Token accepted")
		end
	end)
end

return {
	get_access_token = mod.get_access_token,
	register = mod.get_access_token
}

