function uiAttach(char)
  local head = char:WaitForChild("Head")
  
  local ui = head:FindFirstChild("AdminInfoUi")
  if ui then
    ui:Destroy()
  end

  local ui = Instance.new("BillboardGui", head)
  ui.StudsOffset = Vector3.new(0,2,0)
  ui.Size = UDim2.new(2,0,1,0)
  ui.Name="AdminInfoUi"
  
  local freeze = Instance.new("TextLabel", ui)
  freeze.Size = UDim2.new(1,0,1,0)
  freeze.BackgroundTransparency = 1
  freeze.TextColor3 = Color3.fromRGB(255,0,0)
  freeze.TextScaled = true
  freeze.Text = "FROZEN"
  freeze.Visible = false

  return ui, freeze
end

function handlePlr(player)
  player.CharacterAdded:Connect(function(char)
    handleChar(player, char)
  end)
  if player.Character then
    handleChar(player, player.Character)
  end
end

function anchorCheck(freeze, char, hrp)
  if hrp.Anchored then
    local hl = Instance.new("Highlight", char)
    hl.Name="AdminAnchorHl"
    freeze.Visible = true
  else
    local hl = char:FindFirstChild("AdminAnchorHl")
    if hl then hl:Destroy() end
    freeze.Visible = false
  end
end

function handleChar(player, char)
  local hrp = char:WaitForChild("HumanoidRootPart")
  local ui, freeze = uiAttach(char)
  anchorCheck(freeze, char, hrp)
  hrp:GetPropertyChangedSignal("Anchored"):Connect(function()
    anchorCheck(freeze, char, hrp)
  end)
end


game:GetService("Players").PlayerAdded:Connect(handlePlr)
for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
  handlePlr(plr)
end

game:GetService("StarterGui"):SetCore("SendNotification", {Title="ChipLag",Text="AdmFreeze Loaded", Duration=5})
