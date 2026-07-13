_G.srr_unload = true
task.wait(0.5)
_G.srr_unload = false

local Svc = {
	Plrs = game:GetService("Players"),
	RepStore = game:GetService("ReplicatedStorage"),
	Workspace = game:GetService("Workspace"),
	Run = game:GetService("RunService")
}

local LocalPlayer = Svc.Plrs.LocalPlayer

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
	Name="Slap Royale Remake",
	Icon = "hand",
	LoadingTitle = "Slap Royale Remake Script",
	LoadingSubtitle = "by ChipLag",
	ShowText = "SRR Script",
	ToggleUIKeybind = "P",
	Discord = {
		Enabled = false,
		Invite = "noinvitelink",
		RememberJoins = true
	}
})

local function Notify(msg, img)
	local i = img or "hand"
	Rayfield:Notify({Title="Slap Royale Remake", Content=msg, Duration=5, Image=i})
end

-----------------
-- TOOLS TOOLS --
-----------------
local ToolsTab = Window:CreateTab("Tools", "wrench")

ToolsTab:CreateButton({
	Name = "Give all Safe Tools",
	Callback = function()
		for i,v in pairs(Svc.RepStore:FindFirstChild("Gloves"):GetChildren()) do
			if v:IsA("Tool") then
				v:Clone().Parent = LocalPlayer.Backpack
			end
		end
	end
})

ToolsTab:CreateButton({
	Name = "Give all UN-Safe / Unused Tools (HIGH KICK/BAN RISK)",
	Callback = function()
		for i,v in pairs(Svc.RepStore:FindFirstChild("Gloves"):FindFirstChild("unused"):GetChildren()) do
			if v:IsA("Tool") then
				v:Clone().Parent = LocalPlayer.Backpack
			end
		end
	end
})

ToolsTab:CreateButton({
	Name = "Clear Tools",
	Callback = function()
		for i,v in pairs(LocalPlayer.Backpack:GetChildren()) do
			v:Destroy()
		end
	end
})


-----------------
-- ADMIN TOOLS --
-----------------

local AdminTab = Window:CreateTab("Admin", "user")

AdminTab:CreateButton({
	Name = "GodMode",
	Callback = function()
		Svc.RepStore:FindFirstChild("GodModeToggle"):FireServer()
	end
})

AdminTab:CreateButton({
	Name = "Invisible",
	Callback = function()
		Svc.RepStore:FindFirstChild("InvisibleToggle"):FireServer()
	end
})

-----------------
-- HACKS TOOLS --
-----------------
local HackTab = Window:CreateTab("Hacks", "laptop")
local cooldowns = {}


function resetOfCooldown(tool, ctype)
	local cfg = tool:FindFirstChild("Config")
	if not cfg then return warn(tool.Name, "has no Config!") end
	local abilityCd = cfg:FindFirstChild(ctype.."CD")
	
	if not abilityCd then return end -- Tools may not have abilities
	
	local cdData = cooldowns[tool.Name]
	
	if not cdData then return error(tool.Name, "has no Cooldown Data!") end
	
	abilityCd.Value = cdData[ctype]
end

function noOfCooldown(tool, ctype)
	local cfg = tool:FindFirstChild("Config")
	if not cfg then return warn(tool.Name, "has no Config!") end
	local abilityCd = cfg:FindFirstChild(ctype.."CD")
	
	if not abilityCd then return end -- Tools may not have abilities
	
	local cdData = cooldowns[tool.Name]
	
	if not cdData then
		cooldowns[tool.Name] = {}
	end
	
	cooldowns[tool.Name][ctype] = abilityCd.Value
	
	abilityCd.Value = 0.001
end

function cooldownOf(Value, ctype)
	for _, tool in pairs(Svc.RepStore:FindFirstChild("Gloves"):GetDescendants()) do
		if tool:IsA("Tool") then
			if not Value then
				resetOfCooldown(tool, ctype)	
			else
				noOfCooldown(tool, ctype)
			end
		end
	end
	
	for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
		if tool:IsA("Tool") then
			if not Value then
				resetOfCooldown(tool, ctype)
			else
				noOfCooldown(tool, ctype)	
			end
		end
	end
end

HackTab:CreateToggle({
	Name = "No Ability Cooldown Enabled?",
	CurrentValue = false,
	Callback = function(Value)
		cooldownOf(Value, "Ability")
	end
})

HackTab:CreateToggle({
	Name = "No Attack Cooldown Enabled?",
	CurrentValue = false,
	Callback = function(Value)
		cooldownOf(Value, "Attack")
	end
})

HackTab:CreateButton({
	Name = "Allow Noclip through Office Doors",
	Callback = function()
		local aa = Svc.Workspace:FindFirstChild("Map"):FindFirstChild("OriginOffice"):FindFirstChild("Antiaccess")
		if aa:FindFirstChild("TouchInterest") then
			aa:FindFirstChild("TouchInterest"):Destroy()
			Notify("Done! Now use any NoClip!")
		else
			Notify("Already Done! Now use any NoClip!")
		end
	end
})

HackTab:CreateButton({
	Name = "TP To Office",
	Callback = function()
		local Ladder = Svc.Workspace:FindFirstChild("Map"):FindFirstChild("FiestaFarm"):FindFirstChild("Ladder")
		local Child = Ladder:GetChildren()[35]
		if Child and LocalPlayer and LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart then
			LocalPlayer.Character.HumanoidRootPart.CFrame = Child.CFrame
			Notify("Done!")
		else
			Notify("Error while Teleporting!")
		end
	end
})

