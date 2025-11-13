-- Stranger Things Infinite Obby - Main Server
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")

-- DataStore
local playerDataStore = DataStoreService:GetDataStore("StrangerThingsObbyData")

-- Folders
local RemoteEvents = Instance.new("Folder")
RemoteEvents.Name = "RemoteEvents"
RemoteEvents.Parent = ReplicatedStorage

local LevelUpdate = Instance.new("RemoteEvent")
LevelUpdate.Name = "LevelUpdate"
LevelUpdate.Parent = RemoteEvents

local ObbyFolder = workspace:FindFirstChild("Obby") or Instance.new("Folder", workspace)
ObbyFolder.Name = "Obby"

-- Configuración
local STAGE_LENGTH = 50
local STAGE_WIDTH = 20
local OBSTACLES_PER_STAGE = 8

-- Datos de jugadores
local playerData = {}

-- Configurar atmósfera
local function setupAtmosphere()
	local lighting = game:GetService("Lighting")
	lighting.Ambient = Color3.fromRGB(80, 90, 110)
	lighting.OutdoorAmbient = Color3.fromRGB(70, 80, 100)
	lighting.Brightness = 2
	lighting.ClockTime = 14
	lighting.FogColor = Color3.fromRGB(50, 60, 80)
	lighting.FogEnd = 400
	lighting.FogStart = 100
	
	local atmosphere = Instance.new("Atmosphere")
	atmosphere.Density = 0.3
	atmosphere.Color = Color3.fromRGB(70, 80, 100)
	atmosphere.Decay = Color3.fromRGB(60, 70, 90)
	atmosphere.Glare = 0.3
	atmosphere.Haze = 1
	atmosphere.Parent = lighting
end

-- Crear checkpoint
local function createCheckpoint(position, stageNumber)
	local checkpoint = Instance.new("Part")
	checkpoint.Name = "Checkpoint_" .. stageNumber
	checkpoint.Size = Vector3.new(15, 1, 15)
	checkpoint.Position = position
	checkpoint.Anchored = true
	checkpoint.BrickColor = BrickColor.new("Bright green")
	checkpoint.Material = Enum.Material.Neon
	checkpoint.Transparency = 0.3
	checkpoint.CanCollide = true
	checkpoint.Parent = ObbyFolder
	
	local light = Instance.new("PointLight")
	light.Color = Color3.fromRGB(0, 255, 0)
	light.Brightness = 3
	light.Range = 30
	light.Parent = checkpoint
	
	-- Texto del nivel
	local billboardGui = Instance.new("BillboardGui")
	billboardGui.Size = UDim2.new(0, 200, 0, 50)
	billboardGui.StudsOffset = Vector3.new(0, 5, 0)
	billboardGui.AlwaysOnTop = true
	billboardGui.Parent = checkpoint
	
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = "NIVEL " .. stageNumber
	textLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
	textLabel.TextScaled = true
	textLabel.Font = Enum.Font.GothamBold
	textLabel.Parent = billboardGui
	
	-- Detector
	checkpoint.Touched:Connect(function(hit)
		local humanoid = hit.Parent:FindFirstChild("Humanoid")
		if humanoid then
			local player = Players:GetPlayerFromCharacter(hit.Parent)
			if player and playerData[player.UserId] then
				if playerData[player.UserId].currentStage < stageNumber then
					playerData[player.UserId].currentStage = stageNumber
					playerData[player.UserId].spawnPosition = position + Vector3.new(0, 5, 0)
					LevelUpdate:FireClient(player, stageNumber)
					
					-- Guardar datos
					pcall(function()
						playerDataStore:SetAsync(player.UserId, {
							stage = stageNumber
						})
					end)
				end
			end
		end
	end)
	
	return checkpoint
end

-- Crear plataforma normal
local function createPlatform(position, size, color)
	local platform = Instance.new("Part")
	platform.Name = "Platform"
	platform.Size = size or Vector3.new(8, 1, 8)
	platform.Position = position
	platform.Anchored = true
	platform.Color = color or Color3.fromRGB(60, 50, 70)
	platform.Material = Enum.Material.Slate
	platform.Parent = ObbyFolder
	return platform
