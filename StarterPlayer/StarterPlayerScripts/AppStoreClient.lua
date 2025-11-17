-- LOCAL SCRIPT: App Store HTML
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

repeat task.wait() until ReplicatedStorage:FindFirstChild("AppStoreRemotes")
local Remotes = ReplicatedStorage.AppStoreRemotes

local currentSection = "explore"
local allApps = {}
local mainUI

local function createMainUI()
	local sg = Instance.new("ScreenGui")
	sg.Name = "AppStoreUI"
	sg.ResetOnSpawn = false
	sg.IgnoreGuiInset = true
	sg.Parent = playerGui
	mainUI = sg
	
	local main = Instance.new("Frame")
	main.Size = UDim2.new(1, 0, 1, 0)
	main.BackgroundColor3 = Color3.fromRGB(242, 242, 247)
	main.BorderSizePixel = 0
	main.Parent = sg
	
	-- Header
	local header = Instance.new("Frame")
	header.Size = UDim2.new(1, 0, 0, 100)
	header.BackgroundColor3 = Color3.new(1, 1, 1)
	header.BorderSizePixel = 0
	header.Parent = main
	
	local headerShadow = Instance.new("Frame")
	headerShadow.Size = UDim2.new(1, 0, 0, 2)
	headerShadow.Position = UDim2.new(0, 0, 1, 0)
	headerShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	headerShadow.BackgroundTransparency = 0.9
	headerShadow.BorderSizePixel = 0
	headerShadow.Parent = header
	
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(0, 300, 0, 40)
	title.Position = UDim2.new(0, 20, 0, 15)
	title.BackgroundTransparency = 1
	title.Text = "App Store"
	title.TextColor3 = Color3.fromRGB(0, 0, 0)
	title.TextSize = 34
	title.Font = Enum.Font.GothamBold
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = header
	
	-- Search Bar
	local searchContainer = Instance.new("Frame")
	searchContainer.Size = UDim2.new(1, -40, 0, 40)
	searchContainer.Position = UDim2.new(0, 20, 0, 55)
	searchContainer.BackgroundColor3 = Color3.fromRGB(235, 235, 240)
	searchContainer.BorderSizePixel = 0
	searchContainer.Parent = header
	
	Instance.new("UICorner", searchContainer).CornerRadius = UDim.new(0, 10)
	
	local searchIcon = Instance.new("TextLabel")
	searchIcon.Size = UDim2.new(0, 40, 1, 0)
	searchIcon.BackgroundTransparency = 1
	searchIcon.Text = "🔍"
	searchIcon.TextSize = 20
	searchIcon.Parent = searchContainer
	
	local searchBox = Instance.new("TextBox")
	searchBox.Size = UDim2.new(1, -50, 1, 0)
	searchBox.Position = UDim2.new(0, 45, 0, 0)
	searchBox.BackgroundTransparency = 1
	searchBox.PlaceholderText = "Buscar apps..."
	searchBox.Text = ""
	searchBox.TextColor3 = Color3.fromRGB(0, 0, 0)
	searchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
	searchBox.TextSize = 17
	searchBox.Font = Enum.Font.Gotham
	searchBox.TextXAlignment = Enum.TextXAlignment.Left
	searchBox.ClearTextOnFocus = false
	searchBox.Parent = searchContainer
	
	-- Content Area
	local contentFrame = Instance.new("Frame")
	contentFrame.Name = "ContentFrame"
	contentFrame.Size = UDim2.new(1, 0, 1, -180)
	contentFrame.Position = UDim2.new(0, 0, 0, 100)
	contentFrame.BackgroundTransparency = 1
	contentFrame.BorderSizePixel = 0
	contentFrame.Parent = main
	
	-- Bottom Navigation
	local bottomNav = Instance.new("Frame")
	bottomNav.Size = UDim2.new(1, 0, 0, 80)
	bottomNav.Position = UDim2.new(0, 0, 1, -80)
	bottomNav.BackgroundColor3 = Color3.new(1, 1, 1)
	bottomNav.BorderSizePixel = 0
	bottomNav.Parent = main
	
	local navShadow = Instance.new("Frame")
	navShadow.Size = UDim2.new(1, 0, 0, 2)
	navShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	navShadow.BackgroundTransparency = 0.9
	navShadow.BorderSizePixel = 0
	navShadow.Parent = bottomNav
	
	local navButtons = {
		{Icon = "🏠", Text = "Explorar", Section = "explore"},
		{Icon = "📱", Text = "Mis Apps", Section = "myapps"},
		{Icon = "➕", Text = "Crear", Section = "create"}
	}
	
	for i, btn in ipairs(navButtons) do
		local navBtn = Instance.new("TextButton")
		navBtn.Size = UDim2.new(1/3, 0, 1, 0)
		navBtn.Position = UDim2.new((i-1)/3, 0, 0, 0)
		navBtn.BackgroundTransparency = 1
		navBtn.Text = ""
		navBtn.Parent = bottomNav
		
		local icon = Instance.new("TextLabel")
		icon.Size = UDim2.new(1, 0, 0, 30)
		icon.Position = UDim2.new(0, 0, 0, 12)
		icon.BackgroundTransparency = 1
		icon.Text = btn.Icon
		icon.TextSize = 28
		icon.Parent = navBtn
		
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 0, 20)
		label.Position = UDim2.new(0, 0, 0, 45)
		label.BackgroundTransparency = 1
		label.Text = btn.Text
		label.TextColor3 = Color3.fromRGB(150, 150, 150)
		label.TextSize = 12
		label.Font = Enum.Font.Gotham
		label.Parent = navBtn
		
		navBtn.MouseButton1Click:Connect(function()
			if btn.Section == "create" then
				openCreateUI()
			else
				currentSection = btn.Section
				updateContent(contentFrame, searchBox.Text)
				
				for _, child in ipairs(bottomNav:GetChildren()) do
					if child:IsA("TextButton") then
						local lbl = child:FindFirstChild("TextLabel", true)
						if lbl and lbl.Name ~= "TextLabel" then
							lbl.TextColor3 = Color3.fromRGB(150, 150, 150)
						end
					end
				end
				label.TextColor3 = Color3.fromRGB(0, 122, 255)
			end
		end)
		
		if btn.Section == "explore" then
			label.TextColor3 = Color3.fromRGB(0, 122, 255)
		end
	end
	
	searchBox:GetPropertyChangedSignal("Text"):Connect(function()
		updateContent(contentFrame, searchBox.Text)
	end)
	
	updateContent(contentFrame, "")
