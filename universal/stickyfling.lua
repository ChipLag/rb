-- MODIFY FLING FORCE WITH _G.flingForce = VALUE

_G.flingForce = 2500
-- Gui to Lua
-- Version: 3.2^

-- Instances:

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local SpeedRightButton = Instance.new("TextButton") -- Done
local UICorner = Instance.new("UICorner")
local SpeedLeftButton = Instance.new("TextButton") -- Done
local UICorner_2 = Instance.new("UICorner")
local SpeedLabel = Instance.new("TextLabel") -- Done
local UICorner_3 = Instance.new("UICorner")
local KillDoButton = Instance.new("TextButton") -- Done
local UICorner_4 = Instance.new("UICorner")
local KillWhoBox = Instance.new("TextBox") -- Done
local UICorner_5 = Instance.new("UICorner")
local StopScriptButton = Instance.new("TextButton") -- Done
local UICorner_6 = Instance.new("UICorner")
local UICorner_7 = Instance.new("UICorner")
local MoveUpButton = Instance.new("TextButton")  -- Done
local UICorner_8 = Instance.new("UICorner")
local MoveDownButton = Instance.new("TextButton") -- Done
local UICorner_9 = Instance.new("UICorner")

--Properties:
local savedFrame = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.Name = "MovableSticky-Gui"

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(36, 39, 58)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.349999994, 0, 0, 0)
Frame.Size = UDim2.new(0.300000012, 0, 0.150000006, 0)

SpeedRightButton.Name = "SpeedRightButton"
SpeedRightButton.Parent = Frame
SpeedRightButton.BackgroundColor3 = Color3.fromRGB(54, 58, 79)
SpeedRightButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
SpeedRightButton.BorderSizePixel = 0
SpeedRightButton.Position = UDim2.new(0.75, 0, 0.0500000007, 0)
SpeedRightButton.Size = UDim2.new(0.200000003, 0, 0.275000006, 0)
SpeedRightButton.Font = Enum.Font.SourceSans
SpeedRightButton.Text = "→"
SpeedRightButton.TextColor3 = Color3.fromRGB(202, 211, 245)
SpeedRightButton.TextScaled = true
SpeedRightButton.TextSize = 14.000
SpeedRightButton.TextWrapped = true

UICorner.CornerRadius = UDim.new(0.300000012, 0)
UICorner.Parent = SpeedRightButton

SpeedLeftButton.Name = "SpeedLeftButton"
SpeedLeftButton.Parent = Frame
SpeedLeftButton.BackgroundColor3 = Color3.fromRGB(54, 58, 79)
SpeedLeftButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
SpeedLeftButton.BorderSizePixel = 0
SpeedLeftButton.Position = UDim2.new(0.0500000007, 0, 0.0500000007, 0)
SpeedLeftButton.Size = UDim2.new(0.200000003, 0, 0.275000006, 0)
SpeedLeftButton.Font = Enum.Font.SourceSans
SpeedLeftButton.Text = "←"
SpeedLeftButton.TextColor3 = Color3.fromRGB(202, 211, 245)
SpeedLeftButton.TextScaled = true
SpeedLeftButton.TextSize = 14.000
SpeedLeftButton.TextWrapped = true

UICorner_2.CornerRadius = UDim.new(0.300000012, 0)
UICorner_2.Parent = SpeedLeftButton

SpeedLabel.Name = "SpeedLabel"
SpeedLabel.Parent = Frame
SpeedLabel.BackgroundColor3 = Color3.fromRGB(30, 32, 48)
SpeedLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
SpeedLabel.BorderSizePixel = 0
SpeedLabel.Position = UDim2.new(0.300000012, 0, 0.0500000007, 0)
SpeedLabel.Size = UDim2.new(0.400000006, 0, 0.275000006, 0)
SpeedLabel.Font = Enum.Font.SourceSans
SpeedLabel.Text = "speed#"
SpeedLabel.TextColor3 = Color3.fromRGB(202, 211, 245)
SpeedLabel.TextScaled = true
SpeedLabel.TextSize = 14.000
SpeedLabel.TextWrapped = true

UICorner_3.CornerRadius = UDim.new(0.300000012, 0)
UICorner_3.Parent = SpeedLabel

