-- Stranger Things Obby - Client UI
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

repeat wait() until ReplicatedStorage:FindFirstChild("RemoteEvents")
local LevelUpdate = ReplicatedStorage.RemoteEvents:WaitForChild("LevelUpdate")

-- Crear GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ObbyUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 350, 0, 120)
mainFrame.Position = UDim2.new(0.5, -175, 0, 20)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = mainFrame

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 35)
titleLabel.Position = UDim2.new(0, 0, 0, 5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "STRANGER THINGS OBBY"
titleLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
titleLabel.TextSize = 20
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

-- Nivel actual
local levelLabel = Instance.new("TextLabel")
levelLabel.Name = "LevelLabel"
levelLabel.Size = UDim2.new(1, -20, 0, 30)
levelLabel.Position = UDim2.new(0, 10, 0, 45)
levelLabel.BackgroundTransparency = 1
levelLabel.Text = "NIVEL: 1"
levelLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
levelLabel.TextSize = 24
levelLabel.Font = Enum.Font.GothamBold
levelLabel.TextXAlignment = Enum.TextXAlignment.Left
levelLabel.Parent = mainFrame

-- Barra de progreso
local progressBarBg = Instance.new("Frame")
progressBarBg.Name = "ProgressBarBg"
progressBarBg.Size = UDim2.new(1, -20, 0, 20)
progressBarBg.Position = UDim2.new(0, 10, 0, 85)
progressBarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
progressBarBg.BorderSizePixel = 0
progressBarBg.Parent = mainFrame

local progressBarCorner = Instance.new("UICorner")
progressBarCorner.CornerRadius = UDim.new(0, 10)
progressBarCorner.Parent = progressBarBg

local progressBar = Instance.new("Frame")
progressBar.Name = "ProgressBar"
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
progressBar.BorderSizePixel = 0
progressBar.Parent = progressBarBg

local progressBarCorner2 = Instance.new("UICorner")
progressBarCorner2.CornerRadius = UDim.new(0, 10)
progressBarCorner2.Parent = progressBar

-- Texto de progreso
local progressText = Instance.new("TextLabel")
progressText.Name = "ProgressText"
progressText.Size = UDim2.new(1, 0, 1, 0)
progressText.BackgroundTransparency = 1
progressText.Text = "0%"
progressText.TextColor3 = Color3.fromRGB(255, 255, 255)
progressText.TextSize = 14
progressText.Font = Enum.Font.GothamBold
progressText.ZIndex = 2
progressText.Parent = progressBarBg

-- Notificación de nivel
local function showLevelNotification(level)
	local notification = Instance.new("Frame")
	notification.Name = "Notification"
	notification.Size = UDim2.new(0, 300, 0, 80)
	notification.Position = UDim2.new(0.5, -150, 0.5, -40)
	notification.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
	notification.BackgroundTransparency = 0.1
	notification.BorderSizePixel = 0
	notification.Parent = screenGui
	
	local notifCorner = Instance.new("UICorner")
	notifCorner.CornerRadius = UDim.new(0, 15)
	notifCorner.Parent = notification
	
	local notifText = Instance.new("TextLabel")
	notifText.Size = UDim2.new(1, 0, 1, 0)
	notifText.BackgroundTransparency = 1
	notifText.Text = "¡NIVEL " .. level .. " COMPLETADO!"
	notifText.TextColor3 = Color3.fromRGB(255, 255, 255)
	notifText.TextSize = 24
	notifText.Font = Enum.Font.GothamBold
	notifText.Parent = notification
	
	-- Animación
	notification.Size = UDim2.new(0, 0, 0, 0)
	local expandTween = TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 300, 0, 80)
	})
	expandTween:Play()
	
	wait(2)
	
	local fadeTween = TweenService:Create(notification, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		BackgroundTransparency = 1
	})
	local textFadeTween = TweenService:Create(notifText, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		TextTransparency = 1
	})
	fadeTween:Play()
	textFadeTween:Play()
	
	wait(0.5)
	notification:Destroy()
end

-- Actualizar UI
local currentLevel = 1
local function updateUI(level)
	if level > currentLevel then
		showLevelNotification(level)
		currentLevel = level
	end
	
	levelLabel.Text = "NIVEL: " .. level
	
	-- Animar barra de progreso
	local targetSize = math.min((level % 10) / 10, 1)
	if level % 10 == 0 then targetSize = 1 end
	
	local tween = TweenService:Create(progressBar, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.new(targetSize, 0, 1, 0)
	})
	tween:Play()
	
	progressText.Text = math.floor(targetSize * 100) .. "%"
end

-- Escuchar actualizaciones
LevelUpdate.OnClientEvent:Connect(function(level)
	updateUI(level)
end)

-- Efecto de parpadeo en el título
spawn(function()
	while true do
		local tween = TweenService:Create(titleLabel, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
			TextColor3 = Color3.fromRGB(255, 150, 150)
		})
		tween:Play()
		wait(1)
	end
end)

print("Obby UI initialized!")
