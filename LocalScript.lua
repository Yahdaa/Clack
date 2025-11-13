-- ========================================
-- ALICE IN WONDERLAND - CLIENT SCRIPT
-- Efectos Cinematográficos y UI
-- ========================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Esperar a que los RemoteEvents estén disponibles
local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local startGameEvent = remoteEvents:WaitForChild("StartGame")
local cinematicEvent = remoteEvents:WaitForChild("CinematicEvent")
local transformEvent = remoteEvents:WaitForChild("TransformEvent")

-- ========================================
-- INTERFAZ DE USUARIO PRINCIPAL
-- ========================================

local function createMainUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AliceWonderlandUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    -- Título del juego con efectos
    local titleFrame = Instance.new("Frame")
    titleFrame.Name = "TitleFrame"
    titleFrame.Size = UDim2.new(1, 0, 0.3, 0)
    titleFrame.Position = UDim2.new(0, 0, 0.1, 0)
    titleFrame.BackgroundTransparency = 1
    titleFrame.Parent = screenGui
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, 0, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.Fantasy
    titleLabel.TextSize = 48
    titleLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    titleLabel.TextStrokeTransparency = 0
    titleLabel.TextStrokeColor3 = Color3.fromRGB(139, 0, 139)
    titleLabel.Text = "🎭 ALICIA EN EL PAÍS DE LAS MARAVILLAS 🎭"
    titleLabel.Parent = titleFrame
    
    -- Efectos de brillo en el título
    local titleGlow = Instance.new("UIGradient")
    titleGlow.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 215, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 215, 0))
    }
    titleGlow.Parent = titleLabel
    
    -- Animación del título
    local titleTween = TweenService:Create(
        titleLabel,
        TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {TextTransparency = 0.3}
    )
    titleTween:Play()
    
    -- Botón de inicio
    local startButton = Instance.new("TextButton")
    startButton.Name = "StartButton"
    startButton.Size = UDim2.new(0.3, 0, 0.1, 0)
    startButton.Position = UDim2.new(0.35, 0, 0.5, 0)
    startButton.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
    startButton.BorderSizePixel = 0
    startButton.Font = Enum.Font.Fantasy
    startButton.TextSize = 24
    startButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    startButton.Text = "🌟 COMENZAR AVENTURA 🌟"
    startButton.Parent = screenGui
    
    -- Efectos del botón
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 15)
    buttonCorner.Parent = startButton
    
    local buttonGradient = Instance.new("UIGradient")
    buttonGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 20, 147)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(138, 43, 226))
    }
    buttonGradient.Parent = startButton
    
    -- Animación del botón
    startButton.MouseEnter:Connect(function()
        local hoverTween = TweenService:Create(
            startButton,
            TweenInfo.new(0.3, Enum.EasingStyle.Bounce),
            {Size = UDim2.new(0.32, 0, 0.12, 0)}
        )
        hoverTween:Play()
    end)
    
    startButton.MouseLeave:Connect(function()
        local leaveTween = TweenService:Create(
            startButton,
            TweenInfo.new(0.3, Enum.EasingStyle.Bounce),
            {Size = UDim2.new(0.3, 0, 0.1, 0)}
        )
        leaveTween:Play()
    end)
    
    -- Función del botón
    startButton.MouseButton1Click:Connect(function()
        -- Ocultar UI de inicio
        local fadeOut = TweenService:Create(
            screenGui,
            TweenInfo.new(1, Enum.EasingStyle.Sine),
            {Enabled = false}
        )
        fadeOut:Play()
        
        -- Iniciar el juego
        startGameEvent:FireServer()
    end)
    
    return screenGui
end

-- ========================================
-- SISTEMA DE CINEMÁTICAS
-- ========================================

local function createCinematicBars()
    local cinematicGui = Instance.new("ScreenGui")
    cinematicGui.Name = "CinematicBars"
    cinematicGui.Parent = playerGui
    
    -- Barra superior
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0.1, 0)
    topBar.Position = UDim2.new(0, 0, -0.1, 0)
    topBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    topBar.BorderSizePixel = 0
    topBar.Parent = cinematicGui
    
    -- Barra inferior
    local bottomBar = Instance.new("Frame")
    bottomBar.Name = "BottomBar"
    bottomBar.Size = UDim2.new(1, 0, 0.1, 0)
    bottomBar.Position = UDim2.new(0, 0, 1, 0)
    bottomBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bottomBar.BorderSizePixel = 0
    bottomBar.Parent = cinematicGui
    
    return cinematicGui, topBar, bottomBar
end

