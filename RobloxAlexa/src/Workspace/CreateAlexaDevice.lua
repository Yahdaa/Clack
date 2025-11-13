-- Script para crear el dispositivo Alexa en el Workspace
local TweenService = game:GetService("TweenService")

-- Crear modelo de Alexa
local alexaModel = Instance.new("Model")
alexaModel.Name = "AlexaDevice"
alexaModel.Parent = workspace

-- Base del dispositivo
local base = Instance.new("Part")
base.Name = "Base"
base.Size = Vector3.new(4, 6, 4)
base.Position = Vector3.new(0, 3, 0)
base.Anchored = true
base.Color = Color3.fromRGB(30, 30, 35)
base.Material = Enum.Material.SmoothPlastic
base.Shape = Enum.PartType.Cylinder
base.Parent = alexaModel

-- Mesh para forma cilíndrica
local mesh = Instance.new("SpecialMesh")
mesh.MeshType = Enum.MeshType.Cylinder
mesh.Scale = Vector3.new(1, 1, 1)
mesh.Parent = base

-- Anillo de luz superior
local lightRing = Instance.new("Part")
lightRing.Name = "LightRing"
lightRing.Size = Vector3.new(4.2, 0.3, 4.2)
lightRing.Position = Vector3.new(0, 6.2, 0)
lightRing.Anchored = true
lightRing.Color = Color3.fromRGB(0, 255, 200)
lightRing.Material = Enum.Material.Neon
lightRing.Transparency = 0.5
lightRing.Shape = Enum.PartType.Cylinder
lightRing.Parent = alexaModel

-- Luz ambiental
local pointLight = Instance.new("PointLight")
pointLight.Color = Color3.fromRGB(0, 255, 200)
pointLight.Brightness = 3
pointLight.Range = 20
pointLight.Parent = lightRing

-- Logo de Alexa (círculo frontal)
local logo = Instance.new("Part")
logo.Name = "Logo"
logo.Size = Vector3.new(0.1, 2, 2)
logo.Position = Vector3.new(0, 3, 2.1)
logo.Anchored = true
logo.Color = Color3.fromRGB(0, 150, 255)
logo.Material = Enum.Material.Neon
logo.Transparency = 0.3
logo.Parent = alexaModel

-- Decal del logo
local surfaceGui = Instance.new("SurfaceGui")
surfaceGui.Face = Enum.NormalId.Front
surfaceGui.Parent = logo

local logoText = Instance.new("TextLabel")
logoText.Size = UDim2.new(1, 0, 1, 0)
logoText.BackgroundTransparency = 1
logoText.Text = "🎤"
logoText.TextColor3 = Color3.fromRGB(255, 255, 255)
logoText.TextScaled = true
logoText.Font = Enum.Font.GothamBold
logoText.Parent = surfaceGui

-- Botones físicos en la parte superior
for i = 1, 4 do
	local button = Instance.new("Part")
	button.Name = "Button" .. i
	button.Size = Vector3.new(0.8, 0.3, 0.8)
	local angle = (i - 1) * (math.pi / 2)
	button.Position = Vector3.new(math.sin(angle) * 1.2, 6.5, math.cos(angle) * 1.2)
	button.Anchored = true
	button.Color = Color3.fromRGB(50, 50, 55)
	button.Material = Enum.Material.SmoothPlastic
	button.Shape = Enum.PartType.Cylinder
	button.Parent = alexaModel
	
	-- ClickDetector para interacción
	local clickDetector = Instance.new("ClickDetector")
	clickDetector.MaxActivationDistance = 10
	clickDetector.Parent = button
end

-- Establecer PrimaryPart
alexaModel.PrimaryPart = base

-- Animación de respiración del anillo de luz
spawn(function()
	while lightRing.Parent do
		local tween = TweenService:Create(lightRing, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
			Transparency = 0.8
		})
		tween:Play()
		
		local lightTween = TweenService:Create(pointLight, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
			Brightness = 5
		})
		lightTween:Play()
		
		wait(2)
	end
end)

-- Animación de rotación sutil
spawn(function()
	while base.Parent do
		base.CFrame = base.CFrame * CFrame.Angles(0, math.rad(0.5), 0)
		lightRing.CFrame = lightRing.CFrame * CFrame.Angles(0, math.rad(0.5), 0)
		logo.CFrame = logo.CFrame * CFrame.Angles(0, math.rad(0.5), 0)
		wait()
	end
end)

-- Partículas de sonido
local attachment = Instance.new("Attachment")
attachment.Parent = lightRing

local particles = Instance.new("ParticleEmitter")
particles.Texture = "rbxasset://textures/particles/sparkles_main.dds"
particles.Color = ColorSequence.new(Color3.fromRGB(0, 200, 255))
particles.Size = NumberSequence.new(0.3, 0)
particles.Transparency = NumberSequence.new(0, 1)
particles.Lifetime = NumberRange.new(1, 2)
particles.Rate = 10
particles.Speed = NumberRange.new(2, 4)
particles.SpreadAngle = Vector2.new(180, 180)
particles.Parent = attachment

print("Alexa Device created in workspace!")
