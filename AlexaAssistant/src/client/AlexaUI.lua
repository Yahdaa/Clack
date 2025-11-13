-- Alexa Assistant UI
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Esperar RemoteEvents
repeat wait() until ReplicatedStorage:FindFirstChild("RemoteEvents")
local remoteEvents = ReplicatedStorage.RemoteEvents
local voiceCommand = remoteEvents:WaitForChild("VoiceCommand")
local alexaResponse = remoteEvents:WaitForChild("AlexaResponse")

-- Crear ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AlexaAssistant"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 500)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 35, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 20)
corner.Parent = mainFrame

-- Alexa Device (cilindro)
local alexaDevice = Instance.new("Frame")
alexaDevice.Name = "AlexaDevice"
alexaDevice.Size = UDim2.new(0, 200, 0, 250)
alexaDevice.Position = UDim2.new(0.5, -100, 0, 20)
alexaDevice.BackgroundColor3 = Color3.fromRGB(50, 55, 65)
alexaDevice.BorderSizePixel = 0
alexaDevice.Parent = mainFrame

local deviceCorner = Instance.new("UICorner")
deviceCorner.CornerRadius = UDim.new(0, 100)
deviceCorner.Parent = alexaDevice

-- Anillo LED superior
local ledRing = Instance.new("Frame")
ledRing.Name = "LEDRing"
ledRing.Size = UDim2.new(0, 180, 0, 20)
ledRing.Position = UDim2.new(0.5, -90, 0, 10)
ledRing.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
ledRing.BorderSizePixel = 0
ledRing.Parent = alexaDevice

local ledCorner = Instance.new("UICorner")
ledCorner.CornerRadius = UDim.new(0, 10)
ledCorner.Parent = ledRing

-- Botones de control
local buttonFrame = Instance.new("Frame")
buttonFrame.Size = UDim2.new(0, 120, 0, 40)
buttonFrame.Position = UDim2.new(0.5, -60, 0, 50)
buttonFrame.BackgroundTransparency = 1
buttonFrame.Parent = alexaDevice

-- Botón de micrófono
local micButton = Instance.new("TextButton")
micButton.Size = UDim2.new(0, 35, 0, 35)
micButton.Position = UDim2.new(0, 10, 0, 2.5)
micButton.BackgroundColor3 = Color3.fromRGB(70, 75, 85)
micButton.Text = "🎤"
micButton.TextSize = 16
micButton.BorderSizePixel = 0
micButton.Parent = buttonFrame

local micCorner = Instance.new("UICorner")
micCorner.CornerRadius = UDim.new(1, 0)
micCorner.Parent = micButton

-- Botón de volumen
local volButton = Instance.new("TextButton")
volButton.Size = UDim2.new(0, 35, 0, 35)
volButton.Position = UDim2.new(0, 75, 0, 2.5)
volButton.BackgroundColor3 = Color3.fromRGB(70, 75, 85)
volButton.Text = "🔊"
volButton.TextSize = 16
volButton.BorderSizePixel = 0
volButton.Parent = buttonFrame

local volCorner = Instance.new("UICorner")
volCorner.CornerRadius = UDim.new(1, 0)
volCorner.Parent = volButton

-- Pantalla de estado
local statusScreen = Instance.new("Frame")
statusScreen.Size = UDim2.new(0, 160, 0, 100)
statusScreen.Position = UDim2.new(0.5, -80, 0, 110)
statusScreen.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
statusScreen.BorderSizePixel = 0
statusScreen.Parent = alexaDevice

local screenCorner = Instance.new("UICorner")
screenCorner.CornerRadius = UDim.new(0, 10)
screenCorner.Parent = statusScreen

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -10, 1, -10)
statusText.Position = UDim2.new(0, 5, 0, 5)
statusText.BackgroundTransparency = 1
statusText.Text = "Hola, soy Alexa\n¿En qué puedo ayudarte?"
statusText.TextColor3 = Color3.fromRGB(255, 255, 255)
statusText.TextSize = 14
statusText.Font = Enum.Font.Gotham
statusText.TextWrapped = true
statusText.Parent = statusScreen

-- Chat de conversación
local chatFrame = Instance.new("ScrollingFrame")
chatFrame.Name = "ChatFrame"
chatFrame.Size = UDim2.new(1, -20, 0, 180)
chatFrame.Position = UDim2.new(0, 10, 0, 280)
chatFrame.BackgroundColor3 = Color3.fromRGB(40, 45, 55)
chatFrame.BorderSizePixel = 0
chatFrame.ScrollBarThickness = 6
chatFrame.Parent = mainFrame

local chatCorner = Instance.new("UICorner")
chatCorner.CornerRadius = UDim.new(0, 10)
chatCorner.Parent = chatFrame

local chatLayout = Instance.new("UIListLayout")
chatLayout.SortOrder = Enum.SortOrder.LayoutOrder
chatLayout.Padding = UDim.new(0, 5)
chatLayout.Parent = chatFrame