local function playCinematic(cinematicType)
    local cinematicGui, topBar, bottomBar = createCinematicBars()
    
    -- Animar barras cinemáticas
    local topTween = TweenService:Create(
        topBar,
        TweenInfo.new(1, Enum.EasingStyle.Sine),
        {Position = UDim2.new(0, 0, 0, 0)}
    )
    
    local bottomTween = TweenService:Create(
        bottomBar,
        TweenInfo.new(1, Enum.EasingStyle.Sine),
        {Position = UDim2.new(0, 0, 0.9, 0)}
    )
    
    topTween:Play()
    bottomTween:Play()
    
    if cinematicType == "intro" then
        playIntroCinematic(cinematicGui)
    elseif cinematicType == "transformation" then
        playTransformationCinematic(cinematicGui)
    elseif cinematicType == "ending" then
        playEndingCinematic(cinematicGui)
    end
end

local function playIntroCinematic(cinematicGui)
    -- Texto narrativo
    local narrativeFrame = Instance.new("Frame")
    narrativeFrame.Size = UDim2.new(0.8, 0, 0.3, 0)
    narrativeFrame.Position = UDim2.new(0.1, 0, 0.35, 0)
    narrativeFrame.BackgroundTransparency = 1
    narrativeFrame.Parent = cinematicGui
    
    local narrativeText = Instance.new("TextLabel")
    narrativeText.Size = UDim2.new(1, 0, 1, 0)
    narrativeText.BackgroundTransparency = 1
    narrativeText.Font = Enum.Font.Fantasy
    narrativeText.TextSize = 20
    narrativeText.TextColor3 = Color3.fromRGB(255, 255, 255)
    narrativeText.TextWrapped = true
    narrativeText.Text = ""
    narrativeText.Parent = narrativeFrame
    
    -- Secuencia narrativa
    local narrativeSequence = {
        "Había una vez una niña llamada Alicia...",
        "Que siguió a un conejo blanco por una madriguera...",
        "Y cayó en un mundo lleno de maravillas y locura...",
        "¿Estás listo para unirte a su aventura?",
        "¡Bienvenido al País de las Maravillas!"
    }
    
    -- Mostrar texto secuencialmente
    spawn(function()
        for i, text in ipairs(narrativeSequence) do
            narrativeText.Text = text
            
            -- Efecto de escritura
            local originalText = text
            narrativeText.Text = ""
            
            for j = 1, #originalText do
                narrativeText.Text = originalText:sub(1, j)
                wait(0.05)
            end
            
            wait(2)
        end
        
        -- Ocultar cinemática
        local fadeOut = TweenService:Create(
            cinematicGui,
            TweenInfo.new(1, Enum.EasingStyle.Sine),
            {Enabled = false}
        )
        fadeOut:Play()
        
        wait(1)
        cinematicGui:Destroy()
    end)
    
    -- Efectos de cámara
    local originalCFrame = Camera.CFrame
    
    spawn(function()
        for i = 1, 100 do
            Camera.CFrame = originalCFrame * CFrame.Angles(
                math.rad(math.sin(i * 0.1) * 2),
                math.rad(math.cos(i * 0.1) * 2),
                0
            )
            wait(0.1)
        end
        Camera.CFrame = originalCFrame
    end)
end

-- ========================================
-- EFECTOS DE TRANSFORMACIÓN
-- ========================================

local function createTransformationEffects(transformationType)
    local effectsGui = Instance.new("ScreenGui")
    effectsGui.Name = "TransformationEffects"
    effectsGui.Parent = playerGui
    
    -- Overlay de color
    local colorOverlay = Instance.new("Frame")
    colorOverlay.Size = UDim2.new(1, 0, 1, 0)
    colorOverlay.BackgroundTransparency = 1
    colorOverlay.Parent = effectsGui
    
    if transformationType == "grow" then
        colorOverlay.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    elseif transformationType == "shrink" then
        colorOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
    end
    
    -- Animación de flash
    local flashTween = TweenService:Create(
        colorOverlay,
        TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 2, true),
        {BackgroundTransparency = 0.3}
    )
    flashTween:Play()
    
    -- Partículas de transformación
    for i = 1, 20 do
        local particle = Instance.new("Frame")
        particle.Size = UDim2.new(0.02, 0, 0.02, 0)
        particle.Position = UDim2.new(0.5, 0, 0.5, 0)
        particle.BackgroundColor3 = colorOverlay.BackgroundColor3
        particle.BorderSizePixel = 0
        particle.Parent = effectsGui
        
        local particleCorner = Instance.new("UICorner")
        particleCorner.CornerRadius = UDim.new(1, 0)
        particleCorner.Parent = particle
        
        -- Animación de explosión
        local angle = math.rad(i * (360 / 20))
        local endPos = UDim2.new(
            0.5 + math.cos(angle) * 0.4,
            0,
            0.5 + math.sin(angle) * 0.4,
            0
        )
        
        local particleTween = TweenService:Create(
            particle,
            TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                Position = endPos,
                Size = UDim2.new(0.05, 0, 0.05, 0),
                BackgroundTransparency = 1
            }
        )
        particleTween:Play()
    end
    
    -- Limpiar efectos
    game:GetService("Debris"):AddItem(effectsGui, 2)
