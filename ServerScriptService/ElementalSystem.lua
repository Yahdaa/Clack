-- SERVER SCRIPT: Sistema de Poderes Elementales
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local ElementalEvents = Instance.new("Folder")
ElementalEvents.Name = "ElementalEvents"
ElementalEvents.Parent = ReplicatedStorage

local SelectElement = Instance.new("RemoteEvent")
SelectElement.Name = "SelectElement"
SelectElement.Parent = ElementalEvents

local UseAbility = Instance.new("RemoteEvent")
UseAbility.Name = "UseAbility"
UseAbility.Parent = ElementalEvents

local PlayerElements = {}

local ElementAbilities = {
	Fire = {
		{Name = "Bola de Fuego", Damage = 25, Cooldown = 2, Range = 100},
		{Name = "Lanzallamas", Damage = 15, Cooldown = 3, Range = 50},
		{Name = "Explosión de Fuego", Damage = 40, Cooldown = 8, Range = 30}
	},
	Water = {
		{Name = "Látigo de Agua", Damage = 20, Cooldown = 2, Range = 60},
		{Name = "Escudo de Agua", Damage = 0, Cooldown = 10, Range = 0},
		{Name = "Ola Gigante", Damage = 35, Cooldown = 7, Range = 80}
	},
	Earth = {
		{Name = "Lanzar Roca", Damage = 30, Cooldown = 3, Range = 90},
		{Name = "Muro de Tierra", Damage = 0, Cooldown = 8, Range = 0},
		{Name = "Terremoto", Damage = 45, Cooldown = 10, Range = 50}
	},
	Air = {
		{Name = "Ráfaga de Viento", Damage = 18, Cooldown = 1.5, Range = 70},
		{Name = "Tornado", Damage = 28, Cooldown = 6, Range = 60},
		{Name = "Levitación", Damage = 0, Cooldown = 5, Range = 0}
	}
}

SelectElement.OnServerEvent:Connect(function(player, element)
	if PlayerElements[player.UserId] then return end
	
	PlayerElements[player.UserId] = element
	
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player
	
	local elementValue = Instance.new("StringValue")
	elementValue.Name = "Element"
	elementValue.Value = element
	elementValue.Parent = leaderstats
	
	local cooldowns = Instance.new("Folder")
	cooldowns.Name = "Cooldowns"
	cooldowns.Parent = player
end)

local function createFireball(origin, direction, damage)
	local fireball = Instance.new("Part")
	fireball.Shape = Enum.PartType.Ball
	fireball.Size = Vector3.new(3, 3, 3)
	fireball.BrickColor = BrickColor.new("Bright orange")
	fireball.Material = Enum.Material.Neon
	fireball.CanCollide = false
	fireball.CFrame = CFrame.new(origin)
	fireball.Parent = workspace
	
	local fire = Instance.new("Fire")
	fire.Size = 8
	fire.Heat = 15
	fire.Parent = fireball
	
	local light = Instance.new("PointLight")
	light.Brightness = 5
	light.Color = Color3.fromRGB(255, 100, 0)
	light.Range = 15
	light.Parent = fireball
	
	local bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.Velocity = direction * 80
	bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	bodyVelocity.Parent = fireball
	
	fireball.Touched:Connect(function(hit)
		local humanoid = hit.Parent:FindFirstChild("Humanoid")
		if humanoid and not Players:GetPlayerFromCharacter(fireball.Parent) then
			humanoid:TakeDamage(damage)
			fireball:Destroy()
		end
	end)
	
	game:GetService("Debris"):AddItem(fireball, 5)
end

