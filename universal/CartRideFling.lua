_G.CARTRIDE = 1
task.wait(1)
_G.CARTRIDE = nil

local RoBeX = _G.__ROBEX_CLIENT
if not RoBeX then
  game.Players.LocalPlayer:Kick("You forgot to inject RoBeX into the game!")
  return
end

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Offset = Vector3.new(2, 0 ,0)
local VoidTarget = Vector3.new(20000000, 20000000, 0)
-- Create GUI
local root = gethui()
local screen = Instance.new("ScreenGui", root)
local textbox = Instance.new("TextBox", screen)
textbox.AnchorPoint = Vector2.new(1, 0.5)
textbox.Position = UDim2.new(0.8, 0, 0, 0)
textbox.Size = UDim2.new(0.1, 0, 0.05, 0)
textbox.Text = ""
textbox.PlaceholderText = "Input Name..."

local button = Instance.new("TextButton", screen)
button.AnchorPoint = Vector2.new(1, 0.5)
button.Position = UDim2.new(0.8, 0, 0.05, 0)
button.Size = UDim2.new(0.1, 0, 0.05, 0)
button.Text = "Murder"

local step = nil

function loop()
  local Victim = RoBeX:GetPlayer(textbox.Text)
  if Victim == nil then
    button.Text = "Player Left!"
    step:Disconnect()
    return
  end

  -- Do Murder
  local MyChar = Player.Character
  local VictimChar = Victim.Character
  if MyChar == nil or VictimChar == nil then return end

  local MyHrp = MyChar.HumanoidRootPart
  local VictimHrp = VictimChar.HumanoidRootPart
  if MyHrp == nil or VictimHrp == nil then return end

  MyHrp.CFrame = CFrame.new(VictimHrp.CFrame.Position + Offset)
  if Victim.Humanoid.Sit then
    MyHrp.CFrame.Position = CFrame.new(VoidTarget)
  end
end

button.MouseButton1Click:Connect(function()
  if step then
    step:Disconnect()
    step = nil
    button.Text="Murder"
  else
    step = game:GetService("RunService").Heartbeat:Connect(loop)
    button.Text="Stop Murder"
  end
end)

-- Cleanup
while task.wait(0.5) do
  if _G.CARTRIDE == 1 then
    if step then step:Disconnect() end
    screen:Destroy()
    break
  end
end
