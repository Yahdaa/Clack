-- Camera Effects para Stranger Things Obby
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Efecto de viñeta
local function createVignette()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "VignetteEffect"
	screenGui.DisplayOrder = 10
	screenGui.Parent = player:WaitForChild("PlayerGui")
	
	local vignette = Instance.new("ImageLabel")
	vignette.Size = UDim2.new(1, 0, 1, 0)
	vignette.BackgroundTransparency = 1
	vignette.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
	vignette.ImageColor3 = Color3.fromRGB(0, 0, 0)
	vignette.ImageTransparency = 0.5
	vignette.Parent = screenGui
end

-- Blur sutil
local blur = Instance.new("BlurEffect")
blur.Size = 1
blur.Parent = camera

createVignette()

print("Camera effects loaded!")
