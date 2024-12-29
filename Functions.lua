-- Main Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Remote Services
local ReplicatedModules = ReplicatedStorage:WaitForChild("ReplicatedModules")
local KnitServices = ReplicatedModules.KnitPackage.Knit:WaitforChild("Services")
local ShopService = KnitServices:WaitForChild("ShopService")
local LevelService = KnitServices:WaitForChild("LevelService")
local CraftingService = KnitServices:WaitForChild("CraftingService")

-- Remote Functions
local AscendAbility = LevelService.RF:WaitForChild("AscendAbility")
local RollBanner = ShopService.RF:WaitForChild("RollBanner")
local GetAllAbilityShards = CraftingService.RF:WaitForChild("GetAllAbilityShards")
local ConsumeShardsForXP = LevelService.RF:WaitForChild("ConsumeShardsForXP")
local BuySkinCrate = ShopService.RF:WaitForChild("BuySkinCrate")

-- Script starts here :3
local LP = Players.LocalPlayer
local MainLoop = true 
local Banner,Skins,EXP 

local function RollBanner(State) 
  if State == 1 then 
    Banner = true 
  else Banner = false 
  end 
end 

local function BuySkins(State) 
  if State == 1 then 
    Skins = true 
  else Skins = false 
  end 
end 

local function DeleteSkins(State) 
  print("Function in maintenance") 
end 

local function EXPFarm(State) 
  if State == 1 then 
    EXP = true 
  else 
    EXP = false 
  end 
  
  if EXP then 
    spawn(function() 
        while EXP do 
          local AbilityNow = LP.Data.Ability.Value 
          AscendAbility:InvokeServer(AbilityNow) 
          task.wait(0.1) 
        end 
      end) 
  end 
  
  if EXP then 
    spawn(function() 
        while EXP do 
          local args = { [1] = 1, [2] = "UShards", [3] = 10 } 
          RollBanner:InvokeServer(unpack(args)) 
          task.wait(0.1) 
        end 
      end) 
  end 
  
  if EXP then 
    spawn(function() 
        while EXP do 
          local shards = GetAllAbilityShards:InvokeServer() 
          for abilityName, abilityData in pairs(shards) do 
            if not EXP then return end 
            if type(abilityData) == "table" and abilityData.Shards and abilityData.Shards > 0 then 
              local rarity = abilityData.Rarity 
              local amountToUse = 1 
              if rarity == "Common" 
                then amountToUse = 200 
              elseif rarity == "Uncommon" then 
                amountToUse = 100 
              elseif rarity == "Rare" then 
                amountToUse = 40 
              elseif rarity == "Epic" then 
                amountToUse = 20 
              elseif rarity == "Legendary" then 
                amountToUse = 7 
              elseif rarity == "Mythic"
                then amountToUse = 3 
              end 
              
              while abilityData.Shards > 0 do 
                if not EXP then return end 
                local shardsToUse = math.min(amountToUse, abilityData.Shards) 
                local args = { [1] = { [abilityName] = shardsToUse } } 
                ConsumeShardsForXP:InvokeServer(unpack(args)) 
                task.wait(0.25) 
                shards = GetAllAbilityShards:InvokeServer() 
                abilityData = shards[abilityName] 
              end 
            end 
          end 
        end 
      end) 
  end 
end 

MainLoop = game:GetService("RunService").Heartbeat:Connect(function() 
    if Banner then 
      RollBanner:InvokeServer(1,"UShards",10) 
    end 
    if Skins then 
      BuySkinCrate:InvokeServer("Skin_Crate","UShards",10) 
    end 
  end) 

return { ["BuySkins"] = BuySkins, ["RollBanner"] = RollBanner, ["DeleteSkins"] = DeleteSkins, ["EXPFarm"] = EXPFarm }
