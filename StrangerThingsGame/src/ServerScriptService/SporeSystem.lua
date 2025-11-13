-- Sistema de esporas flotantes del Upside Down
local TweenService = game:GetService("TweenService")
local workspace = game:GetService("Workspace")

local UpsideDownFolder = workspace:WaitForChild("UpsideDown")

-- Crear esporas flotantes individuales
local function createFloatingSpore(position)
	local spore = Instance.new("Part")
	spore.Name = "FloatingSpore"
	spore.Size = Vector3.new(0.3, 0.3, 0.3)
	spore.Position = position
	spore.Anchored = true
	spore.CanCollide = false
	spore.Transparency = 0.5
	spore.Color = Color3.fromRGB(60, 70, 50)
	spore.Material = Enum.Material.Neon
	spore.Shape = Enum.PartType.Ball
	spore.Parent = UpsideDownFolder
	
	-- Luz tenue
	local light = Instance.new("PointLight")
	light.Color = Color3.fromRGB(60, 70, 50)
	light.Brightness = 0.5
	light.Range = 5
	light.Parent = spore
	
	-- Movimiento flotante aleatorio
	spawn(function()
		while spore.Parent do
			local randomOffset = Vector3.new(
				math.random(-20, 20),
				math.random(-10, 10),
				math.random(-20, 20)
			)
			
			local targetPos = position + randomOffset
			local tween = TweenService:Create(spore, TweenInfo.new(
				math.random(5, 10),
				Enum.EasingStyle.Sine,
				Enum.EasingDirection.InOut
			), {
				Position = targetPos
			})
			tween:Play()
			tween.Completed:Wait()
		end
	end)
	
	return spore
end

-- Generar múltiples esporas en el área
for i = 1, 100 do
	local randomPos = Vector3.new(
		math.random(-200, 200),
		math.random(5, 40),
		math.random(-200, 200)
	)
	createFloatingSpore(randomPos)
end

print("Spore system initialized!")
