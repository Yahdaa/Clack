-- Alexa Assistant Client
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

repeat wait() until ReplicatedStorage:FindFirstChild("RemoteEvents")
local VoiceCommand = ReplicatedStorage.RemoteEvents:WaitForChild("VoiceCommand")
local AlexaResponse = ReplicatedStorage.RemoteEvents:WaitForChild("AlexaResponse")

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AlexaUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 20)
corner.Parent = mainFrame

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🎤 ALEXA"
titleLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
titleLabel.TextSize = 28
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

-- Indicador de escucha
local listeningIndicator = Instance.new("Frame")
listeningIndicator.Name = "ListeningIndicator"
listeningIndicator.Size = UDim2.new(0, 100, 0, 100)
listeningIndicator.Position = UDim2.new(0.5, -50, 0, 70)
listeningIndicator.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
listeningIndicator.BorderSizePixel = 0
listeningIndicator.Parent = mainFrame

local indicatorCorner = Instance.new("UICorner")
indicatorCorner.CornerRadius = UDim.new(1, 0)
indicatorCorner.Parent = listeningIndicator

-- Animación de pulso
local pulseAnimation = TweenService:Create(listeningIndicator, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
	Size = UDim2.new(0, 110, 0, 110),
	BackgroundTransparency = 0.5
})

-- Input de texto
local textBox = Instance.new("TextBox")
textBox.Name = "CommandInput"
textBox.Size = UDim2.new(0.9, 0, 0, 40)
textBox.Position = UDim2.new(0.05, 0, 0, 190)
textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
textBox.BorderSizePixel = 0
textBox.Text = ""
textBox.PlaceholderText = "Escribe tu comando aquí..."
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.TextSize = 16
textBox.Font = Enum.Font.Gotham
textBox.ClearTextOnFocus = false
textBox.Parent = mainFrame

local textBoxCorner = Instance.new("UICorner")
textBoxCorner.CornerRadius = UDim.new(0, 10)
textBoxCorner.Parent = textBox

-- Botón enviar
local sendButton = Instance.new("TextButton")
sendButton.Name = "SendButton"
sendButton.Size = UDim2.new(0.9, 0, 0, 40)
sendButton.Position = UDim2.new(0.05, 0, 0, 240)
sendButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
sendButton.BorderSizePixel = 0
sendButton.Text = "ENVIAR"
sendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
sendButton.TextSize = 18
sendButton.Font = Enum.Font.GothamBold
sendButton.Parent = mainFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 10)
buttonCorner.Parent = sendButton

-- Respuesta de Alexa
local responseLabel = Instance.new("TextLabel")
responseLabel.Name = "Response"
responseLabel.Size = UDim2.new(0.9, 0, 0, 80)
responseLabel.Position = UDim2.new(0.05, 0, 1, 10)
responseLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
responseLabel.BorderSizePixel = 0
responseLabel.Text = ""
responseLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
responseLabel.TextSize = 16
responseLabel.Font = Enum.Font.Gotham
responseLabel.TextWrapped = true
responseLabel.Visible = false
responseLabel.Parent = mainFrame

local responseCorner = Instance.new("UICorner")
responseCorner.CornerRadius = UDim.new(0, 10)
responseCorner.Parent = responseLabel

-- Botón para abrir/cerrar
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 80, 0, 80)
toggleButton.Position = UDim2.new(1, -100, 1, -100)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
toggleButton.BorderSizePixel = 0
toggleButton.Text = "🎤"
toggleButton.TextSize = 40
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0)
toggleCorner.Parent = toggleButton

-- Funciones
local function sendCommand()
	local command = textBox.Text
	if command ~= "" then
		pulseAnimation:Play()
		VoiceCommand:FireServer(command)
		textBox.Text = ""
		responseLabel.Visible = false
	end
end

local function showResponse(text)
	pulseAnimation:Cancel()
	listeningIndicator.Size = UDim2.new(0, 100, 0, 100)
	listeningIndicator.BackgroundTransparency = 0
	
	responseLabel.Text = text
	responseLabel.Visible = true
	
	-- Animar respuesta
	responseLabel.Position = UDim2.new(0.05, 0, 1, 10)
	local tween = TweenService:Create(responseLabel, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.05, 0, 1, -90)
	})
	tween:Play()
	
	wait(5)
	local fadeTween = TweenService:Create(responseLabel, TweenInfo.new(0.5), {
		Position = UDim2.new(0.05, 0, 1, 10)
	})
	fadeTween:Play()
	fadeTween.Completed:Wait()
	responseLabel.Visible = false
end

-- Eventos
toggleButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
	if mainFrame.Visible then
		mainFrame.Size = UDim2.new(0, 0, 0, 0)
		local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 400, 0, 300)
		})
		tween:Play()
	end
end)

sendButton.MouseButton1Click:Connect(sendCommand)

textBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		sendCommand()
	end
end)

AlexaResponse.OnClientEvent:Connect(function(response)
	showResponse(response)
end)

-- Animación del botón toggle
spawn(function()
	while true do
		local tween = TweenService:Create(toggleButton, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
			BackgroundColor3 = Color3.fromRGB(0, 200, 255)
		})
		tween:Play()
		wait(2)
	end
end)

print("Alexa Client initialized!")