end

local function updateContent(container, searchText)
	for _, c in ipairs(container:GetChildren()) do
		if c:IsA("ScrollingFrame") then c:Destroy() end
	end
	
	allApps = Remotes.LoadApps:InvokeServer()
	
	local scroll = Instance.new("ScrollingFrame")
	scroll.Size = UDim2.new(1, 0, 1, 0)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 6
	scroll.ScrollBarImageColor3 = Color3.fromRGB(200, 200, 200)
	scroll.Parent = container
	
	local grid = Instance.new("UIGridLayout")
	grid.CellSize = UDim2.new(0, 280, 0, 350)
	grid.CellPadding = UDim2.new(0, 20, 0, 20)
	grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
	grid.Parent = scroll
	
	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 20)
	padding.PaddingBottom = UDim.new(0, 20)
	padding.Parent = scroll
	
	local filteredApps = {}
	for _, app in ipairs(allApps) do
		local matchSearch = searchText == "" or string.find(string.lower(app.Name), string.lower(searchText))
		local matchSection = currentSection == "explore" or (currentSection == "myapps" and app.CreatorId == player.UserId)
		
		if matchSearch and matchSection then
			table.insert(filteredApps, app)
		end
	end
	
	if #filteredApps == 0 then
		local empty = Instance.new("TextLabel")
		empty.Size = UDim2.new(1, 0, 0, 100)
		empty.Position = UDim2.new(0, 0, 0.5, -50)
		empty.BackgroundTransparency = 1
		empty.Text = currentSection == "myapps" and "No has creado apps aún" or "No se encontraron apps"
		empty.TextColor3 = Color3.fromRGB(150, 150, 150)
		empty.TextSize = 20
		empty.Font = Enum.Font.Gotham
		empty.Parent = container
		return
	end
	
	for _, app in ipairs(filteredApps) do
		local card = Instance.new("Frame")
		card.BackgroundColor3 = Color3.new(1, 1, 1)
		card.BorderSizePixel = 0
		card.Parent = scroll
		
		Instance.new("UICorner", card).CornerRadius = UDim.new(0, 14)
		
		local thumb = Instance.new("Frame")
		thumb.Size = UDim2.new(1, -20, 0, 160)
		thumb.Position = UDim2.new(0, 10, 0, 10)
		thumb.BackgroundColor3 = Color3.fromRGB(app.ThumbColor[1], app.ThumbColor[2], app.ThumbColor[3])
		thumb.BorderSizePixel = 0
		thumb.Parent = card
		
		Instance.new("UICorner", thumb).CornerRadius = UDim.new(0, 10)
		
		local appTitle = Instance.new("TextLabel")
		appTitle.Size = UDim2.new(1, -20, 0, 30)
		appTitle.Position = UDim2.new(0, 10, 0, 180)
		appTitle.BackgroundTransparency = 1
		appTitle.Text = app.Name
		appTitle.TextColor3 = Color3.fromRGB(0, 0, 0)
		appTitle.TextSize = 18
		appTitle.Font = Enum.Font.GothamBold
		appTitle.TextXAlignment = Enum.TextXAlignment.Left
		appTitle.TextTruncate = Enum.TextTruncate.AtEnd
		appTitle.Parent = card
		
		local creator = Instance.new("TextLabel")
		creator.Size = UDim2.new(1, -20, 0, 20)
		creator.Position = UDim2.new(0, 10, 0, 210)
		creator.BackgroundTransparency = 1
		creator.Text = "Por: " .. app.Creator
		creator.TextColor3 = Color3.fromRGB(140, 140, 140)
		creator.TextSize = 14
		creator.Font = Enum.Font.Gotham
		creator.TextXAlignment = Enum.TextXAlignment.Left
		creator.Parent = card
		
		local stats = Instance.new("TextLabel")
		stats.Size = UDim2.new(1, -20, 0, 20)
		stats.Position = UDim2.new(0, 10, 0, 235)
		stats.BackgroundTransparency = 1
		stats.Text = "❤️ " .. (app.Likes or 0)
		stats.TextColor3 = Color3.fromRGB(255, 45, 85)
		stats.TextSize = 14
		stats.Font = Enum.Font.Gotham
		stats.TextXAlignment = Enum.TextXAlignment.Left
		stats.Parent = card
		
		local playBtn = Instance.new("TextButton")
		playBtn.Size = UDim2.new(1, -20, 0, 50)
		playBtn.Position = UDim2.new(0, 10, 1, -60)
		playBtn.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
		playBtn.Text = "▶ Abrir"
		playBtn.TextColor3 = Color3.new(1, 1, 1)
		playBtn.TextSize = 18
		playBtn.Font = Enum.Font.GothamBold
		playBtn.BorderSizePixel = 0
		playBtn.Parent = card
		
		Instance.new("UICorner", playBtn).CornerRadius = UDim.new(0, 8)
		
		playBtn.MouseButton1Click:Connect(function()
			openAppViewer(app)
		end)
	end
	
	grid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		scroll.CanvasSize = UDim2.new(0, 0, 0, grid.AbsoluteContentSize.Y + 40)
	end)
