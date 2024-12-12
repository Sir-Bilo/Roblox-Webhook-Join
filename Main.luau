local HttpService = game:GetService("HttpService")
local url = " -[add your webhook url]- "

game.Players.PlayerAdded:Connect(function(Player)
	-- Construct the URL for the ropoxy/roblox Thumbnails API
	local thumbnailUrl = "https://thumbnails.roproxy.com/v1/users/avatar-headshot?userIds=" .. Player.UserId .. "&size=150x150&format=Png&isCircular=false"

	-- Send a GET request to fetch the player's avatar image
	local response
	local success, err = pcall(function()
		response = HttpService:GetAsync(thumbnailUrl)
	end)

	if not success then
		warn("Failed to fetch avatar image: " .. tostring(err))
		return
	end

	-- Parse the JSON response
	local responseData = HttpService:JSONDecode(response)
	local imageUrl = responseData.data[1] and responseData.data[1].imageUrl or "https://via.placeholder.com/150" -- Default image if none found

	-- Construct the embed
	local embed = {
		["title"] = Player.Name .. " has joined the game!",
		["description"] = "User ID: " .. Player.UserId,
		["color"] = 0x00FF00, --adjust color
		["thumbnail"] = {
			["url"] = imageUrl
		},
		["footer"] = {
			["text"] = "Player joined at: " .. os.date("%Y-%m-%d %H:%M:%S")
		}
	}

	-- Send the webhook with the embed
	local data = {
		["embeds"] = {embed}
	}
	local FinalData = HttpService:JSONEncode(data)
	HttpService:PostAsync(url, FinalData)
end)

game.Players.PlayerRemoving:Connect(function(Player)
	-- Construct the embed for player leaving
	local embed = {
		["title"] = Player.Name .. " has left the game!",
		["description"] = "Goodbye, " .. Player.Name .. "!",
		["color"] = 0xFF0000, --adjust color
		["footer"] = {
			["text"] = "Player left at: " .. os.date("%Y-%m-%d %H:%M:%S")
		}
	}

	-- Send the webhook with the embed
	local data = {
		["embeds"] = {embed}
	}
	local FinalData = HttpService:JSONEncode(data)
	HttpService:PostAsync(url, FinalData)
end)
