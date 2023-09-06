--Loadstring:
--loadstring(game:HttpGet("https://raw.githubusercontent.com/ChipLag/rb/main/universal/simpleinfjump.lua",true))()

local ScreenGui = Instance.new("ScreenGui")
local Destroyr = Instance.new("TextButton") 
ScreenGui.Parent = game.CoreGui
Destroyr.Name = "Destroyr"
Destroyr.Parent = ScreenGui
Destroyr.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Destroyr.BorderColor3 = Color3.fromRGB(0, 0, 0)
Destroyr.BorderSizePixel = 0
Destroyr.Size = UDim2.new(0, 50,0,50)
Destroyr.Position = UDim2.new(1, -75, 0.5, 50)
Destroyr.Font = Enum.Font.SourceSans
Destroyr.Text = "Destroy"
Destroyr.TextColor3 = Color3.fromRGB(0, 0, 0)
Destroyr.TextSize = 15.000 

local Fall = Instance.new("TextButton") 
ScreenGui.Parent = game.CoreGui
Fall.Name = "Fall"
Fall.Parent = ScreenGui
Fall.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Fall.BorderColor3 = Color3.fromRGB(0, 0, 0)
Fall.BorderSizePixel = 0
Fall.Size = UDim2.new(0, 50,0,50)
Fall.Position = UDim2.new(1, -75, 0.5, 0)
Fall.Font = Enum.Font.SourceSans
Fall.Text = "Fall"
Fall.TextColor3 = Color3.fromRGB(0, 0, 0)
Fall.TextSize = 18.000 

local function YRZYZ_fake_script() -- Fall.LocalScript 
	local script = Instance.new('LocalScript', Fall)
	local b = script.Parent
	b.MouseButton1Click:Connect(function()
	  local prt = game.Workspace:FindFirstChild("FunnyPart") 
	  prt.CanCollide = false
	  wait(0.8)
	  prt.CanCollide = true
	end)
end
coroutine.wrap(YRZYZ_fake_script)()

local function OMG_fake_script() -- Fall.LocalScript 
  local script = Instance.new('LocalScript', Destroyr)
	local b = script.Parent
	b.MouseButton1Click:Connect(function()
  	for i, v in ipairs(workspace:GetDescendants()) do
      if v.Name == "FunnyPart" then
          v:Destroy()
      end
  	end	  
    b.Parent:Destroy()
	end)
end
coroutine.wrap(OMG_fake_script)()

local p = Instance.new("Part")
p.Parent = game.Workspace
p.Anchored = true
p.Transparency = 1
p.Name = "FunnyPart"
local anchor = "HumanoidRootPart"
while true do
  p.Position = game.Players.LocalPlayer.Character:FindFirstChild(anchor).Position
    p.Position = p.Position + Vector3.new(0,-6,0)
      wait(0.1)
end
    
  
