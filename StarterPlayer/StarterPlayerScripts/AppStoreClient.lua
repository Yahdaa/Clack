-- LOCAL SCRIPT: Cliente de App Store
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

repeat task.wait() until ReplicatedStorage:FindFirstChild("AppStoreRemotes")
local Remotes = ReplicatedStorage.AppStoreRemotes

local currentAppId = nil
local editMode = false
local selectedObject = nil
local placedObjects = {}

local function createMainUI()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "AppStoreUI"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui
	
	local background = Instance.new("Frame")
	background.Size = UDim2.new(1, 0, 1, 0)
	background.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
	background.Parent = screenGui
	
	local header = Instance.new("Frame")
	header.Size = UDim2.new(1, 0, 0, 70)
	header.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
	header.Parent = background
	
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(0, 300, 1, 0)
	title.Position = UDim2.new(0, 20, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = "📱 App Store"
	title.TextColor3 = Color3.new(1, 1, 1)
	title.TextSize = 32
	title.Font = Enum.Font.GothamBold
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = header
	
	local createBtn = Instance.new("TextButton")
	createBtn.Size = UDim2.new(0, 180, 0, 45)
	createBtn.Position = UDim2.new(1, -200, 0.5, -22.5)
	createBtn.BackgroundColor3 = Color3.fromRGB(52, 199, 89)
	createBtn.Text = "+ Crear App"
	createBtn.TextColor3 = Color3.new(1, 1, 1)
	createBtn.TextSize = 20
	createBtn.Font = Enum.Font.GothamBold
	createBtn.Parent = header
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = createBtn
	
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Size = UDim2.new(1, -40, 1, -100)
	scrollFrame.Position = UDim2.new(0, 20, 0, 85)
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.BorderSizePixel = 0
	scrollFrame.ScrollBarThickness = 8
	scrollFrame.Parent = background
	
	local listLayout = Instance.new("UIGridLayout")
	listLayout.CellSize = UDim2.new(0, 280, 0, 320)
	listLayout.CellPadding = UDim2.new(0, 20, 0, 20)
	listLayout.Parent = scrollFrame
	
	createBtn.MouseButton1Click:Connect(function()
		openCreateAppUI()
	end)
	
	loadApps(scrollFrame)
	
	return screenGui
end

local function loadApps(container)
	for _, child in ipairs(container:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end
	
	local apps = Remotes.LoadApps:InvokeServer()
	
	for _, app in ipairs(apps) do
		local appCard = Instance.new("Frame")
		appCard.Size = UDim2.new(0, 280, 0, 320)
		appCard.BackgroundColor3 = Color3.new(1, 1, 1)
		appCard.Parent = container
		
		local cardCorner = Instance.new("UICorner")
		cardCorner.CornerRadius = UDim.new(0, 12)
		cardCorner.Parent = appCard
		
		local thumbnail = Instance.new("Frame")
		thumbnail.Size = UDim2.new(1, -20, 0, 140)
		thumbnail.Position = UDim2.new(0, 10, 0, 10)
		thumbnail.BackgroundColor3 = Color3.fromRGB(app.ThumbnailColor[1], app.ThumbnailColor[2], app.ThumbnailColor[3])
		thumbnail.Parent = appCard
		
		local thumbCorner = Instance.new("UICorner")
		thumbCorner.CornerRadius = UDim.new(0, 8)
		thumbCorner.Parent = thumbnail
		
		local appTitle = Instance.new("TextLabel")
		appTitle.Size = UDim2.new(1, -20, 0, 30)
		appTitle.Position = UDim2.new(0, 10, 0, 160)
		appTitle.BackgroundTransparency = 1
		appTitle.Text = app.Name
		appTitle.TextColor3 = Color3.new(0, 0, 0)
		appTitle.TextSize = 18
		appTitle.Font = Enum.Font.GothamBold
		appTitle.TextXAlignment = Enum.TextXAlignment.Left
		appTitle.TextTruncate = Enum.TextTruncate.AtEnd
		appTitle.Parent = appCard
		
		local creator = Instance.new("TextLabel")
		creator.Size = UDim2.new(1, -20, 0, 20)
		creator.Position = UDim2.new(0, 10, 0, 190)
		creator.BackgroundTransparency = 1
		creator.Text = "Por: " .. app.Creator
		creator.TextColor3 = Color3.fromRGB(100, 100, 100)
		creator.TextSize = 14
		creator.Font = Enum.Font.Gotham
		creator.TextXAlignment = Enum.TextXAlignment.Left
		creator.Parent = appCard
		
		local stats = Instance.new("TextLabel")
		stats.Size = UDim2.new(1, -20, 0, 20)
		stats.Position = UDim2.new(0, 10, 0, 215)
		stats.BackgroundTransparency = 1
		stats.Text = "👁 " .. app.Visits .. "  ❤️ " .. app.Likes
		stats.TextColor3 = Color3.fromRGB(100, 100, 100)
		stats.TextSize = 14
		stats.Font = Enum.Font.Gotham
		stats.TextXAlignment = Enum.TextXAlignment.Left
		stats.Parent = appCard
		
		local playBtn = Instance.new("TextButton")
		playBtn.Size = UDim2.new(1, -20, 0, 45)
		playBtn.Position = UDim2.new(0, 10, 1, -55)
		playBtn.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
		playBtn.Text = "▶ Jugar"
		playBtn.TextColor3 = Color3.new(1, 1, 1)
		playBtn.TextSize = 18
		playBtn.Font = Enum.Font.GothamBold
		playBtn.Parent = appCard
		
		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 8)
		btnCorner.Parent = playBtn
		
		playBtn.MouseButton1Click:Connect(function()
			currentAppId = app.Id
			Remotes.PlayApp:FireServer(app.Id)
			playerGui.AppStoreUI.Enabled = false
			createExitButton()
		end)
		
		if app.CreatorId == player.UserId then
			local editBtn = Instance.new("TextButton")
			editBtn.Size = UDim2.new(0.48, 0, 0, 45)
			editBtn.Position = UDim2.new(0, 10, 1, -55)
			editBtn.BackgroundColor3 = Color3.fromRGB(255, 149, 0)
			editBtn.Text = "✏️ Editar"
			editBtn.TextColor3 = Color3.new(1, 1, 1)
			editBtn.TextSize = 16
			editBtn.Font = Enum.Font.GothamBold
			editBtn.Parent = appCard
			
			local editCorner = Instance.new("UICorner")
			editCorner.CornerRadius = UDim.new(0, 8)
			editCorner.Parent = editBtn
			
			playBtn.Size = UDim2.new(0.48, 0, 0, 45)
			playBtn.Position = UDim2.new(0.52, 10, 1, -55)
			
			editBtn.MouseButton1Click:Connect(function()
				openEditor(app.Id)
			end)
		end
	end
end

local function openCreateAppUI()
	local createGui = Instance.new("ScreenGui")
	createGui.Name = "CreateAppUI"
	createGui.Parent = playerGui
	
	local bg = Instance.new("Frame")
	bg.Size = UDim2.new(1, 0, 1, 0)
	bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	bg.BackgroundTransparency = 0.5
	bg.Parent = createGui
	
	local panel = Instance.new("Frame")
	panel.Size = UDim2.new(0, 500, 0, 450)
	panel.Position = UDim2.new(0.5, -250, 0.5, -225)
	panel.BackgroundColor3 = Color3.new(1, 1, 1)
	panel.Parent = bg
	
	local panelCorner = Instance.new("UICorner")
	panelCorner.CornerRadius = UDim.new(0, 15)
	panelCorner.Parent = panel
	
	local panelTitle = Instance.new("TextLabel")
	panelTitle.Size = UDim2.new(1, 0, 0, 60)
	panelTitle.BackgroundTransparency = 1
	panelTitle.Text = "Crear Nueva App"
	panelTitle.TextColor3 = Color3.new(0, 0, 0)
	panelTitle.TextSize = 28
	panelTitle.Font = Enum.Font.GothamBold
	panelTitle.Parent = panel
	
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(1, -40, 0, 25)
	nameLabel.Position = UDim2.new(0, 20, 0, 70)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = "Nombre de la App:"
	nameLabel.TextColor3 = Color3.new(0, 0, 0)
	nameLabel.TextSize = 16
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = panel
	
	local nameBox = Instance.new("TextBox")
	nameBox.Size = UDim2.new(1, -40, 0, 40)
	nameBox.Position = UDim2.new(0, 20, 0, 100)
	nameBox.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
	nameBox.Text = ""
	nameBox.PlaceholderText = "Ej: Mi Juego Increíble"
	nameBox.TextColor3 = Color3.new(0, 0, 0)
	nameBox.TextSize = 16
	nameBox.Font = Enum.Font.Gotham
	nameBox.Parent = panel
	
	local nameCorner = Instance.new("UICorner")
	nameCorner.CornerRadius = UDim.new(0, 8)
	nameCorner.Parent = nameBox
	
	local descLabel = Instance.new("TextLabel")
	descLabel.Size = UDim2.new(1, -40, 0, 25)
	descLabel.Position = UDim2.new(0, 20, 0, 155)
	descLabel.BackgroundTransparency = 1
	descLabel.Text = "Descripción:"
	descLabel.TextColor3 = Color3.new(0, 0, 0)
	descLabel.TextSize = 16
	descLabel.Font = Enum.Font.GothamBold
	descLabel.TextXAlignment = Enum.TextXAlignment.Left
	descLabel.Parent = panel
	
	local descBox = Instance.new("TextBox")
	descBox.Size = UDim2.new(1, -40, 0, 80)
	descBox.Position = UDim2.new(0, 20, 0, 185)
	descBox.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
	descBox.Text = ""
	descBox.PlaceholderText = "Describe tu app..."
	descBox.TextColor3 = Color3.new(0, 0, 0)
	descBox.TextSize = 16
	descBox.Font = Enum.Font.Gotham
	descBox.TextWrapped = true
	descBox.TextYAlignment = Enum.TextYAlignment.Top
	descBox.MultiLine = true
	descBox.Parent = panel
	
	local descCorner = Instance.new("UICorner")
	descCorner.CornerRadius = UDim.new(0, 8)
	descCorner.Parent = descBox
	
	local colorLabel = Instance.new("TextLabel")
	colorLabel.Size = UDim2.new(1, -40, 0, 25)
	colorLabel.Position = UDim2.new(0, 20, 0, 280)
	colorLabel.BackgroundTransparency = 1
	colorLabel.Text = "Color de Miniatura:"
	colorLabel.TextColor3 = Color3.new(0, 0, 0)
	colorLabel.TextSize = 16
	colorLabel.Font = Enum.Font.GothamBold
	colorLabel.TextXAlignment = Enum.TextXAlignment.Left
	colorLabel.Parent = panel
	
	local colors = {
		{255, 59, 48}, {255, 149, 0}, {255, 204, 0}, {52, 199, 89},
		{0, 122, 255}, {88, 86, 214}, {175, 82, 222}, {255, 45, 85}
	}
	
	local selectedColor = colors[1]
	
	for i, color in ipairs(colors) do
		local colorBtn = Instance.new("TextButton")
		colorBtn.Size = UDim2.new(0, 45, 0, 45)
		colorBtn.Position = UDim2.new(0, 20 + (i - 1) * 55, 0, 310)
		colorBtn.BackgroundColor3 = Color3.fromRGB(color[1], color[2], color[3])
		colorBtn.Text = ""
		colorBtn.Parent = panel
		
		local colorCorner = Instance.new("UICorner")
		colorCorner.CornerRadius = UDim.new(0, 8)
		colorCorner.Parent = colorBtn
		
		colorBtn.MouseButton1Click:Connect(function()
			selectedColor = color
		end)
	end
	
	local publishBtn = Instance.new("TextButton")
	publishBtn.Size = UDim2.new(0, 220, 0, 50)
	publishBtn.Position = UDim2.new(0.5, -110, 1, -70)
	publishBtn.BackgroundColor3 = Color3.fromRGB(52, 199, 89)
	publishBtn.Text = "Publicar y Editar"
	publishBtn.TextColor3 = Color3.new(1, 1, 1)
	publishBtn.TextSize = 18
	publishBtn.Font = Enum.Font.GothamBold
	publishBtn.Parent = panel
	
	local pubCorner = Instance.new("UICorner")
	pubCorner.CornerRadius = UDim.new(0, 10)
	pubCorner.Parent = publishBtn
	
	local cancelBtn = Instance.new("TextButton")
	cancelBtn.Size = UDim2.new(0, 100, 0, 50)
	cancelBtn.Position = UDim2.new(0, 20, 1, -70)
	cancelBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
	cancelBtn.Text = "Cancelar"
	cancelBtn.TextColor3 = Color3.new(0, 0, 0)
	cancelBtn.TextSize = 16
	cancelBtn.Font = Enum.Font.GothamBold
	cancelBtn.Parent = panel
	
	local cancelCorner = Instance.new("UICorner")
	cancelCorner.CornerRadius = UDim.new(0, 10)
	cancelCorner.Parent = cancelBtn
	
	publishBtn.MouseButton1Click:Connect(function()
		if nameBox.Text ~= "" then
			local appData = {
				Name = nameBox.Text,
				Description = descBox.Text,
				ThumbnailColor = selectedColor,
				Objects = {}
			}
			Remotes.PublishApp:FireServer(appData)
			createGui:Destroy()
		end
	end)
	
	cancelBtn.MouseButton1Click:Connect(function()
		createGui:Destroy()
	end)
end

local function openEditor(appId)
	currentAppId = appId
	editMode = true
	placedObjects = {}
	
	local appData = Remotes.LoadAppContent:InvokeServer(appId)
	if not appData then return end
	
	Remotes.PlayApp:FireServer(appId)
	playerGui.AppStoreUI.Enabled = false
	
	local editorGui = Instance.new("ScreenGui")
	editorGui.Name = "EditorUI"
	editorGui.Parent = playerGui
	
	local toolbar = Instance.new("Frame")
	toolbar.Size = UDim2.new(0, 250, 0, 400)
	toolbar.Position = UDim2.new(0, 10, 0.5, -200)
	toolbar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	toolbar.BackgroundTransparency = 0.2
	toolbar.Parent = editorGui
	
	local toolCorner = Instance.new("UICorner")
	toolCorner.CornerRadius = UDim.new(0, 10)
	toolCorner.Parent = toolbar
	
	local toolTitle = Instance.new("TextLabel")
	toolTitle.Size = UDim2.new(1, 0, 0, 40)
	toolTitle.BackgroundTransparency = 1
	toolTitle.Text = "🛠️ Editor"
	toolTitle.TextColor3 = Color3.new(1, 1, 1)
	toolTitle.TextSize = 20
	toolTitle.Font = Enum.Font.GothamBold
	toolTitle.Parent = toolbar
	
	local objects = {
		{Name = "Plataforma", Size = Vector3.new(10, 1, 10), Color = "Bright green"},
		{Name = "Obstáculo", Size = Vector3.new(4, 4, 4), Color = "Bright red"},
		{Name = "Muro", Size = Vector3.new(10, 8, 1), Color = "Dark stone grey"},
		{Name = "Rampa", Size = Vector3.new(8, 1, 10), Color = "Bright yellow"}
	}
	
	for i, obj in ipairs(objects) do
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, -20, 0, 50)
		btn.Position = UDim2.new(0, 10, 0, 40 + i * 60)
		btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		btn.Text = "➕ " .. obj.Name
		btn.TextColor3 = Color3.new(1, 1, 1)
		btn.TextSize = 16
		btn.Font = Enum.Font.GothamBold
		btn.Parent = toolbar
		
		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 8)
		btnCorner.Parent = btn
		
		btn.MouseButton1Click:Connect(function()
			local char = player.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				local pos = char.HumanoidRootPart.Position + char.HumanoidRootPart.CFrame.LookVector * 10
				local part = Instance.new("Part")
				part.Size = obj.Size
				part.Position = pos
				part.BrickColor = BrickColor.new(obj.Color)
				part.Anchored = true
				part.Parent = workspace.AppWorlds:FindFirstChild(appId)
				
				table.insert(placedObjects, {
					Part = part,
					SizeX = obj.Size.X, SizeY = obj.Size.Y, SizeZ = obj.Size.Z,
					PosX = pos.X, PosY = pos.Y, PosZ = pos.Z,
					RotX = 0, RotY = 0, RotZ = 0,
					Color = obj.Color,
					Material = "Plastic"
				})
			end
		end)
	end
	
	local saveBtn = Instance.new("TextButton")
	saveBtn.Size = UDim2.new(1, -20, 0, 50)
	saveBtn.Position = UDim2.new(0, 10, 1, -120)
	saveBtn.BackgroundColor3 = Color3.fromRGB(52, 199, 89)
	saveBtn.Text = "💾 Guardar"
	saveBtn.TextColor3 = Color3.new(1, 1, 1)
	saveBtn.TextSize = 18
	saveBtn.Font = Enum.Font.GothamBold
	saveBtn.Parent = toolbar
	
	local saveCorner = Instance.new("UICorner")
	saveCorner.CornerRadius = UDim.new(0, 8)
	saveCorner.Parent = saveBtn
	
	local exitBtn = Instance.new("TextButton")
	exitBtn.Size = UDim2.new(1, -20, 0, 50)
	exitBtn.Position = UDim2.new(0, 10, 1, -60)
	exitBtn.BackgroundColor3 = Color3.fromRGB(255, 59, 48)
	exitBtn.Text = "🚪 Salir"
	exitBtn.TextColor3 = Color3.new(1, 1, 1)
	exitBtn.TextSize = 18
	exitBtn.Font = Enum.Font.GothamBold
	exitBtn.Parent = toolbar
	
	local exitCorner = Instance.new("UICorner")
	exitCorner.CornerRadius = UDim.new(0, 8)
	exitCorner.Parent = exitBtn
	
	saveBtn.MouseButton1Click:Connect(function()
		Remotes.SaveAppContent:FireServer(appId, placedObjects)
	end)
	
	exitBtn.MouseButton1Click:Connect(function()
		editMode = false
		editorGui:Destroy()
		Remotes.ExitApp:FireServer()
		playerGui.AppStoreUI.Enabled = true
	end)
end

local function createExitButton()
	local exitGui = Instance.new("ScreenGui")
	exitGui.Name = "ExitAppUI"
	exitGui.Parent = playerGui
	
	local exitBtn = Instance.new("TextButton")
	exitBtn.Size = UDim2.new(0, 150, 0, 50)
	exitBtn.Position = UDim2.new(0.5, -75, 0, 20)
	exitBtn.BackgroundColor3 = Color3.fromRGB(255, 59, 48)
	exitBtn.Text = "🏠 Salir"
	exitBtn.TextColor3 = Color3.new(1, 1, 1)
	exitBtn.TextSize = 20
	exitBtn.Font = Enum.Font.GothamBold
	exitBtn.Parent = exitGui
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = exitBtn
	
	exitBtn.MouseButton1Click:Connect(function()
		Remotes.ExitApp:FireServer()
		exitGui:Destroy()
		playerGui.AppStoreUI.Enabled = true
	end)
end

Remotes.CreateApp.OnClientEvent:Connect(function(success, appId)
	if success then
		openEditor(appId)
	end
end)

task.wait(1)
createMainUI()
