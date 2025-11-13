-- Video Editor UI - Estilo CapCut
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Crear ScreenGui principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VideoEditor"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- Frame principal (ocupa toda la pantalla)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.Position = UDim2.new(0, 0, 0, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Barra superior
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 50)
topBar.Position = UDim2.new(0, 0, 0, 0)
topBar.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

-- Logo/Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(0, 200, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Video Editor"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

-- Botones de la barra superior
local function createTopButton(text, position)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 80, 0, 30)
    button.Position = UDim2.new(1, position, 0.5, -15)
    button.BackgroundColor3 = Color3.fromRGB(60, 130, 255)
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.Gotham
    button.Parent = topBar
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    return button
end

local exportBtn = createTopButton("Export", -90)
local saveBtn = createTopButton("Save", -180)
local importBtn = createTopButton("Import", -270)

-- Panel izquierdo (herramientas)
local leftPanel = Instance.new("Frame")
leftPanel.Name = "LeftPanel"
leftPanel.Size = UDim2.new(0, 250, 1, -50)
leftPanel.Position = UDim2.new(0, 0, 0, 50)
leftPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
leftPanel.BorderSizePixel = 0
leftPanel.Parent = mainFrame

-- Scroll para herramientas
local toolsScroll = Instance.new("ScrollingFrame")
toolsScroll.Name = "ToolsScroll"
toolsScroll.Size = UDim2.new(1, 0, 1, 0)
toolsScroll.BackgroundTransparency = 1
toolsScroll.ScrollBarThickness = 6
toolsScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
toolsScroll.Parent = leftPanel

local toolsLayout = Instance.new("UIListLayout")
toolsLayout.SortOrder = Enum.SortOrder.LayoutOrder
toolsLayout.Padding = UDim.new(0, 5)
toolsLayout.Parent = toolsScroll

-- Función para crear herramientas
local function createTool(name, icon, description)
    local toolFrame = Instance.new("Frame")
    toolFrame.Size = UDim2.new(1, -10, 0, 60)
    toolFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    toolFrame.BorderSizePixel = 0
    toolFrame.Parent = toolsScroll
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = toolFrame
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 40, 0, 40)
    iconLabel.Position = UDim2.new(0, 10, 0, 10)
    iconLabel.BackgroundColor3 = Color3.fromRGB(60, 130, 255)
    iconLabel.Text = icon
    iconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    iconLabel.TextSize = 20
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Parent = toolFrame
    
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(0, 6)
    iconCorner.Parent = iconLabel
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -60, 0, 20)
    nameLabel.Position = UDim2.new(0, 55, 0, 8)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = toolFrame
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, -60, 0, 15)
    descLabel.Position = UDim2.new(0, 55, 0, 30)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = description
    descLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    descLabel.TextSize = 11
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = toolFrame
    
    return toolFrame
end

-- Crear herramientas
createTool("Cut", "✂", "Cortar clips")
createTool("Trim", "⚡", "Recortar duración")
createTool("Text", "T", "Agregar texto")
createTool("Music", "♪", "Agregar música")
createTool("Effects", "✨", "Efectos visuales")
createTool("Filters", "🎨", "Filtros de color")
createTool("Speed", "⚡", "Cambiar velocidad")
createTool("Transition", "→", "Transiciones")

-- Área de preview (centro)
local previewArea = Instance.new("Frame")
previewArea.Name = "PreviewArea"
previewArea.Size = UDim2.new(1, -500, 1, -200)
previewArea.Position = UDim2.new(0, 250, 0, 50)
previewArea.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
previewArea.BorderSizePixel = 0
previewArea.Parent = mainFrame

-- Video preview
local videoPreview = Instance.new("Frame")
videoPreview.Name = "VideoPreview"
videoPreview.Size = UDim2.new(1, -20, 1, -60)
videoPreview.Position = UDim2.new(0, 10, 0, 10)
videoPreview.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
videoPreview.BorderSizePixel = 0
videoPreview.Parent = previewArea

local previewCorner = Instance.new("UICorner")
previewCorner.CornerRadius = UDim.new(0, 10)
previewCorner.Parent = videoPreview