-- Input de texto
local inputFrame = Instance.new("Frame")
inputFrame.Size = UDim2.new(1, -20, 0, 40)
inputFrame.Position = UDim2.new(0, 10, 1, -50)
inputFrame.BackgroundColor3 = Color3.fromRGB(50, 55, 65)
inputFrame.BorderSizePixel = 0
inputFrame.Parent = mainFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 10)
inputCorner.Parent = inputFrame

local textInput = Instance.new("TextBox")
textInput.Size = UDim2.new(1, -50, 1, -10)
textInput.Position = UDim2.new(0, 5, 0, 5)
textInput.BackgroundTransparency = 1
textInput.Text = ""
textInput.PlaceholderText = "Escribe o habla con Alexa..."
textInput.TextColor3 = Color3.fromRGB(255, 255, 255)
textInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
textInput.TextSize = 14
textInput.Font = Enum.Font.Gotham
textInput.Parent = inputFrame

local sendButton = Instance.new("TextButton")
sendButton.Size = UDim2.new(0, 35, 0, 30)
sendButton.Position = UDim2.new(1, -40, 0, 5)
sendButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
sendButton.Text = "➤"
sendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
sendButton.TextSize = 16
sendButton.BorderSizePixel = 0
sendButton.Parent = inputFrame

local sendCorner = Instance.new("UICorner")
sendCorner.CornerRadius = UDim.new(0, 8)
sendCorner.Parent = sendButton

-- Variables
local isListening = false
local chatMessages = {}

-- Animaciones LED
local function animateLED(color, pattern)
    if pattern == "listening" then
        local tween = TweenService:Create(ledRing, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
            BackgroundColor3 = color
        })
        tween:Play()
        return tween
    elseif pattern == "thinking" then
        spawn(function()
            for i = 1, 10 do
                ledRing.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
                wait(0.1)
                ledRing.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
                wait(0.1)
            end
        end)
    elseif pattern == "speaking" then
        ledRing.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    else
        ledRing.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    end
end

-- Agregar mensaje al chat
local function addMessage(sender, message, isUser)
    local msgFrame = Instance.new("Frame")
    msgFrame.Size = UDim2.new(1, -10, 0, 60)
    msgFrame.BackgroundColor3 = isUser and Color3.fromRGB(0, 120, 200) or Color3.fromRGB(60, 65, 75)
    msgFrame.BorderSizePixel = 0
    msgFrame.Parent = chatFrame
    
    local msgCorner = Instance.new("UICorner")
    msgCorner.CornerRadius = UDim.new(0, 8)
    msgCorner.Parent = msgFrame
    
    local senderLabel = Instance.new("TextLabel")
    senderLabel.Size = UDim2.new(1, -10, 0, 20)
    senderLabel.Position = UDim2.new(0, 5, 0, 2)
    senderLabel.BackgroundTransparency = 1
    senderLabel.Text = sender
    senderLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    senderLabel.TextSize = 12
    senderLabel.Font = Enum.Font.GothamBold
    senderLabel.TextXAlignment = Enum.TextXAlignment.Left
    senderLabel.Parent = msgFrame
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -10, 0, 35)
    messageLabel.Position = UDim2.new(0, 5, 0, 20)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message
    messageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    messageLabel.TextSize = 14
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextWrapped = true
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.Parent = msgFrame
    
    chatFrame.CanvasSize = UDim2.new(0, 0, 0, chatLayout.AbsoluteContentSize.Y)
    chatFrame.CanvasPosition = Vector2.new(0, chatFrame.CanvasSize.Y.Offset)
end

-- Procesar comando
local function processCommand(command)
    addMessage("Tú", command, true)
    animateLED(Color3.fromRGB(255, 150, 0), "thinking")
    statusText.Text = "Procesando..."
    
    voiceCommand:FireServer(command)
end

-- Eventos
sendButton.MouseButton1Click:Connect(function()
    if textInput.Text ~= "" then
        processCommand(textInput.Text)
        textInput.Text = ""
    end
end)

textInput.FocusLost:Connect(function(enterPressed)
    if enterPressed and textInput.Text ~= "" then
        processCommand(textInput.Text)
        textInput.Text = ""
    end
end)

micButton.MouseButton1Click:Connect(function()
    if not isListening then
        isListening = true
        micButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        animateLED(Color3.fromRGB(255, 50, 50), "listening")
        statusText.Text = "Escuchando..."
        
        -- Simular reconocimiento de voz
        wait(3)
        isListening = false
        micButton.BackgroundColor3 = Color3.fromRGB(70, 75, 85)
        processCommand("Comando de voz simulado")
    end
end)

-- Respuesta de Alexa
alexaResponse.OnClientEvent:Connect(function(response)
    animateLED(Color3.fromRGB(0, 255, 150), "speaking")
    statusText.Text = "Respondiendo..."
    addMessage("Alexa", response, false)
    
    wait(2)
    animateLED(Color3.fromRGB(0, 150, 255), "idle")
    statusText.Text = "¿En qué más puedo ayudarte?"
end)

-- Inicializar
addMessage("Alexa", "¡Hola! Soy tu asistente Alexa. Puedes hablarme o escribirme.", false)
animateLED(Color3.fromRGB(0, 150, 255), "idle")

print("Alexa Assistant UI loaded!")