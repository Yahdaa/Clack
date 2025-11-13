-- Main Server Script para Stranger Things Upside Down
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- Eventos remotos
local RemoteEvents = Instance.new("Folder")
RemoteEvents.Name = "RemoteEvents"
RemoteEvents.Parent = ReplicatedStorage

local TeleportEvent = Instance.new("RemoteEvent")
TeleportEvent.Name = "TeleportToUpsideDown"
TeleportEvent.Parent = RemoteEvents

local PowerEvent = Instance.new("RemoteEvent")
PowerEvent.Name = "ElevenPower"
PowerEvent.Parent = RemoteEvents

-- Configuración del mundo
local UpsideDownFolder = workspace:FindFirstChild("UpsideDown") or Instance.new("Folder", workspace)
UpsideDownFolder.Name = "UpsideDown"

local NormalWorldFolder = workspace:FindFirstChild("NormalWorld") or Instance.new("Folder", workspace)
NormalWorldFolder.Name = "NormalWorld"

-- Crear atmósfera del Upside Down
local function setupUpsideDownAtmosphere()
	local lighting = game:GetService("Lighting")
	
	-- Configuración oscura y tenebrosa
	lighting.Ambient = Color3.fromRGB(100, 110, 130)
	lighting.OutdoorAmbient = Color3.fromRGB(90, 100, 120)
	lighting.Brightness = 2.5
	lighting.ClockTime = 14
	lighting.FogColor = Color3.fromRGB(60, 70, 90)
	lighting.FogEnd = 500
	lighting.FogStart = 100
	
	-- Efectos atmosféricos
	local atmosphere = Instance.new("Atmosphere")
	atmosphere.Density = 0.3
	atmosphere.Offset = 0.3
	atmosphere.Color = Color3.fromRGB(80, 90, 110)
	atmosphere.Decay = Color3.fromRGB(70, 80, 100)
	atmosphere.Glare = 0.5
	atmosphere.Haze = 1
	atmosphere.Parent = lighting
	
	-- Color correction para tono azul-gris
	local colorCorrection = Instance.new("ColorCorrectionEffect")
	colorCorrection.Brightness = 0.1
	colorCorrection.Contrast = 0.1
	colorCorrection.Saturation = -0.2
	colorCorrection.TintColor = Color3.fromRGB(180, 190, 210)
	colorCorrection.Parent = lighting
	
	-- Bloom para efectos de luz
	local bloom = Instance.new("BloomEffect")
	bloom.Intensity = 0.5
	bloom.Size = 24
	bloom.Threshold = 0.8
	bloom.Parent = lighting
end

-- Crear el suelo del Upside Down con textura orgánica
local function createUpsideDownGround()
	local ground = Instance.new("Part")
	ground.Name = "UpsideDownGround"
	ground.Size = Vector3.new(500, 5, 500)
	ground.Position = Vector3.new(0, -2.5, 0)
	ground.Anchored = true
	ground.Color = Color3.fromRGB(25, 30, 40)
	ground.Material = Enum.Material.Slate
	ground.Parent = UpsideDownFolder
	
	-- Textura orgánica del suelo
	local texture = Instance.new("Texture")
	texture.Texture = "rbxasset://textures/terrain/slate.png"
	texture.StudsPerTileU = 10
	texture.StudsPerTileV = 10
	texture.Parent = ground
	
	-- Partículas flotantes en el suelo
	local particleEmitter = Instance.new("ParticleEmitter")
	particleEmitter.Texture = "rbxasset://textures/particles/smoke_main.dds"
	particleEmitter.Color = ColorSequence.new(Color3.fromRGB(40, 50, 70))
	particleEmitter.Size = NumberSequence.new(0.5, 2)
	particleEmitter.Transparency = NumberSequence.new(0.5, 1)
	particleEmitter.Lifetime = NumberRange.new(3, 6)
	particleEmitter.Rate = 5
	particleEmitter.Speed = NumberRange.new(0.5, 1)
	particleEmitter.SpreadAngle = Vector2.new(180, 180)
	particleEmitter.Parent = ground
	
	return ground
end