-- Placeholder para video
local videoPlaceholder = Instance.new("TextLabel")
videoPlaceholder.Size = UDim2.new(1, 0, 1, 0)
videoPlaceholder.BackgroundTransparency = 1
videoPlaceholder.Text = "📹\nVideo Preview\nImport video to start editing"
videoPlaceholder.TextColor3 = Color3.fromRGB(100, 100, 100)
videoPlaceholder.TextSize = 24
videoPlaceholder.Font = Enum.Font.Gotham
videoPlaceholder.Parent = videoPreview

-- Controles de reproducción
local playControls = Instance.new("Frame")
playControls.Name = "PlayControls"
playControls.Size = UDim2.new(1, -20, 0, 40)
playControls.Position = UDim2.new(0, 10, 1, -50)
playControls.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
playControls.BorderSizePixel = 0
playControls.Parent = previewArea

local controlsCorner = Instance.new("UICorner")
controlsCorner.CornerRadius = UDim.new(0, 8)
controlsCorner.Parent = playControls

-- Botón play/pause
local playButton = Instance.new("TextButton")
playButton.Size = UDim2.new(0, 40, 0, 30)
playButton.Position = UDim2.new(0, 10, 0.5, -15)
playButton.BackgroundColor3 = Color3.fromRGB(60, 130, 255)
playButton.Text = "▶"
playButton.TextColor3 = Color3.fromRGB(255, 255, 255)
playButton.TextSize = 16
playButton.Font = Enum.Font.GothamBold
playButton.BorderSizePixel = 0
playButton.Parent = playControls

local playCorner = Instance.new("UICorner")
playCorner.CornerRadius = UDim.new(0, 6)
playCorner.Parent = playButton

-- Barra de tiempo
local timeBar = Instance.new("Frame")
timeBar.Size = UDim2.new(1, -120, 0, 6)
timeBar.Position = UDim2.new(0, 60, 0.5, -3)
timeBar.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
timeBar.BorderSizePixel = 0
timeBar.Parent = playControls

local timeBarCorner = Instance.new("UICorner")
timeBarCorner.CornerRadius = UDim.new(0, 3)
timeBarCorner.Parent = timeBar

local timeProgress = Instance.new("Frame")
timeProgress.Size = UDim2.new(0, 0, 1, 0)
timeProgress.BackgroundColor3 = Color3.fromRGB(60, 130, 255)
timeProgress.BorderSizePixel = 0
timeProgress.Parent = timeBar

local progressCorner = Instance.new("UICorner")
progressCorner.CornerRadius = UDim.new(0, 3)
progressCorner.Parent = timeProgress

-- Tiempo actual
local timeLabel = Instance.new("TextLabel")
timeLabel.Size = UDim2.new(0, 50, 1, 0)
timeLabel.Position = UDim2.new(1, -50, 0, 0)
timeLabel.BackgroundTransparency = 1
timeLabel.Text = "0:00"
timeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
timeLabel.TextSize = 12
timeLabel.Font = Enum.Font.Gotham
timeLabel.Parent = playControls

-- Panel derecho (propiedades)
local rightPanel = Instance.new("Frame")
rightPanel.Name = "RightPanel"
rightPanel.Size = UDim2.new(0, 250, 1, -50)
rightPanel.Position = UDim2.new(1, -250, 0, 50)
rightPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
rightPanel.BorderSizePixel = 0
rightPanel.Parent = mainFrame

-- Título del panel
local propTitle = Instance.new("TextLabel")
propTitle.Size = UDim2.new(1, 0, 0, 40)
propTitle.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
propTitle.Text = "Properties"
propTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
propTitle.TextSize = 16
propTitle.Font = Enum.Font.GothamBold
propTitle.BorderSizePixel = 0
propTitle.Parent = rightPanel

-- Scroll para propiedades
local propScroll = Instance.new("ScrollingFrame")
propScroll.Name = "PropScroll"
propScroll.Size = UDim2.new(1, 0, 1, -40)
propScroll.Position = UDim2.new(0, 0, 0, 40)
propScroll.BackgroundTransparency = 1
propScroll.ScrollBarThickness = 6
propScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
propScroll.Parent = rightPanel

