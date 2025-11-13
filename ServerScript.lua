-- STRANGER THINGS ROBLOX GAME - SERVER SCRIPT
-- Mundo completo de Hawkins con todas las locaciones

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Debris = game:GetService("Debris")

-- Crear RemoteEvents
local remoteEvents = Instance.new("Folder", ReplicatedStorage)
remoteEvents.Name = "RemoteEvents"

local startGameEvent = Instance.new("RemoteEvent", remoteEvents)
startGameEvent.Name = "StartGame"

local questEvent = Instance.new("RemoteEvent", remoteEvents)
questEvent.Name = "QuestEvent"

local cinematicEvent = Instance.new("RemoteEvent", remoteEvents)
cinematicEvent.Name = "CinematicEvent"

-- CONFIGURACIÓN DEL MUNDO
local function createHawkins()
    -- Iluminación oscura y misteriosa
    Lighting.Brightness = 1
    Lighting.Ambient = Color3.fromRGB(50, 50, 80)
    Lighting.OutdoorAmbient = Color3.fromRGB(80, 80, 100)
    Lighting.TimeOfDay = "20:00:00"
    Lighting.FogEnd = 500
    Lighting.FogColor = Color3.fromRGB(20, 20, 40)
    
    local atmosphere = Instance.new("Atmosphere", Lighting)
    atmosphere.Density = 0.4
    atmosphere.Offset = 0.5
    atmosphere.Color = Color3.fromRGB(100, 100, 150)
    atmosphere.Decay = Color3.fromRGB(50, 50, 80)
    atmosphere.Glare = 0
    atmosphere.Haze = 2
    
    -- TERRENO BASE
    local terrain = workspace.Terrain
    for x = -600, 600, 20 do
        for z = -600, 600, 20 do
            local height = math.noise(x/150, z/150, 0) * 15 + 5
            terrain:FillRegion(
                Region3.new(Vector3.new(x-10, 0, z-10), Vector3.new(x+10, height, z+10)),
                4,
                Enum.Material.Grass
            )
        end
    end
    
    -- HAWKINS MIDDLE SCHOOL (Proporciones realistas)
    local school = Instance.new("Model", workspace)
    school.Name = "HawkinsMiddleSchool"
    
    local schoolBuilding = Instance.new("Part", school)
    schoolBuilding.Name = "MainBuilding"
    schoolBuilding.Size = Vector3.new(60, 15, 40)
    schoolBuilding.Position = Vector3.new(0, 12.5, 0)
    schoolBuilding.Material = Enum.Material.Brick
    schoolBuilding.BrickColor = BrickColor.new("Brick yellow")
    schoolBuilding.Anchored = true
    
    local roof = Instance.new("WedgePart", school)
    roof.Size = Vector3.new(62, 8, 42)
    roof.Position = Vector3.new(0, 24, 0)
    roof.Material = Enum.Material.Slate
    roof.BrickColor = BrickColor.new("Dark stone grey")
    roof.Anchored = true
    
    local door = Instance.new("Part", school)
    door.Name = "MainDoor"
    door.Size = Vector3.new(6, 8, 0.5)
    door.Position = Vector3.new(0, 9, 20.5)
    door.Material = Enum.Material.Wood
    door.BrickColor = BrickColor.new("CGA brown")
    door.Anchored = true
    
    for x = -25, 25, 12 do
        for y = 8, 16, 8 do
            if math.abs(x) > 8 or y > 12 then
                local window = Instance.new("Part", school)
                window.Size = Vector3.new(4, 5, 0.3)
                window.Position = Vector3.new(x, y, 20.6)
                window.Material = Enum.Material.Glass
                window.Transparency = 0.6
                window.Reflectance = 0.3
                window.Anchored = true
            end
        end
    end
    
    local gym = Instance.new("Part", school)
    gym.Name = "Gymnasium"
    gym.Size = Vector3.new(30, 12, 35)
    gym.Position = Vector3.new(50, 11, 0)
    gym.Material = Enum.Material.Concrete
    gym.BrickColor = BrickColor.new("Medium stone grey")
    gym.Anchored = true
    
    local court = Instance.new("Part", school)
    court.Size = Vector3.new(25, 0.2, 30)
    court.Position = Vector3.new(50, 5.1, 0)
    court.Material = Enum.Material.Wood
    court.BrickColor = BrickColor.new("Nougat")
    court.Anchored = true
    
    -- LABORATORIO SECRETO (HAWKINS LAB) - Rediseñado
    local lab = Instance.new("Model", workspace)
    lab.Name = "HawkinsLab"
    
    local labBuilding = Instance.new("Part", lab)
    labBuilding.Name = "LabBuilding"
    labBuilding.Size = Vector3.new(70, 25, 60)
    labBuilding.Position = Vector3.new(-300, 17.5, -300)
    labBuilding.Material = Enum.Material.Concrete
    labBuilding.BrickColor = BrickColor.new("Dark stone grey")
    labBuilding.Anchored = true
    
    for i = 1, 50 do
        local fence = Instance.new("Part", lab)
        fence.Size = Vector3.new(0.5, 6, 0.5)
        fence.Material = Enum.Material.Metal
        fence.BrickColor = BrickColor.new("Really black")
        fence.Anchored = true
        local angle = (i-1) * (math.pi * 2 / 50)
        fence.Position = Vector3.new(-300 + math.cos(angle) * 60, 8, -300 + math.sin(angle) * 60)
    end
    
    -- Luces rojas de emergencia
    for i = 1, 8 do
        local light = Instance.new("Part", lab)
        light.Size = Vector3.new(2, 2, 2)
        light.Shape = Enum.PartType.Ball
        light.Material = Enum.Material.Neon
        light.BrickColor = BrickColor.new("Really red")
        light.Anchored = true
        light.Position = Vector3.new(-300 + (i-4)*15, 45, -300)
        
        local pointLight = Instance.new("PointLight", light)
        pointLight.Brightness = 5
        pointLight.Range = 30
        pointLight.Color = Color3.fromRGB(255, 0, 0)
        
        -- Parpadeo
        spawn(function()
            while true do
                pointLight.Enabled = not pointLight.Enabled
                wait(0.5)
            end
        end)
    end
    
    local portal = Instance.new("Part", lab)
    portal.Name = "UpsideDownPortal"
    portal.Size = Vector3.new(10, 12, 0.5)
    portal.Position = Vector3.new(-300, 11, -240)
    portal.Material = Enum.Material.Neon
    portal.BrickColor = BrickColor.new("Really red")
    portal.Transparency = 0.4
    portal.Anchored = true
    
    local portalParticles = Instance.new("ParticleEmitter", portal)
    portalParticles.Texture = "rbxasset://textures/particles/smoke_main.dds"
    portalParticles.Rate = 30
    portalParticles.Lifetime = NumberRange.new(1.5, 3)
    portalParticles.Speed = NumberRange.new(3, 7)
    portalParticles.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
    
    -- CASA DE MIKE WHEELER (Proporciones realistas)
    local mikeHouse = Instance.new("Model", workspace)
    mikeHouse.Name = "MikeHouse"
    
    local house = Instance.new("Part", mikeHouse)
    house.Size = Vector3.new(20, 12, 18)
    house.Position = Vector3.new(150, 11, 150)
    house.Material = Enum.Material.Brick
    house.BrickColor = BrickColor.new("Daisy orange")
    house.Anchored = true
    
    local houseRoof = Instance.new("WedgePart", mikeHouse)
    houseRoof.Size = Vector3.new(22, 6, 20)
    houseRoof.Position = Vector3.new(150, 20, 150)
    houseRoof.Material = Enum.Material.Slate
    houseRoof.BrickColor = BrickColor.new("Dark stone grey")
    houseRoof.Anchored = true
    
    local basement = Instance.new("Part", mikeHouse)
    basement.Name = "Basement"
    basement.Size = Vector3.new(18, 6, 16)
    basement.Position = Vector3.new(150, 2, 150)
    basement.Material = Enum.Material.Concrete
    basement.BrickColor = BrickColor.new("Medium stone grey")
    basement.Anchored = true
    basement.Transparency = 1
    
    local dndTable = Instance.new("Part", mikeHouse)
    dndTable.Name = "DnDTable"
    dndTable.Size = Vector3.new(6, 0.5, 4)
    dndTable.Position = Vector3.new(150, 5.5, 150)
    dndTable.Material = Enum.Material.Wood
    dndTable.BrickColor = BrickColor.new("CGA brown")
    dndTable.Anchored = true
    
    -- BOSQUE DE HAWKINS (Optimizado)
    for i = 1, 80 do
        local tree = Instance.new("Model", workspace)
        tree.Name = "Tree" .. i
        
        local trunk = Instance.new("Part", tree)
        trunk.Size = Vector3.new(2, 15, 2)
        trunk.Material = Enum.Material.Wood
        trunk.BrickColor = BrickColor.new("CGA brown")
        trunk.Anchored = true
        
        local leaves = Instance.new("Part", tree)
        leaves.Size = Vector3.new(10, 10, 10)
        leaves.Shape = Enum.PartType.Ball
        leaves.Material = Enum.Material.Grass
        leaves.BrickColor = BrickColor.new("Dark green")
        leaves.Anchored = true
        
        local x = math.random(-500, 500)
        local z = math.random(-500, 500)
        trunk.Position = Vector3.new(x, 12.5, z)
        leaves.Position = Vector3.new(x, 22, z)
    end
    
    -- BENNY'S BURGERS (Rediseñado)
    local bennys = Instance.new("Model", workspace)
    bennys.Name = "BennysBurgers"
    
    local restaurant = Instance.new("Part", bennys)
    restaurant.Size = Vector3.new(25, 10, 20)
    restaurant.Position = Vector3.new(200, 10, -100)
    restaurant.Material = Enum.Material.Brick
    restaurant.BrickColor = BrickColor.new("Bright red")
    restaurant.Anchored = true
    
    local sign = Instance.new("Part", bennys)
    sign.Size = Vector3.new(15, 3, 0.5)
    sign.Position = Vector3.new(200, 18, -90)
    sign.Material = Enum.Material.Neon
    sign.BrickColor = BrickColor.new("New Yeller")
    sign.Anchored = true
    
    local signLight = Instance.new("PointLight", sign)
    signLight.Brightness = 2.5
    signLight.Range = 25
    signLight.Color = Color3.fromRGB(255, 255, 0)
    
    -- STARCOURT MALL (Rediseñado)
    local mall = Instance.new("Model", workspace)
    mall.Name = "StarcourtMall"
    
    local mallBuilding = Instance.new("Part", mall)
    mallBuilding.Size = Vector3.new(100, 20, 80)
    mallBuilding.Position = Vector3.new(-400, 15, 200)
    mallBuilding.Material = Enum.Material.Concrete
    mallBuilding.BrickColor = BrickColor.new("White")
    mallBuilding.Anchored = true
    
    local mallSign = Instance.new("Part", mall)
    mallSign.Size = Vector3.new(50, 6, 1)
    mallSign.Position = Vector3.new(-400, 28, 241)
    mallSign.Material = Enum.Material.Neon
    mallSign.BrickColor = BrickColor.new("Hot pink")
    mallSign.Anchored = true
    
    local stores = {"Scoops Ahoy", "Gap", "Claire's", "JCPenney"}
    for i, storeName in ipairs(stores) do
        local store = Instance.new("Part", mall)
        store.Name = storeName
        store.Size = Vector3.new(15, 12, 10)
        store.Position = Vector3.new(-430 + i*22, 11, 220)
        store.Material = Enum.Material.SmoothPlastic
        store.BrickColor = BrickColor.new("Bright blue")
        store.Anchored = true
    end
    
    -- CASTLE BYERS (Fortaleza de Will) - Rediseñado
    local castle = Instance.new("Model", workspace)
    castle.Name = "CastleByers"
    
    local walls = {
        {pos = Vector3.new(300, 8, 293), size = Vector3.new(12, 6, 0.5)},
        {pos = Vector3.new(306, 8, 300), size = Vector3.new(0.5, 6, 12), rot = 90},
        {pos = Vector3.new(300, 8, 307), size = Vector3.new(12, 6, 0.5)},
        {pos = Vector3.new(294, 8, 300), size = Vector3.new(0.5, 6, 12), rot = 90}
    }
    
    for _, w in ipairs(walls) do
        local wall = Instance.new("Part", castle)
        wall.Size = w.size
        wall.Position = w.pos
        wall.Material = Enum.Material.Wood
        wall.BrickColor = BrickColor.new("CGA brown")
        wall.Anchored = true
        if w.rot then wall.Orientation = Vector3.new(0, w.rot, 0) end
    end
    
    for i = 1, 26 do
        local light = Instance.new("Part", castle)
        light.Name = "ChristmasLight" .. i
        light.Size = Vector3.new(0.4, 0.4, 0.4)
        light.Shape = Enum.PartType.Ball
        light.Material = Enum.Material.Neon
        light.BrickColor = BrickColor.new("Really red")
        light.Anchored = true
        light.Position = Vector3.new(294 + i*0.5, 10, 300)
        
        local bulbLight = Instance.new("PointLight", light)
        bulbLight.Brightness = 1.5
        bulbLight.Range = 8
        bulbLight.Color = Color3.fromRGB(255, 0, 0)
    end
    
    -- THE UPSIDE DOWN (Mundo Invertido)
    local upsideDown = Instance.new("Model", workspace)
    upsideDown.Name = "UpsideDown"
    
    local upsideDownGround = Instance.new("Part", upsideDown)
    upsideDownGround.Size = Vector3.new(1000, 5, 1000)
    upsideDownGround.Position = Vector3.new(0, -100, 0)
    upsideDownGround.Material = Enum.Material.Slate
    upsideDownGround.BrickColor = BrickColor.new("Really black")
    upsideDownGround.Anchored = true
    
    -- Partículas flotantes del Upside Down
    for i = 1, 200 do
        local particle = Instance.new("Part", upsideDown)
        particle.Size = Vector3.new(0.3, 0.3, 0.3)
        particle.Shape = Enum.PartType.Ball
        particle.Material = Enum.Material.Neon
        particle.BrickColor = BrickColor.new("Really black")
        particle.Anchored = true
        particle.CanCollide = false
        particle.Position = Vector3.new(
            math.random(-500, 500),
            math.random(-95, -50),
            math.random(-500, 500)
        )
        
        local floatTween = TweenService:Create(
            particle,
            TweenInfo.new(math.random(3, 8), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
            {Position = particle.Position + Vector3.new(math.random(-5, 5), math.random(-3, 3), math.random(-5, 5))}
        )
        floatTween:Play()
    end
    
    -- DEMOGORGON SPAWN POINTS
    for i = 1, 5 do
        local spawnPoint = Instance.new("Part", workspace)
        spawnPoint.Name = "DemogorgonSpawn" .. i
        spawnPoint.Size = Vector3.new(5, 0.5, 5)
        spawnPoint.Position = Vector3.new(math.random(-400, 400), 6, math.random(-400, 400))
        spawnPoint.Material = Enum.Material.Neon
        spawnPoint.BrickColor = BrickColor.new("Really red")
        spawnPoint.Transparency = 0.7
        spawnPoint.Anchored = true
        
        local spawnParticles = Instance.new("ParticleEmitter", spawnPoint)
        spawnParticles.Texture = "rbxasset://textures/particles/smoke_main.dds"
        spawnParticles.Rate = 20
        spawnParticles.Lifetime = NumberRange.new(1, 3)
        spawnParticles.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
    end
    
    -- CASA DE HOPPER (Rediseñado)
    local hopperCabin = Instance.new("Model", workspace)
    hopperCabin.Name = "HopperCabin"
    
    local cabin = Instance.new("Part", hopperCabin)
    cabin.Size = Vector3.new(18, 10, 15)
    cabin.Position = Vector3.new(-150, 10, 250)
    cabin.Material = Enum.Material.Wood
    cabin.BrickColor = BrickColor.new("CGA brown")
    cabin.Anchored = true
    
    local cabinRoof = Instance.new("WedgePart", hopperCabin)
    cabinRoof.Size = Vector3.new(20, 5, 17)
    cabinRoof.Position = Vector3.new(-150, 17, 250)
    cabinRoof.Material = Enum.Material.Slate
    cabinRoof.BrickColor = BrickColor.new("Dark stone grey")
    cabinRoof.Anchored = true
    
    -- ARCADE PALACE (Rediseñado)
    local arcade = Instance.new("Model", workspace)
    arcade.Name = "ArcadePalace"
    
    local arcadeBuilding = Instance.new("Part", arcade)
    arcadeBuilding.Size = Vector3.new(28, 12, 24)
    arcadeBuilding.Position = Vector3.new(250, 11, -50)
    arcadeBuilding.Material = Enum.Material.Brick
    arcadeBuilding.BrickColor = BrickColor.new("Bright violet")
    arcadeBuilding.Anchored = true
    
    for i = 1, 8 do
        local machine = Instance.new("Part", arcade)
        machine.Name = "ArcadeMachine" .. i
        machine.Size = Vector3.new(2.5, 4, 1.5)
        machine.Position = Vector3.new(240 + (i%4)*6, 7, -56 + math.floor(i/4)*10)
        machine.Material = Enum.Material.SmoothPlastic
        machine.BrickColor = BrickColor.new("Really black")
        machine.Anchored = true
        
        local screen = Instance.new("Part", arcade)
        screen.Size = Vector3.new(2, 2.5, 0.1)
        screen.Position = Vector3.new(240 + (i%4)*6, 7.5, -54.7 + math.floor(i/4)*10)
        screen.Material = Enum.Material.Neon
        screen.BrickColor = BrickColor.new("Cyan")
        screen.Anchored = true
    end
    
    -- BIBLIOTECA PÚBLICA (Rediseñado)
    local library = Instance.new("Model", workspace)
    library.Name = "PublicLibrary"
    
    local libraryBuilding = Instance.new("Part", library)
    libraryBuilding.Size = Vector3.new(40, 15, 30)
    libraryBuilding.Position = Vector3.new(100, 12.5, -200)
    libraryBuilding.Material = Enum.Material.Brick
    libraryBuilding.BrickColor = BrickColor.new("Brick yellow")
    libraryBuilding.Anchored = true
    
    for i = 1, 12 do
        local shelf = Instance.new("Part", library)
        shelf.Size = Vector3.new(6, 8, 0.5)
        shelf.Position = Vector3.new(88 + (i%4)*8, 9, -208 + math.floor(i/4)*8)
        shelf.Material = Enum.Material.Wood
        shelf.BrickColor = BrickColor.new("CGA brown")
        shelf.Anchored = true
    end
end

-- SISTEMA DE NPCs
local function createNPC(name, position, dialogue)
    local npc = Instance.new("Model", workspace)
    npc.Name = name
    
    local humanoid = Instance.new("Humanoid", npc)
    
    local head = Instance.new("Part", npc)
    head.Name = "Head"
    head.Size = Vector3.new(2, 1, 1)
    head.Position = position + Vector3.new(0, 4.5, 0)
    head.BrickColor = BrickColor.new("Light orange")
    head.Shape = Enum.PartType.Ball
    head.Anchored = true
    
    local torso = Instance.new("Part", npc)
    torso.Name = "Torso"
    torso.Size = Vector3.new(2, 2, 1)
    torso.Position = position + Vector3.new(0, 3, 0)
    torso.BrickColor = BrickColor.new("Bright blue")
    torso.Anchored = true
    
    local billboardGui = Instance.new("BillboardGui", head)
    billboardGui.Size = UDim2.new(0, 200, 0, 50)
    billboardGui.StudsOffset = Vector3.new(0, 3, 0)
    
    local dialogueLabel = Instance.new("TextLabel", billboardGui)
    dialogueLabel.Size = UDim2.new(1, 0, 1, 0)
    dialogueLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    dialogueLabel.BackgroundTransparency = 0.3
    dialogueLabel.Font = Enum.Font.SourceSansBold
    dialogueLabel.TextSize = 14
    dialogueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    dialogueLabel.Text = dialogue
    dialogueLabel.TextWrapped = true
    
    return npc
end

-- Crear personajes principales
createNPC("Eleven", Vector3.new(0, 10, 20), "Amigos no mienten")
createNPC("Mike", Vector3.new(150, 10, 150), "Tenemos que encontrar a Will")
createNPC("Dustin", Vector3.new(10, 10, 20), "¡Esto es una locura!")
createNPC("Lucas", Vector3.new(-10, 10, 20), "Necesitamos un plan")
createNPC("Will", Vector3.new(300, 10, 300), "Estoy aquí...")
createNPC("Hopper", Vector3.new(-150, 10, 250), "Mantengan la calma")

-- SISTEMA DE MISIONES INTERACTIVO
local playerQuests = {}
local questZones = {}

local quests = {
    {id = 1, name = "Encuentra a Will", description = "Busca pistas en Castle Byers", location = Vector3.new(300, 10, 300), reward = 100},
    {id = 2, name = "Investiga el Laboratorio", description = "Infiltrate en Hawkins Lab", location = Vector3.new(-300, 10, -300), reward = 200},
    {id = 3, name = "Cierra el Portal", description = "Sella la puerta al Upside Down", location = Vector3.new(-300, 10, -240), reward = 300},
    {id = 4, name = "Derrota al Demogorgon", description = "Enfrenta a la criatura", location = Vector3.new(0, -90, 0), reward = 500},
    {id = 5, name = "Salva Hawkins", description = "Protege la ciudad", location = Vector3.new(0, 10, 0), reward = 1000}
}

for _, quest in ipairs(quests) do
    local zone = Instance.new("Part", workspace)
    zone.Name = "QuestZone" .. quest.id
    zone.Size = Vector3.new(15, 10, 15)
    zone.Position = quest.location
    zone.Transparency = 0.7
    zone.CanCollide = false
    zone.Anchored = true
    zone.BrickColor = BrickColor.new("Lime green")
    
    local billboard = Instance.new("BillboardGui", zone)
    billboard.Size = UDim2.new(0, 150, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 8, 0)
    
    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 0.5
    label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    label.TextColor3 = Color3.fromRGB(255, 255, 0)
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 18
    label.Text = "⭐ " .. quest.name
    
    questZones[quest.id] = zone
    
    zone.Touched:Connect(function(hit)
        local character = hit.Parent
        local player = Players:GetPlayerFromCharacter(character)
        if player and playerQuests[player.UserId] then
            local pq = playerQuests[player.UserId]
            if pq.currentQuest == quest.id and not pq.completed[quest.id] then
                pq.completed[quest.id] = true
                pq.currentQuest = quest.id + 1
                questEvent:FireClient(player, "complete", quest)
                zone.BrickColor = BrickColor.new("Bright green")
                label.Text = "✓ Completada"
            end
        end
    end)
end

Players.PlayerAdded:Connect(function(player)
    playerQuests[player.UserId] = {currentQuest = 1, completed = {}}
    
    local leaderstats = Instance.new("Folder", player)
    leaderstats.Name = "leaderstats"
    
    local points = Instance.new("IntValue", leaderstats)
    points.Name = "Puntos"
    points.Value = 0
    
    player.CharacterAdded:Connect(function(character)
        wait(1)
        character.HumanoidRootPart.CFrame = CFrame.new(0, 20, 0)
        cinematicEvent:FireClient(player, "intro")
    end)
end)

questEvent.OnServerEvent:Connect(function(player, action, data)
    if action == "complete" and playerQuests[player.UserId] then
        local quest = quests[data.id]
        if quest then
            player.leaderstats.Puntos.Value = player.leaderstats.Puntos.Value + quest.reward
        end
    end
end)

createHawkins()
print("🎮 Mundo de Stranger Things creado con misiones interactivas!")