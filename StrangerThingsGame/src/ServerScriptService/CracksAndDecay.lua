-- Sistema de grietas y deterioro del Upside Down
local TweenService = game:GetService("TweenService")
local workspace = game:GetService("Workspace")

local UpsideDownFolder = workspace:WaitForChild("UpsideDown")

-- Crear grietas en el suelo
local function createGroundCrack(position, size)
	local crack = Instance.new("Part")
	crack.Name = "GroundCrack"
	crack.Size = Vector3.new(size.X, 0.1, size.Z)
	crack.Position = position
	crack.Anchored = true
	crack.CanCollide = false
	crack.Color = Color3.fromRGB(15, 10, 15)
	crack.Material = Enum.Material.Slate
	crack.Transparency = 0.3
	crack.Parent = UpsideDownFolder
	
	-- Decal de grieta
	local decal = Instance.new("Decal")
	decal.Texture = "rbxasset://textures/face.png"
	decal.Face = Enum.NormalId.Top
	decal.Transparency = 0.5
	decal.Color3 = Color3.fromRGB(20, 15, 20)
	decal.Parent = crack
	
	-- Luz roja emanando de la grieta
	local light = Instance.new("PointLight")
	light.Color = Color3.fromRGB(150, 50, 50)
	light.Brightness = 1
	light.Range = 15
	light.Parent = crack
	
	-- Efecto pulsante de luz (optimizado)
	local pulse = TweenService:Create(light, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
		Brightness = 2
	})
	pulse:Play()
	
	-- Partículas de humo saliendo
	local attachment = Instance.new("Attachment")
	attachment.Parent = crack
	
	local smoke = Instance.new("ParticleEmitter")
	smoke.Texture = "rbxasset://textures/particles/smoke_main.dds"
	smoke.Color = ColorSequence.new(Color3.fromRGB(30, 20, 25))
	smoke.Size = NumberSequence.new(2, 4)
	smoke.Transparency = NumberSequence.new(0.5, 1)
	smoke.Lifetime = NumberRange.new(3, 5)
	smoke.Rate = 5
	smoke.Speed = NumberRange.new(1, 3)
	smoke.EmissionDirection = Enum.NormalId.Top
	smoke.Parent = attachment
	
	return crack
end

-- Crear paredes con textura orgánica
local function createOrganicWall(position, size)
	local wall = Instance.new("Part")
	wall.Name = "OrganicWall"
	wall.Size = size
	wall.Position = position
	wall.Anchored = true
	wall.Color = Color3.fromRGB(30, 25, 30)
	wall.Material = Enum.Material.Slate
	wall.Parent = UpsideDownFolder
	
	-- Textura de venas
	for i = 1, math.random(3, 6) do
		local vein = Instance.new("Part")
		vein.Name = "Vein"
		vein.Size = Vector3.new(0.3, size.Y * 0.8, 0.3)
		vein.Position = position + Vector3.new(
			math.random(-size.X/2, size.X/2),
			0,
			size.Z/2 + 0.2
		)
		vein.Anchored = true
		vein.CanCollide = false
		vein.Color = Color3.fromRGB(50, 30, 40)
		vein.Material = Enum.Material.Neon
		vein.Transparency = 0.3
		vein.Parent = wall
		
		-- Pulso de venas (optimizado)
		local pulse = TweenService:Create(vein, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
			Transparency = 0.6,
			Color = Color3.fromRGB(70, 40, 50)
		})
		pulse:Play()
	end
	
	return wall
end

