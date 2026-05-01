--loadstring(game:HttpGet("https://raw.githubusercontent.com/ChipLag/rb/main/universal/sticky.lua",true))()
local Root = game.Players.LocalPlayer.PlayerGui
local White = Color3.fromRGB(205, 214, 244)
-- Helpers
function addCorners(root, radius)
	local c = Instance.new("UICorner", root)
	c.CornerRadius = UDim.new(radius, 0)
	return c
end

-- Build ScreenGUI
local ScreenGui = Instance.new("ScreenGui", Root)
ScreenGui.Name="CLStickyScript"
ScreenGui.ResetOnSpawn = false

-- Build Root Window
local Window = Instance.new("Frame", ScreenGui)
Window.Name = "Window"
Window.Position = UDim2.new(0.375, 0, 0.7, 0)
Window.Size = UDim2.new(0.25, 0, 0.1, 0)
Window.BackgroundColor3 = Color3.fromRGB(30, 30, 46)
Window.SizeConstraint = Enum.SizeConstraint.RelativeXX
addCorners(Window, 0.05)

-- Build Content Window
local WContent = Instance.new("Frame", Window)
WContent.Name = "Content"
WContent.BackgroundTransparency = 1
WContent.Size = UDim2.new(1, 0, 0.8, 0)
WContent.Position = UDim2.new(0, 0, 0.2, 0)

local Layout = Instance.new("UIListLayout", WContent)
Layout.Padding = UDim.new(0.05, 0)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.VerticalAlignment = Enum.VerticalAlignment.Center
Layout.FillDirection = Enum.FillDirection.Horizontal

function buildBtn(text, onclick)
	local button = Instance.new("TextButton", WContent)
	button.Text = text
	button.BackgroundColor3 = Color3.fromRGB(49, 50, 68)
	button.TextColor3 = White
	button.TextScaled = true
	button.TextXAlignment = Enum.TextXAlignment.Center
	button.TextYAlignment = Enum.TextYAlignment.Center
	button.Size = UDim2.new(0.283, 0, 0.75, 0)
	button.Font = Enum.Font.Roboto
	button.MouseButton1Click:Connect(function()
		onclick(button)
	end)
	local tc = Instance.new("UITextSizeConstraint", button)
	tc.MaxTextSize = 26
	addCorners(button, 0.15)
end

local stuckPos = nil
local lp = game.Players.LocalPlayer

-- Build Buttons
buildBtn("Anchor Self", function(btn)
	local hrp = lp.Character:FindFirstChild("HumanoidRootPart")
	if hrp then
		hrp.Anchored = not hrp.Anchored
		btn.Text = hrp.Anchored and "Unanchor Self" or "Anchor Self"
	end
end)

buildBtn("Stick CFrame", function(btn)
	if stuckPos == nil then
		stuckPos = lp.Character:FindFirstChild("HumanoidRootPart").CFrame
	else
		stuckPos = nil
	end
	
	btn.Text = stuckPos ~= nil and "Unstick CFrame" or "Stick CFrame"
end)

buildBtn("Reset Velocity", function(btn)
	local hrp = lp.Character:FindFirstChild("HumanoidRootPart")
	if hrp then
		hrp.AssemblyLinearVelocity = Vector3.zero
		hrp.AssemblyAngularVelocity = Vector3.zero
	end
end)


-- Build Title Bar
local TitleBar = Instance.new("Frame", Window)
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0.2, 0)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(17, 17, 27)
addCorners(TitleBar, 0.23)

-- Remove Bottom Corners Trick
local TBB = Instance.new("Frame", TitleBar)
TBB.Name = "TitleBarBottom"
TBB.Size = UDim2.new(1, -2, 0.5, 0)
TBB.Position = UDim2.new(0, 1, 0.5, 0)
TBB.BackgroundColor3 = Color3.fromRGB(17, 17, 27)
TBB.BorderSizePixel = 0
TBB.ZIndex = 1

-- Title Bar Text
local Title = Instance.new("TextLabel", TitleBar)
Title.Name = "Title"
Title.Size = UDim2.new(0.8, 0, 0.9, 0)
Title.Position = UDim2.new(0.05, 0, 0.05, 0)
Title.Text = "StickyScript"
Title.TextColor3 = White
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextScaled = true

-- Close Button
local Close = Instance.new("ImageButton", TitleBar)
Close.Image = "rbxassetid://130334254289066"
Close.ImageColor3 = White
Close.Size = UDim2.new(0.1, 0, 1, 0)
Close.Position = UDim2.new(0.9, 0, 0, 0)
Close.BackgroundColor3 = Color3.fromRGB(243, 139, 168)
Close.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
	script:Destroy()
end)
addCorners(Close, 0.24)


-- Dragging Logic (only works on TitleBar)
local UserInputService = game:GetService("UserInputService")
local dragging = false
local dragStartPos = nil
local windowStartPos = nil

TitleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStartPos = input.Position
		windowStartPos = Window.Position
	end
end)

TitleBar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStartPos
		Window.Position = UDim2.new(
			windowStartPos.X.Scale,
			windowStartPos.X.Offset + delta.X,
			windowStartPos.Y.Scale,
			windowStartPos.Y.Offset + delta.Y
		)
	end
end)

-- Heartbeat
game.RunService.Heartbeat:Connect(function()
	if stuckPos ~= nil then
		local hrp = lp.Character:FindFirstChild("HumanoidRootPart")
		hrp.CFrame = stuckPos
	end
end)
