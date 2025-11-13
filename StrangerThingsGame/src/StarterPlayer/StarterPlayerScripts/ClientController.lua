-- Client Controller para Stranger Things Upside Down
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera

-- Esperar eventos remotos
repeat wait() until ReplicatedStorage:FindFirstChild("RemoteEvents")
local PowerEvent = ReplicatedStorage.RemoteEvents:WaitForChild("ElevenPower")

-- Variables de poderes
local powerCooldown = false
local currentPower = "Telekinesis"

-- Crear GUI de poderes
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PowersGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(1, -320, 1, -220)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.3
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = mainFrame

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "PODERES DE ELEVEN"
titleLabel.TextColor3 = Color3.fromRGB(200, 100, 255)
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

-- Botón Telequinesis
local telekinesisBtn = Instance.new("TextButton")
telekinesisBtn.Name = "TelekinesisButton"
telekinesisBtn.Size = UDim2.new(0.9, 0, 0, 35)
telekinesisBtn.Position = UDim2.new(0.05, 0, 0, 50)
telekinesisBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 150)
telekinesisBtn.Text = "[Q] Telequinesis"
telekinesisBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
telekinesisBtn.TextSize = 16
telekinesisBtn.Font = Enum.Font.Gotham
telekinesisBtn.Parent = mainFrame

local btnCorner1 = Instance.new("UICorner")
btnCorner1.CornerRadius = UDim.new(0, 8)
btnCorner1.Parent = telekinesisBtn

-- Botón Mind Blast
local mindBlastBtn = Instance.new("TextButton")
mindBlastBtn.Name = "MindBlastButton"
mindBlastBtn.Size = UDim2.new(0.9, 0, 0, 35)
mindBlastBtn.Position = UDim2.new(0.05, 0, 0, 95)
mindBlastBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 100)
mindBlastBtn.Text = "[E] Onda Mental"
mindBlastBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
mindBlastBtn.TextSize = 16
mindBlastBtn.Font = Enum.Font.Gotham
mindBlastBtn.Parent = mainFrame

local btnCorner2 = Instance.new("UICorner")
btnCorner2.CornerRadius = UDim.new(0, 8)
btnCorner2.Parent = mindBlastBtn

-- Botón Levitación
local levitationBtn = Instance.new("TextButton")
levitationBtn.Name = "LevitationButton"
levitationBtn.Size = UDim2.new(0.9, 0, 0, 35)
levitationBtn.Position = UDim2.new(0.05, 0, 0, 140)
levitationBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
levitationBtn.Text = "[R] Levitación"
levitationBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
levitationBtn.TextSize = 16
levitationBtn.Font = Enum.Font.Gotham
levitationBtn.Parent = mainFrame

local btnCorner3 = Instance.new("UICorner")
btnCorner3.CornerRadius = UDim.new(0, 8)
btnCorner3.Parent = levitationBtn

-- Efecto de sangrado de nariz cuando usa poderes
local function createNoseBleedEffect()
	local head = character:FindFirstChild("Head")
	if not head then return end
	
	-- Partículas de sangre
	local bloodParticles = Instance.new("ParticleEmitter")
	bloodParticles.Name = "NoseBleed"
	bloodParticles.Texture = "rbxasset://textures/particles/smoke_main.dds"
	bloodParticles.Color = ColorSequence.new(Color3.fromRGB(150, 0, 0))
	bloodParticles.Size = NumberSequence.new(0.1, 0.3)
	bloodParticles.Transparency = NumberSequence.new(0, 1)
	bloodParticles.Lifetime = NumberRange.new(0.5, 1)
	bloodParticles.Rate = 20
	bloodParticles.Speed = NumberRange.new(1, 2)
	bloodParticles.SpreadAngle = Vector2.new(30, 30)
	bloodParticles.Parent = head
	
	wait(2)
	bloodParticles:Destroy()
end

-- Efecto visual de uso de poder
local function createPowerAura()
	local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
	if not torso then return end
	
	-- Aura de energía
	local aura = Instance.new("Part")
	aura.Name = "PowerAura"
	aura.Size = Vector3.new(6, 6, 6)
	aura.CFrame = torso.CFrame
	aura.Anchored = true
	aura.CanCollide = false
	aura.Transparency = 0.7
	aura.Color = Color3.fromRGB(200, 100, 255)
	aura.Material = Enum.Material.Neon
	aura.Shape = Enum.PartType.Ball
	aura.Parent = workspace
	
	-- Seguir al jugador
	local connection
	connection = RunService.RenderStepped:Connect(function()
		if aura.Parent and torso.Parent then
			aura.CFrame = torso.CFrame
		else
			connection:Disconnect()
		end
	end)
	
	-- Partículas de energía
	local particles = Instance.new("ParticleEmitter")
	particles.Texture = "rbxasset://textures/particles/sparkles_main.dds"
	particles.Color = ColorSequence.new(Color3.fromRGB(200, 100, 255))
	particles.Size = NumberSequence.new(0.5, 1)
	particles.Transparency = NumberSequence.new(0, 1)
	particles.Lifetime = NumberRange.new(0.5, 1)
	particles.Rate = 50
	particles.Speed = NumberRange.new(3, 6)
	particles.SpreadAngle = Vector2.new(180, 180)
	particles.Parent = aura
	
	-- Pulso de aura
	local pulseTween = TweenService:Create(aura, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
		Size = Vector3.new(7, 7, 7),
		Transparency = 0.9
	})
	pulseTween:Play()
	
	wait(2)
	connection:Disconnect()
	aura:Destroy()