-- Crear nidos orgánicos
local function createOrganicNest(position)
	local nest = Instance.new("Part")
	nest.Name = "OrganicNest"
	nest.Size = Vector3.new(8, 4, 8)
	nest.Position = position
	nest.Anchored = true
	nest.Color = Color3.fromRGB(35, 30, 35)
	nest.Material = Enum.Material.Slate
	nest.Shape = Enum.PartType.Ball
	nest.Parent = UpsideDownFolder
	
	-- Mesh especial
	local mesh = Instance.new("SpecialMesh")
	mesh.MeshType = Enum.MeshType.Sphere
	mesh.Scale = Vector3.new(1, 0.5, 1)
	mesh.Parent = nest
	
	-- Partículas de esporas
	local attachment = Instance.new("Attachment")
	attachment.Parent = nest
	
	local spores = Instance.new("ParticleEmitter")
	spores.Texture = "rbxasset://textures/particles/smoke_main.dds"
	spores.Color = ColorSequence.new(Color3.fromRGB(50, 60, 40))
	spores.Size = NumberSequence.new(0.5, 1.5)
	spores.Transparency = NumberSequence.new(0.4, 1)
	spores.Lifetime = NumberRange.new(4, 6)
	spores.Rate = 10
	spores.Speed = NumberRange.new(1, 3)
	spores.SpreadAngle = Vector2.new(180, 180)
	spores.Parent = attachment
	
	-- Luz pulsante
	local light = Instance.new("PointLight")
	light.Color = Color3.fromRGB(60, 70, 50)
	light.Brightness = 1.5
	light.Range = 20
	light.Parent = nest
	
	local pulse = TweenService:Create(light, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
		Brightness = 2.5
	})
	pulse:Play()
	
	return nest
end

-- Crear rocas flotantes
local function createFloatingRock(position, size)
	local rock = Instance.new("Part")
	rock.Name = "FloatingRock"
	rock.Size = size
	rock.Position = position
	rock.Anchored = true
	rock.Color = Color3.fromRGB(40, 45, 50)
	rock.Material = Enum.Material.Slate
	rock.Parent = UpsideDownFolder
	
	-- Partículas de polvo
	local attachment = Instance.new("Attachment")
	attachment.Parent = rock
	
	local dust = Instance.new("ParticleEmitter")
	dust.Texture = "rbxasset://textures/particles/smoke_main.dds"
	dust.Color = ColorSequence.new(Color3.fromRGB(50, 55, 60))
	dust.Size = NumberSequence.new(0.3, 0.6)
	dust.Transparency = NumberSequence.new(0.6, 1)
	dust.Lifetime = NumberRange.new(2, 4)
	dust.Rate = 3
	dust.Speed = NumberRange.new(0.5, 1)
	dust.SpreadAngle = Vector2.new(180, 180)
	dust.Parent = attachment
	
	-- Movimiento flotante (optimizado)
	local originalPos = position
	local RunService = game:GetService("RunService")
	RunService.Heartbeat:Connect(function()
		if not rock.Parent then return end
		local offset = Vector3.new(
			math.sin(tick() * 0.5) * 2,
			math.sin(tick() * 0.3) * 1,
			math.cos(tick() * 0.5) * 2
		)
		rock.Position = originalPos + offset
	end)
	
	return rock
end

-- Generar grietas en el suelo
for i = 1, 15 do
	local crackPos = Vector3.new(
		math.random(-200, 200),
		0.5,
		math.random(-200, 200)
	)
	local crackSize = Vector3.new(
		math.random(5, 15),
		0.1,
		math.random(5, 15)
	)
	createGroundCrack(crackPos, crackSize)
end

-- Generar paredes orgánicas
for i = 1, 8 do
	local wallPos = Vector3.new(
		math.random(-180, 180),
		math.random(10, 20),
		math.random(-180, 180)
	)
	local wallSize = Vector3.new(
		math.random(15, 25),
		math.random(20, 35),
		2
	)
	createOrganicWall(wallPos, wallSize)
end

-- Generar nidos orgánicos
for i = 1, 6 do
	local nestPos = Vector3.new(
		math.random(-170, 170),
		math.random(2, 8),
		math.random(-170, 170)
	)
	createOrganicNest(nestPos)
end

-- Generar rocas flotantes
for i = 1, 12 do
	local rockPos = Vector3.new(
		math.random(-190, 190),
		math.random(15, 35),
		math.random(-190, 190)
	)
	local rockSize = Vector3.new(
		math.random(3, 8),
		math.random(3, 8),
		math.random(3, 8)
	)
	createFloatingRock(rockPos, rockSize)
end

print("Cracks and decay system initialized!")
