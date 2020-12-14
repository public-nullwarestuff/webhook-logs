local function fetch(method, placeid)
	if method == "name" then
		return(game:GetService("MarketplaceService"):GetProductInfo(placeid).Name)
	elseif method == "icon" then
		return("https://www.roblox.com/Thumbs/Asset.ashx?width=110&height=110&assetId="..placeid)
	end
end

local function post(name, message)
	local user
	local user2
	local img
	if name == game:GetService("Players").LocalPlayer.Name then
		if _G.ScreenshotMode == true then
			user = "You"
			img = "https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png"
		else
			user = name
			img = game:GetService("Players"):GetUserThumbnailAsync(game:GetService("Players"):FindFirstChild(name).UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
		end
		user2 = "You"
	else
		user = name
		user2 = name
		img = game:GetService("Players"):GetUserThumbnailAsync(game:GetService("Players"):FindFirstChild(name).UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
	end
	syn.request({
		Url = _G.WebHook,
		Method = "POST",
		Headers = {
			["Content-Type"] = "application/json"
		},
		Body = game:GetService("HttpService"):JSONEncode({
			["username"] = user,
			["avatar_url"] = img,
			["embeds"] = {
				{
					["title"] = user2,
					["description"] = message,
					["color"] = 50060
				}
			}
		})
	})
end

for _,start in pairs(game:GetService("Players"):GetPlayers()) do
	start.Chatted:Connect(function(msg)
		post(start.Name, msg)
	end)
end

game:GetService("Players").PlayerAdded:Connect(function(start)
	post(start.Name, start.Name.." has joined the game.")
	start.Chatted:Connect(function(msg)
		post(start.Name, msg)
	end)
end)

game:GetService("Players").PlayerRemoving:Connect(function(start)
	if _G.ScreenshotMode == true then
		if start.Name == game:GetService("Players").LocalPlayer.Name then
			post(start.Name, "You have left the game.")
		end
	else
		post(start.Name, start.Name.." has left the game.")
	end
end)

post(game:GetService("Players").LocalPlayer.Name, "You have joined '"..fetch("name", game.PlaceId).."', listening for messages. \n \n PlaceId: ".. game.PlaceId)
