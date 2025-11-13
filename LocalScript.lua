-- STRANGER THINGS CLIENT SCRIPT
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local questEvent = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("QuestEvent")
local cinematicEvent = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("CinematicEvent")

-- UI DE MISIONES
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "QuestUI"
screenGui.ResetOnSpawn = false

local questFrame = Instance.new("Frame", screenGui)
questFrame.Size = UDim2.new(0, 300, 0, 150)
questFrame.Position = UDim2.new(0, 20, 0, 20)
questFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
questFrame.BackgroundTransparency = 0.3
questFrame.BorderSizePixel = 0

local questTitle = Instance.new("TextLabel", questFrame)
questTitle.Size = UDim2.new(1, 0, 0, 40)
questTitle.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
questTitle.Font = Enum.Font.SourceSansBold
questTitle.TextSize = 20
questTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
questTitle.Text = "📋 MISIÓN ACTUAL"

local questName = Instance.new("TextLabel", questFrame)
questName.Size = UDim2.new(1, -20, 0, 40)
questName.Position = UDim2.new(0, 10, 0, 50)
questName.BackgroundTransparency = 1
questName.Font = Enum.Font.SourceSansBold
questName.TextSize = 18
questName.TextColor3 = Color3.fromRGB(255, 215, 0)
questName.TextXAlignment = Enum.TextXAlignment.Left
questName.Text = "Encuentra a Will"

local questDesc = Instance.new("TextLabel", questFrame)
questDesc.Size = UDim2.new(1, -20, 0, 50)
questDesc.Position = UDim2.new(0, 10, 0, 90)
questDesc.BackgroundTransparency = 1
questDesc.Font = Enum.Font.SourceSans
questDesc.TextSize = 16
questDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
questDesc.TextXAlignment = Enum.TextXAlignment.Left
questDesc.TextWrapped = true
questDesc.Text = "Busca pistas en Castle Byers"

-- NOTIFICACIONES
local function showNotification(title, message, color)
    local notif = Instance.new("Frame", screenGui)
    notif.Size = UDim2.new(0, 350, 0, 80)
    notif.Position = UDim2.new(0.5, -175, 0, -100)
    notif.BackgroundColor3 = color or Color3.fromRGB(0, 150, 0)
    notif.BorderSizePixel = 0
    
    local notifTitle = Instance.new("TextLabel", notif)
    notifTitle.Size = UDim2.new(1, 0, 0, 30)
    notifTitle.BackgroundTransparency = 1
    notifTitle.Font = Enum.Font.SourceSansBold
    notifTitle.TextSize = 20
    notifTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    notifTitle.Text = title
    
    local notifMsg = Instance.new("TextLabel", notif)
    notifMsg.Size = UDim2.new(1, -10, 0, 45)
    notifMsg.Position = UDim2.new(0, 5, 0, 30)
    notifMsg.BackgroundTransparency = 1
    notifMsg.Font = Enum.Font.SourceSans
    notifMsg.TextSize = 16
    notifMsg.TextColor3 = Color3.fromRGB(255, 255, 255)
    notifMsg.TextWrapped = true
    notifMsg.Text = message
    
    notif:TweenPosition(UDim2.new(0.5, -175, 0, 20), "Out", "Bounce", 0.5, true)
    
    wait(3)
    notif:TweenPosition(UDim2.new(0.5, -175, 0, -100), "In", "Back", 0.3, true)
    wait(0.3)
    notif:Destroy()
end

-- EVENTOS
questEvent.OnClientEvent:Connect(function(action, data)
    if action == "complete" then
        showNotification("✅ MISIÓN COMPLETADA", data.name .. " - +" .. data.reward .. " puntos", Color3.fromRGB(0, 200, 0))
        
        if data.id < 5 then
            wait(1)
            local nextQuest = data.id + 1
            local quests = {
                "Encuentra a Will",
                "Investiga el Laboratorio",
                "Cierra el Portal",
                "Derrota al Demogorgon",
                "Salva Hawkins"
            }
            local descs = {
                "Busca pistas en Castle Byers",
                "Infiltrate en Hawkins Lab",
                "Sella la puerta al Upside Down",
                "Enfrenta a la criatura",
                "Protege la ciudad"
            }
            questName.Text = quests[nextQuest]
            questDesc.Text = descs[nextQuest]
            showNotification("🎯 NUEVA MISIÓN", quests[nextQuest], Color3.fromRGB(255, 165, 0))
        else
            questName.Text = "¡JUEGO COMPLETADO!"
            questDesc.Text = "Has salvado Hawkins"
        end
    end
end)

cinematicEvent.OnClientEvent:Connect(function(type)
    if type == "intro" then
        showNotification("🎮 STRANGER THINGS", "Bienvenido a Hawkins. Encuentra a Will Byers.", Color3.fromRGB(139, 0, 0))
    end
end)

print("✅ Cliente de Stranger Things cargado")