local function createFlamethrower(origin, direction, damage, player)
	for i = 1, 15 do
		task.wait(0.1)
		local flame = Instance.new("Part")
		flame.Size = Vector3.new(2, 2, 2)
		flame.BrickColor = BrickColor.new("Deep orange")
		flame.Material = Enum.Material.Neon
		flame.CanCollide = false
		flame.Transparency = 0.3
		flame.CFrame = CFrame.new(origin + direction * (i * 3))
		flame.Parent = workspace
		
		local fire = Instance.new("Fire")
		fire.Size = 10
		fire.Parent = flame
		
		flame.Touched:Connect(function(hit)
			local humanoid = hit.Parent:FindFirstChild("Humanoid")
			if humanoid and hit.Parent ~= player.Character then
				humanoid:TakeDamage(damage)
			end
		end)
		
		game:GetService("Debris"):AddItem(flame, 0.5)
	end
end

local function createFireExplosion(origin, damage)
	local explosion = Instance.new("Part")
	explosion.Shape = Enum.PartType.Ball
	explosion.Size = Vector3.new(5, 5, 5)
	explosion.BrickColor = BrickColor.new("Bright red")
	explosion.Material = Enum.Material.Neon
	explosion.CanCollide = false
	explosion.Anchored = true
	explosion.CFrame = CFrame.new(origin)
	explosion.Parent = workspace
	
	local light = Instance.new("PointLight")
	light.Brightness = 10
	light.Color = Color3.fromRGB(255, 50, 0)
	light.Range = 30
	light.Parent = explosion
	
	for i = 1, 20 do
		explosion.Size = explosion.Size + Vector3.new(2, 2, 2)
		explosion.Transparency = i / 20
		task.wait(0.05)
	end
	
	for _, player in pairs(Players:GetPlayers()) do
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local distance = (player.Character.HumanoidRootPart.Position - origin).Magnitude
			if distance <= 30 then
				local humanoid = player.Character:FindFirstChild("Humanoid")
				if humanoid then
					humanoid:TakeDamage(damage)
				end
			end
		end
	end
	
	explosion:Destroy()
end

local function createWaterWhip(origin, direction, damage)
	local whip = Instance.new("Part")
	whip.Size = Vector3.new(1, 1, 15)
	whip.BrickColor = BrickColor.new("Bright blue")
	whip.Material = Enum.Material.Glass
	whip.CanCollide = false
	whip.Transparency = 0.3
	whip.CFrame = CFrame.new(origin, origin + direction) * CFrame.new(0, 0, -7.5)
	whip.Parent = workspace
	
	local bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.Velocity = direction * 60
	bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	bodyVelocity.Parent = whip
	
	whip.Touched:Connect(function(hit)
		local humanoid = hit.Parent:FindFirstChild("Humanoid")
		if humanoid then
			humanoid:TakeDamage(damage)
			whip:Destroy()
		end
	end)
	
	game:GetService("Debris"):AddItem(whip, 3)
end

local function createWaterShield(player)
	local character = player.Character
	if not character then return end
	
	local shield = Instance.new("Part")
	shield.Shape = Enum.PartType.Ball
	shield.Size = Vector3.new(10, 10, 10)
	shield.BrickColor = BrickColor.new("Cyan")
	shield.Material = Enum.Material.Glass
	shield.CanCollide = false
	shield.Transparency = 0.5
	shield.Anchored = true
	shield.Parent = workspace
	
	for i = 1, 50 do
		if character and character:FindFirstChild("HumanoidRootPart") then
			shield.CFrame = character.HumanoidRootPart.CFrame
		end
		task.wait(0.1)
	end
	
	shield:Destroy()
end

local function createWaterWave(origin, direction, damage)
	local wave = Instance.new("Part")
	wave.Size = Vector3.new(20, 8, 3)
	wave.BrickColor = BrickColor.new("Deep blue")
	wave.Material = Enum.Material.Glass
	wave.CanCollide = false
	wave.Transparency = 0.4
	wave.CFrame = CFrame.new(origin, origin + direction)
	wave.Parent = workspace
	
	local bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.Velocity = direction * 50
	bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	bodyVelocity.Parent = wave
	
	wave.Touched:Connect(function(hit)
		local humanoid = hit.Parent:FindFirstChild("Humanoid")
		if humanoid then
			humanoid:TakeDamage(damage)
		end
	end)
	
	game:GetService("Debris"):AddItem(wave, 4)