end

-- ========================================
-- SISTEMA DE DIÁLOGOS
-- ========================================

local function createDialogueSystem()
    local dialogueGui = Instance.new("ScreenGui")
    dialogueGui.Name = "DialogueSystem"
    dialogueGui.Parent = playerGui
    
    local dialogueFrame = Instance.new("Frame")
    dialogueFrame.Name = "DialogueFrame"
    dialogueFrame.Size = UDim2.new(0.8, 0, 0.2, 0)
    dialogueFrame.Position = UDim2.new(0.1, 0, 0.75, 0)
    dialogueFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    dialogueFrame.BackgroundTransparency = 0.3
    dialogueFrame.BorderSizePixel = 0
    dialogueFrame.Visible = false
    dialogueFrame.Parent = dialogueGui
    
    local dialogueCorner = Instance.new("UICorner")
    dialogueCorner.CornerRadius = UDim.new(0, 15)
    dialogueCorner.Parent = dialogueFrame
    
    local speakerLabel = Instance.new("TextLabel")
    speakerLabel.Name = "SpeakerLabel"
    speakerLabel.Size = UDim2.new(1, 0, 0.3, 0)
    speakerLabel.Position = UDim2.new(0, 0, 0, 0)
    speakerLabel.BackgroundTransparency = 1
    speakerLabel.Font = Enum.Font.FantasyItalic
    speakerLabel.TextSize = 18
    speakerLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    speakerLabel.TextXAlignment = Enum.TextXAlignment.Left
    speakerLabel.Text = ""
    speakerLabel.Parent = dialogueFrame
    
    local dialogueText = Instance.new("TextLabel")
    dialogueText.Name = "DialogueText"
    dialogueText.Size = UDim2.new(1, 0, 0.7, 0)
    dialogueText.Position = UDim2.new(0, 0, 0.3, 0)
    dialogueText.BackgroundTransparency = 1
    dialogueText.Font = Enum.Font.Fantasy
    dialogueText.TextSize = 16
    dialogueText.TextColor3 = Color3.fromRGB(255, 255, 255)
    dialogueText.TextWrapped = true
    dialogueText.TextXAlignment = Enum.TextXAlignment.Left
    dialogueText.TextYAlignment = Enum.TextYAlignment.Top
    dialogueText.Text = ""
    dialogueText.Parent = dialogueFrame
    
    return dialogueGui, dialogueFrame, speakerLabel, dialogueText
end

local function showDialogue(speaker, text, duration)
    local dialogueGui, dialogueFrame, speakerLabel, dialogueText = createDialogueSystem()
    
    speakerLabel.Text = "💬 " .. speaker
    dialogueFrame.Visible = true
    
    -- Efecto de escritura
    spawn(function()
        dialogueText.Text = ""
        for i = 1, #text do
            dialogueText.Text = text:sub(1, i)
            wait(0.03)
        end
        
        wait(duration or 3)
        
        -- Ocultar diálogo
        local fadeOut = TweenService:Create(
            dialogueFrame,
            TweenInfo.new(0.5, Enum.EasingStyle.Sine),
            {BackgroundTransparency = 1}
        )
        fadeOut:Play()
        
        wait(0.5)
        dialogueGui:Destroy()
    end)
end

-- ========================================
-- SISTEMA DE INVENTARIO
-- ========================================

