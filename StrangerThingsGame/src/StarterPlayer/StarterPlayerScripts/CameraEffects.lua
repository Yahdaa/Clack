-- Efectos de cámara para el Upside Down
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Efecto de aberración cromática
local function createChromaticAberration()
	local blur = Instance.new("BlurEffect")
	blur.Size = 2
	blur.Parent = camera
	
	-- Variar el blur sutilmente
	spawn(function()
		while blur.Parent do
			local tween = TweenService:Create(blur, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
				Size = 3
			})
			tween:Play()
			wait(3)
		end
	end)
end

-- Efecto de viñeta oscura
local function createVignette()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "VignetteEffect"
	screenGui.DisplayOrder = 10
	screenGui.Parent = player:WaitForChild("PlayerGui")
	
	local vignette = Instance.new("ImageLabel")
	vignette.Name = "Vignette"
	vignette.Size = UDim2.new(1, 0, 1, 0)
	vignette.Position = UDim2.new(0, 0, 0, 0)
	vignette.BackgroundTransparency = 1
	vignette.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
	vignette.ImageColor3 = Color3.fromRGB(0, 0, 0)
	vignette.ImageTransparency = 0.3
	vignette.ScaleType = Enum.ScaleType.Stretch
	vignette.Parent = screenGui
	
	-- Pulso sutil
	spawn(function()
		while vignette.Parent do
			local pulse = TweenService:Create(vignette, TweenInfo.new(4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
				ImageTransparency = 0.5
			})
			pulse:Play()
			wait(4)
		end
	end)
end

-- Efecto de distorsión de pantalla
local function createScreenDistortion()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "DistortionEffect"
	screenGui.DisplayOrder = 5
	screenGui.Parent = player:WaitForChild("PlayerGui")
	
	-- Líneas de interferencia
	for i = 1, 5 do
		local line = Instance.new("Frame")
		line.Name = "InterferenceLine" .. i
		line.Size = UDim2.new(1, 0, 0, 2)
		line.Position = UDim2.new(0, 0, math.random(0, 100) / 100, 0)
		line.BackgroundColor3 = Color3.fromRGB(100, 150, 200)
		line.BackgroundTransparency = 0.7
		line.BorderSizePixel = 0
		line.Parent = screenGui
		
		-- Movimiento aleatorio
		spawn(function()
			while line.Parent do
				local newPos = UDim2.new(0, 0, math.random(0, 100) / 100, 0)
				local tween = TweenService:Create(line, TweenInfo.new(
					math.random(2, 5),
					Enum.EasingStyle.Linear
				), {
					Position = newPos
				})
				tween:Play()
				tween.Completed:Wait()
			end
		end)
	end
end

-- Efecto de partículas en la cámara
local function createCameraParticles()
	local attachment = Instance.new("Attachment")
	attachment.Parent = camera
	
	local particles = Instance.new("ParticleEmitter")
	particles.Name = "CameraSpores"
	particles.Texture = "rbxasset://textures/particles/smoke_main.dds"
	particles.Color = ColorSequence.new(Color3.fromRGB(60, 70, 80))
	particles.Size = NumberSequence.new(0.1, 0.3)
	particles.Transparency = NumberSequence.new(0.7, 1)
	particles.Lifetime = NumberRange.new(2, 4)
	particles.Rate = 5
	particles.Speed = NumberRange.new(1, 3)
	particles.SpreadAngle = Vector2.new(180, 180)
	particles.VelocityInheritance = 0.5
	particles.Parent = attachment
end

-- Shake sutil de cámara
local function createCameraShake()
	local originalCFrame = camera.CFrame
	
	RunService.RenderStepped:Connect(function()
		if camera.CameraType == Enum.CameraType.Custom then
			local shake = CFrame.new(
				math.random(-10, 10) / 100,
				math.random(-10, 10) / 100,
				math.random(-10, 10) / 100
			) * CFrame.Angles(
				math.rad(math.random(-5, 5) / 10),
				math.rad(math.random(-5, 5) / 10),
				math.rad(math.random(-5, 5) / 10)
			)
			
			camera.CFrame = camera.CFrame * shake
		end
	end)
end

-- Inicializar efectos
createChromaticAberration()
createVignette()
createScreenDistortion()
createCameraParticles()
createCameraShake()

print("Camera effects initialized!")
