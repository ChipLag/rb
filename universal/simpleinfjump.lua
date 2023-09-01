--Loadstring:
--loadstring(game:HttpGet("https://raw.githubusercontent.com/ChipLag/rb/main/universal/simpleinfjump.lua",true))()
local p = Instance.new("Part")
p.Parent = game.Workspace
p.Anchored = true
p.Transparency = 1
local anchor = "LeftFoot"
while true do
  p.Position = game.Players.LocalPlayer.Character:FindFirstChild(anchor).Position
    p.Position = p.Position + Vector3.new(0,-3,0)
      wait(0.1)
      end