end

function openCreateUI()
	local sg = Instance.new("ScreenGui")
	sg.Name = "CreateUI"
	sg.IgnoreGuiInset = true
	sg.Parent = playerGui
	
	local bg = Instance.new("Frame")
	bg.Size = UDim2.new(1, 0, 1, 0)
	bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	bg.BackgroundTransparency = 0.3
	bg.BorderSizePixel = 0
	bg.Parent = sg
	
	local panel = Instance.new("ScrollingFrame")
	panel.Size = UDim2.new(0.9, 0, 0.9, 0)
	panel.Position = UDim2.new(0.05, 0, 0.05, 0)
	panel.BackgroundColor3 = Color3.new(1, 1, 1)
	panel.BorderSizePixel = 0
	panel.ScrollBarThickness = 6
	panel.Parent = bg
	
	Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 16)
	
	local content = Instance.new("Frame")
	content.Size = UDim2.new(1, -40, 0, 800)
	content.Position = UDim2.new(0, 20, 0, 20)
	content.BackgroundTransparency = 1
	content.Parent = panel
	
	panel.CanvasSize = UDim2.new(0, 0, 0, 820)
	
	local panelTitle = Instance.new("TextLabel")
	panelTitle.Size = UDim2.new(1, 0, 0, 50)
	panelTitle.BackgroundTransparency = 1
	panelTitle.Text = "Crear Nueva App"
	panelTitle.TextColor3 = Color3.fromRGB(0, 0, 0)
	panelTitle.TextSize = 28
	panelTitle.Font = Enum.Font.GothamBold
	panelTitle.Parent = content
	
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(1, 0, 0, 25)
	nameLabel.Position = UDim2.new(0, 0, 0, 60)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = "Nombre de la App"
	nameLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
	nameLabel.TextSize = 16
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = content
	
	local nameBox = Instance.new("TextBox")
	nameBox.Size = UDim2.new(1, 0, 0, 45)
	nameBox.Position = UDim2.new(0, 0, 0, 90)
	nameBox.BackgroundColor3 = Color3.fromRGB(242, 242, 247)
	nameBox.Text = ""
	nameBox.PlaceholderText = "Ej: Mi Juego Increíble"
	nameBox.TextColor3 = Color3.fromRGB(0, 0, 0)
	nameBox.TextSize = 16
	nameBox.Font = Enum.Font.Gotham
	nameBox.BorderSizePixel = 0
	nameBox.ClearTextOnFocus = false
	nameBox.Parent = content
	
	Instance.new("UICorner", nameBox).CornerRadius = UDim.new(0, 8)
	local namePadding = Instance.new("UIPadding", nameBox)
	namePadding.PaddingLeft = UDim.new(0, 12)
	
	local codeLabel = Instance.new("TextLabel")
	codeLabel.Size = UDim2.new(1, 0, 0, 25)
	codeLabel.Position = UDim2.new(0, 0, 0, 150)
	codeLabel.BackgroundTransparency = 1
	codeLabel.Text = "Código HTML (todo en un archivo)"
	codeLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
	codeLabel.TextSize = 16
	codeLabel.Font = Enum.Font.GothamBold
	codeLabel.TextXAlignment = Enum.TextXAlignment.Left
	codeLabel.Parent = content
	
	local codeBox = Instance.new("TextBox")
	codeBox.Size = UDim2.new(1, 0, 0, 350)
	codeBox.Position = UDim2.new(0, 0, 0, 180)
	codeBox.BackgroundColor3 = Color3.fromRGB(40, 44, 52)
	codeBox.Text = [[<!DOCTYPE html>
<html>
<head>
<style>
body {
  margin: 0;
  font-family: Arial;
  background: linear-gradient(135deg, #667eea, #764ba2);
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
}
.container {
  text-align: center;
  color: white;
}
h1 { font-size: 48px; }
button {
  padding: 15px 30px;
  font-size: 20px;
  background: white;
  border: none;
  border-radius: 10px;
  cursor: pointer;
}
</style>
</head>
<body>
<div class="container">
  <h1>¡Mi App!</h1>
  <p>Edita este HTML</p>
  <button onclick="alert('Funciona')">Click</button>
</div>
</body>
</html>]]
	codeBox.TextColor3 = Color3.fromRGB(171, 178, 191)
	codeBox.TextSize = 14
	codeBox.Font = Enum.Font.Code
	codeBox.TextXAlignment = Enum.TextXAlignment.Left
	codeBox.TextYAlignment = Enum.TextYAlignment.Top
	codeBox.MultiLine = true
	codeBox.ClearTextOnFocus = false
	codeBox.BorderSizePixel = 0
	codeBox.Parent = content
	
	Instance.new("UICorner", codeBox).CornerRadius = UDim.new(0, 8)
	local codePadding = Instance.new("UIPadding", codeBox)
	codePadding.PaddingLeft = UDim.new(0, 10)
	codePadding.PaddingTop = UDim.new(0, 10)
	
	local colorLabel = Instance.new("TextLabel")
	colorLabel.Size = UDim2.new(1, 0, 0, 25)
	colorLabel.Position = UDim2.new(0, 0, 0, 545)
	colorLabel.BackgroundTransparency = 1
	colorLabel.Text = "Color de Miniatura"
	colorLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
	colorLabel.TextSize = 16
	colorLabel.Font = Enum.Font.GothamBold
	colorLabel.TextXAlignment = Enum.TextXAlignment.Left
	colorLabel.Parent = content
	
	local colors = {
		{255, 59, 48}, {255, 149, 0}, {52, 199, 89}, {0, 122, 255},
		{88, 86, 214}, {255, 45, 85}, {255, 204, 0}, {175, 82, 222}
	}
	local selectedColor = colors[1]
	
	for i, c in ipairs(colors) do
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0, 45, 0, 45)
		btn.Position = UDim2.new(0, (i - 1) * 55, 0, 575)
		btn.BackgroundColor3 = Color3.fromRGB(c[1], c[2], c[3])
		btn.Text = ""
		btn.BorderSizePixel = 0
		btn.Parent = content
		
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
		
		btn.MouseButton1Click:Connect(function()
			selectedColor = c
			for _, other in ipairs(content:GetChildren()) do
				if other:IsA("TextButton") and other ~= btn and other.Text == "" then
					other.BorderSizePixel = 0
				end
			end
			btn.BorderSizePixel = 3
			btn.BorderColor3 = Color3.fromRGB(0, 0, 0)
		end)
	end
	
	local publishBtn = Instance.new("TextButton")
	publishBtn.Size = UDim2.new(1, 0, 0, 55)
	publishBtn.Position = UDim2.new(0, 0, 0, 640)
	publishBtn.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
	publishBtn.Text = "Publicar App"
	publishBtn.TextColor3 = Color3.new(1, 1, 1)
	publishBtn.TextSize = 20
	publishBtn.Font = Enum.Font.GothamBold
	publishBtn.BorderSizePixel = 0
	publishBtn.Parent = content
	
	Instance.new("UICorner", publishBtn).CornerRadius = UDim.new(0, 10)
	
	local cancelBtn = Instance.new("TextButton")
	cancelBtn.Size = UDim2.new(1, 0, 0, 50)
	cancelBtn.Position = UDim2.new(0, 0, 0, 710)
	cancelBtn.BackgroundColor3 = Color3.fromRGB(242, 242, 247)
	cancelBtn.Text = "Cancelar"
	cancelBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
	cancelBtn.TextSize = 18
	cancelBtn.Font = Enum.Font.Gotham
	cancelBtn.BorderSizePixel = 0
	cancelBtn.Parent = content
	
	Instance.new("UICorner", cancelBtn).CornerRadius = UDim.new(0, 10)
	
	publishBtn.MouseButton1Click:Connect(function()
		if nameBox.Text ~= "" and codeBox.Text ~= "" then
			Remotes.PublishApp:FireServer({
				Name = nameBox.Text,
				HTMLCode = codeBox.Text,
				ThumbColor = selectedColor
			})
			sg:Destroy()
			task.wait(0.5)
			updateContent(mainUI.Frame.ContentFrame, "")
		end
	end)
	
	cancelBtn.MouseButton1Click:Connect(function()
		sg:Destroy()
	end)
