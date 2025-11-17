-- SERVER SCRIPT: App Store con HTML
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AppsDataStore = DataStoreService:GetDataStore("HTMLApps")

local RemoteFolder = Instance.new("Folder")
RemoteFolder.Name = "AppStoreRemotes"
RemoteFolder.Parent = ReplicatedStorage

local PublishApp = Instance.new("RemoteEvent")
PublishApp.Name = "PublishApp"
PublishApp.Parent = RemoteFolder

local LoadApps = Instance.new("RemoteFunction")
LoadApps.Name = "LoadApps"
LoadApps.Parent = RemoteFolder

local LikeApp = Instance.new("RemoteEvent")
LikeApp.Name = "LikeApp"
LikeApp.Parent = RemoteFolder

LoadApps.OnServerInvoke = function()
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
	appData.Timestamp = os.time()
	
	pcall(function()
		local allApps = AppsDataStore:GetAsync("AllApps") or {}
		table.insert(allApps, appData)
		AppsDataStore:SetAsync("AllApps", allApps)
		AppsDataStore:SetAsync(appId, appData)
	end)
end)

LikeApp.OnServerEvent:Connect(function(player, appId)
	pcall(function()
		local allApps = AppsDataStore:GetAsync("AllApps") or {}
		for i, app in ipairs(allApps) do
			if app.Id == appId then
				allApps[i].Likes = (allApps[i].Likes or 0) + 1
				AppsDataStore:SetAsync("AllApps", allApps)
				break
			end
		end
	end)
end)
