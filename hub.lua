--loadstring:
--loadstring(game:HttpGet("https://raw.githubusercontent.com/ChipLag/rb/main/hub.lua",true))() 
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("ChipLag Hub", "DarkTheme")

--Universal
local universal = Window:NewTab("Universal")
local uUniversal = universal:NewSection("UNIVERSAL SCRIPTS")
uUniversal:NewButton("StickyScript", "Make yourself stuck at a postition", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ChipLag/rb/main/universal/sticky.lua",true))() 
    end) 
    uUniversal:NewButton("Security Cameras", "Script for Security Cameras to spy on people", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ChipLag/rb/main/universal/securitycam.lua",true))()
        end)

        local uUseful = universal:NewSection("USEFUL UNIVERSAL SCRIPTS NOT BY ME")
        uUseful:NewButton("Nameless Admin", "Nameless Admin", function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source"))() 
            end) 
            uUseful:NewButton("Infinite Yield", "An Absolute Classic! ", function()
                loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
                end)