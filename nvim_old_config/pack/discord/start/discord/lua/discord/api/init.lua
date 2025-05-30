local auth = require("discord.api.auth")
local curl = require("plenary.curl")

local mod = {}

mod.request = function(method, endpoint, data)
	local headers = {
		Authorization = auth.get_access_token(),
	}

	local response = 0

	if method == "post" then
		if data then
			if vim.tbl_isempty(data) then
				data = nil
			else
				data = vim.json.encode(data)
				headers["Content-Type"] = "application/json"
			end
		end

		response = curl[method]({url="https://discord.com/api/v10" .. endpoint,headers=headers,body=data})
	elseif method == "get" then
		response = curl[method]({url="https://discord.com/api/v10" .. endpoint,headers=headers,query=data})
	end

	return vim.json.decode(response.body)
end

mod.get_users_me = function()
	return mod.request("get","/users/@me")
end

mod.send_message = function(data)
	return mod.request("post","/channels/"..data.channel_id.."/messages",data.opts)
end

mod.get_messages = function(data)
	return mod.request("get","/channels/"..data.channel_id.."/messages",data.opts)
end

mod.create_dm = function(data)
	return mod.request("post","/users/@me/channels",data.opts)
end

mod.get_relationships = function()
	return mod.request("get","/users/@me/relationships")
end

return {
	register = auth.register,
	get_users_me = mod.get_users_me,
	send_message = mod.send_message,
	get_messages = mod.get_messages,
	create_dm = mod.create_dm,
	get_relationships = mod.get_relationships
}
