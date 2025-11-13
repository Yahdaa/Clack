-- Alexa Device 3D Model
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

-- Crear el dispositivo Alexa físico
local alexaModel = Instance.new("Model")
alexaModel.Name = "AlexaDevice"
alexaModel.Parent = workspace

-- Base cilíndrica
local base = Instance.new("Part")
base.Name = "Base"
base.Size = Vector3.new(4, 6, 4)
base.Position = Vector3.new(0, 3, 0)
base.Anchored = true
base.Shape = Enum.PartType.Cylinder
base.Material = Enum.Material.Plastic
base.BrickColor = BrickColor.new("Really black")
base.Parent = alexaModel

-- Anillo LED
local ledRing = Instance.new("Part")
ledRing.Name = "LEDRing"
ledRing.Size = Vector3.new(4.2, 0.2, 4.2)
ledRing.Position = Vector3.new(0, 6.1, 0)
ledRing.Anchored = true
ledRing.Shape = Enum.PartType.Cylinder
ledRing.Material = Enum.Material.Neon
ledRing.BrickColor = BrickColor.new("Cyan")
ledRing.Parent = alexaModel

local pointLight = Instance.new("PointLight")
pointLight.Color = Color3.fromRGB(0, 150, 255)
pointLight.Brightness = 2
pointLight.Range = 10
pointLight.Parent = ledRing

-- Botones
local micButton = Instance.new("Part")
micButton.Name = "MicButton"
micButton.Size = Vector3.new(0.8, 0.2, 0.8)
micButton.Position = Vector3.new(-0.8, 5.1, 2.1)
micButton.Anchored = true
micButton.Shape = Enum.PartType.Cylinder
micButton.Material = Enum.Material.Plastic
micButton.BrickColor = BrickColor.new("Medium stone grey")
micButton.Parent = alexaModel

local clickDetector = Instance.new("ClickDetector")
clickDetector.MaxActivationDistance = 10
clickDetector.Parent = micButton

-- Pantalla
local screen = Instance.new("Part")
screen.Name = "Screen"
screen.Size = Vector3.new(2.5, 1.5, 0.1)
screen.Position = Vector3.new(0, 4, 2.05)
screen.Anchored = true
screen.Material = Enum.Material.Neon
screen.BrickColor = BrickColor.new("Really black")
screen.Parent = alexaModel

local screenGui = Instance.new("SurfaceGui")
screenGui.Face = Enum.NormalId.Front
screenGui.Parent = screen

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 1, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Alexa\nReady"
statusLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
statusLabel.TextSize = 24
statusLabel.Font = Enum.Font.GothamBold
statusLabel.Parent = screenGui

-- Animaciones
local function animateLED(state)
    if state == "listening" then
        ledRing.BrickColor = BrickColor.new("Bright red")
        pointLight.Color = Color3.fromRGB(255, 50, 50)
        statusLabel.Text = "Listening..."
    elseif state == "speaking" then
        ledRing.BrickColor = BrickColor.new("Bright green")
        pointLight.Color = Color3.fromRGB(0, 255, 150)
        statusLabel.Text = "Speaking..."
    else
        ledRing.BrickColor = BrickColor.new("Cyan")
        pointLight.Color = Color3.fromRGB(0, 150, 255)
        statusLabel.Text = "Alexa\nReady"
    end
end

clickDetector.MouseClick:Connect(function(player)
    animateLED("listening")
    wait(2)
    animateLED("speaking")
    wait(3)
    animateLED("idle")
end)

print("Alexa 3D Device created!")