end

function openAppViewer(app)
	local sg = Instance.new("ScreenGui")
	sg.Name = "AppViewer"
	sg.IgnoreGuiInset = true
	sg.Parent = playerGui
	
	local main = Instance.new("Frame")
	main.Size = UDim2.new(1, 0, 1, 0)
	main.BackgroundColor3 = Color3.fromRGB(242, 242, 247)
	main.BorderSizePixel = 0
	main.Parent = sg
	
	local topBar = Instance.new("Frame")
	topBar.Size = UDim2.new(1, 0, 0, 70)
	topBar.BackgroundColor3 = Color3.new(1, 1, 1)
	topBar.BorderSizePixel = 0
	topBar.Parent = main
	
	local shadow = Instance.new("Frame")
	shadow.Size = UDim2.new(1, 0, 0, 2)
	shadow.Position = UDim2.new(0, 0, 1, 0)
	shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	shadow.BackgroundTransparency = 0.9
	shadow.BorderSizePixel = 0
	shadow.Parent = topBar
	
	local backBtn = Instance.new("TextButton")
	backBtn.Size = UDim2.new(0, 70, 0, 40)
	backBtn.Position = UDim2.new(0, 15, 0.5, -20)
	backBtn.BackgroundTransparency = 1
	backBtn.Text = "←"
	backBtn.TextColor3 = Color3.fromRGB(0, 122, 255)
	backBtn.TextSize = 32
	backBtn.Font = Enum.Font.GothamBold
	backBtn.Parent = topBar
	
	local appTitle = Instance.new("TextLabel")
	appTitle.Size = UDim2.new(1, -180, 1, 0)
	appTitle.Position = UDim2.new(0, 90, 0, 0)
	appTitle.BackgroundTransparency = 1
	appTitle.Text = app.Name
	appTitle.TextColor3 = Color3.fromRGB(0, 0, 0)
	appTitle.TextSize = 20
	appTitle.Font = Enum.Font.GothamBold
	appTitle.TextXAlignment = Enum.TextXAlignment.Left
	appTitle.TextTruncate = Enum.TextTruncate.AtEnd
	appTitle.Parent = topBar
	
	local likeBtn = Instance.new("TextButton")
	likeBtn.Size = UDim2.new(0, 80, 0, 40)
	likeBtn.Position = UDim2.new(1, -95, 0.5, -20)
	likeBtn.BackgroundColor3 = Color3.fromRGB(255, 45, 85)
	likeBtn.Text = "❤️"
	likeBtn.TextColor3 = Color3.new(1, 1, 1)
	likeBtn.TextSize = 24
	likeBtn.Font = Enum.Font.GothamBold
	likeBtn.BorderSizePixel = 0
	likeBtn.Parent = topBar
	
	Instance.new("UICorner", likeBtn).CornerRadius = UDim.new(0, 10)
	
	local content = Instance.new("ScrollingFrame")
	content.Size = UDim2.new(1, -40, 1, -110)
	content.Position = UDim2.new(0, 20, 0, 85)
	content.BackgroundTransparency = 1
	content.BorderSizePixel = 0
	content.ScrollBarThickness = 6
	content.Parent = main
	
	local infoCard = Instance.new("Frame")
	infoCard.Size = UDim2.new(1, 0, 0, 150)
	infoCard.BackgroundColor3 = Color3.new(1, 1, 1)
	infoCard.BorderSizePixel = 0
	infoCard.Parent = content
	
	Instance.new("UICorner", infoCard).CornerRadius = UDim.new(0, 12)
	
	local thumb = Instance.new("Frame")
	thumb.Size = UDim2.new(0, 100, 0, 100)
	thumb.Position = UDim2.new(0, 20, 0, 25)
	thumb.BackgroundColor3 = Color3.fromRGB(app.ThumbColor[1], app.ThumbColor[2], app.ThumbColor[3])
	thumb.BorderSizePixel = 0
	thumb.Parent = infoCard
	
	Instance.new("UICorner", thumb).CornerRadius = UDim.new(0, 10)
	
	local infoTitle = Instance.new("TextLabel")
	infoTitle.Size = UDim2.new(1, -150, 0, 30)
	infoTitle.Position = UDim2.new(0, 135, 0, 25)
	infoTitle.BackgroundTransparency = 1
	infoTitle.Text = app.Name
	infoTitle.TextColor3 = Color3.fromRGB(0, 0, 0)
	infoTitle.TextSize = 22
	infoTitle.Font = Enum.Font.GothamBold
	infoTitle.TextXAlignment = Enum.TextXAlignment.Left
	infoTitle.TextTruncate = Enum.TextTruncate.AtEnd
	infoTitle.Parent = infoCard
	
	local creator = Instance.new("TextLabel")
	creator.Size = UDim2.new(1, -150, 0, 25)
	creator.Position = UDim2.new(0, 135, 0, 55)
	creator.BackgroundTransparency = 1
	creator.Text = "Por: " .. app.Creator
	creator.TextColor3 = Color3.fromRGB(140, 140, 140)
	creator.TextSize = 16
	creator.Font = Enum.Font.Gotham
	creator.TextXAlignment = Enum.TextXAlignment.Left
	creator.Parent = infoCard
	
	local likes = Instance.new("TextLabel")
	likes.Size = UDim2.new(1, -150, 0, 25)
	likes.Position = UDim2.new(0, 135, 0, 85)
	likes.BackgroundTransparency = 1
	likes.Text = "❤️ " .. (app.Likes or 0) .. " likes"
	likes.TextColor3 = Color3.fromRGB(255, 45, 85)
	likes.TextSize = 16
	likes.Font = Enum.Font.GothamBold
	likes.TextXAlignment = Enum.TextXAlignment.Left
	likes.Parent = infoCard
	
	local codeCard = Instance.new("Frame")
	codeCard.Size = UDim2.new(1, 0, 0, 400)
	codeCard.Position = UDim2.new(0, 0, 0, 170)
	codeCard.BackgroundColor3 = Color3.new(1, 1, 1)
	codeCard.BorderSizePixel = 0
	codeCard.Parent = content
	
	Instance.new("UICorner", codeCard).CornerRadius = UDim.new(0, 12)
	
	local codeTitle = Instance.new("TextLabel")
	codeTitle.Size = UDim2.new(1, -40, 0, 40)
	codeTitle.Position = UDim2.new(0, 20, 0, 15)
	codeTitle.BackgroundTransparency = 1
	codeTitle.Text = "Código HTML"
	codeTitle.TextColor3 = Color3.fromRGB(0, 0, 0)
	codeTitle.TextSize = 18
	codeTitle.Font = Enum.Font.GothamBold
	codeTitle.TextXAlignment = Enum.TextXAlignment.Left
	codeTitle.Parent = codeCard
	
	local codeBox = Instance.new("TextBox")
	codeBox.Size = UDim2.new(1, -40, 0, 320)
	codeBox.Position = UDim2.new(0, 20, 0, 60)
	codeBox.BackgroundColor3 = Color3.fromRGB(40, 44, 52)
	codeBox.Text = app.HTMLCode or "Sin código"
	codeBox.TextColor3 = Color3.fromRGB(171, 178, 191)
	codeBox.TextSize = 14
	codeBox.Font = Enum.Font.Code
	codeBox.TextXAlignment = Enum.TextXAlignment.Left
	codeBox.TextYAlignment = Enum.TextYAlignment.Top
	codeBox.TextEditable = false
	codeBox.MultiLine = true
	codeBox.BorderSizePixel = 0
	codeBox.Parent = codeCard
	
	Instance.new("UICorner", codeBox).CornerRadius = UDim.new(0, 8)
	local codePadding = Instance.new("UIPadding", codeBox)
	codePadding.PaddingLeft = UDim.new(0, 10)
	codePadding.PaddingTop = UDim.new(0, 10)
	
	content.CanvasSize = UDim2.new(0, 0, 0, 590)
	
	backBtn.MouseButton1Click:Connect(function()
		sg:Destroy()
	end)
	
	likeBtn.MouseButton1Click:Connect(function()
		Remotes.LikeApp:FireServer(app.Id)
		likeBtn.Text = "✓"
		likeBtn.BackgroundColor3 = Color3.fromRGB(52, 199, 89)
		task.wait(0.5)
		updateContent(mainUI.Frame.ContentFrame, "")
	end)
end

task.wait(1)
createMainUI()