local crashServer = false

HackTab:CreateToggle({
	Name = "Server Crasher",
	Callback = function(Value)
		crashServer = Value
		if Value == false then
			task.delay(0.2, function()
				-- Final Anti-Lag
				for i,v in pairs(Svc.Workspace:GetChildren()) do
					if v.Name=="Blackhole" then v:Destroy() end
				end
			end)
		end
	end
})

function getToolRemote()
	-- Get tool in hand
	if not LocalPlayer.Character then
		return nil
	end
	local firstTool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
	if not firstTool then return nil end
	
	-- Get name
	local name = firstTool.Name
	-- Get RE
	local re = Svc.RepStore.Events.SlapEvents:FindFirstChild(name)
	return re
	
end

-----------------
-- SLAPS TOOLS --
-----------------
local killAllDummies = false
local killAllPlayers = false
local killAura = false
local killAuraRange = 6

local SlapTab = Window:CreateTab("Slaps", "sword")
local cooldowns = {}

SlapTab:CreateToggle({
	Name = "[BLATANT] Kill All Dummies",
	Callback = function(Value)
		killAllDummies = Value
	end
})

SlapTab:CreateToggle({
	Name = "[BLATANT] Kill All Players",
	Callback = function(Value)
		killAllPlayers = Value
	end
})

SlapTab:CreateToggle({
	Name = "Slap Aura",
	Callback = function(Value)
		killAura = Value
	end
})

SlapTab:CreateSlider({
	Name = "Slap Aura Distance",
	Range = {1, 40},
	Increment = 1,
	CurrentValue = 6,
	Callback = function(Value)
		killAuraRange = Value
	end
})

------------------
--  MAP  TOOLS --
-----------------
local MapTab = Window:CreateTab("Map", "sword")
local acidJesusParts = {}
local antibh = false

MapTab:CreateToggle({
	Name = "Acid Jesus",
	Callback = function(Value)
		-- Destroy old Parts
		for _, v in pairs(acidJesusParts) do
			v:Destroy()		
		end
		acidJesusParts = {}
		
		if not Value then return end
		
		for i,v in pairs(Svc.Workspace.Map.AcidAbnormality.AcidPit:GetChildren()) do
			local part = Instance.new("Part", Svc.Workspace)
			part.Transparency = 0.5
			part.CFrame = v.CFrame
			part.Size = v.Size + Vector3.new(10,10,10)
			part.Anchored = true
			table.insert(acidJesusParts, part)
		end
	end
})

MapTab:CreateButton({
	Name = "Steal all items",
	Callback = function(Value)
		for _, v in pairs(Svc.Workspace.Items:GetChildren()) do
			if v:IsA("Tool") then
				Svc.RepStore.Events.Item:FireServer(v.Handle)
			end			
		end
	end
})

MapTab:CreateToggle({
	Name = "Anti - Black Hole",
	Callback = function(Value)
		antibh = Value
	end
})

-- Service
local run
run = Svc.Run.Heartbeat:Connect(function()
	if antibh then
		for i,v in pairs(Svc.Workspace:GetChildren()) do
				if v.Name=="Blackhole" then v:Destroy() end
		end
	end

	if crashServer then
		for i, v in pairs(Svc.Plrs:GetPlayers()) do
			if v.Character.HumanoidRootPart and LocalPlayer.Character.HumanoidRootPart and v ~= LocalPlayer then
				LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.Character.HumanoidRootPart.CFrame.Position +
					Vector3.new(
						math.random(-80,80)*3/10,
						math.random(-10,30)/10,
						math.random(-80,80)*3/10
					)
				)
			end
			Svc.RepStore.Events.AbilityEvents.BlackholeAbility:FireServer()
			task.wait(0.005)
			-- ANTI-LAG
			for i,v in pairs(Svc.Workspace:GetChildren()) do
				if v.Name=="Blackhole" then v:Destroy() end
			end
		end
	end
	
	if killAllDummies then
		local re = getToolRemote()
		if not re then return end
		
		for _, v in pairs(Svc.Workspace.Dummies:GetChildren()) do
			re:FireServer(v)
		end
	end
	
	if killAllPlayers then
		local re = getToolRemote()
		if not re then return end
		
		for _, v in pairs(Svc.Plrs:GetPlayers()) do
			if v.Character and v ~= LocalPlayer then
				re:FireServer(v.Character)
			end
		end
	end
	
	if killAura then
		local re = getToolRemote()
		if not re then return end
		if not LocalPlayer.Character or not LocalPlayer.Character.HumanoidRootPart then return end
		
		-- Players
		for _, v in pairs(game.Players:GetPlayers()) do
			if v.Character and v ~= LocalPlayer and v.Character.HumanoidRootPart then
				local a = LocalPlayer.Character.HumanoidRootPart.Position
				local b = v.Character.HumanoidRootPart.Position
				
				local dist = (a-b).Magnitude
				
				if dist <= killAuraRange then
					re:FireServer(v.Character)
				end
			end
		end
		
		-- Dummies
		for _, v in pairs(Svc.Workspace.Dummies:GetChildren()) do
			if v and v.HumanoidRootPart then
				local a = LocalPlayer.Character.HumanoidRootPart.Position
				local b = v.HumanoidRootPart.Position
				
				local dist = (a-b).Magnitude
				
				if dist <= killAuraRange then
					re:FireServer(v)
				end
			end
		end
	end
end)


-- DEBUG UNLOAD --
while task.wait(0.1) do
	if _G.srr_unload then
		Rayfield:Destroy()
		run:Disconnect()
	end
end
