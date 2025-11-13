-- Alexa Assistant Server
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- Crear dispositivo Alexa virtual
local function createAlexaDevice()
	local alexaModel = Instance.new("Model")
	alexaModel.Name = "AlexaDevice"
	alexaModel.Parent = workspace
	
	local base = Instance.new("Part")
	base.Name = "Base"
	base.Size = Vector3.new(4, 6, 4)
	base.Position = Vector3.new(0, 3, 0)
	base.Anchored = true
	base.Color = Color3.fromRGB(30, 30, 35)
	base.Material = Enum.Material.SmoothPlastic
	base.Shape = Enum.PartType.Cylinder
	base.Parent = alexaModel
	
	local lightRing = Instance.new("Part")
	lightRing.Name = "LightRing"
	lightRing.Size = Vector3.new(4.2, 0.3, 4.2)
	lightRing.Position = Vector3.new(0, 6.2, 0)
	lightRing.Anchored = true
	lightRing.Color = Color3.fromRGB(0, 255, 200)
	lightRing.Material = Enum.Material.Neon
	lightRing.Transparency = 0.5
	lightRing.Shape = Enum.PartType.Cylinder
	lightRing.Parent = alexaModel
	
	local pointLight = Instance.new("PointLight")
	pointLight.Color = Color3.fromRGB(0, 255, 200)
	pointLight.Brightness = 3
	pointLight.Range = 20
	pointLight.Parent = lightRing
	
	alexaModel.PrimaryPart = base
	
	-- Animación
	spawn(function()
		while lightRing.Parent do
			TweenService:Create(lightRing, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
				Transparency = 0.8
			}):Play()
			TweenService:Create(pointLight, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
				Brightness = 5
			}):Play()
			wait(2)
		end
	end)
	
	return alexaModel
end

-- Remote Events
local RemoteEvents = Instance.new("Folder")
RemoteEvents.Name = "RemoteEvents"
RemoteEvents.Parent = ReplicatedStorage

local VoiceCommand = Instance.new("RemoteEvent")
VoiceCommand.Name = "VoiceCommand"
VoiceCommand.Parent = RemoteEvents

local AlexaResponse = Instance.new("RemoteEvent")
AlexaResponse.Name = "AlexaResponse"
AlexaResponse.Parent = RemoteEvents

-- Comandos de Alexa
local commands = {
	["hola"] = "Hola, ¿en qué puedo ayudarte?",
	["como estas"] = "Estoy funcionando perfectamente, gracias por preguntar.",
	["que hora es"] = function() return "Son las " .. os.date("%H:%M") end,
	["cuentame un chiste"] = "¿Por qué los programadores prefieren el modo oscuro? Porque la luz atrae bugs.",
	["reproduce musica"] = "Reproduciendo tu música favorita...",
	["apaga las luces"] = "Apagando las luces...",
	["enciende las luces"] = "Encendiendo las luces...",
	["cual es tu nombre"] = "Soy Alexa, tu asistente virtual en Roblox.",
	["ayuda"] = "Puedo responder preguntas, contar chistes, controlar luces y mucho más. Solo pregúntame.",
	["adios"] = "Hasta luego, que tengas un buen día.",
	["baila"] = "¡Bailando!",
	["clima"] = "El clima está soleado y agradable hoy.",
	["gracias"] = "De nada, estoy aquí para ayudarte."
}

-- Procesar comando
local function processCommand(text)
	text = string.lower(text)
	
	for keyword, response in pairs(commands) do
		if string.find(text, keyword) then
			if type(response) == "function" then
				return response()
			else
				return response
			end
		end
	end
	
	return "Lo siento, no entendí tu comando. Intenta decir 'ayuda' para ver qué puedo hacer."
end

-- Animar dispositivo Alexa
local function animateAlexa(alexaDevice, isListening)
	local ring = alexaDevice:FindFirstChild("LightRing")
	if not ring then return end
	
	if isListening then
		ring.Color = Color3.fromRGB(0, 150, 255)
		local tween = TweenService:Create(ring, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
			Transparency = 0.3
		})
		tween:Play()
	else
		ring.Color = Color3.fromRGB(0, 255, 200)
		ring.Transparency = 0.5
	end
end

-- Manejar comandos de voz
VoiceCommand.OnServerEvent:Connect(function(player, command)
	local alexaDevice = workspace:FindFirstChild("AlexaDevice")
	if alexaDevice then
		animateAlexa(alexaDevice, true)
	end
	
	wait(0.5)
	
	local response = processCommand(command)
	AlexaResponse:FireClient(player, response)
	
	wait(1)
	
	if alexaDevice then
		animateAlexa(alexaDevice, false)
	end
	
	-- Acciones especiales
	if string.find(string.lower(command), "apaga las luces") then
		game:GetService("Lighting").Brightness = 0
		game:GetService("Lighting").Ambient = Color3.fromRGB(10, 10, 10)
	elseif string.find(string.lower(command), "enciende las luces") then
		game:GetService("Lighting").Brightness = 2
		game:GetService("Lighting").Ambient = Color3.fromRGB(150, 150, 150)
	elseif string.find(string.lower(command), "baila") then
		if alexaDevice then
			local tween = TweenService:Create(alexaDevice.PrimaryPart, TweenInfo.new(0.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.InOut, 4, true), {
				CFrame = alexaDevice.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(15), 0)
			})
			tween:Play()
		end
	end
end)

createAlexaDevice()
print("Alexa Server initialized!")