local function createInventoryUI()
    local inventoryGui = Instance.new("ScreenGui")
    inventoryGui.Name = "InventoryUI"
    inventoryGui.Parent = playerGui
    
    local inventoryFrame = Instance.new("Frame")
    inventoryFrame.Name = "InventoryFrame"
    inventoryFrame.Size = UDim2.new(0.3, 0, 0.4, 0)
    inventoryFrame.Position = UDim2.new(0.65, 0, 0.1, 0)
    inventoryFrame.BackgroundColor3 = Color3.fromRGB(139, 69, 19)
    inventoryFrame.BackgroundTransparency = 0.2
    inventoryFrame.BorderSizePixel = 0
    inventoryFrame.Parent = inventoryGui
    
    local inventoryCorner = Instance.new("UICorner")
    inventoryCorner.CornerRadius = UDim.new(0, 10)
    inventoryCorner.Parent = inventoryFrame
    
    local inventoryTitle = Instance.new("TextLabel")
    inventoryTitle.Size = UDim2.new(1, 0, 0.15, 0)
    inventoryTitle.BackgroundTransparency = 1
    inventoryTitle.Font = Enum.Font.Fantasy
    inventoryTitle.TextSize = 16
    inventoryTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
    inventoryTitle.Text = "🎒 INVENTARIO MÁGICO"
    inventoryTitle.Parent = inventoryFrame
    
    local itemsFrame = Instance.new("ScrollingFrame")
    itemsFrame.Size = UDim2.new(1, 0, 0.85, 0)
    itemsFrame.Position = UDim2.new(0, 0, 0.15, 0)
    itemsFrame.BackgroundTransparency = 1
    itemsFrame.BorderSizePixel = 0
    itemsFrame.ScrollBarThickness = 5
    itemsFrame.Parent = inventoryFrame
    
    local itemsLayout = Instance.new("UIListLayout")
    itemsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    itemsLayout.Padding = UDim.new(0, 5)
    itemsLayout.Parent = itemsFrame
    
    return inventoryGui, itemsFrame
end

-- ========================================
-- SISTEMA DE MISIONES UI
-- ========================================

local function createQuestUI()
    local questGui = Instance.new("ScreenGui")
    questGui.Name = "QuestUI"
    questGui.Parent = playerGui
    
    local questFrame = Instance.new("Frame")
    questFrame.Name = "QuestFrame"
    questFrame.Size = UDim2.new(0.35, 0, 0.3, 0)
    questFrame.Position = UDim2.new(0.02, 0, 0.1, 0)
    questFrame.BackgroundColor3 = Color3.fromRGB(75, 0, 130)
    questFrame.BackgroundTransparency = 0.2
    questFrame.BorderSizePixel = 0
    questFrame.Parent = questGui
    
    local questCorner = Instance.new("UICorner")
    questCorner.CornerRadius = UDim.new(0, 10)
    questCorner.Parent = questFrame
    
    local questTitle = Instance.new("TextLabel")
    questTitle.Size = UDim2.new(1, 0, 0.2, 0)
    questTitle.BackgroundTransparency = 1
    questTitle.Font = Enum.Font.Fantasy
    questTitle.TextSize = 16
    questTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
    questTitle.Text = "📜 MISIÓN ACTUAL"
    questTitle.Parent = questFrame
    
    local questDescription = Instance.new("TextLabel")
    questDescription.Size = UDim2.new(1, 0, 0.8, 0)
    questDescription.Position = UDim2.new(0, 0, 0.2, 0)
    questDescription.BackgroundTransparency = 1
    questDescription.Font = Enum.Font.Fantasy
    questDescription.TextSize = 14
    questDescription.TextColor3 = Color3.fromRGB(255, 255, 255)
    questDescription.TextWrapped = true
    questDescription.TextYAlignment = Enum.TextYAlignment.Top
    questDescription.Text = "🐰 Sigue al Conejo Blanco hasta su madriguera"
    questDescription.Parent = questFrame
    
    return questGui, questDescription
end

-- ========================================
-- EFECTOS AMBIENTALES
-- ========================================

local function createAmbientEffects()
    -- Partículas flotantes
    spawn(function()
        while true do
            local particle = Instance.new("Frame")
            particle.Size = UDim2.new(0.01, 0, 0.01, 0)
            particle.Position = UDim2.new(math.random(), 0, 1.1, 0)
            particle.BackgroundColor3 = Color3.fromHSV(math.random(), 0.8, 1)
            particle.BorderSizePixel = 0
            particle.Parent = playerGui
            
            local particleCorner = Instance.new("UICorner")
            particleCorner.CornerRadius = UDim.new(1, 0)
            particleCorner.Parent = particle
            
            -- Animación de flotación
            local floatTween = TweenService:Create(
                particle,
                TweenInfo.new(math.random(5, 10), Enum.EasingStyle.Linear),
                {
                    Position = UDim2.new(particle.Position.X.Scale, 0, -0.1, 0),
                    BackgroundTransparency = 1
                }
            )
            floatTween:Play()
            
            game:GetService("Debris"):AddItem(particle, 10)
            wait(0.5)
        end
    end)
end