end

local function createRockProjectile(origin, direction, damage)
	local rock = Instance.new("Part")
	rock.Size = Vector3.new(4, 4, 4)
	rock.BrickColor = BrickColor.new("Brown")
	rock.Material = Enum.Material.Rock
	rock.CanCollide = false
	rock.CFrame = CFrame.new(origin)
	rock.Parent = workspace
	
	local bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.Velocity = direction * 70
	bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	bodyVelocity.Parent = rock
	
	rock.Touched:Connect(function(hit)
		local humanoid = hit.Parent:FindFirstChild("Humanoid")
		if humanoid then
			humanoid:TakeDamage(damage)
			rock:Destroy()
		end
	end)
	
	game:GetService("Debris"):AddItem(rock, 5)
end

local function createEarthWall(origin, direction)
	local wall = Instance.new("Part")
	wall.Size = Vector3.new(15, 10, 2)
	wall.BrickColor = BrickColor.new("Earth green")
	wall.Material = Enum.Material.Rock
	wall.Anchored = true
	wall.CFrame = CFrame.new(origin + direction * 5, origin + direction * 10)
	wall.Parent = workspace
	
	game:GetService("Debris"):AddItem(wall, 8)
end

local function createEarthquake(origin, damage)
	for i = 1, 30 do
		local crack = Instance.new("Part")
		crack.Size = Vector3.new(math.random(3, 8), 0.5, math.random(3, 8))
		crack.BrickColor = BrickColor.new("Dark stone grey")
		crack.Material = Enum.Material.Rock
		crack.Anchored = true
		local angle = math.rad(i * 12)
		local distance = math.random(10, 40)
		crack.CFrame = CFrame.new(origin + Vector3.new(math.cos(angle) * distance, -2, math.sin(angle) * distance))
		crack.Parent = workspace
		
		game:GetService("Debris"):AddItem(crack, 3)
	end
	
	for _, player in pairs(Players:GetPlayers()) do
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local distance = (player.Character.HumanoidRootPart.Position - origin).Magnitude
			if distance <= 50 then
				local humanoid = player.Character:FindFirstChild("Humanoid")
				if humanoid then
					humanoid:TakeDamage(damage)
				end
			end
		end
	end
end

local function createAirBlast(origin, direction, damage)
	local blast = Instance.new("Part")
	blast.Shape = Enum.PartType.Ball
	blast.Size = Vector3.new(4, 4, 4)
	blast.BrickColor = BrickColor.new("White")
	blast.Material = Enum.Material.SmoothPlastic
	blast.CanCollide = false
	blast.Transparency = 0.7
	blast.CFrame = CFrame.new(origin)
	blast.Parent = workspace
	
	local smoke = Instance.new("Smoke")
	smoke.Size = 5
	smoke.RiseVelocity = 2
	smoke.Parent = blast
	
	local bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.Velocity = direction * 90
	bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	bodyVelocity.Parent = blast
	
	blast.Touched:Connect(function(hit)
		local humanoid = hit.Parent:FindFirstChild("Humanoid")
		if humanoid then
			humanoid:TakeDamage(damage)
			local rootPart = hit.Parent:FindFirstChild("HumanoidRootPart")
			if rootPart then
				local knockback = Instance.new("BodyVelocity")
				knockback.Velocity = direction * 50
				knockback.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
				knockback.Parent = rootPart
				game:GetService("Debris"):AddItem(knockback, 0.3)
			end
			blast:Destroy()
		end
	end)
	
	game:GetService("Debris"):AddItem(blast, 4)
end