-- Crear lianas colgantes (vines)
local function createVines(position, length)
	local vine = Instance.new("Part")
	vine.Name = "Vine"
	vine.Size = Vector3.new(0.5, length, 0.5)
	vine.Position = position
	vine.Anchored = true
	vine.Color = Color3.fromRGB(30, 40, 35)
	vine.Material = Enum.Material.Fabric
	vine.CanCollide = false
	vine.Parent = UpsideDownFolder
	
	-- Textura de liana
	local mesh = Instance.new("CylinderMesh")
	mesh.Scale = Vector3.new(1, 1, 1)
	mesh.Parent = vine
	
	-- Efecto de movimiento
	local attachment = Instance.new("Attachment")
	attachment.Parent = vine
	
	-- Partículas de esporas
	local spores = Instance.new("ParticleEmitter")
	spores.Texture = "rbxasset://textures/particles/smoke_main.dds"
	spores.Color = ColorSequence.new(Color3.fromRGB(60, 70, 50))
	spores.Size = NumberSequence.new(0.2, 0.5)
	spores.Transparency = NumberSequence.new(0.3, 1)
	spores.Lifetime = NumberRange.new(2, 4)
	spores.Rate = 2
	spores.Speed = NumberRange.new(0.2, 0.5)
	spores.Parent = attachment
	
	-- Animación de balanceo (optimizada)
	local tween = TweenService:Create(vine, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
		CFrame = vine.CFrame * CFrame.Angles(math.rad(5), 0, math.rad(5))
	})
	tween:Play()
	
	return vine
end

-- Crear portal de teletransporte
local function createPortal(normalPos, upsideDownPos)
	-- Portal en mundo normal
	local normalPortal = Instance.new("Part")
	normalPortal.Name = "PortalToUpsideDown"
	normalPortal.Size = Vector3.new(8, 12, 0.5)
	normalPortal.Position = normalPos
	normalPortal.Anchored = true
	normalPortal.CanCollide = false
	normalPortal.Transparency = 0.3
	normalPortal.Color = Color3.fromRGB(100, 50, 150)
	normalPortal.Material = Enum.Material.Neon
	normalPortal.Parent = NormalWorldFolder
	
	-- Efecto visual del portal
	local portalLight = Instance.new("PointLight")
	portalLight.Color = Color3.fromRGB(100, 50, 150)
	portalLight.Brightness = 3
	portalLight.Range = 20
	portalLight.Parent = normalPortal
	
	-- Partículas del portal
	local portalParticles = Instance.new("ParticleEmitter")
	portalParticles.Texture = "rbxasset://textures/particles/sparkles_main.dds"
	portalParticles.Color = ColorSequence.new(Color3.fromRGB(100, 50, 150))
	portalParticles.Size = NumberSequence.new(1, 0)
	portalParticles.Transparency = NumberSequence.new(0, 1)
	portalParticles.Lifetime = NumberRange.new(1, 2)
	portalParticles.Rate = 50
	portalParticles.Speed = NumberRange.new(2, 5)
	portalParticles.Rotation = NumberRange.new(0, 360)
	portalParticles.Parent = normalPortal
	
	-- Detector de proximidad
	local detector = Instance.new("Part")
	detector.Name = "PortalDetector"
	detector.Size = Vector3.new(10, 14, 3)
	detector.Position = normalPos
	detector.Anchored = true
	detector.CanCollide = false
	detector.Transparency = 1
	detector.Parent = normalPortal
	
	detector.Touched:Connect(function(hit)
		local humanoid = hit.Parent:FindFirstChild("Humanoid")
		if humanoid then
			local player = Players:GetPlayerFromCharacter(hit.Parent)
			if player then
				-- Teletransportar al Upside Down
				hit.Parent:SetPrimaryPartCFrame(CFrame.new(upsideDownPos))
				
				-- Efecto de teletransporte
				local char = hit.Parent
				for _, part in pairs(char:GetDescendants()) do
					if part:IsA("BasePart") then
						local flash = Instance.new("PointLight")
						flash.Color = Color3.fromRGB(100, 50, 150)
						flash.Brightness = 5
						flash.Range = 10
						flash.Parent = part
						game:GetService("Debris"):AddItem(flash, 0.5)
					end
				end
			end
		end
	end)
	
	-- Portal de regreso en Upside Down
	local returnPortal = normalPortal:Clone()
	returnPortal.Name = "PortalToNormal"
	returnPortal.Position = upsideDownPos
	returnPortal.Parent = UpsideDownFolder
	
	returnPortal.PortalDetector.Touched:Connect(function(hit)
		local humanoid = hit.Parent:FindFirstChild("Humanoid")
		if humanoid then
			local player = Players:GetPlayerFromCharacter(hit.Parent)
			if player then
				hit.Parent:SetPrimaryPartCFrame(CFrame.new(normalPos + Vector3.new(0, 0, 10)))
			end
		end
	end)
	
	-- Animación de rotación (optimizada)
	local RunService = game:GetService("RunService")
	RunService.Heartbeat:Connect(function()
		if normalPortal.Parent then
			normalPortal.CFrame = normalPortal.CFrame * CFrame.Angles(0, math.rad(1), 0)
			returnPortal.CFrame = returnPortal.CFrame * CFrame.Angles(0, math.rad(1), 0)
		end
	end)