local propLayout = Instance.new("UIListLayout")
propLayout.SortOrder = Enum.SortOrder.LayoutOrder
propLayout.Padding = UDim.new(0, 10)
propLayout.Parent = propScroll

-- Función para crear propiedades
local function createProperty(name, value)
    local propFrame = Instance.new("Frame")
    propFrame.Size = UDim2.new(1, -10, 0, 50)
    propFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    propFrame.BorderSizePixel = 0
    propFrame.Parent = propScroll
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = propFrame
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -10, 0, 20)
    nameLabel.Position = UDim2.new(0, 5, 0, 5)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = name
    nameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    nameLabel.TextSize = 12
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = propFrame
    
    local valueBox = Instance.new("TextBox")
    valueBox.Size = UDim2.new(1, -10, 0, 20)
    valueBox.Position = UDim2.new(0, 5, 0, 25)
    valueBox.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    valueBox.Text = value
    valueBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueBox.TextSize = 12
    valueBox.Font = Enum.Font.Gotham
    valueBox.BorderSizePixel = 0
    valueBox.Parent = propFrame
    
    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 4)
    boxCorner.Parent = valueBox
    
    return propFrame
end

-- Crear propiedades
createProperty("Duration", "0:00")
createProperty("Resolution", "1920x1080")
createProperty("FPS", "30")
createProperty("Volume", "100%")

-- Timeline (parte inferior)
local timeline = Instance.new("Frame")
timeline.Name = "Timeline"
timeline.Size = UDim2.new(1, 0, 0, 150)
timeline.Position = UDim2.new(0, 0, 1, -150)
timeline.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
timeline.BorderSizePixel = 0
timeline.Parent = mainFrame

-- Separador
local separator = Instance.new("Frame")
separator.Size = UDim2.new(1, 0, 0, 2)
separator.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
separator.BorderSizePixel = 0
separator.Parent = timeline

-- Área de tracks
local tracksArea = Instance.new("ScrollingFrame")
tracksArea.Name = "TracksArea"
tracksArea.Size = UDim2.new(1, 0, 1, -2)
tracksArea.Position = UDim2.new(0, 0, 0, 2)
tracksArea.BackgroundTransparency = 1
tracksArea.ScrollBarThickness = 8
tracksArea.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
tracksArea.CanvasSize = UDim2.new(3, 0, 0, 0)
tracksArea.Parent = timeline

-- Función para crear track
local function createTrack(name, color)
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, 0, 0, 40)
    track.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    track.BorderSizePixel = 0
    track.Parent = tracksArea
    
    local trackLabel = Instance.new("TextLabel")
    trackLabel.Size = UDim2.new(0, 100, 1, 0)
    trackLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    trackLabel.Text = name
    trackLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    trackLabel.TextSize = 12
    trackLabel.Font = Enum.Font.Gotham
    trackLabel.BorderSizePixel = 0
    trackLabel.Parent = track
    
    return track
end

-- Crear tracks
createTrack("Video 1", Color3.fromRGB(60, 130, 255))
createTrack("Audio 1", Color3.fromRGB(255, 130, 60))
createTrack("Text 1", Color3.fromRGB(130, 255, 60))

-- Layout para tracks
local tracksLayout = Instance.new("UIListLayout")
tracksLayout.SortOrder = Enum.SortOrder.LayoutOrder
tracksLayout.Parent = tracksArea

-- Actualizar canvas size
tracksLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    tracksArea.CanvasSize = UDim2.new(3, 0, 0, tracksLayout.AbsoluteContentSize.Y)
end)

-- Actualizar canvas size de herramientas
toolsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    toolsScroll.CanvasSize = UDim2.new(0, 0, 0, toolsLayout.AbsoluteContentSize.Y)
end)

-- Actualizar canvas size de propiedades
propLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    propScroll.CanvasSize = UDim2.new(0, 0, 0, propLayout.AbsoluteContentSize.Y)
end)

print("Video Editor UI loaded!")