local function createTornado(origin, damage)
	local tornado = Instance.new("Part")
	tornado.Shape = Enum.PartType.Cylinder
	tornado.Size = Vector3.new(15, 8, 8)
	tornado.BrickColor = BrickColor.new("Light grey")
	tornado.Material = Enum.Material.SmoothPlastic
	tornado.CanCollide = false
	tornado.Transparency = 0.6
	tornado.Anchored = true
	tornado.CFrame = CFrame.new(origin) * CFrame.Angles(0, 0, math.rad(90))
	tornado.Parent = workspace
	
	local smoke = Instance.new("Smoke")
	smoke.Size = 15
	smoke.RiseVelocity = 10
	smoke.Parent = tornado
	
	for i = 1, 60 do
		tornado.CFrame = tornado.CFrame * CFrame.Angles(0, math.rad(10), 0)
		
		for _, player in pairs(Players:GetPlayers()) do
			if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				local distance = (player.Character.HumanoidRootPart.Position - origin).Magnitude
				if distance <= 15 then
					local humanoid = player.Character:FindFirstChild("Humanoid")
					if humanoid then
						humanoid:TakeDamage(damage / 10)
					end
					local rootPart = player.Character.HumanoidRootPart
					rootPart.CFrame = rootPart.CFrame + Vector3.new(0, 0.5, 0)
				end
			end
		end
		
		task.wait(0.1)
	end
	
	tornado:Destroy()
end

local function createLevitation(player)
	local character = player.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then return end
	
	local rootPart = character.HumanoidRootPart
	local bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.Velocity = Vector3.new(0, 30, 0)
	bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
	bodyVelocity.Parent = rootPart
	
	task.wait(3)
	bodyVelocity:Destroy()
end

UseAbility.OnServerEvent:Connect(function(player, abilityIndex)
	local element = PlayerElements[player.UserId]
	if not element then return end
	
	local abilities = ElementAbilities[element]
	local ability = abilities[abilityIndex]
	if not ability then return end
	
	local cooldownFolder = player:FindFirstChild("Cooldowns")
	if not cooldownFolder then return end
	
	local cooldownValue = cooldownFolder:FindFirstChild("Ability" .. abilityIndex)
	if cooldownValue and cooldownValue.Value then return end
	
	if not cooldownValue then
		cooldownValue = Instance.new("BoolValue")
		cooldownValue.Name = "Ability" .. abilityIndex
		cooldownValue.Parent = cooldownFolder
	end
	
	cooldownValue.Value = true
	
	local character = player.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then return end
	
	local rootPart = character.HumanoidRootPart
	local origin = rootPart.Position + Vector3.new(0, 2, 0)
	local direction = rootPart.CFrame.LookVector
	
	if element == "Fire" then
		if abilityIndex == 1 then
			createFireball(origin, direction, ability.Damage)
		elseif abilityIndex == 2 then
			createFlamethrower(origin, direction, ability.Damage, player)
		elseif abilityIndex == 3 then
			createFireExplosion(origin + direction * 10, ability.Damage)
		end
	elseif element == "Water" then
		if abilityIndex == 1 then
			createWaterWhip(origin, direction, ability.Damage)
		elseif abilityIndex == 2 then
			createWaterShield(player)
		elseif abilityIndex == 3 then
			createWaterWave(origin, direction, ability.Damage)
		end
	elseif element == "Earth" then
		if abilityIndex == 1 then
			createRockProjectile(origin, direction, ability.Damage)
		elseif abilityIndex == 2 then
			createEarthWall(origin, direction)
		elseif abilityIndex == 3 then
			createEarthquake(origin, ability.Damage)
		end
	elseif element == "Air" then
		if abilityIndex == 1 then
			createAirBlast(origin, direction, ability.Damage)
		elseif abilityIndex == 2 then
			createTornado(origin + direction * 10, ability.Damage)
		elseif abilityIndex == 3 then
			createLevitation(player)
		end
	end
	
	task.wait(ability.Cooldown)
	cooldownValue.Value = false
end)
