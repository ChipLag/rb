--loadstring(game:HttpGet("https://raw.githubusercontent.com/ChipLag/rb/main/universal/securitycam.lua",true))()
-- Gui to Lua
-- Made By ChipLag
 
 -- Instances:
  
  local Security = Instance.new("ScreenGui")
  local CAMID = Instance.new("TextLabel")
  local NEXTCAM = Instance.new("TextButton")
  local PLACE = Instance.new("TextButton")
  local PREVCAM = Instance.new("TextButton")
  local VIEWCAM = Instance.new("TextButton")
  local REMCAM = Instance.new("TextButton")
  local ADDCAM = Instance.new("TextButton")
  local cam = Instance.new("Part")
  local view = Instance.new("Part")
  --Properties:
   
   Security.Name = "Security"
   Security.Parent = game.CoreGui
   Security.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
     
     cam.Parent = Security
     cam.Size = Vector3.new(2,2,2)
     cam.Position = Vector3.new(1,1,1)
     cam.Name = "Cam"
     cam.Anchored = true
     cam.CanCollide = false
     cam.Material = Enum.Material.SmoothPlastic
     cam.BrickColor = BrickColor.Black()
      
       
       view.Parent = cam
       view.Size = Vector3.new(0.1,0.1,0.1)
       view.Name = "View"
       view.Anchored = true
       view.CanCollide = false
       view.Transparency = 1
        
        CAMID.Name = "CAMID"
        CAMID.Parent = Security
        CAMID.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        CAMID.BorderColor3 = Color3.fromRGB(0, 0, 0)
        CAMID.BorderSizePixel = 2
        CAMID.Position = UDim2.new(0.449999988, 0, 0.899999976-0.1, 0)
        CAMID.Size = UDim2.new(0.100000001, 0, 0.0500000007, 0)
        CAMID.Font = Enum.Font.SourceSans
        CAMID.TextColor3 = Color3.fromRGB(0, 0, 0)
        CAMID.TextScaled = true
        CAMID.TextSize = 14.000
        CAMID.TextWrapped = true
         
         NEXTCAM.Name = "NEXTCAM"
         NEXTCAM.Parent = Security
         NEXTCAM.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
         NEXTCAM.BorderColor3 = Color3.fromRGB(0, 0, 0)
         NEXTCAM.BorderSizePixel = 2
         NEXTCAM.Position = UDim2.new(0.550000012, 0, 0.899999976-0.1, 0)
         NEXTCAM.Size = UDim2.new(0.0500000007, 0, 0.0500000007, 0)
         NEXTCAM.Font = Enum.Font.SourceSans
         NEXTCAM.Text = ">"
         NEXTCAM.TextColor3 = Color3.fromRGB(255, 255, 255)
         NEXTCAM.TextScaled = true
         NEXTCAM.TextSize = 14.000
         NEXTCAM.TextWrapped = true
          
          PLACE.Name = "PLACE"
          PLACE.Parent = Security
          PLACE.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
          PLACE.BorderColor3 = Color3.fromRGB(0, 0, 0)
          PLACE.BorderSizePixel = 2
          PLACE.Position = UDim2.new(0.5, 0, 0.949999988-0.1, 0)
          PLACE.Size = UDim2.new(0.100000001, 0, 0.0500000007, 0)
          PLACE.Font = Enum.Font.SourceSans
          PLACE.Text = "PLACE HERE"
          PLACE.TextColor3 = Color3.fromRGB(0, 0, 0)
          PLACE.TextScaled = true
          PLACE.TextSize = 14.000
          PLACE.TextWrapped = true
           
           PREVCAM.Name = "PREVCAM"
           PREVCAM.Parent = Security
           PREVCAM.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
           PREVCAM.BorderColor3 = Color3.fromRGB(0, 0, 0)
           PREVCAM.BorderSizePixel = 2
           PREVCAM.Position = UDim2.new(0.400000006, 0, 0.899999976-0.1, 0)
           PREVCAM.Size = UDim2.new(0.0500000007, 0, 0.0500000007, 0)
           PREVCAM.Font = Enum.Font.SourceSans
           PREVCAM.Text = "<"
           PREVCAM.TextColor3 = Color3.fromRGB(255, 255, 255)
           PREVCAM.TextScaled = true
           PREVCAM.TextSize = 14.000
           PREVCAM.TextWrapped = true
            
            VIEWCAM.Name = "VIEWCAM"
            VIEWCAM.Parent = Security
            VIEWCAM.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            VIEWCAM.BorderColor3 = Color3.fromRGB(0, 0, 0)
            VIEWCAM.BorderSizePixel = 2
            VIEWCAM.Position = UDim2.new(0.400000006, 0, 0.949999988-0.1, 0)
            VIEWCAM.Size = UDim2.new(0.100000001, 0, 0.0500000007, 0)
            VIEWCAM.Font = Enum.Font.SourceSans
            VIEWCAM.Text = "VIEW"
            VIEWCAM.TextColor3 = Color3.fromRGB(255, 255, 255)
            VIEWCAM.TextScaled = true
            VIEWCAM.TextSize = 14.000
            VIEWCAM.TextWrapped = true
             
             REMCAM.Name = "REMCAM"
             REMCAM.Parent = Security
             REMCAM.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
             REMCAM.BorderColor3 = Color3.fromRGB(0, 0, 0)
             REMCAM.BorderSizePixel = 2
             REMCAM.Position = UDim2.new(0.349999994, 0, 0.949999988-0.1, 0)
             REMCAM.Size = UDim2.new(0.0500000007, 0, 0.0500000007, 0)
             REMCAM.Font = Enum.Font.SourceSans
             REMCAM.Text = "-"
             REMCAM.TextColor3 = Color3.fromRGB(255, 255, 255)
             REMCAM.TextScaled = true
             REMCAM.TextSize = 14.000
             REMCAM.TextWrapped = true
              
              ADDCAM.Name = "ADDCAM"
              ADDCAM.Parent = Security
              ADDCAM.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
              ADDCAM.BorderColor3 = Color3.fromRGB(0, 0, 0)
              ADDCAM.BorderSizePixel = 2
              ADDCAM.Position = UDim2.new(0.600000024, 0, 0.949999988-0.1, 0)
              ADDCAM.Size = UDim2.new(0.0500000007, 0, 0.0500000007, 0)
              ADDCAM.Font = Enum.Font.SourceSans
              ADDCAM.Text = "+"
              ADDCAM.TextColor3 = Color3.fromRGB(255, 255, 255)
              ADDCAM.TextScaled = true
              ADDCAM.TextSize = 14.000
              ADDCAM.TextWrapped = true
               
               -- Scripts:
                
                local function IDORMWB_fake_script() -- Security.Script 
                	local script = Instance.new('LocalScript', Security)
                     
                     	local cam = script.Parent.Cam
                        	local cams = {cam:Clone(),cam:Clone(),cam:Clone()}
                             
                             	local cur = 1
                                	local viewing = false
                                    	wait(0.1)
                                        	local sj = game.Workspace.Camera.CameraSubject
                                             
                                             	--GUI--
                                                	local id = script.Parent.CAMID
                                                    	local nxt = script.Parent.NEXTCAM
                                                        	local prev = script.Parent.PREVCAM
                                                            	local vwcm = script.Parent.VIEWCAM
                                                                	local place = script.Parent.PLACE
                                                                     
                                                                     	local add = script.Parent.ADDCAM
                                                                        	local rem = script.Parent.REMCAM
                                                                             
                                                                             	for _,v in pairs(cams) do
                                                                                		v.Parent = game.Workspace
                                                                                        	end
                                                                                             
                                                                                              
                                                                                               
                                                                                               	prev.MouseButton1Down:Connect(function()
                                                                                                		cur = cur-1
                                                                                                        		if cur < 1 then
                                                                                                                			cur = #cams
                                                                                                                            		end
                                                                                                                                    		id.Text = cur
                                                                                                                                            	end)
                                                                                                                                                 
                                                                                                                                                 	nxt.MouseButton1Down:Connect(function()
                                                                                                                                                    		cur = cur+1
                                                                                                                                                            		if cur > #cams then
                                                                                                                                                                    			cur = 1
                                                                                                                                                                                		end
                                                                                                                                                                                        		id.Text = cur
                                                                                                                                                                                                	end)
                                                                                                                                                                                                     
                                                                                                                                                                                                      
                                                                                                                                                                                                      	vwcm.MouseButton1Down:Connect(function()
                                                                                                                                                                                                        		if viewing then
                                                                                                                                                                                                                			viewing = false
                                                                                                                                                                                                                            			game.Workspace.Camera.CameraSubject = sj
                                                                                                                                                                                                                                        		else
                                                                                                                                                                                                                                                			viewing = true
                                                                                                                                                                                                                                                            			game.Workspace.Camera.CameraSubject = cams[cur].View
                                                                                                                                                                                                                                                                        		end
                                                                                                                                                                                                                                                                                	end)
                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                     	place.MouseButton1Down:Connect(function()
                                                                                                                                                                                                                                                                                        		cams[cur].CFrame = game.Workspace.Camera.CFrame
                                                                                                                                                                                                                                                                                                		cams[cur].View.CFrame = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame
                                                                                                                                                                                                                                                                                                        	end)
                                                                                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                                                                                             	add.MouseButton1Down:Connect(function()
                                                                                                                                                                                                                                                                                                                		local new = cam:Clone()
                                                                                                                                                                                                                                                                                                                        		new.Parent = game.Workspace
                                                                                                                                                                                                                                                                                                                                		table.insert(cams, new)
                                                                                                                                                                                                                                                                                                                                        	end)
                                                                                                                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                                                                                                                             	rem.MouseButton1Down:Connect(function()
                                                                                                                                                                                                                                                                                                                                                		cams[#cams]:Destroy()
                                                                                                                                                                                                                                                                                                                                                        		table.remove(cams,#cams)
                                                                                                                                                                                                                                                                                                                                                                	end)
                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                      
                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                                                                                                                        	while true do
                                                                                                                                                                                                                                                                                                                                                                            		wait(0)
                                                                                                                                                                                                                                                                                                                                                                                    		id.Text = cur
                                                                                                                                                                                                                                                                                                                                                                                            		if viewing then
                                                                                                                                                                                                                                                                                                                                                                                                    			game.Workspace.Camera.CFrame = cams[cur].CFrame
                                                                                                                                                                                                                                                                                                                                                                                                                			game.Workspace.Camera.CameraSubject = cams[cur].View
                                                                                                                                                                                                                                                                                                                                                                                                                            		else
                                                                                                                                                                                                                                                                                                                                                                                                                                    			game.Workspace.Camera.CameraSubject = sj
                                                                                                                                                                                                                                                                                                                                                                                                                                                		end
                                                                                                                                                                                                                                                                                                                                                                                                                                                        	end
                                                                                                                                                                                                                                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                                                                                                                                                                                                                                             end
                                                                                                                                                                                                                                                                                                                                                                                                                                                             coroutine.wrap(IDORMWB_fake_script)() 