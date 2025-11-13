-- ========================================
-- ALICE IN WONDERLAND ROBLOX GAME
-- Servidor Principal - Mundo Completo
-- ========================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local Workspace = game:GetService("Workspace")

-- ========================================
-- CONFIGURACIÓN DEL MUNDO
-- ========================================

-- Crear RemoteEvents para comunicación cliente-servidor
local remoteEvents = Instance.new("Folder")
remoteEvents.Name = "RemoteEvents"
remoteEvents.Parent = ReplicatedStorage

local startGameEvent = Instance.new("RemoteEvent")
startGameEvent.Name = "StartGame"
startGameEvent.Parent = remoteEvents

local cinematicEvent = Instance.new("RemoteEvent")
cinematicEvent.Name = "CinematicEvent"
cinematicEvent.Parent = remoteEvents

local transformEvent = Instance.new("RemoteEvent")
transformEvent.Name = "TransformEvent"
transformEvent.Parent = remoteEvents

-- ========================================
-- CREACIÓN DEL MUNDO DE ALICIA
-- ========================================

local function createWonderland()
    -- Configurar iluminación mágica
    Lighting.Brightness = 2
    Lighting.Ambient = Color3.fromRGB(100, 150, 255)
    Lighting.OutdoorAmbient = Color3.fromRGB(150, 200, 255)
    Lighting.TimeOfDay = "14:00:00"
    
    -- Crear atmósfera mágica
    local atmosphere = Instance.new("Atmosphere")
    atmosphere.Density = 0.3
    atmosphere.Offset = 0.25
    atmosphere.Color = Color3.fromRGB(199, 175, 255)
    atmosphere.Decay = Color3.fromRGB(92, 60, 122)
    atmosphere.Glare = 0.2
    atmosphere.Haze = 1.7
    atmosphere.Parent = Lighting
    
    -- ========================================
    -- TERRENO BASE - PAÍS DE LAS MARAVILLAS
    -- ========================================
    
    local terrain = Workspace.Terrain
    local region = Region3.new(Vector3.new(-500, -50, -500), Vector3.new(500, 200, 500))
    
    -- Crear colinas onduladas
    for x = -500, 500, 20 do
        for z = -500, 500, 20 do
            local height = math.noise(x/100, z/100, 0) * 30 + 10
            local position = Vector3.new(x, height, z)
            local size = Vector3.new(25, height + 10, 25)
            
            terrain:FillRegion(
                Region3.new(position - size/2, position + size/2),
                4,
                Enum.Material.Grass
            )
        end
    end
    
    -- ========================================
    -- MADRIGUERA DEL CONEJO
    -- ========================================
    
    local rabbitHole = Instance.new("Part")
    rabbitHole.Name = "RabbitHole"
    rabbitHole.Size = Vector3.new(20, 2, 20)
    rabbitHole.Position = Vector3.new(0, 5, 0)
    rabbitHole.Material = Enum.Material.Grass
    rabbitHole.BrickColor = BrickColor.new("Bright green")
    rabbitHole.Shape = Enum.PartType.Cylinder
    rabbitHole.Anchored = true
    rabbitHole.Parent = Workspace
    
    -- Túnel de la madriguera
    local tunnel = Instance.new("Part")
    tunnel.Name = "Tunnel"
    tunnel.Size = Vector3.new(8, 100, 8)
    tunnel.Position = Vector3.new(0, -45, 0)
    tunnel.Material = Enum.Material.Rock
    tunnel.BrickColor = BrickColor.new("Dark stone grey")
    tunnel.Shape = Enum.PartType.Cylinder
    tunnel.Anchored = true
    tunnel.Parent = Workspace
    
    -- Crear agujero en el túnel
    local hole = Instance.new("Part")
    hole.Name = "Hole"
    hole.Size = Vector3.new(6, 102, 6)
    hole.Position = Vector3.new(0, -45, 0)
    hole.Material = Enum.Material.Air
    hole.Transparency = 1
    hole.CanCollide = false
    hole.Shape = Enum.PartType.Cylinder
    hole.Anchored = true
    hole.Parent = Workspace
    
    -- ========================================
    -- BOSQUE ENCANTADO
    -- ========================================
    
    local function createMagicalTree(position, scale)
        local tree = Instance.new("Model")
        tree.Name = "MagicalTree"
        tree.Parent = Workspace
        
        -- Tronco
        local trunk = Instance.new("Part")
        trunk.Name = "Trunk"
        trunk.Size = Vector3.new(2 * scale, 15 * scale, 2 * scale)
        trunk.Position = position + Vector3.new(0, 7.5 * scale, 0)
        trunk.Material = Enum.Material.Wood
        trunk.BrickColor = BrickColor.new("Brown")
        trunk.Anchored = true
        trunk.Parent = tree
        
        -- Copa del árbol
        local crown = Instance.new("Part")
        crown.Name = "Crown"
        crown.Size = Vector3.new(8 * scale, 8 * scale, 8 * scale)
        crown.Position = position + Vector3.new(0, 18 * scale, 0)
        crown.Material = Enum.Material.Grass
        crown.BrickColor = BrickColor.new("Bright green")
        crown.Shape = Enum.PartType.Ball
        crown.Anchored = true
        crown.Parent = tree
        
        -- Efectos mágicos en el árbol
        local sparkles = Instance.new("Sparkles")
        sparkles.SparkleColor = Color3.fromRGB(255, 255, 0)
        sparkles.Parent = crown
        
        -- Animación de flotación
        local floatTween = TweenService:Create(
            crown,
            TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
            {Position = crown.Position + Vector3.new(0, 2, 0)}
        )
        floatTween:Play()
        
        return tree
    end
    
    -- Crear bosque de árboles mágicos
    for i = 1, 50 do
        local x = math.random(-400, 400)
        local z = math.random(-400, 400)
        local y = terrain:ReadVoxels(
            Region3.new(Vector3.new(x-1, 0, z-1), Vector3.new(x+1, 200, z+1)),
            4
        )
        
        if math.random() > 0.7 then
            createMagicalTree(Vector3.new(x, 20, z), math.random(0.5, 1.5))
        end
    end
    
    -- ========================================
    -- CASA DEL SOMBRERERO LOCO
    -- ========================================
    
    local madHatterHouse = Instance.new("Model")
    madHatterHouse.Name = "MadHatterHouse"
    madHatterHouse.Parent = Workspace
    
    -- Base de la casa
    local houseBase = Instance.new("Part")
    houseBase.Name = "HouseBase"
    houseBase.Size = Vector3.new(30, 20, 30)
    houseBase.Position = Vector3.new(100, 25, 100)
    houseBase.Material = Enum.Material.Brick
    houseBase.BrickColor = BrickColor.new("Bright red")
    houseBase.Anchored = true
    houseBase.Parent = madHatterHouse
    
    -- Techo cónico
    local roof = Instance.new("Part")
    roof.Name = "Roof"
    roof.Size = Vector3.new(35, 15, 35)
    roof.Position = Vector3.new(100, 42.5, 100)
    roof.Material = Enum.Material.Slate
    roof.BrickColor = BrickColor.new("Dark green")
    roof.Shape = Enum.PartType.Cylinder
    roof.Anchored = true
    roof.Parent = madHatterHouse
    
    -- Chimenea
    local chimney = Instance.new("Part")
    chimney.Name = "Chimney"
    chimney.Size = Vector3.new(3, 10, 3)
    chimney.Position = Vector3.new(110, 55, 110)
    chimney.Material = Enum.Material.Brick
    chimney.BrickColor = BrickColor.new("Really red")
    chimney.Anchored = true
    chimney.Parent = madHatterHouse
    
    -- Humo de la chimenea
    local smoke = Instance.new("Smoke")
    smoke.Size = 5
    smoke.Opacity = 0.5
    smoke.RiseVelocity = 10
    smoke.Color = Color3.fromRGB(100, 100, 100)
    smoke.Parent = chimney
    
    -- Mesa de té gigante
    local teaTable = Instance.new("Part")
    teaTable.Name = "TeaTable"
    teaTable.Size = Vector3.new(20, 2, 10)
    teaTable.Position = Vector3.new(80, 16, 80)
    teaTable.Material = Enum.Material.Wood
    teaTable.BrickColor = BrickColor.new("Brown")
    teaTable.Anchored = true
    teaTable.Parent = madHatterHouse
    
    -- Sillas alrededor de la mesa
    for i = 1, 6 do
        local chair = Instance.new("Part")
        chair.Name = "Chair" .. i
        chair.Size = Vector3.new(3, 8, 3)
        chair.Material = Enum.Material.Wood
        chair.BrickColor = BrickColor.new("Brown")
        chair.Anchored = true
        chair.Parent = madHatterHouse
        
        local angle = (i - 1) * (math.pi * 2 / 6)
        chair.Position = Vector3.new(
            80 + math.cos(angle) * 12,
            20,
            80 + math.sin(angle) * 12
        )
    end
    
    -- ========================================
    -- PALACIO DE LA REINA DE CORAZONES
    -- ========================================
    
    local queenPalace = Instance.new("Model")
    queenPalace.Name = "QueenPalace"
    queenPalace.Parent = Workspace
    
    -- Torre principal
    local mainTower = Instance.new("Part")
    mainTower.Name = "MainTower"
    mainTower.Size = Vector3.new(40, 80, 40)
    mainTower.Position = Vector3.new(-200, 55, -200)
    mainTower.Material = Enum.Material.Marble
    mainTower.BrickColor = BrickColor.new("Really red")
    mainTower.Anchored = true
    mainTower.Parent = queenPalace
    
    -- Torres laterales
    for i = 1, 4 do
        local tower = Instance.new("Part")
        tower.Name = "Tower" .. i
        tower.Size = Vector3.new(15, 60, 15)
        tower.Material = Enum.Material.Marble
        tower.BrickColor = BrickColor.new("Really red")
        tower.Anchored = true
        tower.Parent = queenPalace
        
        local positions = {
            Vector3.new(-230, 45, -230),
            Vector3.new(-170, 45, -230),
            Vector3.new(-230, 45, -170),
            Vector3.new(-170, 45, -170)
        }
        tower.Position = positions[i]
    end
    
    -- Jardín de rosas
    for i = 1, 20 do
        local rose = Instance.new("Part")
        rose.Name = "Rose" .. i
        rose.Size = Vector3.new(2, 4, 2)
        rose.Material = Enum.Material.Grass
        rose.BrickColor = BrickColor.new("Really red")
        rose.Shape = Enum.PartType.Ball
        rose.Anchored = true
        rose.Parent = queenPalace
        
        rose.Position = Vector3.new(
            -200 + math.random(-50, 50),
            17,
            -150 + math.random(-20, 20)
        )
        
        -- Efectos de partículas en las rosas
        local sparkles = Instance.new("Sparkles")
        sparkles.SparkleColor = Color3.fromRGB(255, 0, 0)
        sparkles.Parent = rose
    end
    
    -- ========================================
    -- LABERINTO DE SETOS
    -- ========================================
    
    local maze = Instance.new("Model")
    maze.Name = "Maze"
    maze.Parent = Workspace
    
    -- Crear paredes del laberinto
    local mazePattern = {
        "####################",
        "#    #      #      #",
        "# ## # #### # #### #",
        "#  # #    # #    # #",
        "## # #### # #### # #",
        "#  #      #      # #",
        "# ############## # #",
        "#                # #",
        "################ # #",
        "#                # #",
        "# ############## # #",
        "#  #      #      # #",
        "## # #### # #### # #",
        "#  # #    # #    # #",
        "# ## # #### # #### #",
        "#    #      #      #",
        "####################"
    }
    
    for row = 1, #mazePattern do
        for col = 1, #mazePattern[row] do
            if mazePattern[row]:sub(col, col) == "#" then
                local wall = Instance.new("Part")
                wall.Name = "MazeWall"
                wall.Size = Vector3.new(5, 10, 5)
                wall.Position = Vector3.new(
                    200 + (col - 1) * 5,
                    20,
                    200 + (row - 1) * 5
                )
                wall.Material = Enum.Material.Grass
                wall.BrickColor = BrickColor.new("Bright green")
                wall.Anchored = true
                wall.Parent = maze
            end
        end
    end
    
    -- ========================================
    -- LAGO DE LÁGRIMAS
    -- ========================================
    
    local tearLake = Instance.new("Part")
    tearLake.Name = "TearLake"
    tearLake.Size = Vector3.new(100, 5, 100)
    tearLake.Position = Vector3.new(-100, 7.5, 200)
    tearLake.Material = Enum.Material.Water
    tearLake.BrickColor = BrickColor.new("Bright blue")
    tearLake.Transparency = 0.3
    tearLake.Anchored = true
    tearLake.Parent = Workspace
    
    -- Ondas en el agua
    local waterTween = TweenService:Create(
        tearLake,
        TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Transparency = 0.1}
    )
    waterTween:Play()
    
    -- ========================================
    -- HONGOS GIGANTES
    -- ========================================
    
    for i = 1, 15 do
        local mushroom = Instance.new("Model")
        mushroom.Name = "GiantMushroom" .. i
        mushroom.Parent = Workspace
        
        -- Tallo
        local stem = Instance.new("Part")
        stem.Name = "Stem"
        stem.Size = Vector3.new(3, 12, 3)
        stem.Material = Enum.Material.Concrete
        stem.BrickColor = BrickColor.new("White")
        stem.Anchored = true
        stem.Parent = mushroom
        
        -- Sombrero
        local cap = Instance.new("Part")
        cap.Name = "Cap"
        cap.Size = Vector3.new(12, 4, 12)
        cap.Material = Enum.Material.Neon
        cap.Shape = Enum.PartType.Cylinder
        cap.Anchored = true
        cap.Parent = mushroom
        
        -- Colores aleatorios para los hongos
        local colors = {"Really red", "Bright blue", "Bright green", "New Yeller", "Magenta"}
        cap.BrickColor = BrickColor.new(colors[math.random(1, #colors)])
        
        -- Posición aleatoria
        local x = math.random(-300, 300)
        local z = math.random(-300, 300)
        stem.Position = Vector3.new(x, 21, z)
        cap.Position = Vector3.new(x, 29, z)
        
        -- Efectos de brillo
        local pointLight = Instance.new("PointLight")
        pointLight.Brightness = 2
        pointLight.Range = 20
        pointLight.Color = cap.Color
        pointLight.Parent = cap
    end
end

-- ========================================
-- SISTEMA DE PERSONAJES NPC
-- ========================================

local function createNPC(name, position, color, dialogue)
    local npc = Instance.new("Model")
    npc.Name = name
    npc.Parent = Workspace
    
    -- Cuerpo del NPC
    local humanoid = Instance.new("Humanoid")
    humanoid.Parent = npc
    
    local head = Instance.new("Part")
    head.Name = "Head"
    head.Size = Vector3.new(2, 1, 1)
    head.Position = position + Vector3.new(0, 4.5, 0)
    head.BrickColor = BrickColor.new(color)
    head.Shape = Enum.PartType.Ball
    head.Material = Enum.Material.Neon
    head.Anchored = true
    head.Parent = npc
    
    local torso = Instance.new("Part")
    torso.Name = "Torso"
    torso.Size = Vector3.new(2, 2, 1)
    torso.Position = position + Vector3.new(0, 3, 0)
    torso.BrickColor = BrickColor.new(color)
    torso.Anchored = true
    torso.Parent = npc
    
    -- Diálogo del NPC
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Size = UDim2.new(0, 200, 0, 50)
    billboardGui.StudsOffset = Vector3.new(0, 3, 0)
    billboardGui.Parent = head
    
    local dialogueLabel = Instance.new("TextLabel")
    dialogueLabel.Size = UDim2.new(1, 0, 1, 0)
    dialogueLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dialogueLabel.BackgroundTransparency = 0.2
    dialogueLabel.BorderSizePixel = 0
    dialogueLabel.Font = Enum.Font.Fantasy
    dialogueLabel.TextSize = 14
    dialogueLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    dialogueLabel.Text = dialogue
    dialogueLabel.TextWrapped = true
    dialogueLabel.Parent = billboardGui
    
    -- Animación de flotación para NPCs
    local floatTween = TweenService:Create(
        npc.PrimaryPart or torso,
        TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Position = position + Vector3.new(0, 2, 0)}
    )
    floatTween:Play()
    
    return npc
end

-- Crear NPCs principales
local function createMainNPCs()
    -- Conejo Blanco
    createNPC("WhiteRabbit", Vector3.new(10, 15, 10), "White", "¡Llego tarde! ¡Muy tarde!")
    
    -- Gato de Cheshire
    createNPC("CheshireCat", Vector3.new(50, 25, 50), "Magenta", "Todos estamos locos aquí...")
    
    -- Sombrerero Loco
    createNPC("MadHatter", Vector3.new(80, 20, 80), "Bright green", "¿Por qué un cuervo se parece a un escritorio?")
    
    -- Reina de Corazones
    createNPC("QueenOfHearts", Vector3.new(-200, 20, -200), "Really red", "¡Que le corten la cabeza!")
    
    -- Oruga Azul
    createNPC("BlueCaterpillar", Vector3.new(150, 30, 150), "Bright blue", "¿Quién... eres... tú?")
end

-- ========================================
-- SISTEMA DE TRANSFORMACIONES MÁGICAS
-- ========================================

local function createTransformationPotions()
    -- Poción para crecer
    local growPotion = Instance.new("Part")
    growPotion.Name = "GrowPotion"
    growPotion.Size = Vector3.new(2, 4, 2)
    growPotion.Position = Vector3.new(75, 18, 85)
    growPotion.Material = Enum.Material.Glass
    growPotion.BrickColor = BrickColor.new("Bright red")
    growPotion.Shape = Enum.PartType.Cylinder
    growPotion.Anchored = true
    growPotion.Parent = Workspace
    
    -- Efectos de la poción
    local glowEffect = Instance.new("PointLight")
    glowEffect.Brightness = 3
    glowEffect.Range = 15
    glowEffect.Color = Color3.fromRGB(255, 0, 0)
    glowEffect.Parent = growPotion
    
    -- Poción para encogerse
    local shrinkPotion = Instance.new("Part")
    shrinkPotion.Name = "ShrinkPotion"
    shrinkPotion.Size = Vector3.new(2, 4, 2)
    shrinkPotion.Position = Vector3.new(85, 18, 85)
    shrinkPotion.Material = Enum.Material.Glass
    shrinkPotion.BrickColor = BrickColor.new("Bright blue")
    shrinkPotion.Shape = Enum.PartType.Cylinder
    shrinkPotion.Anchored = true
    shrinkPotion.Parent = Workspace
    
    local shrinkGlow = Instance.new("PointLight")
    shrinkGlow.Brightness = 3
    shrinkGlow.Range = 15
    shrinkGlow.Color = Color3.fromRGB(0, 0, 255)
    shrinkGlow.Parent = shrinkPotion
end

-- ========================================
-- SISTEMA DE MÚSICA Y SONIDOS
-- ========================================

local function setupAmbientSounds()
    -- Música de fondo mágica
    local backgroundMusic = Instance.new("Sound")
    backgroundMusic.Name = "WonderlandMusic"
    backgroundMusic.SoundId = "rbxasset://sounds/electronicpingshort.wav" -- Placeholder
    backgroundMusic.Volume = 0.3
    backgroundMusic.Looped = true
    backgroundMusic.Parent = Workspace
    backgroundMusic:Play()
    
    -- Sonidos ambientales
    local windSound = Instance.new("Sound")
    windSound.Name = "MagicalWind"
    windSound.SoundId = "rbxasset://sounds/wind_gust.mp3" -- Placeholder
    windSound.Volume = 0.2
    windSound.Looped = true
    windSound.Parent = Workspace
    windSound:Play()
end

-- ========================================
-- SISTEMA DE PARTÍCULAS MÁGICAS
-- ========================================

local function createMagicalParticles()
    -- Partículas flotantes en el aire
    for i = 1, 100 do
        local particle = Instance.new("Part")
        particle.Name = "MagicParticle"
        particle.Size = Vector3.new(0.5, 0.5, 0.5)
        particle.Material = Enum.Material.Neon
        particle.Shape = Enum.PartType.Ball
        particle.Anchored = true
        particle.CanCollide = false
        particle.Parent = Workspace
        
        -- Colores aleatorios
        local colors = {
            Color3.fromRGB(255, 255, 0),
            Color3.fromRGB(255, 0, 255),
            Color3.fromRGB(0, 255, 255),
            Color3.fromRGB(255, 100, 255)
        }
        particle.Color = colors[math.random(1, #colors)]
        
        -- Posición aleatoria
        particle.Position = Vector3.new(
            math.random(-400, 400),
            math.random(20, 80),
            math.random(-400, 400)
        )
        
        -- Animación de flotación
        local floatTween = TweenService:Create(
            particle,
            TweenInfo.new(
                math.random(3, 8),
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut,
                -1,
                true
            ),
            {
                Position = particle.Position + Vector3.new(
                    math.random(-10, 10),
                    math.random(-5, 5),
                    math.random(-10, 10)
                )
            }
        )
        floatTween:Play()
        
        -- Efecto de transparencia
        local fadeTween = TweenService:Create(
            particle,
            TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
            {Transparency = 0.8}
        )
        fadeTween:Play()
    end
end

-- ========================================
-- EVENTOS DEL JUEGO
-- ========================================

-- Función para iniciar el juego
local function startGame(player)
    -- Teletransportar al jugador al inicio
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(0, 20, 0)
        
        -- Iniciar cinemática de introducción
        cinematicEvent:FireClient(player, "intro")
    end
end

-- Función para manejar transformaciones
local function handleTransformation(player, transformationType)
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    if transformationType == "grow" then
        -- Hacer crecer al jugador
        local scaleTween = TweenService:Create(
            humanoid,
            TweenInfo.new(2, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out),
            {HipHeight = humanoid.HipHeight + 10}
        )
        scaleTween:Play()
        
        -- Cambiar tamaño de las partes del cuerpo
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                local sizeTween = TweenService:Create(
                    part,
                    TweenInfo.new(2, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out),
                    {Size = part.Size * 2}
                )
                sizeTween:Play()
            end
        end
        
    elseif transformationType == "shrink" then
        -- Hacer encoger al jugador
        local scaleTween = TweenService:Create(
            humanoid,
            TweenInfo.new(2, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out),
            {HipHeight = math.max(humanoid.HipHeight - 5, -2)}
        )
        scaleTween:Play()
        
        -- Cambiar tamaño de las partes del cuerpo
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                local sizeTween = TweenService:Create(
                    part,
                    TweenInfo.new(2, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out),
                    {Size = part.Size * 0.5}
                )
                sizeTween:Play()
            end
        end
    end
end

-- ========================================
-- SISTEMA DE MISIONES
-- ========================================

local playerQuests = {}

local function initializeQuests(player)
    playerQuests[player.UserId] = {
        currentQuest = 1,
        completedQuests = {},
        questProgress = {}
    }
end

local quests = {
    {
        id = 1,
        name = "Sigue al Conejo Blanco",
        description = "Encuentra y sigue al Conejo Blanco hasta su madriguera",
        objective = "reach_rabbit_hole",
        reward = "Acceso al País de las Maravillas"
    },
    {
        id = 2,
        name = "La Fiesta del Té",
        description = "Únete a la fiesta del té del Sombrerero Loco",
        objective = "attend_tea_party",
        reward = "Sombrero Mágico"
    },
    {
        id = 3,
        name = "El Jardín de la Reina",
        description = "Ayuda a pintar las rosas rojas en el jardín de la Reina",
        objective = "paint_roses",
        reward = "Rosa Dorada"
    },
    {
        id = 4,
        name = "Escapa del Laberinto",
        description = "Encuentra la salida del laberinto de setos",
        objective = "escape_maze",
        reward = "Brújula Mágica"
    },
    {
        id = 5,
        name = "El Enigma del Gato",
        description = "Resuelve el acertijo del Gato de Cheshire",
        objective = "solve_riddle",
        reward = "Sonrisa Invisible"
    }
}

-- ========================================
-- EFECTOS CINEMATOGRÁFICOS
-- ========================================

local function createCinematicEffects()
    -- Efectos de lluvia de pétalos
    local function createPetalRain()
        for i = 1, 50 do
            local petal = Instance.new("Part")
            petal.Name = "Petal"
            petal.Size = Vector3.new(0.5, 0.1, 0.5)
            petal.Material = Enum.Material.Neon
            petal.BrickColor = BrickColor.new("Hot pink")
            petal.Shape = Enum.PartType.Block
            petal.Anchored = true
            petal.CanCollide = false
            petal.Parent = Workspace
            
            petal.Position = Vector3.new(
                math.random(-500, 500),
                100,
                math.random(-500, 500)
            )
            
            -- Animación de caída
            local fallTween = TweenService:Create(
                petal,
                TweenInfo.new(10, Enum.EasingStyle.Linear),
                {Position = petal.Position - Vector3.new(0, 120, 0)}
            )
            fallTween:Play()
            
            -- Rotación mientras cae
            local rotateTween = TweenService:Create(
                petal,
                TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
                {Rotation = Vector3.new(0, 360, 0)}
            )
            rotateTween:Play()
            
            -- Eliminar después de caer
            Debris:AddItem(petal, 10)
        end
    end
    
    -- Crear lluvia de pétalos cada 30 segundos
    spawn(function()
        while true do
            wait(30)
            createPetalRain()
        end
    end)
end

-- ========================================
-- CONEXIONES DE EVENTOS
-- ========================================

-- Cuando un jugador se une
Players.PlayerAdded:Connect(function(player)
    initializeQuests(player)
    
    player.CharacterAdded:Connect(function(character)
        wait(1) -- Esperar a que el personaje se cargue completamente
        startGame(player)
    end)
end)

-- Eventos remotos
startGameEvent.OnServerEvent:Connect(startGame)

transformEvent.OnServerEvent:Connect(function(player, transformationType)
    handleTransformation(player, transformationType)
end)

-- ========================================
-- DETECCIÓN DE COLISIONES PARA INTERACCIONES
-- ========================================

local function setupInteractions()
    -- Interacción con pociones
    local function onPotionTouched(hit, potionType)
        local character = hit.Parent
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local player = Players:GetPlayerFromCharacter(character)
            if player then
                transformEvent:FireClient(player, potionType)
                handleTransformation(player, potionType)
            end
        end
    end
    
    -- Configurar detección para pociones
    if Workspace:FindFirstChild("GrowPotion") then
        Workspace.GrowPotion.Touched:Connect(function(hit)
            onPotionTouched(hit, "grow")
        end)
    end
    
    if Workspace:FindFirstChild("ShrinkPotion") then
        Workspace.ShrinkPotion.Touched:Connect(function(hit)
            onPotionTouched(hit, "shrink")
        end)
    end
end

-- ========================================
-- INICIALIZACIÓN DEL MUNDO
-- ========================================

-- Crear todo el mundo de Alicia
createWonderland()
createMainNPCs()
createTransformationPotions()
setupAmbientSounds()
createMagicalParticles()
createCinematicEffects()
setupInteractions()

print("🎭 Mundo de Alicia en el País de las Maravillas creado exitosamente!")
print("🌟 ¡Bienvenidos a la aventura mágica!")

-- ========================================
-- SISTEMA DE GUARDADO DE PROGRESO
-- ========================================

local DataStoreService = game:GetService("DataStoreService")
local playerDataStore = DataStoreService:GetDataStore("AliceWonderlandData")

local function savePlayerData(player)
    local success, errorMessage = pcall(function()
        local dataToSave = {
            quests = playerQuests[player.UserId],
            lastPosition = player.Character and player.Character.HumanoidRootPart.Position or Vector3.new(0, 20, 0),
            transformations = 0 -- Contador de transformaciones
        }
        
        playerDataStore:SetAsync(player.UserId, dataToSave)
    end)
    
    if not success then
        warn("Error al guardar datos del jugador: " .. errorMessage)
    end
end

local function loadPlayerData(player)
    local success, playerData = pcall(function()
        return playerDataStore:GetAsync(player.UserId)
    end)
    
    if success and playerData then
        playerQuests[player.UserId] = playerData.quests or {
            currentQuest = 1,
            completedQuests = {},
            questProgress = {}
        }
        return playerData
    else
        initializeQuests(player)
        return nil
    end
end

-- Guardar datos cuando el jugador se va
Players.PlayerRemoving:Connect(function(player)
    savePlayerData(player)
    playerQuests[player.UserId] = nil
end)

-- Guardar datos periódicamente
spawn(function()
    while true do
        wait(300) -- Guardar cada 5 minutos
        for _, player in pairs(Players:GetPlayers()) do
            savePlayerData(player)
        end
    end
end)