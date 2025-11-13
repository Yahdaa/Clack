-- Sistema de relámpagos rojos del Upside Down
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local workspace = game:GetService("Workspace")

-- Crear efecto de relámpago
local function createLightning()
	-- Flash de luz roja
	local originalAmbient = Lighting.Ambient
	local originalOutdoorAmbient = Lighting.OutdoorAmbient
	
	Lighting.Ambient = Color3.fromRGB(100, 20, 20)
	Lighting.OutdoorAmbient = Color3.fromRGB(80, 15, 15)
	
	-- Crear rayo visual
	local startPos = Vector3.new(
		math.random(-200, 200),
		100,
		math.random(-200, 200)
	)
	local endPos = Vector3.new(
		startPos.X + math.random(-20, 20),
		0,
		startPos.Z + math.random(-20, 20)
	)
	
	local distance = (endPos - startPos).Magnitude
	local midPoint = (startPos + endPos) / 2
	
	local bolt = Instance.new("Part")
	bolt.Name = "LightningBolt"
	bolt.Size = Vector3.new(1, distance, 1)
	bolt.CFrame = CFrame.new(midPoint, endPos)
	bolt.Anchored = true
	bolt.CanCollide = false
	bolt.Color = Color3.fromRGB(200, 50, 50)
	bolt.Material = Enum.Material.Neon
	bolt.Transparency = 0.3
	bolt.Parent = workspace
	
	-- Mesh del rayo
	local mesh = Instance.new("CylinderMesh")
	mesh.Scale = Vector3.new(0.5, 1, 0.5)
	mesh.Parent = bolt
	
	-- Luz del impacto
	local impactLight = Instance.new("Part")
	impactLight.Name = "ImpactLight"
	impactLight.Size = Vector3.new(20, 20, 20)
	impactLight.Position = endPos + Vector3.new(0, 10, 0)
	impactLight.Anchored = true
	impactLight.CanCollide = false
	impactLight.Transparency = 0.5
	impactLight.Color = Color3.fromRGB(200, 50, 50)
	impactLight.Material = Enum.Material.Neon
	impactLight.Shape = Enum.PartType.Ball
	impactLight.Parent = workspace
	
	local pointLight = Instance.new("PointLight")
	pointLight.Color = Color3.fromRGB(200, 50, 50)
	pointLight.Brightness = 10
	pointLight.Range = 100
	pointLight.Parent = impactLight
	
	-- Partículas del impacto
	local attachment = Instance.new("Attachment")
	attachment.Parent = impactLight
	
	local particles = Instance.new("ParticleEmitter")
	particles.Texture = "rbxasset://textures/particles/sparkles_main.dds"
	particles.Color = ColorSequence.new(Color3.fromRGB(200, 50, 50))
	particles.Size = NumberSequence.new(2, 5)
	particles.Transparency = NumberSequence.new(0, 1)
	particles.Lifetime = NumberRange.new(0.5, 1)
	particles.Rate = 500
	particles.Speed = NumberRange.new(10, 20)
	particles.SpreadAngle = Vector2.new(180, 180)
	particles.Enabled = true
	particles.Parent = attachment
	
	-- Sonido de trueno (simulado)
	local thunder = Instance.new("Sound")
	thunder.SoundId = "rbxasset://sounds/Rocket shot.wav"
	thunder.Volume = 0.5
	thunder.Parent = impactLight
	thunder:Play()
	
	-- Eliminar después de un momento
	wait(0.1)
	particles.Enabled = false
	
	wait(0.2)
	Lighting.Ambient = originalAmbient
	Lighting.OutdoorAmbient = originalOutdoorAmbient
	
	game:GetService("Debris"):AddItem(bolt, 0.5)
	game:GetService("Debris"):AddItem(impactLight, 2)
end

-- Generar relámpagos aleatorios
spawn(function()
	while true do
		wait(math.random(10, 25))
		createLightning()
	end
end)

print("Lightning system initialized!")
