-- LOCAL SCRIPT: Cliente de Poderes Elementales
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

repeat task.wait() until ReplicatedStorage:FindFirstChild("ElementalEvents")
local ElementalEvents = ReplicatedStorage.ElementalEvents
local SelectElement = ElementalEvents:WaitForChild("SelectElement")
local UseAbility = ElementalEvents:WaitForChild("UseAbility")

local selectedElement = nil

local ElementColors = {
	Fire = Color3.fromRGB(255, 85, 0),
	Water = Color3.fromRGB(0, 150, 255),
	Earth = Color3.fromRGB(100, 150, 50),
	Air = Color3.fromRGB(200, 200, 200)
}

local ElementAbilities = {
	Fire = {"Bola de Fuego (Q)", "Lanzallamas (E)", "Explosión (R)"},
	Water = {"Látigo de Agua (Q)", "Escudo (E)", "Ola Gigante (R)"},
	Earth = {"Lanzar Roca (Q)", "Muro (E)", "Terremoto (R)"},
	Air = {"Ráfaga (Q)", "Tornado (E)", "Levitación (R)"}
}

local function createSelectionGUI()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "ElementSelection"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui
	
	local background = Instance.new("Frame")
	background.Size = UDim2.new(1, 0, 1, 0)
	background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	background.BackgroundTransparency = 0.3
	background.Parent = screenGui
	
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(0, 600, 0, 80)
	title.Position = UDim2.new(0.5, -300, 0.1, 0)
	title.BackgroundTransparency = 1
	title.Text = "ELIGE TU ELEMENTO"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 48
	title.Font = Enum.Font.GothamBold
	title.Parent = background
	
	local subtitle = Instance.new("TextLabel")
	subtitle.Size = UDim2.new(0, 600, 0, 40)
	subtitle.Position = UDim2.new(0.5, -300, 0.18, 0)
	subtitle.BackgroundTransparency = 1
	subtitle.Text = "Inspirado en Avatar: La Leyenda de Aang"
	subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
	subtitle.TextSize = 20
	subtitle.Font = Enum.Font.Gotham
	subtitle.Parent = background
	
	local elements = {"Fire", "Water", "Earth", "Air"}
	local elementNames = {Fire = "🔥 FUEGO", Water = "💧 AGUA", Earth = "🌍 TIERRA", Air = "💨 AIRE"}
	
	for i, element in ipairs(elements) do
		local button = Instance.new("TextButton")
		button.Size = UDim2.new(0, 200, 0, 200)
		button.Position = UDim2.new(0.5 + (i - 2.5) * 0.25, -100, 0.5, -100)
		button.BackgroundColor3 = ElementColors[element]
		button.Text = elementNames[element]
		button.TextColor3 = Color3.fromRGB(255, 255, 255)
		button.TextSize = 28
		button.Font = Enum.Font.GothamBold
		button.Parent = background
		
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 15)
		corner.Parent = button
		
		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.fromRGB(255, 255, 255)
		stroke.Thickness = 3
		stroke.Parent = button
		
		button.MouseEnter:Connect(function()
			button.Size = UDim2.new(0, 220, 0, 220)
		end)
		
		button.MouseLeave:Connect(function()
			button.Size = UDim2.new(0, 200, 0, 200)
		end)
		
		button.MouseButton1Click:Connect(function()
			selectedElement = element
			SelectElement:FireServer(element)
			screenGui:Destroy()
			createAbilityGUI()
		end)
	end
end

local function createAbilityGUI()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "AbilityGUI"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui
	
	local container = Instance.new("Frame")
	container.Size = UDim2.new(0, 400, 0, 120)
	container.Position = UDim2.new(0.5, -200, 0.85, 0)
	container.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	container.BackgroundTransparency = 0.3
	container.Parent = screenGui
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = container
	
	local elementLabel = Instance.new("TextLabel")
	elementLabel.Size = UDim2.new(1, 0, 0, 30)
	elementLabel.BackgroundTransparency = 1
	elementLabel.Text = "ELEMENTO: " .. string.upper(selectedElement)
	elementLabel.TextColor3 = ElementColors[selectedElement]
	elementLabel.TextSize = 20
	elementLabel.Font = Enum.Font.GothamBold
	elementLabel.Parent = container
	
	for i = 1, 3 do
		local abilityButton = Instance.new("TextButton")
		abilityButton.Size = UDim2.new(0, 120, 0, 60)
		abilityButton.Position = UDim2.new((i - 1) * 0.33 + 0.05, 0, 0.4, 0)
		abilityButton.BackgroundColor3 = ElementColors[selectedElement]
		abilityButton.Text = ElementAbilities[selectedElement][i]
		abilityButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		abilityButton.TextSize = 14
		abilityButton.Font = Enum.Font.GothamBold
		abilityButton.Parent = container
		
		local buttonCorner = Instance.new("UICorner")
		buttonCorner.CornerRadius = UDim.new(0, 8)
		buttonCorner.Parent = abilityButton
		
		abilityButton.MouseButton1Click:Connect(function()
			UseAbility:FireServer(i)
		end)
	end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed or not selectedElement then return end
	
	if input.KeyCode == Enum.KeyCode.Q then
		UseAbility:FireServer(1)
	elseif input.KeyCode == Enum.KeyCode.E then
		UseAbility:FireServer(2)
	elseif input.KeyCode == Enum.KeyCode.R then
		UseAbility:FireServer(3)
	end
end)

task.wait(1)
if not player.leaderstats or not player.leaderstats:FindFirstChild("Element") then
	createSelectionGUI()
else
	selectedElement = player.leaderstats.Element.Value
	createAbilityGUI()
end