KillDoButton.Name = "KillDoButton"
KillDoButton.Parent = Frame
KillDoButton.BackgroundColor3 = Color3.fromRGB(54, 58, 79)
KillDoButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
KillDoButton.BorderSizePixel = 0
KillDoButton.Position = UDim2.new(0.524999976, 0, 0.375, 0)
KillDoButton.Size = UDim2.new(0.425000012, 0, 0.275000006, 0)
KillDoButton.Font = Enum.Font.SourceSans
KillDoButton.Text = "Kill"
KillDoButton.TextColor3 = Color3.fromRGB(202, 211, 245)
KillDoButton.TextScaled = true
KillDoButton.TextSize = 14.000
KillDoButton.TextWrapped = true

UICorner_4.CornerRadius = UDim.new(0.300000012, 0)
UICorner_4.Parent = KillDoButton

KillWhoBox.Name = "KillWhoBox"
KillWhoBox.Parent = Frame
KillWhoBox.BackgroundColor3 = Color3.fromRGB(73, 77, 100)
KillWhoBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
KillWhoBox.BorderSizePixel = 0
KillWhoBox.Position = UDim2.new(0.0500000007, 0, 0.375, 0)
KillWhoBox.Size = UDim2.new(0.425000012, 0, 0.275000006, 0)
KillWhoBox.Font = Enum.Font.SourceSans
KillWhoBox.PlaceholderColor3 = Color3.fromRGB(165, 173, 203)
KillWhoBox.PlaceholderText = "Who to kill..."
KillWhoBox.Text = ""
KillWhoBox.TextColor3 = Color3.fromRGB(202, 211, 245)
KillWhoBox.TextScaled = true
KillWhoBox.TextSize = 14.000
KillWhoBox.TextWrapped = true

UICorner_5.CornerRadius = UDim.new(0.300000012, 0)
UICorner_5.Parent = KillWhoBox

StopScriptButton.Name = "StopScriptButton"
StopScriptButton.Parent = Frame
StopScriptButton.BackgroundColor3 = Color3.fromRGB(54, 58, 79)
StopScriptButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
StopScriptButton.BorderSizePixel = 0
StopScriptButton.Position = UDim2.new(0.0500000007, 0, 0.675000012, 0)
StopScriptButton.Size = UDim2.new(0.425000012, 0, 0.275000006, 0)
StopScriptButton.Font = Enum.Font.SourceSans
StopScriptButton.Text = "Stop this script"
StopScriptButton.TextColor3 = Color3.fromRGB(202, 211, 245)
StopScriptButton.TextScaled = true
StopScriptButton.TextSize = 14.000
StopScriptButton.TextWrapped = true

UICorner_6.CornerRadius = UDim.new(0.300000012, 0)
UICorner_6.Parent = StopScriptButton

UICorner_7.CornerRadius = UDim.new(0.100000001, 0)
UICorner_7.Parent = Frame

MoveUpButton.Name = "MoveUpButton"
MoveUpButton.Parent = Frame
MoveUpButton.BackgroundColor3 = Color3.fromRGB(54, 58, 79)
MoveUpButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
MoveUpButton.BorderSizePixel = 0
MoveUpButton.Position = UDim2.new(0.524999976, 0, 0.675000012, 0)
MoveUpButton.Size = UDim2.new(0.200000003, 0, 0.275000006, 0)
MoveUpButton.Font = Enum.Font.SourceSans
MoveUpButton.Text = "Up"
MoveUpButton.TextColor3 = Color3.fromRGB(202, 211, 245)
MoveUpButton.TextScaled = true
MoveUpButton.TextSize = 14.000
MoveUpButton.TextWrapped = true

UICorner_8.CornerRadius = UDim.new(0.300000012, 0)
UICorner_8.Parent = MoveUpButton

MoveDownButton.Name = "MoveDownButton"
MoveDownButton.Parent = Frame
MoveDownButton.BackgroundColor3 = Color3.fromRGB(54, 58, 79)
MoveDownButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
MoveDownButton.BorderSizePixel = 0
MoveDownButton.Position = UDim2.new(0.75, 0, 0.675000012, 0)
MoveDownButton.Size = UDim2.new(0.200000003, 0, 0.275000006, 0)
MoveDownButton.Font = Enum.Font.SourceSans
MoveDownButton.Text = "Down"
MoveDownButton.TextColor3 = Color3.fromRGB(202, 211, 245)
MoveDownButton.TextScaled = true
MoveDownButton.TextSize = 14.000
MoveDownButton.TextWrapped = true