end

-- Crear plataforma de lava (kill)
local function createLavaPlatform(position, size)
	local lava = Instance.new("Part")
	lava.Name = "Lava"
	lava.Size = size or Vector3.new(8, 1, 8)
	lava.Position = position
	lava.Anchored = true
	lava.Color = Color3.fromRGB(255, 50, 50)
	lava.Material = Enum.Material.Neon
	lava.Transparency = 0.3
	lava.CanCollide = true
	lava.Parent = ObbyFolder
	
	local light = Instance.new("PointLight")
	light.Color = Color3.fromRGB(255, 50, 50)
	light.Brightness = 2
	light.Range = 15
	light.Parent = lava
	
	lava.Touched:Connect(function(hit)
		local humanoid = hit.Parent:FindFirstChild("Humanoid")
		if humanoid then
			humanoid.Health = 0
		end
	end)
	
	return lava
end

-- Crear plataforma que desaparece
local function createDisappearingPlatform(position)
	local platform = Instance.new("Part")
	platform.Name = "DisappearingPlatform"
	platform.Size = Vector3.new(8, 1, 8)
	platform.Position = position
	platform.Anchored = true
	platform.Color = Color3.fromRGB(100, 100, 255)
	platform.Material = Enum.Material.Neon
	platform.Transparency = 0.2
	platform.Parent = ObbyFolder
	
	platform.Touched:Connect(function(hit)
		if hit.Parent:FindFirstChild("Humanoid") then
			wait(0.5)
			platform.CanCollide = false
			platform.Transparency = 1
			wait(3)
			platform.CanCollide = true
			platform.Transparency = 0.2
		end
	end)
	
	return platform
end

-- Crear plataforma móvil
local function createMovingPlatform(startPos, endPos)
	local platform = Instance.new("Part")
	platform.Name = "MovingPlatform"
	platform.Size = Vector3.new(10, 1, 10)
	platform.Position = startPos
	platform.Anchored = true
	platform.Color = Color3.fromRGB(150, 100, 200)
	platform.Material = Enum.Material.Neon
	platform.Transparency = 0.2
	platform.Parent = ObbyFolder
	
	local TweenService = game:GetService("TweenService")
	local tween = TweenService:Create(platform, TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {
		Position = endPos
	})
	tween:Play()
	
	return platform
end

-- Crear obstáculo giratorio
local function createSpinner(position)
	local base = Instance.new("Part")
	base.Name = "SpinnerBase"
	base.Size = Vector3.new(2, 8, 2)
	base.Position = position
	base.Anchored = true
	base.Color = Color3.fromRGB(80, 40, 40)
	base.Material = Enum.Material.Metal
	base.Parent = ObbyFolder
	
	for i = 1, 4 do
		local blade = Instance.new("Part")
		blade.Name = "Blade"
		blade.Size = Vector3.new(12, 1, 2)
		blade.Position = position
		blade.Color = Color3.fromRGB(150, 50, 50)
		blade.Material = Enum.Material.Neon
		blade.CanCollide = true
		blade.Parent = base
		
		local weld = Instance.new("WeldConstraint")
		weld.Part0 = base
		weld.Part1 = blade
		weld.Parent = blade
		
		blade.Touched:Connect(function(hit)
			local humanoid = hit.Parent:FindFirstChild("Humanoid")
			if humanoid then
				humanoid.Health = 0
			end
		end)
	end
	
	local RunService = game:GetService("RunService")
	RunService.Heartbeat:Connect(function()
		if base.Parent then
			base.CFrame = base.CFrame * CFrame.Angles(0, math.rad(2), 0)
		end
	end)
	
	return base
end

-- Crear lianas decorativas
local function createVines(position)
	local vine = Instance.new("Part")
	vine.Name = "Vine"
	vine.Size = Vector3.new(0.5, math.random(8, 15), 0.5)
	vine.Position = position
	vine.Anchored = true
	vine.Color = Color3.fromRGB(40, 60, 40)
	vine.Material = Enum.Material.Fabric
	vine.CanCollide = false
	vine.Parent = ObbyFolder
	return vine
