-- this is just a backup incase it gets deleted :P

repeat task.wait() until game:IsLoaded() 

local Farm = loadstring(game:HttpGet('https://raw.githubusercontent.com/dedegahatesyou/AUT/refs/heads/main/Farm.lua'))() 
local AUTFunctions = loadstring(game:HttpGet('https://raw.githubusercontent.com/dedegahatesyou/AUT/refs/heads/main/Functions.lua'))() 
local GUI = loadstring(game:HttpGet('https://raw.githubusercontent.com/dedegahatesyou/AUT/refs/heads/main/GUI.lua'))() 

local function Main(State) 
  if State == 1 then 
    Farm.On() 
  else 
    Farm.Off() 
  end 
end 

local function Render(State) 
  if State == 1 then 
    game:GetService("RunService"):Set3dRenderingEnabled(true) 
  else game:GetService("RunService"):Set3dRenderingEnabled(false) 
  end 
end 

local function SetAutoBearer(State) 
  if State == 1 then 
    getgenv().NoBearer = 0 
    print("No longer taking Finger Bearer quests") 
  else 
    getgenv().NoBearer = 1 
    print("Automatically taking Finger Bearer quests") 
  end 
end 

local function SetAutoAscend(State) 
  if State == 1 then 
    getgenv().AutoAscend = true 
    print("Automatically Ascending and picking traits") 
  else 
    getgenv().AutoAscend = false 
    print("No longer automatically ascending") 
  end 
end 

local MainUI = GUI.InitUI() 
local Settings = GUI.NewPage("http://www.roblox.com/asset/?id=134836909415217","Settings") 

GUI.NewToggle(Settings,"No Render",Render) 
GUI.NewToggle(Settings,"Auto Bearer",SetAutoBearer) 
GUI.NewToggle(Settings,"Auto Ascend",SetAutoAscend) 

local Functions = GUI.NewPage("http://www.roblox.com/asset/?id=103303771414812","Functions") 

GUI.NewToggle(Functions,"Buy Skins",AUTFunctions.BuySkins) 
GUI.NewToggle(Functions,"Delete Skins",AUTFunctions.DeleteSkins) 
GUI.NewToggle(Functions,"Roll Banner",AUTFunctions.RollBanner) 
GUI.NewToggle(Functions,"EXP Farm",AUTFunctions.EXPFarm) 
GUI.SetMain(Main)