UICorner_9.CornerRadius = UDim.new(0.300000012, 0)
UICorner_9.Parent = MoveDownButton


local savedFrame = nil

local speed = 5
local conn = nil

StopScriptButton.MouseButton1Click:Connect(function() 
	--script:Destroy()
	ScreenGui:Destroy()	
	conn:Disconnect()
end)

MoveDownButton.MouseButton1Click:Connect(function()
	local chr = game.Players.LocalPlayer.Character
	local root = chr:FindFirstChild("HumanoidRootPart")

	-- Ensure there's no floor below us via raycast
	local rayOrigin = root.Position
	local rayDirection = Vector3.new(0, -speed, 0)
	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {chr}
	local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
	if raycastResult then
		-- Snap to floor
		savedFrame = CFrame.new(root.Position.X, raycastResult.Position.Y + root.Size.Y + 1, root.Position.Z) * root.CFrame.Rotation
	else
		savedFrame = savedFrame + Vector3.new(0, -speed, 0)
	end
end)

MoveUpButton.MouseButton1Click:Connect(function()
	local chr = game.Players.LocalPlayer.Character
	local root = chr:FindFirstChild("HumanoidRootPart")
	
	-- Ensure there's no ceiling above us via raycast
	local rayOrigin = root.Position
	local rayDirection = Vector3.new(0, speed, 0)
	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {chr}
	local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
	if raycastResult then
		-- Snap to ceiling
		savedFrame = CFrame.new(root.Position.X, raycastResult.Position.Y - root.Size.Y / 2, root.Position.Z) * root.CFrame.Rotation
	else
		savedFrame = savedFrame + Vector3.new(0, speed, 0)
	end
end)

SpeedRightButton.MouseButton1Click:Connect(function()
	speed *= 2
end)

SpeedLeftButton.MouseButton1Click:Connect(function()
	speed /= 2
end)

local doTarget = nil
local justKill = false

KillDoButton.MouseButton1Click:Connect(function()
	local targetPrefix = KillWhoBox.Text
	local target = nil
	-- Filter usernames by prefix
	if targetPrefix ~= "" then
		for i, v in pairs(game.Players:GetChildren()) do
			if v.Name:sub(1, #targetPrefix):lower() == targetPrefix:lower() then
				target = v
			elseif v.DisplayName:sub(1, #targetPrefix):lower() == targetPrefix:lower() then
				target = v
			end
		end
	end
	
	if target == nil then
		justKill = not justKill
		KillDoButton.Text = "Fling: " .. tostring(justKill)
		return
	end
	
	doTarget = target
	task.wait(2)
	doTarget = nil
end)


conn = game.RunService.Heartbeat:Connect(function(deltaTime: number) 
	-- Reset the saved CFrame so that the player ends up at wherever they should spawn
	local chr = game.Players.LocalPlayer.Character
	if chr == nil then
		savedFrame = nil
		return
	end
	local root = chr:FindFirstChild("HumanoidRootPart")
	if root == nil then
		savedFrame = nil
		return
	end

	if savedFrame == nil then
		savedFrame = root.CFrame
	end

	
	SpeedLabel.Text = speed
	
	-- Get player input
	local humanoid:Humanoid = chr.Humanoid
	local dir = humanoid.MoveDirection

	-- Move CFrame by the player's input
	savedFrame = savedFrame + dir * speed * deltaTime
	
	
	if doTarget ~= nil then
		root.CFrame = doTarget.Character.HumanoidRootPart.CFrame
		root.AssemblyLinearVelocity = Vector3.new(_G.flingForce, 0, 0)
		root.AssemblyAngularVelocity = Vector3.new(10000, 10000, 10000)
	else
		-- Apply CFrame
		root.CFrame = savedFrame
		
		if justKill then
			root.AssemblyLinearVelocity = Vector3.new(_G.flingForce, 0, 0)
			root.AssemblyAngularVelocity = Vector3.new(10000, 10000, 10000)
		else
			root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
		end
	end
end)