-- ========================================
-- CONTROLES Y INPUT
-- ========================================

local function setupControls()
    -- Tecla I para inventario
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.I then
            local inventoryGui = playerGui:FindFirstChild("InventoryUI")
            if inventoryGui then
                inventoryGui.Enabled = not inventoryGui.Enabled
            else
                createInventoryUI()
            end
        elseif input.KeyCode == Enum.KeyCode.Q then
            local questGui = playerGui:FindFirstChild("QuestUI")
            if questGui then
                questGui.Enabled = not questGui.Enabled
            else
                createQuestUI()
            end
        end
    end)
end

-- ========================================
-- EFECTOS DE SONIDO
-- ========================================

local function playSound(soundId, volume, pitch)
    local sound = Instance.new("Sound")
    sound.SoundId = soundId
    sound.Volume = volume or 0.5
    sound.Pitch = pitch or 1
    sound.Parent = SoundService
    sound:Play()
    
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end

-- ========================================
-- CONEXIONES DE EVENTOS
-- ========================================

-- Evento de cinemática
cinematicEvent.OnClientEvent:Connect(function(cinematicType)
    playCinematic(cinematicType)
end)

-- Evento de transformación
transformEvent.OnClientEvent:Connect(function(transformationType)
    createTransformationEffects(transformationType)
    
    if transformationType == "grow" then
        showDialogue("Sistema", "¡Te has vuelto más grande! 🔍", 2)
        playSound("rbxasset://sounds/electronicpingshort.wav", 0.7, 0.8)
    elseif transformationType == "shrink" then
        showDialogue("Sistema", "¡Te has encogido! 🔬", 2)
        playSound("rbxasset://sounds/electronicpingshort.wav", 0.7, 1.2)
    end
end)

-- ========================================
-- INICIALIZACIÓN
-- ========================================

-- Crear UI principal al cargar
local mainUI = createMainUI()

-- Configurar controles
setupControls()

-- Crear efectos ambientales
createAmbientEffects()

-- Crear UIs del juego
createInventoryUI()
createQuestUI()

-- Ocultar UIs del juego inicialmente
playerGui:FindFirstChild("InventoryUI").Enabled = false
playerGui:FindFirstChild("QuestUI").Enabled = false

print("🎮 Cliente de Alicia en el País de las Maravillas cargado!")
print("🎯 Controles: I = Inventario, Q = Misiones")

-- ========================================
-- SISTEMA DE NOTIFICACIONES
-- ========================================

local function showNotification(title, message, duration, color)
    local notificationGui = Instance.new("ScreenGui")
    notificationGui.Name = "NotificationSystem"
    notificationGui.Parent = playerGui
    
    local notificationFrame = Instance.new("Frame")
    notificationFrame.Size = UDim2.new(0.3, 0, 0.1, 0)
    notificationFrame.Position = UDim2.new(0.35, 0, -0.15, 0)
    notificationFrame.BackgroundColor3 = color or Color3.fromRGB(138, 43, 226)
    notificationFrame.BorderSizePixel = 0
    notificationFrame.Parent = notificationGui
    
    local notificationCorner = Instance.new("UICorner")
    notificationCorner.CornerRadius = UDim.new(0, 10)
    notificationCorner.Parent = notificationFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0.4, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.FantasyItalic
    titleLabel.TextSize = 16
    titleLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    titleLabel.Text = title
    titleLabel.Parent = notificationFrame
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, 0, 0.6, 0)
    messageLabel.Position = UDim2.new(0, 0, 0.4, 0)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Font = Enum.Font.Fantasy
    messageLabel.TextSize = 14
    messageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    messageLabel.TextWrapped = true
    messageLabel.Text = message
    messageLabel.Parent = notificationFrame
    
    -- Animación de entrada
    local slideIn = TweenService:Create(
        notificationFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(0.35, 0, 0.05, 0)}
    )
    slideIn:Play()
    
    -- Animación de salida
    spawn(function()
        wait(duration or 3)
        
        local slideOut = TweenService:Create(
            notificationFrame,
            TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In),
            {Position = UDim2.new(0.35, 0, -0.15, 0)}
        )
        slideOut:Play()
        
        wait(0.5)
        notificationGui:Destroy()
    end)
end

-- Ejemplo de uso de notificaciones
spawn(function()
    wait(5)
    showNotification("🎭 Bienvenido", "¡Explora el mágico mundo de Alicia!", 4)
    
    wait(8)
    showNotification("💡 Consejo", "Usa I para abrir tu inventario y Q para ver misiones", 5, Color3.fromRGB(0, 128, 255))
end)