end

-- Crear edificios del Upside Down (versión deteriorada)
local function createUpsideDownBuilding(position, size)
	local building = Instance.new("Part")
	building.Name = "UpsideDownBuilding"
	building.Size = size
	building.Position = position
	building.Anchored = true
	building.Color = Color3.fromRGB(35, 40, 50)
	building.Material = Enum.Material.Concrete
	building.Parent = UpsideDownFolder
	
	-- Agregar grietas y deterioro
	local decal = Instance.new("Decal")
	decal.Texture = "rbxasset://textures/face.png"
	decal.Face = Enum.NormalId.Front
	decal.Transparency = 0.7
	decal.Parent = building
	
	-- Lianas en el edificio
	for i = 1, math.random(3, 6) do
		local vinePos = position + Vector3.new(
			math.random(-size.X/2, size.X/2),
			size.Y/2,
			math.random(-size.Z/2, size.Z/2)
		)
		createVines(vinePos, math.random(5, 15))
	end
	
	-- Partículas de deterioro
	local attachment = Instance.new("Attachment")
	attachment.Position = Vector3.new(0, size.Y/2, 0)
	attachment.Parent = building
	
	local debris = Instance.new("ParticleEmitter")
	debris.Texture = "rbxasset://textures/particles/smoke_main.dds"
	debris.Color = ColorSequence.new(Color3.fromRGB(40, 45, 55))
	debris.Size = NumberSequence.new(0.3, 0.8)
	debris.Transparency = NumberSequence.new(0.5, 1)
	debris.Lifetime = NumberRange.new(3, 5)
	debris.Rate = 1
	debris.Speed = NumberRange.new(0.5, 1)
	debris.Parent = attachment
	
	return building
end

-- Crear membranas orgánicas en paredes
local function createOrganicMembrane(position, size)
	local membrane = Instance.new("Part")
	membrane.Name = "OrganicMembrane"
	membrane.Size = size
	membrane.Position = position
	membrane.Anchored = true
	membrane.Color = Color3.fromRGB(40, 30, 35)
	membrane.Material = Enum.Material.SmoothPlastic
	membrane.Transparency = 0.4
	membrane.CanCollide = false
	membrane.Parent = UpsideDownFolder
	
	-- Efecto pulsante (optimizado)
	local pulse = TweenService:Create(membrane, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
		Transparency = 0.6,
		Size = size * 1.05
	})
	pulse:Play()
	
	return membrane
end