end

-- Función para usar telequinesis
local function useTelekinesis()
	if powerCooldown then return end
	powerCooldown = true
	
	-- Obtener posición del mouse en el mundo
	local mouse = player:GetMouse()
	local targetPosition = mouse.Hit.Position
	
	-- Efectos visuales locales
	createPowerAura()
	createNoseBleedEffect()
	
	-- Enviar al servidor
	PowerEvent:FireServer("Telekinesis", targetPosition)
	
	-- Efecto de cámara shake
	local originalCFrame = camera.CFrame
	spawn(function()
		for i = 1, 10 do
			camera.CFrame = originalCFrame * CFrame.new(
				math.random(-1, 1) * 0.1,
				math.random(-1, 1) * 0.1,
				math.random(-1, 1) * 0.1
			)
			wait(0.05)
		end
		camera.CFrame = originalCFrame
	end)
	
	wait(3)
	powerCooldown = false
end

-- Función para usar onda mental
local function useMindBlast()
	if powerCooldown then return end
	powerCooldown = true
	
	createPowerAura()
	createNoseBleedEffect()
	
	PowerEvent:FireServer("MindBlast", humanoidRootPart.Position)
	
	-- Efecto de cámara
	local originalFOV = camera.FieldOfView
	local fovTween = TweenService:Create(camera, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		FieldOfView = 90
	})
	fovTween:Play()
	fovTween.Completed:Wait()
	
	local fovReturn = TweenService:Create(camera, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		FieldOfView = originalFOV
	})
	fovReturn:Play()
	
	wait(5)
	powerCooldown = false
end

-- Función para levitación
local function useLevitation()
	if powerCooldown then return end
	powerCooldown = true
	
	createPowerAura()
	createNoseBleedEffect()
	
	PowerEvent:FireServer("Levitation", humanoidRootPart.Position)
	
	wait(4)
	powerCooldown = false
end

-- Input handling
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if input.KeyCode == Enum.KeyCode.Q then
		useTelekinesis()
	elseif input.KeyCode == Enum.KeyCode.E then
		useMindBlast()
	elseif input.KeyCode == Enum.KeyCode.R then
		useLevitation()
	end
end)

-- Botones GUI
telekinesisBtn.MouseButton1Click:Connect(useTelekinesis)
mindBlastBtn.MouseButton1Click:Connect(useMindBlast)
levitationBtn.MouseButton1Click:Connect(useLevitation)

-- Efectos ambientales del cliente
local function createAmbientParticles()
	-- Partículas flotantes en el aire
	local attachment = Instance.new("Attachment")
	attachment.Parent = humanoidRootPart
	
	local floatingParticles = Instance.new("ParticleEmitter")
	floatingParticles.Name = "AmbientSpores"
	floatingParticles.Texture = "rbxasset://textures/particles/smoke_main.dds"
	floatingParticles.Color = ColorSequence.new(Color3.fromRGB(50, 60, 70))
	floatingParticles.Size = NumberSequence.new(0.3, 0.8)
	floatingParticles.Transparency = NumberSequence.new(0.6, 1)
	floatingParticles.Lifetime = NumberRange.new(5, 8)
	floatingParticles.Rate = 3
	floatingParticles.Speed = NumberRange.new(0.5, 1.5)
	floatingParticles.SpreadAngle = Vector2.new(180, 180)
	floatingParticles.Drag = 1
	floatingParticles.Parent = attachment
end

createAmbientParticles()

-- Sonido ambiental (simulado con efectos)
local ambientSound = Instance.new("Sound")
ambientSound.Name = "UpsideDownAmbient"
ambientSound.SoundId = "rbxasset://sounds/uuhhh.mp3"
ambientSound.Volume = 0.3
ambientSound.Looped = true
ambientSound.Parent = humanoidRootPart
ambientSound:Play()

print("Client controller initialized - Poderes de Eleven activados!")
