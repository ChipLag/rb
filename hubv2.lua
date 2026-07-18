-- THIS DOES NOT WORK YET!!!!
--loadstring(game:HttpGet("https://raw.githubusercontent.com/ChipLag/rb/main/hubv2.lua",true))() 
print("Loading...")
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deeeity/mercury-lib/master/src.lua"))()

local gui = Library:create{
    Theme = Library.Themes.Serika
}

local tabUniversal = gui:tab{
    Name = "Universal"
}

tabUniversal:button({
    Name = "Nameless Admin",
    Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source"))() 
    end,
})