-- Sistema de poderes de Eleven
PowerEvent.OnServerEvent:Connect(function(player, powerType, targetPosition)
	local character = player.Character
	if not character then return end
	
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then return end
	
	if powerType == "Telekinesis" then
		-- Crear efecto de telequinesis
		local effect = Instance.new("Part")
		effect.Name = "TelekinesisEffect"
		effect.Size = Vector3.new(5, 5, 5)
		effect.Position = targetPosition
		effect.Anchored = true
		effect.CanCollide = false
		effect.Transparency = 0.5
		effect.Color = Color3.fromRGB(200, 100, 255)
		effect.Material = Enum.Material.Neon
		effect.Shape = Enum.PartType.Ball
		effect.Parent = workspace
		
		-- Luz del efecto
		local light = Instance.new("PointLight")
		light.Color = Color3.fromRGB(200, 100, 255)
		light.Brightness = 5
		light.Range = 30
		light.Parent = effect
		
		-- Partículas de energía
		local particles = Instance.new("ParticleEmitter")
		particles.Texture = "rbxasset://textures/particles/sparkles_main.dds"
		particles.Color = ColorSequence.new(Color3.fromRGB(200, 100, 255))
		particles.Size = NumberSequence.new(1, 0)
		particles.Transparency = NumberSequence.new(0, 1)
		particles.Lifetime = NumberRange.new(0.5, 1)
		particles.Rate = 100
		particles.Speed = NumberRange.new(5, 10)
		particles.Parent = effect
		
		-- Empujar objetos cercanos
		local region = Region3.new(targetPosition - Vector3.new(10, 10, 10), targetPosition + Vector3.new(10, 10, 10))
		for _, part in pairs(workspace:FindPartsInRegion3(region, nil, 100)) do
			if part:IsA("BasePart") and not part.Anchored and part.Parent ~= character then
				local bodyVelocity = Instance.new("BodyVelocity")
				bodyVelocity.Velocity = (part.Position - targetPosition).Unit * 50
				bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
				bodyVelocity.Parent = part
				game:GetService("Debris"):AddItem(bodyVelocity, 0.5)
			end
		end
		
		-- Eliminar efecto
		game:GetService("Debris"):AddItem(effect, 2)
		
	elseif powerType == "MindBlast" then
		-- Onda expansiva mental
		local blast = Instance.new("Part")
		blast.Name = "MindBlast"
		blast.Size = Vector3.new(1, 1, 1)
		blast.Position = humanoidRootPart.Position
		blast.Anchored = true
		blast.CanCollide = false
		blast.Transparency = 0.3
		blast.Color = Color3.fromRGB(255, 150, 200)
		blast.Material = Enum.Material.Neon
		blast.Shape = Enum.PartType.Ball
		blast.Parent = workspace
		
		-- Expandir onda
		local expandTween = TweenService:Create(blast, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = Vector3.new(40, 40, 40),
			Transparency = 1
		})
		expandTween:Play()
		
		-- Partículas de onda
		local particles = Instance.new("ParticleEmitter")
		particles.Texture = "rbxasset://textures/particles/smoke_main.dds"
		particles.Color = ColorSequence.new(Color3.fromRGB(255, 150, 200))
		particles.Size = NumberSequence.new(2, 5)
		particles.Transparency = NumberSequence.new(0, 1)
		particles.Lifetime = NumberRange.new(0.5, 1)
		particles.Rate = 200
		particles.Speed = NumberRange.new(20, 30)
		particles.SpreadAngle = Vector2.new(180, 180)
		particles.Parent = blast
		
		game:GetService("Debris"):AddItem(blast, 1)
		
	elseif powerType == "Levitation" then
		-- Levitación del jugador
		local bodyPosition = Instance.new("BodyPosition")
		bodyPosition.Position = humanoidRootPart.Position + Vector3.new(0, 10, 0)
		bodyPosition.MaxForce = Vector3.new(4000, 4000, 4000)
		bodyPosition.P = 5000
		bodyPosition.Parent = humanoidRootPart
		
		-- Efecto visual de levitación
		local levEffect = Instance.new("Part")
		levEffect.Size = Vector3.new(6, 0.5, 6)
		levEffect.Position = humanoidRootPart.Position - Vector3.new(0, 3, 0)
		levEffect.Anchored = true
		levEffect.CanCollide = false
		levEffect.Transparency = 0.5
		levEffect.Color = Color3.fromRGB(200, 100, 255)
		levEffect.Material = Enum.Material.Neon
		levEffect.Shape = Enum.PartType.Cylinder
		levEffect.Parent = workspace
		
		game:GetService("Debris"):AddItem(bodyPosition, 3)
		game:GetService("Debris"):AddItem(levEffect, 3)
	end
end)

-- Inicializar el mundo
setupUpsideDownAtmosphere()
createUpsideDownGround()

-- Crear múltiples lianas en el mundo
for i = 1, 20 do
	local randomPos = Vector3.new(
		math.random(-200, 200),
		math.random(20, 40),
		math.random(-200, 200)
	)
	createVines(randomPos, math.random(10, 25))
end

