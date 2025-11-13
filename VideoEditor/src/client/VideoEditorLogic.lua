-- Video Editor Logic
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Esperar a que se carguen los RemoteEvents
repeat wait() until ReplicatedStorage:FindFirstChild("RemoteEvents")
local remoteEvents = ReplicatedStorage.RemoteEvents

local saveProject = remoteEvents:WaitForChild("SaveProject")
local loadProject = remoteEvents:WaitForChild("LoadProject")
local exportVideo = remoteEvents:WaitForChild("ExportVideo")

-- Esperar a que se cargue la UI
repeat wait() until playerGui:FindFirstChild("VideoEditor")
local videoEditor = playerGui.VideoEditor
local mainFrame = videoEditor.MainFrame

-- Referencias a elementos UI
local topBar = mainFrame.TopBar
local previewArea = mainFrame.PreviewArea
local timeline = mainFrame.Timeline
local leftPanel = mainFrame.LeftPanel
local rightPanel = mainFrame.RightPanel

local playButton = previewArea.PlayControls.TextButton
local timeProgress = previewArea.PlayControls.Frame.Frame
local timeLabel = previewArea.PlayControls.TextLabel

-- Variables del editor
local isPlaying = false
local currentTime = 0
local totalDuration = 60 -- 60 segundos por defecto
local playbackSpeed = 1

-- Función para formatear tiempo
local function formatTime(seconds)
    local minutes = math.floor(seconds / 60)
    local secs = math.floor(seconds % 60)
    return string.format("%d:%02d", minutes, secs)
end

-- Función para actualizar la barra de tiempo
local function updateTimeBar()
    local progress = currentTime / totalDuration
    timeProgress.Size = UDim2.new(progress, 0, 1, 0)
    timeLabel.Text = formatTime(currentTime)
end

-- Sistema de reproducción
local function startPlayback()
    isPlaying = true
    playButton.Text = "⏸"
    
    spawn(function()
        while isPlaying and currentTime < totalDuration do
            wait(0.1)
            currentTime = currentTime + (0.1 * playbackSpeed)
            updateTimeBar()
        end
        
        if currentTime >= totalDuration then
            currentTime = 0
            isPlaying = false
            playButton.Text = "▶"
            updateTimeBar()
        end
    end)
end

local function stopPlayback()
    isPlaying = false
    playButton.Text = "▶"
end

-- Eventos de botones
playButton.MouseButton1Click:Connect(function()
    if isPlaying then
        stopPlayback()
    else
        startPlayback()
    end
end)

-- Botones de la barra superior
topBar.TextButton.MouseButton1Click:Connect(function() -- Export
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 300, 0, 100)
    notification.Position = UDim2.new(0.5, -150, 0.5, -50)
    notification.BackgroundColor3 = Color3.fromRGB(60, 130, 255)
    notification.BorderSizePixel = 0
    notification.Parent = videoEditor
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = notification
    
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = "Exporting video...\nPlease wait"
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.TextSize = 16
    text.Font = Enum.Font.Gotham
    text.Parent = notification
    
    exportVideo:FireServer({
        resolution = "1920x1080",
        fps = 30,
        quality = "high"
    })
    
    wait(3)
    text.Text = "Export completed!"
    wait(1)
    notification:Destroy()
end)

-- Interacción con herramientas
for _, tool in pairs(leftPanel.ToolsScroll:GetChildren()) do
    if tool:IsA("Frame") and tool.Name ~= "UIListLayout" then
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 1, 0)
        button.BackgroundTransparency = 1
        button.Text = ""
        button.Parent = tool
        
        button.MouseButton1Click:Connect(function()
            -- Efecto visual de selección
            local tween = TweenService:Create(tool, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(60, 130, 255)
            })
            tween:Play()
            
            wait(0.2)
            
            local tween2 = TweenService:Create(tool, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            })
            tween2:Play()
            
            print("Selected tool:", tool.TextLabel.Text)
        end)
    end
end

-- Función para crear clip en timeline
local function createClip(trackFrame, startPos, duration, clipType)
    local clip = Instance.new("Frame")
    clip.Size = UDim2.new(0, duration * 2, 0, 35) -- 2 pixels por segundo
    clip.Position = UDim2.new(0, 100 + startPos * 2, 0.5, -17.5)
    clip.BorderSizePixel = 0
    clip.Parent = trackFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = clip
    
    if clipType == "video" then
        clip.BackgroundColor3 = Color3.fromRGB(60, 130, 255)
    elseif clipType == "audio" then
        clip.BackgroundColor3 = Color3.fromRGB(255, 130, 60)
    else
        clip.BackgroundColor3 = Color3.fromRGB(130, 255, 60)
    end
    
    local clipLabel = Instance.new("TextLabel")
    clipLabel.Size = UDim2.new(1, -10, 1, 0)
    clipLabel.Position = UDim2.new(0, 5, 0, 0)
    clipLabel.BackgroundTransparency = 1
    clipLabel.Text = clipType:upper() .. " " .. formatTime(duration)
    clipLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    clipLabel.TextSize = 10
    clipLabel.Font = Enum.Font.Gotham
    clipLabel.TextXAlignment = Enum.TextXAlignment.Left
    clipLabel.Parent = clip
    
    -- Hacer el clip arrastrable
    local dragging = false
    local dragStart = nil
    local startPos = clip.Position
    
    clip.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = clip.Position
        end
    end)
    
    clip.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            clip.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset)
        end
    end)
    
    clip.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    return clip
end

-- Crear algunos clips de ejemplo
wait(1)
local tracks = timeline.TracksArea:GetChildren()
for i, track in pairs(tracks) do
    if track:IsA("Frame") then
        if i == 2 then -- Video track
            createClip(track, 0, 30, "video")
            createClip(track, 35, 25, "video")
        elseif i == 3 then -- Audio track
            createClip(track, 0, 60, "audio")
        elseif i == 4 then -- Text track
            createClip(track, 10, 15, "text")
            createClip(track, 30, 20, "text")
        end
    end
end

-- Actualizar duración total basada en clips
totalDuration = 60
updateTimeBar()

print("Video Editor Logic loaded!")