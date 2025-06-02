local uv = vim.loop
local curl = require("plenary.curl")
local cred = require("discord.api.credentials")

local mod = {}

mod.code = ""
mod.access_token = ""
mod.server = false

mod.auth_link = "https://discord.com/api/oauth2/authorize?client_id=1088580976902406144&redirect_uri=http%3A%2F%2Felektro.wielun.pl%3A12345&response_type=code&scope=messages.read"

mod.prompt_user = function()
	print("Connect to " .. mod.auth_link)
end

mod.get_access_token = function()
	if mod.access_token ~= "" then return mod.access_token end

	local data = {
		client_id = cred.client_id,
		client_secret = cred.client_secret,
		grant_type = "authorization_code",
		code = mod.code,
		redirect_uri = "http://elektro.wielun.pl:12345"
	}

	local response = curl.post({url="https://discord.com/api/v10/oauth2/token",data=data})

	local decoded = vim.json.decode(response.body)
	mod.access_token = decoded.access_token

	return mod.access_token
end

mod.stop_server = function()
	if not mod.server then return end
	mod.server:close()
	mod.server = false
end

mod.new_client = function(socket)
	local request = ""

	socket:read_start(vim.schedule_wrap(function(err, data)
		request = request .. data
		mod.end_connection(socket)
		mod.parse_request(request)
	end))
end

mod.end_connection = function(socket)
	socket:write("HTTP/1.1 200 OK\nConnection: close\n\n", function(err) socket:close() end)
end

mod.parse_request = function(request)
	local regex = vim.regex("code=\\S\\+")
	local start, stop = regex:match_str(vim.split(request,"\n")[1])

	if start ~= nil then
		mod.code = string.sub(request, start + 6, stop)
		mod.stop_server()
		mod.get_access_token()
	end
end

mod.new_connection = function(err)
	local socket = uv.new_tcp()
	mod.server:accept(socket)

	mod.new_client(socket)
end

mod.start_server = function()
	if not mod.server then
		mod.server = uv.new_tcp()
		mod.server:bind("0.0.0.0", 12345)

		mod.server:listen(128, mod.new_connection)
	end
end

mod.get_authorization_code = function()
	mod.start_server()
	mod.prompt_user()
end

mod.register = function()
	local data = {
		grant_type = "client_credentials"
	}

	local response = curl.post({url="https://discord.com/api/v10/oauth2/token",data=data,auth=cred.client_id .. ":" .. cred.client_secret})

	print(vim.inspect(vim.json.decode(response.body)))
end

mod.get_access_token_cred = function()
	if mod.access_token ~= "" then return mod.access_token end

	local data = {
		grant_type = "client_credentials",
		client_id = cred.client_id,
		client_secret = cred.client_secret,
		scope = "webhook.incoming"
	}

	local response = curl.post({url="https://discord.com/api/v10/oauth2/token",data=data})

	local body = vim.json.decode(response.body)
	mod.access_token = body.access_token
	print(vim.inspect(body))
end

return {
	get_access_token = mod.get_access_token,
	register = mod.get_authorization_code
}