end

-- Generar stage completo
local function generateStage(stageNumber)
	local startZ = (stageNumber - 1) * STAGE_LENGTH
	local baseY = 10
	
	-- Checkpoint al inicio
	createCheckpoint(Vector3.new(0, baseY, startZ), stageNumber)
	
	-- Generar obstáculos
	for i = 1, OBSTACLES_PER_STAGE do
		local zPos = startZ + (i * (STAGE_LENGTH / OBSTACLES_PER_STAGE))
		local xOffset = math.random(-STAGE_WIDTH/2, STAGE_WIDTH/2)
		local yOffset = math.random(-3, 3)
		
		local obstacleType = math.random(1, 5)
		
		if obstacleType == 1 then
			-- Plataforma normal
			createPlatform(Vector3.new(xOffset, baseY + yOffset, zPos))
		elseif obstacleType == 2 then
			-- Plataforma de lava
			createLavaPlatform(Vector3.new(xOffset, baseY + yOffset - 2, zPos))
			createPlatform(Vector3.new(xOffset, baseY + yOffset, zPos), Vector3.new(6, 1, 6))
		elseif obstacleType == 3 then
			-- Plataforma que desaparece
			createDisappearingPlatform(Vector3.new(xOffset, baseY + yOffset, zPos))
		elseif obstacleType == 4 then
			-- Plataforma móvil
			local startPos = Vector3.new(xOffset - 10, baseY + yOffset, zPos)
			local endPos = Vector3.new(xOffset + 10, baseY + yOffset, zPos)
			createMovingPlatform(startPos, endPos)
		else
			-- Spinner
			createPlatform(Vector3.new(xOffset - 15, baseY + yOffset, zPos))
			createSpinner(Vector3.new(xOffset, baseY + yOffset + 4, zPos))
			createPlatform(Vector3.new(xOffset + 15, baseY + yOffset, zPos))
		end
		
		-- Decoración
		if math.random(1, 3) == 1 then
			createVines(Vector3.new(xOffset + math.random(-5, 5), baseY + yOffset + 10, zPos))
		end
	end
end

-- Generar stages iniciales
for i = 1, 10 do
	generateStage(i)
end

-- Sistema de generación infinita
local function checkAndGenerateStages()
	while true do
		wait(5)
		for _, player in pairs(Players:GetPlayers()) do
			if playerData[player.UserId] then
				local currentStage = playerData[player.UserId].currentStage
				-- Generar 5 stages adelante
				for i = currentStage, currentStage + 5 do
					if not ObbyFolder:FindFirstChild("Checkpoint_" .. i) then
						generateStage(i)
					end
				end
			end
		end
	end
end

spawn(checkAndGenerateStages)

-- Manejo de jugadores
Players.PlayerAdded:Connect(function(player)
	-- Cargar datos
	local data = {
		currentStage = 1,
		spawnPosition = Vector3.new(0, 15, 0)
	}
	
	local success, savedData = pcall(function()
		return playerDataStore:GetAsync(player.UserId)
	end)
	
	if success and savedData then
		data.currentStage = savedData.stage or 1
		data.spawnPosition = Vector3.new(0, 15, (data.currentStage - 1) * STAGE_LENGTH)
	end
	
	playerData[player.UserId] = data
	
	player.CharacterAdded:Connect(function(character)
		wait(0.1)
		local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
		humanoidRootPart.CFrame = CFrame.new(playerData[player.UserId].spawnPosition)
		
		LevelUpdate:FireClient(player, playerData[player.UserId].currentStage)
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	if playerData[player.UserId] then
		pcall(function()
			playerDataStore:SetAsync(player.UserId, {
				stage = playerData[player.UserId].currentStage
			})
		end)
		playerData[player.UserId] = nil
	end
end)

setupAtmosphere()
print("Stranger Things Infinite Obby initialized!")
