-- Sistema de tentáculos animados del Upside Down
local TweenService = game:GetService("TweenService")
local workspace = game:GetService("Workspace")

local UpsideDownFolder = workspace:WaitForChild("UpsideDown")

-- Crear tentáculo animado
local function createTentacle(basePosition, segments)
	local tentacleModel = Instance.new("Model")
	tentacleModel.Name = "Tentacle"
	tentacleModel.Parent = UpsideDownFolder
	
	local previousSegment = nil
	local segmentParts = {}
	
	for i = 1, segments do
		local segment = Instance.new("Part")
		segment.Name = "Segment" .. i
		segment.Size = Vector3.new(1.5, 3, 1.5)
		segment.Position = basePosition + Vector3.new(0, i * 3, 0)
		segment.Color = Color3.fromRGB(40, 30, 35)
		segment.Material = Enum.Material.Slate
		segment.Anchored = false
		segment.CanCollide = true
		segment.Parent = tentacleModel
		
		-- Mesh para forma orgánica
		local mesh = Instance.new("CylinderMesh")
		mesh.Scale = Vector3.new(1, 1, 1)
		mesh.Parent = segment
		
		-- Textura orgánica
		segment.TopSurface = Enum.SurfaceType.Smooth
		segment.BottomSurface = Enum.SurfaceType.Smooth
		
		-- Unir segmentos con BallSocketConstraint
		if previousSegment then
			local attachment0 = Instance.new("Attachment")
			attachment0.Position = Vector3.new(0, -1.5, 0)
			attachment0.Parent = previousSegment
			
			local attachment1 = Instance.new("Attachment")
			attachment1.Position = Vector3.new(0, 1.5, 0)
			attachment1.Parent = segment
			
			local ballSocket = Instance.new("BallSocketConstraint")
			ballSocket.Attachment0 = attachment0
			ballSocket.Attachment1 = attachment1
			ballSocket.LimitsEnabled = true
			ballSocket.UpperAngle = 30
			ballSocket.Parent = segment
		else
			-- Anclar el primer segmento
			segment.Anchored = true
		end
		
		-- Partículas de humedad
		if i % 2 == 0 then
			local attachment = Instance.new("Attachment")
			attachment.Parent = segment
			
			local drip = Instance.new("ParticleEmitter")
			drip.Texture = "rbxasset://textures/particles/smoke_main.dds"
			drip.Color = ColorSequence.new(Color3.fromRGB(30, 40, 35))
			drip.Size = NumberSequence.new(0.2, 0.4)
			drip.Transparency = NumberSequence.new(0.3, 1)
			drip.Lifetime = NumberRange.new(1, 2)
			drip.Rate = 3
			drip.Speed = NumberRange.new(2, 4)
			drip.EmissionDirection = Enum.NormalId.Bottom
			drip.Parent = attachment
		end
		
		table.insert(segmentParts, segment)
		previousSegment = segment
	end
	
	-- Animación ondulante
	spawn(function()
		while tentacleModel.Parent do
			for i, segment in ipairs(segmentParts) do
				if not segment.Anchored then
					local force = Instance.new("BodyForce")
					force.Force = Vector3.new(
						math.sin(tick() * 2 + i) * 500,
						0,
						math.cos(tick() * 2 + i) * 500
					)
					force.Parent = segment
					game:GetService("Debris"):AddItem(force, 0.1)
				end
			end
			wait(0.1)
		end
	end)
	
	return tentacleModel
end

-- Crear múltiples tentáculos en el mundo
for i = 1, 15 do
	local randomPos = Vector3.new(
		math.random(-180, 180),
		0,
		math.random(-180, 180)
	)
	createTentacle(randomPos, math.random(4, 8))
end

print("Tentacle system initialized!")
