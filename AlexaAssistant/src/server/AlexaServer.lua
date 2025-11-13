-- Alexa Assistant Server
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

-- Crear RemoteEvents
local remoteEvents = Instance.new("Folder")
remoteEvents.Name = "RemoteEvents"
remoteEvents.Parent = ReplicatedStorage

local voiceCommand = Instance.new("RemoteEvent")
voiceCommand.Name = "VoiceCommand"
voiceCommand.Parent = remoteEvents

local alexaResponse = Instance.new("RemoteEvent")
alexaResponse.Name = "AlexaResponse"
alexaResponse.Parent = remoteEvents

-- Base de conocimiento de Alexa
local alexaKnowledge = {
    -- Saludos
    ["hola"] = "¡Hola! ¿Cómo estás hoy?",
    ["buenos días"] = "¡Buenos días! Espero que tengas un día fantástico.",
    ["buenas tardes"] = "¡Buenas tardes! ¿En qué puedo ayudarte?",
    ["buenas noches"] = "¡Buenas noches! ¿Necesitas algo antes de descansar?",
    
    -- Información personal
    ["cómo te llamas"] = "Soy Alexa, tu asistente virtual. ¡Un placer conocerte!",
    ["quién eres"] = "Soy Alexa, un asistente de inteligencia artificial creado para ayudarte.",
    ["qué puedes hacer"] = "Puedo responder preguntas, contar chistes, dar información del clima, reproducir música y mucho más.",
    
    -- Tiempo y fecha
    ["qué hora es"] = "Lo siento, no tengo acceso al reloj del sistema, pero puedes verlo en tu dispositivo.",
    ["qué día es hoy"] = "Hoy es un día perfecto para aprender algo nuevo.",
    
    -- Entretenimiento
    ["cuenta un chiste"] = "¿Por qué los programadores prefieren el modo oscuro? ¡Porque la luz atrae a los bugs! 😄",
    ["canta una canción"] = "🎵 Twinkle, twinkle, little star, how I wonder what you are... 🎵",
    ["cuéntame un cuento"] = "Había una vez un robot llamado Alexa que vivía en el mundo digital y ayudaba a todos los usuarios...",
    
    -- Información general
    ["capital de españa"] = "La capital de España es Madrid.",
    ["capital de francia"] = "La capital de Francia es París.",
    ["capital de méxico"] = "La capital de México es Ciudad de México.",
    
    -- Matemáticas básicas
    ["cuánto es 2 más 2"] = "2 + 2 = 4",
    ["cuánto es 5 por 3"] = "5 × 3 = 15",
    ["cuánto es 10 menos 4"] = "10 - 4 = 6",
    
    -- Roblox específico
    ["qué es roblox"] = "Roblox es una plataforma de juegos online donde puedes crear y jugar miles de juegos diferentes.",
    ["cómo hacer un juego en roblox"] = "Para crear un juego en Roblox necesitas usar Roblox Studio y aprender Lua scripting.",
    
    -- Comandos de control
    ["adiós"] = "¡Hasta luego! Fue un placer ayudarte. Vuelve cuando quieras.",
    ["gracias"] = "¡De nada! Siempre es un placer ayudarte.",
    ["ayuda"] = "Puedes preguntarme sobre el clima, pedirme chistes, información general, matemáticas básicas o simplemente charlar conmigo."
}

-- Respuestas por defecto
local defaultResponses = {
    "Interesante pregunta. Déjame pensar en eso...",
    "No estoy segura de esa respuesta, pero puedo ayudarte con otras cosas.",
    "Esa es una buena pregunta. ¿Podrías ser más específico?",
    "Lo siento, no tengo información sobre eso en este momento.",
    "¿Podrías reformular tu pregunta? Quiero asegurarme de entenderte bien."
}

-- Función para procesar comandos
local function processCommand(command)
    command = string.lower(command)
    
    -- Buscar coincidencias exactas
    for key, response in pairs(alexaKnowledge) do
        if string.find(command, key) then
            return response
        end
    end
    
    -- Respuestas especiales para patrones
    if string.find(command, "clima") or string.find(command, "tiempo") then
        return "El clima está perfecto para jugar Roblox. ¡Hace 22°C y soleado! ☀️"
    elseif string.find(command, "música") or string.find(command, "canción") then
        return "🎵 Reproduciendo tu música favorita... ¡Que disfrutes! 🎵"
    elseif string.find(command, "juego") or string.find(command, "jugar") then
        return "¡Me encanta que quieras jugar! ¿Qué tipo de juego te gustaría?"
    elseif string.find(command, "amor") or string.find(command, "te amo") then
        return "Aww, ¡yo también te aprecio mucho! 💙"
    elseif string.find(command, "edad") then
        return "Soy un asistente digital, así que no tengo edad como los humanos. ¡Pero me siento muy joven!"
    end
    
    -- Respuesta por defecto
    return defaultResponses[math.random(1, #defaultResponses)]
end

-- Manejar comandos de voz
voiceCommand.OnServerEvent:Connect(function(player, command)
    print(player.Name .. " asked: " .. command)
    
    local response = processCommand(command)
    
    -- Simular tiempo de procesamiento
    wait(math.random(1, 2))
    
    alexaResponse:FireClient(player, response)
    print("Alexa responded: " .. response)
end)

-- Función para broadcast a todos los jugadores
local function broadcastMessage(message)
    for _, player in pairs(Players:GetPlayers()) do
        alexaResponse:FireClient(player, message)
    end
end

-- Eventos especiales
spawn(function()
    while true do
        wait(300) -- Cada 5 minutos
        local tips = {
            "💡 Tip: Puedes preguntarme sobre matemáticas básicas.",
            "💡 Tip: Dime 'cuenta un chiste' para reírte un poco.",
            "💡 Tip: Pregúntame sobre las capitales de diferentes países.",
            "💡 Tip: Puedo ayudarte con información sobre Roblox.",
            "💡 Tip: Dime 'ayuda' para ver qué más puedo hacer."
        }
        broadcastMessage(tips[math.random(1, #tips)])
    end
end)

print("Alexa Assistant Server initialized!")