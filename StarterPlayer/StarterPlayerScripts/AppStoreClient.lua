-- LOCAL SCRIPT: App Store HTML
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

repeat task.wait() until ReplicatedStorage:FindFirstChild("AppStoreRemotes")
local Remotes = ReplicatedStorage.AppStoreRemotes

local function createMainUI()
	local sg = Instance.new("ScreenGui")
	sg.Name = "AppStoreUI"
	sg.ResetOnSpawn = false
	sg.IgnoreGuiInset = true
	sg.Parent = playerGui
	
	local main = Instance.new("Frame")
	main.Size = UDim2.new(1, 0, 1, 0)
	main.Position = UDim2.new(0, 0, 0, 0)
	main.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
	main.BorderSizePixel = 0
	main.Parent = sg
	
	local header = Instance.new("Frame")
	header.Size = UDim2.new(1, 0, 0, 80)
	header.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
	header.BorderSizePixel = 0
	header.Parent = main
	
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(0, 300, 1, 0)
	title.Position = UDim2.new(0, 30, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = "📱 App Store"
	title.TextColor3 = Color3.new(1, 1, 1)
	title.TextSize = 36
	title.Font = Enum.Font.GothamBold
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = header
	
	local createBtn = Instance.new("TextButton")
	createBtn.Size = UDim2.new(0, 200, 0, 50)
	createBtn.Position = UDim2.new(1, -230, 0.5, -25)
	createBtn.BackgroundColor3 = Color3.fromRGB(52, 199, 89)
	createBtn.Text = "+ Crear App"
	createBtn.TextColor3 = Color3.new(1, 1, 1)
	createBtn.TextSize = 22
	createBtn.Font = Enum.Font.GothamBold
	createBtn.BorderSizePixel = 0
	createBtn.Parent = header
	
	Instance.new("UICorner", createBtn).CornerRadius = UDim.new(0, 12)
	
	local scroll = Instance.new("ScrollingFrame")
	scroll.Size = UDim2.new(1, -60, 1, -120)
	scroll.Position = UDim2.new(0, 30, 0, 100)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 10
	scroll.Parent = main
	
	local grid = Instance.new("UIGridLayout")
	grid.CellSize = UDim2.new(0, 320, 0, 380)
	grid.CellPadding = UDim2.new(0, 25, 0, 25)
	grid.Parent = scroll
	
	createBtn.MouseButton1Click:Connect(openCreateUI)
	loadApps(scroll)
end

local function loadApps(container)
	for _, c in ipairs(container:GetChildren()) do
		if c:IsA("Frame") then c:Destroy() end
	end
	
	local apps = Remotes.LoadApps:InvokeServer()
	
	for _, app in ipairs(apps) do
		local card = Instance.new("Frame")
		card.Size = UDim2.new(0, 320, 0, 380)
		card.BackgroundColor3 = Color3.new(1, 1, 1)
		card.BorderSizePixel = 0
		card.Parent = container
		
		Instance.new("UICorner", card).CornerRadius = UDim.new(0, 16)
		
		local thumb = Instance.new("Frame")
		thumb.Size = UDim2.new(1, -30, 0, 180)
		thumb.Position = UDim2.new(0, 15, 0, 15)
		thumb.BackgroundColor3 = Color3.fromRGB(app.ThumbColor[1], app.ThumbColor[2], app.ThumbColor[3])
		thumb.BorderSizePixel = 0
		thumb.Parent = card
		
		Instance.new("UICorner", thumb).CornerRadius = UDim.new(0, 12)
		
		local appTitle = Instance.new("TextLabel")
		appTitle.Size = UDim2.new(1, -30, 0, 35)
		appTitle.Position = UDim2.new(0, 15, 0, 205)
		appTitle.BackgroundTransparency = 1
		appTitle.Text = app.Name
		appTitle.TextColor3 = Color3.new(0, 0, 0)
		appTitle.TextSize = 20
		appTitle.Font = Enum.Font.GothamBold
		appTitle.TextXAlignment = Enum.TextXAlignment.Left
		appTitle.TextTruncate = Enum.TextTruncate.AtEnd
		appTitle.Parent = card
		
		local creator = Instance.new("TextLabel")
		creator.Size = UDim2.new(1, -30, 0, 25)
		creator.Position = UDim2.new(0, 15, 0, 240)
		creator.BackgroundTransparency = 1
		creator.Text = "Por: " .. app.Creator
		creator.TextColor3 = Color3.fromRGB(120, 120, 120)
		creator.TextSize = 16
		creator.Font = Enum.Font.Gotham
		creator.TextXAlignment = Enum.TextXAlignment.Left
		creator.Parent = card
		
		local stats = Instance.new("TextLabel")
		stats.Size = UDim2.new(1, -30, 0, 25)
		stats.Position = UDim2.new(0, 15, 0, 270)
		stats.BackgroundTransparency = 1
		stats.Text = "❤️ " .. (app.Likes or 0) .. " likes"
		stats.TextColor3 = Color3.fromRGB(120, 120, 120)
		stats.TextSize = 16
		stats.Font = Enum.Font.Gotham
		stats.TextXAlignment = Enum.TextXAlignment.Left
		stats.Parent = card
		
		local playBtn = Instance.new("TextButton")
		playBtn.Size = UDim2.new(1, -30, 0, 55)
		playBtn.Position = UDim2.new(0, 15, 1, -70)
		playBtn.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
		playBtn.Text = "▶ Ver App"
		playBtn.TextColor3 = Color3.new(1, 1, 1)
		playBtn.TextSize = 20
		playBtn.Font = Enum.Font.GothamBold
		playBtn.BorderSizePixel = 0
		playBtn.Parent = card
		
		Instance.new("UICorner", playBtn).CornerRadius = UDim.new(0, 10)
		
		playBtn.MouseButton1Click:Connect(function()
			openAppViewer(app)
		end)
	end
end

function openCreateUI()
	local sg = Instance.new("ScreenGui")
	sg.Name = "CreateUI"
	sg.Parent = playerGui
	
	local bg = Instance.new("Frame")
	bg.Size = UDim2.new(1, 0, 1, 0)
	bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	bg.BackgroundTransparency = 0.4
	bg.BorderSizePixel = 0
	bg.Parent = sg
	
	local panel = Instance.new("Frame")
	panel.Size = UDim2.new(0, 900, 0, 700)
	panel.Position = UDim2.new(0.5, -450, 0.5, -350)
	panel.BackgroundColor3 = Color3.new(1, 1, 1)
	panel.BorderSizePixel = 0
	panel.Parent = bg
	
	Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 20)
	
	local panelTitle = Instance.new("TextLabel")
	panelTitle.Size = UDim2.new(1, 0, 0, 70)
	panelTitle.BackgroundTransparency = 1
	panelTitle.Text = "Crear Nueva App HTML"
	panelTitle.TextColor3 = Color3.new(0, 0, 0)
	panelTitle.TextSize = 32
	panelTitle.Font = Enum.Font.GothamBold
	panelTitle.Parent = panel
	
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(0, 200, 0, 30)
	nameLabel.Position = UDim2.new(0, 30, 0, 80)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = "Nombre:"
	nameLabel.TextColor3 = Color3.new(0, 0, 0)
	nameLabel.TextSize = 18
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = panel
	
	local nameBox = Instance.new("TextBox")
	nameBox.Size = UDim2.new(1, -60, 0, 45)
	nameBox.Position = UDim2.new(0, 30, 0, 115)
	nameBox.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
	nameBox.Text = ""
	nameBox.PlaceholderText = "Mi App Increíble"
	nameBox.TextColor3 = Color3.new(0, 0, 0)
	nameBox.TextSize = 18
	nameBox.Font = Enum.Font.Gotham
	nameBox.BorderSizePixel = 0
	nameBox.Parent = panel
	
	Instance.new("UICorner", nameBox).CornerRadius = UDim.new(0, 10)
	
	local codeLabel = Instance.new("TextLabel")
	codeLabel.Size = UDim2.new(0, 400, 0, 30)
	codeLabel.Position = UDim2.new(0, 30, 0, 175)
	codeLabel.BackgroundTransparency = 1
	codeLabel.Text = "Código HTML (todo en un archivo):"
	codeLabel.TextColor3 = Color3.new(0, 0, 0)
	codeLabel.TextSize = 18
	codeLabel.Font = Enum.Font.GothamBold
	codeLabel.TextXAlignment = Enum.TextXAlignment.Left
	codeLabel.Parent = panel
	
	local codeBox = Instance.new("TextBox")
	codeBox.Size = UDim2.new(1, -60, 0, 380)
	codeBox.Position = UDim2.new(0, 30, 0, 210)
	codeBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	codeBox.Text = [[<!DOCTYPE html>
<html>
<head>
<style>
body { 
  margin: 0;
  font-family: Arial;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
  <h1>¡Mi Primera App!</h1>
  <p>Edita este HTML para crear tu app</p>
  <button onclick="alert('¡Funciona!')">Click Aquí</button>
</div>
</body>
</html>]]
	codeBox.TextColor3 = Color3.fromRGB(0, 255, 100)
	codeBox.TextSize = 16
	codeBox.Font = Enum.Font.Code
	codeBox.TextXAlignment = Enum.TextXAlignment.Left
	codeBox.TextYAlignment = Enum.TextYAlignment.Top
	codeBox.MultiLine = true
	codeBox.ClearTextOnFocus = false
	codeBox.BorderSizePixel = 0
	codeBox.Parent = panel
	
	Instance.new("UICorner", codeBox).CornerRadius = UDim.new(0, 10)
	
	local colorLabel = Instance.new("TextLabel")
	colorLabel.Size = UDim2.new(0, 200, 0, 30)
	colorLabel.Position = UDim2.new(0, 30, 0, 605)
	colorLabel.BackgroundTransparency = 1
	colorLabel.Text = "Color miniatura:"
	colorLabel.TextColor3 = Color3.new(0, 0, 0)
	colorLabel.TextSize = 16
	colorLabel.Font = Enum.Font.GothamBold
	colorLabel.TextXAlignment = Enum.TextXAlignment.Left
	colorLabel.Parent = panel
	
	local colors = {
		{255, 59, 48}, {255, 149, 0}, {52, 199, 89}, {0, 122, 255},
		{88, 86, 214}, {255, 45, 85}, {255, 204, 0}, {175, 82, 222}
	}
	local selectedColor = colors[1]
	
	for i, c in ipairs(colors) do
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0, 50, 0, 50)
		btn.Position = UDim2.new(0, 30 + (i - 1) * 60, 0, 635)
		btn.BackgroundColor3 = Color3.fromRGB(c[1], c[2], c[3])
		btn.Text = ""
		btn.BorderSizePixel = 0
		btn.Parent = panel
		
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
		
		btn.MouseButton1Click:Connect(function()
			selectedColor = c
		end)
	end
	
	local publishBtn = Instance.new("TextButton")
	publishBtn.Size = UDim2.new(0, 250, 0, 60)
	publishBtn.Position = UDim2.new(0.5, -125, 1, -80)
	publishBtn.BackgroundColor3 = Color3.fromRGB(52, 199, 89)
	publishBtn.Text = "📱 Publicar App"
	publishBtn.TextColor3 = Color3.new(1, 1, 1)
	publishBtn.TextSize = 24
	publishBtn.Font = Enum.Font.GothamBold
	publishBtn.BorderSizePixel = 0
	publishBtn.Parent = panel
	
	Instance.new("UICorner", publishBtn).CornerRadius = UDim.new(0, 12)
	
	local cancelBtn = Instance.new("TextButton")
	cancelBtn.Size = UDim2.new(0, 120, 0, 60)
	cancelBtn.Position = UDim2.new(0, 30, 1, -80)
	cancelBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
	cancelBtn.Text = "Cancelar"
	cancelBtn.TextColor3 = Color3.new(0, 0, 0)
	cancelBtn.TextSize = 20
	cancelBtn.Font = Enum.Font.GothamBold
	cancelBtn.BorderSizePixel = 0
	cancelBtn.Parent = panel
	
	Instance.new("UICorner", cancelBtn).CornerRadius = UDim.new(0, 12)
	
	publishBtn.MouseButton1Click:Connect(function()
		if nameBox.Text ~= "" and codeBox.Text ~= "" then
			Remotes.PublishApp:FireServer({
				Name = nameBox.Text,
				HTMLCode = codeBox.Text,
				ThumbColor = selectedColor
			})
			sg:Destroy()
			task.wait(0.5)
			playerGui.AppStoreUI:Destroy()
			createMainUI()
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
	main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	main.BorderSizePixel = 0
	main.Parent = sg
	
	local topBar = Instance.new("Frame")
	topBar.Size = UDim2.new(1, 0, 0, 60)
	topBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	topBar.BorderSizePixel = 0
	topBar.Parent = main
	
	local appTitle = Instance.new("TextLabel")
	appTitle.Size = UDim2.new(0, 400, 1, 0)
	appTitle.Position = UDim2.new(0, 20, 0, 0)
	appTitle.BackgroundTransparency = 1
	appTitle.Text = app.Name
	appTitle.TextColor3 = Color3.new(1, 1, 1)
	appTitle.TextSize = 24
	appTitle.Font = Enum.Font.GothamBold
	appTitle.TextXAlignment = Enum.TextXAlignment.Left
	appTitle.Parent = topBar
	
	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.new(0, 150, 0, 40)
	closeBtn.Position = UDim2.new(1, -170, 0.5, -20)
	closeBtn.BackgroundColor3 = Color3.fromRGB(255, 59, 48)
	closeBtn.Text = "✕ Cerrar"
	closeBtn.TextColor3 = Color3.new(1, 1, 1)
	closeBtn.TextSize = 20
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.BorderSizePixel = 0
	closeBtn.Parent = topBar
	
	Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 10)
	
	local likeBtn = Instance.new("TextButton")
	likeBtn.Size = UDim2.new(0, 150, 0, 40)
	likeBtn.Position = UDim2.new(1, -340, 0.5, -20)
	likeBtn.BackgroundColor3 = Color3.fromRGB(255, 45, 85)
	likeBtn.Text = "❤️ Like"
	likeBtn.TextColor3 = Color3.new(1, 1, 1)
	likeBtn.TextSize = 20
	likeBtn.Font = Enum.Font.GothamBold
	likeBtn.BorderSizePixel = 0
	likeBtn.Parent = topBar
	
	Instance.new("UICorner", likeBtn).CornerRadius = UDim.new(0, 10)
	
	local browser = Instance.new("Frame")
	browser.Size = UDim2.new(1, -40, 1, -100)
	browser.Position = UDim2.new(0, 20, 0, 80)
	browser.BackgroundColor3 = Color3.new(1, 1, 1)
	browser.BorderSizePixel = 0
	browser.Parent = main
	
	Instance.new("UICorner", browser).CornerRadius = UDim.new(0, 12)
	
	local htmlLabel = Instance.new("TextLabel")
	htmlLabel.Size = UDim2.new(1, -40, 1, -40)
	htmlLabel.Position = UDim2.new(0, 20, 0, 20)
	htmlLabel.BackgroundTransparency = 1
	htmlLabel.Text = "🌐 Vista previa HTML\n\n" .. app.Name .. "\n\nPor: " .. app.Creator .. "\n\n(En Roblox no se puede ejecutar HTML real,\npero en un navegador web se vería así)\n\nCódigo guardado correctamente ✓"
	htmlLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
	htmlLabel.TextSize = 20
	htmlLabel.Font = Enum.Font.Gotham
	htmlLabel.TextWrapped = true
	htmlLabel.Parent = browser
	
	closeBtn.MouseButton1Click:Connect(function()
		sg:Destroy()
	end)
	
	likeBtn.MouseButton1Click:Connect(function()
		Remotes.LikeApp:FireServer(app.Id)
		likeBtn.Text = "❤️ ¡Liked!"
		likeBtn.BackgroundColor3 = Color3.fromRGB(52, 199, 89)
	end)
end

task.wait(1)
createMainUI()
