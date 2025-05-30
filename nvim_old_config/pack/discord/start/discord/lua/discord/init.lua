local api = require("discord.api")

local mod = {}

mod.fill_friends = function()
	mod.friends = api.get_relationships()
end

mod.get_friend = function(filters)
	if mod.friends == nil then
		mod.fill_friends()
	end

	for _,friend in ipairs(mod.friends) do
		local conditions = 0
		if filters.username ~= nil then
			if friend.user.username == filters.username then
				conditions = conditions + 1
			end
		else
			conditions = conditions + 1
		end

		if filters.id ~= nil then
			if friend.user.id == filters.id then
				conditions = conditions + 1
			end
		else
			conditions = conditions + 1
		end

		if conditions == 2 then
			return friend
		end
	end
end

function DiscordAuth()
	api.register()
end

function DiscordTest()
	print(vim.inspect(mod.get_friend({username="Piotrek"})))
end

function DiscordGetUsersMe()
	print(vim.inspect(api.get_users_me()))
end

function DiscordSendMessage(user, message)
	local channel = api.create_dm({opts={recipient_id=user}})

	api.send_message({channel_id=channel.id, opts={content=message}})
end

function DiscordGetMessages(user, count)
	local channel = api.create_dm({opts={recipient_id=user}})

	print(vim.inspect(api.get_messages({channel_id=channel.id, opts={limit=count}})))
end

mod.init = function()
	vim.cmd.command("DiscordAuth", "lua DiscordAuth()")
end

return {init=mod.init}
