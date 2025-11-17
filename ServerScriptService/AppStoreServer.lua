-- SERVER SCRIPT: Sistema de App Store
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local AppsDataStore = DataStoreService:GetDataStore("PublishedApps")

local RemoteFolder = Instance.new("Folder")
RemoteFolder.Name = "AppStoreRemotes"
RemoteFolder.Parent = ReplicatedStorage

local CreateApp = Instance.new("RemoteEvent")
CreateApp.Name = "CreateApp"
CreateApp.Parent = RemoteFolder

local PublishApp = Instance.new("RemoteEvent")
PublishApp.Name = "PublishApp"
PublishApp.Parent = RemoteFolder

local LoadApps = Instance.new("RemoteFunction")
LoadApps.Name = "LoadApps"
LoadApps.Parent = RemoteFolder

local PlayApp = Instance.new("RemoteEvent")
PlayApp.Name = "PlayApp"
PlayApp.Parent = RemoteFolder

local LikeApp = Instance.new("RemoteEvent")
LikeApp.Name = "LikeApp"
LikeApp.Parent = RemoteFolder

local ExitApp = Instance.new("RemoteEvent")
ExitApp.Name = "ExitApp"
ExitApp.Parent = RemoteFolder

local SaveAppContent = Instance.new("RemoteEvent")
SaveAppContent.Name = "SaveAppContent"
SaveAppContent.Parent = RemoteFolder

local LoadAppContent = Instance.new("RemoteFunction")
LoadAppContent.Name = "LoadAppContent"
LoadAppContent.Parent = RemoteFolder

local AppWorlds = Instance.new("Folder")
AppWorlds.Name = "AppWorlds"
AppWorlds.Parent = workspace

local LobbySpawn = Instance.new("SpawnLocation")
LobbySpawn.Size = Vector3.new(10, 1, 10)
LobbySpawn.Position = Vector3.new(0, 0.5, 0)
LobbySpawn.BrickColor = BrickColor.new("Bright blue")
LobbySpawn.Anchored = true
LobbySpawn.Parent = workspace

LoadApps.OnServerInvoke = function(player)
	local success, apps = pcall(function()
		return AppsDataStore:GetAsync("AllApps") or {}
	end)
	return success and apps or {}
end

PublishApp.OnServerEvent:Connect(function(player, appData)
	local appId = player.UserId .. "_" .. tick()
	appData.Id = appId
	appData.Creator = player.Name
	appData.CreatorId = player.UserId
	appData.Visits = 0
	appData.Likes = 0
	appData.Objects = appData.Objects or {}
	
	local success = pcall(function()
		local allApps = AppsDataStore:GetAsync("AllApps") or {}
		table.insert(allApps, appData)
		AppsDataStore:SetAsync("AllApps", allApps)
		AppsDataStore:SetAsync(appId, appData)
	end)
	
	if success then
		CreateApp:FireClient(player, true, appId)
	end
end)

SaveAppContent.OnServerEvent:Connect(function(player, appId, objects)
	local success = pcall(function()
		local appData = AppsDataStore:GetAsync(appId)
		if appData and appData.CreatorId == player.UserId then
			appData.Objects = objects
			AppsDataStore:SetAsync(appId, appData)
			
			local allApps = AppsDataStore:GetAsync("AllApps") or {}
			for i, app in ipairs(allApps) do
				if app.Id == appId then
					allApps[i].Objects = objects
					break
				end
			end
			AppsDataStore:SetAsync("AllApps", allApps)
		end
	end)
end)

LoadAppContent.OnServerInvoke = function(player, appId)
	local success, appData = pcall(function()
		return AppsDataStore:GetAsync(appId)
	end)
	return success and appData or nil
end

PlayApp.OnServerEvent:Connect(function(player, appId)
	local appData = AppsDataStore:GetAsync(appId)
	if not appData then return end
	
	appData.Visits = appData.Visits + 1
	AppsDataStore:SetAsync(appId, appData)
	
	local allApps = AppsDataStore:GetAsync("AllApps") or {}
	for i, app in ipairs(allApps) do
		if app.Id == appId then
			allApps[i].Visits = appData.Visits
			break
		end
	end
	AppsDataStore:SetAsync("AllApps", allApps)
	
	local worldFolder = AppWorlds:FindFirstChild(appId)
	if not worldFolder then
		worldFolder = Instance.new("Folder")
		worldFolder.Name = appId
		worldFolder.Parent = AppWorlds
		
		local spawnPos = Vector3.new(math.random(-500, 500), 100, math.random(-500, 500))
		
		local baseplate = Instance.new("Part")
		baseplate.Name = "Baseplate"
		baseplate.Size = Vector3.new(100, 1, 100)
		baseplate.Position = spawnPos
		baseplate.Anchored = true
		baseplate.BrickColor = BrickColor.new("Dark green")
		baseplate.Parent = worldFolder
		
		local spawn = Instance.new("SpawnLocation")
		spawn.Size = Vector3.new(6, 1, 6)
		spawn.Position = spawnPos + Vector3.new(0, 1, 0)
		spawn.Anchored = true
		spawn.BrickColor = BrickColor.new("Bright green")
		spawn.Parent = worldFolder
		
		for _, objData in ipairs(appData.Objects or {}) do
			local part = Instance.new("Part")
			part.Size = Vector3.new(objData.SizeX, objData.SizeY, objData.SizeZ)
			part.Position = Vector3.new(objData.PosX, objData.PosY, objData.PosZ)
			part.Rotation = Vector3.new(objData.RotX or 0, objData.RotY or 0, objData.RotZ or 0)
			part.BrickColor = BrickColor.new(objData.Color)
			part.Material = Enum.Material[objData.Material or "Plastic"]
			part.Anchored = true
			part.Parent = worldFolder
		end
	end
	
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		local spawn = worldFolder:FindFirstChild("SpawnLocation") or worldFolder:FindFirstChildOfClass("SpawnLocation")
		if spawn then
			char.HumanoidRootPart.CFrame = spawn.CFrame + Vector3.new(0, 3, 0)
		end
	end
end)

ExitApp.OnServerEvent:Connect(function(player)
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		char.HumanoidRootPart.CFrame = LobbySpawn.CFrame + Vector3.new(0, 3, 0)
	end
end)

LikeApp.OnServerEvent:Connect(function(player, appId)
	pcall(function()
		local appData = AppsDataStore:GetAsync(appId)
		if appData then
			appData.Likes = appData.Likes + 1
			AppsDataStore:SetAsync(appId, appData)
			
			local allApps = AppsDataStore:GetAsync("AllApps") or {}
			for i, app in ipairs(allApps) do
				if app.Id == appId then
					allApps[i].Likes = appData.Likes
					break
				end
			end
			AppsDataStore:SetAsync("AllApps", allApps)
		end
	end)
end)