-- Crear edificios del Upside Down
for i = 1, 5 do
	local buildingPos = Vector3.new(
		math.random(-150, 150),
		math.random(15, 25),
		math.random(-150, 150)
	)
	local buildingSize = Vector3.new(
		math.random(20, 40),
		math.random(30, 50),
		math.random(20, 40)
	)
	createUpsideDownBuilding(buildingPos, buildingSize)
end

-- Crear membranas orgánicas
for i = 1, 10 do
	local membranePos = Vector3.new(
		math.random(-180, 180),
		math.random(5, 30),
		math.random(-180, 180)
	)
	createOrganicMembrane(membranePos, Vector3.new(15, 10, 0.5))
end

-- Crear spawn point para jugadores
local spawnLocation = Instance.new("SpawnLocation")
spawnLocation.Name = "UpsideDownSpawn"
spawnLocation.Size = Vector3.new(10, 1, 10)
spawnLocation.Position = Vector3.new(0, 1, 0)
spawnLocation.Anchored = true
spawnLocation.BrickColor = BrickColor.new("Bright red")
spawnLocation.Material = Enum.Material.Neon
spawnLocation.Transparency = 0.5
spawnLocation.CanCollide = true
spawnLocation.Parent = UpsideDownFolder

-- Crear plataforma base visible
local platform = Instance.new("Part")
platform.Name = "StartPlatform"
platform.Size = Vector3.new(50, 2, 50)
platform.Position = Vector3.new(0, 0, 0)
platform.Anchored = true
platform.Color = Color3.fromRGB(60, 50, 55)
platform.Material = Enum.Material.Cobblestone
platform.Parent = UpsideDownFolder

-- Agregar luces en el suelo para visibilidad
for i = 1, 20 do
	local lightPart = Instance.new("Part")
	lightPart.Name = "GroundLight"
	lightPart.Size = Vector3.new(3, 1, 3)
	lightPart.Position = Vector3.new(
		math.random(-100, 100),
		1,
		math.random(-100, 100)
	)
	lightPart.Anchored = true
	lightPart.Color = Color3.fromRGB(100, 50, 150)
	lightPart.Material = Enum.Material.Neon
	lightPart.Transparency = 0.3
	lightPart.Parent = UpsideDownFolder
	
	local light = Instance.new("PointLight")
	light.Color = Color3.fromRGB(100, 50, 150)
	light.Brightness = 5
	light.Range = 40
	light.Parent = lightPart
end

-- Crear rocas y objetos en el suelo
for i = 1, 30 do
	local rock = Instance.new("Part")
	rock.Name = "Rock"
	rock.Size = Vector3.new(
		math.random(3, 8),
		math.random(3, 8),
		math.random(3, 8)
	)
	rock.Position = Vector3.new(
		math.random(-150, 150),
		rock.Size.Y/2 + 1,
		math.random(-150, 150)
	)
	rock.Anchored = true
	rock.Color = Color3.fromRGB(50, 55, 60)
	rock.Material = Enum.Material.Slate
	rock.Parent = UpsideDownFolder
end

-- Crear árboles muertos
for i = 1, 15 do
	local trunk = Instance.new("Part")
	trunk.Name = "DeadTree"
	trunk.Size = Vector3.new(2, 15, 2)
	trunk.Position = Vector3.new(
		math.random(-140, 140),
		8.5,
		math.random(-140, 140)
	)
	trunk.Anchored = true
	trunk.Color = Color3.fromRGB(40, 35, 35)
	trunk.Material = Enum.Material.Wood
	trunk.Parent = UpsideDownFolder
	
	-- Ramas
	for j = 1, 3 do
		local branch = Instance.new("Part")
		branch.Name = "Branch"
		branch.Size = Vector3.new(1, 6, 1)
		branch.Position = trunk.Position + Vector3.new(
			math.random(-3, 3),
			math.random(2, 6),
			math.random(-3, 3)
		)
		branch.Anchored = true
		branch.Color = Color3.fromRGB(40, 35, 35)
		branch.Material = Enum.Material.Wood
		branch.Parent = trunk
	end
end

-- Crear portales
createPortal(Vector3.new(30, 5, 0), Vector3.new(0, 5, 0))

print("Stranger Things Upside Down world initialized!")
print("Spawn at: 0, 1, 0")
print("Portal at: 30, 5, 0")
