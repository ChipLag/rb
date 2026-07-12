local panel = game.StarterGui.Jayys_Panel
panel.AllowedUsers:Destroy()
local np =panel:Clone()
np.Parent = game.Players.LocalPlayer.PlayerGui
np.Enabled = true

local panel = game.StarterGui.Admin2
panel.LocalScript:Destroy()
local np =panel:Clone()
np.Parent = game.Players.LocalPlayer.PlayerGui
np.Enabled = true
