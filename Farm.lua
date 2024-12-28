-- Configs -- 
if not getgenv().Webhook then 
  getgenv().Webhook = "N/A" 
end 

if not getgenv().NoBearer then 
  getgenv().NoBearer = false 
end 

if not getgenv().AutoAscend then 
  getgenv().AutoAscend = false 
end 

if not getgenv().ItemWishlist then 
  getgenv().ItemWishlist = {"Sukuna's Finger"} 
end 

if not getgenv().TraitWishlist then 
  getgenv().TraitWishlist = {"Godly"} 
end 

local LocalPlayer = game:GetService("Players").LocalPlayer 
local CG = game:GetService("CoreGui") 
local UIS = game:GetService("UserInputService") 
local WS = game:GetService("Workspace") 
local RS = game:GetService("ReplicatedStorage") 
local VIM = game:GetService("VirtualInputManager") 
local RemoteServices = RS:WaitForChild("ReplicatedModules"):WaitForChild("KnitPackage"):WaitForChild("Knit"):WaitForChild("Services") 
local CurseLocation = CFrame.new(Vector3.new(1966, 940, -1547)) 

local Target = CurseLocation 
local Curses = {"Jujutsu Sorcerer", "Flyhead", "Roppongi Curse", "Mantis Curse"} 
local Chests = {"Common", "Rare", "Epic", "Legendary"} 

for i, v in ipairs(CG:GetChildren()) do 
  if v.Name == "Stingray" then 
    v:Destroy() 
  end 
end 

if getgenv().Loop then 
  Loop:Disconnect() 
end 

local function Press(K) 
  VIM:SendKeyEvent(true, Enum.KeyCode[K], false, nil) 
  task.wait() 
  VIM:SendKeyEvent(false, Enum.KeyCode[K], false, nil) 
end 

local Switch = false 

local function StoreItem()
  RemoteServices:WaitForChild("InventoryService"):WaitForChild("RE"):WaitForChild("ItemInventory"):FireServer({ ["AddItems"] = true }) 
end 

local function GetQuest() 
  RemoteServices:WaitForChild("DialogueService"):WaitForChild("RF"):WaitForChild("CheckDialogue"):InvokeServer( "Slayer_Quest", "Finger Bearer") 
end 

local function AddStats() 
  local args = { [1] = LocalPlayer.Data.Ability.Value, [2] = { ["Defense"] = 0, ["Special"] = 0, ["Health"] = 0, ["Attack"] = 10 } } 
  RemoteServices:WaitForChild("StatService"):WaitForChild("RF"):WaitForChild("ApplyStats"):InvokeServer(unpack(args)) 
end 

local function SendWebhook(Message) 
  pcall(function() 
      local embed = { ["title"] = "Stingray Notification", ['description'] = Message, ["color"] = tonumber(000000) } 
      local a = request(
        { 
          Url = getgenv().Webhook, Headers = { ['Content-Type'] = 'application/json' }, 
          Body = game:GetService("HttpService"):JSONEncode({ ['embeds'] = {embed}, 
          ['avatar_url'] = "https://cdn.discordapp.com/attachments/1089257712900120576/1105570269055160422/archivector200300015.png" }), 
          Method = "POST" 
        }) 
    end) 
end 

local function SellItems() 
  local ItemTable = {} 
  for i, v in ipairs(LocalPlayer.Backpack:GetChildren()) do 
    if v:IsA("Tool") and not table.find(ItemWishlist, v.Name) then 
      local Attributes = v:GetAttributes() ItemTable[i] = {Attributes["ItemId"], Attributes["UUID"], 1} 
    end 
  end 
  
  RemoteServices:WaitForChild("ShopService"):WaitForChild("RE"):WaitForChild("Signal"):FireServer( "BlackMarketBulkSellItems", ItemTable) 
end 

local function FireInput(i) 
  RemoteServices:WaitForChild("MoveInputService"):WaitForChild("RF"):WaitForChild("FireInput"):InvokeServer(i) 
end 

local function CheckItems() 
  local Backpack = LocalPlayer.Backpack 
  local CombatTag = LocalPlayer.PlayerGui.UI.Gameplay.Character.Info.CombatTag 
  local Found = false 
  
  for i, v in ipairs(Backpack:GetChildren()) do 
    if table.find(ItemWishlist, v.Name) then 
      v.Parent = LocalPlayer.Character SendWebhook("[" .. LocalPlayer.Name .. "] got a " .. v.Name) 
      Found = true 
      Target = CurseLocation + Vector3.new(300, 300, 0) 
    end 
  end 
  
  if Found then 
    repeat task.wait(1) until not CombatTag.Visible StoreItem() 
  end 
end 

local function MainFarm() 
  local Counter = 1 
  local Living = WS:WaitForChild("Living") 
  
  while Switch do task.wait() 
    pcall(function() 
        LocalPLayer.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0,0,0) 
      end) 
    
    if Counter % 200 == 0 then 
      task.spawn(function() pcall(CheckItems) 
          if Counter % 4000 == 0 then 
            SellItems() Counter = 0 
          end 
          AddStats() 
          if not LocalPlayer.QuestLines:FindFirstChild("Slayer Quest") then 
            GetQuest() 
          end 
          if AutoAscend then 
            RemoteServices:WaitForChild("LevelService"):WaitForChild("RF"):WaitForChild("AscendAbility"):InvokeServer(LocalPlayer.Data.Ability.Value) 
          end 
        end) 
    end 
    Counter = Counter + 1 
    pcall(function() 
        if Living:FindFirstChild("The Bearer") and (getgenv().NoBearer ~= "0") then 
          local Bearer = Living:FindFirstChild("The Bearer") 
          Bearer:WaitForChild("HumanoidRootPart") 
          Target = CFrame.new(Bearer.HumanoidRootPart.Position + Vector3.new(0, 3, 0), Bearer.HumanoidRootPart.Position) 
        else 
          local CursesSpawned = false 
          for i, v in ipairs(Living:GetChildren()) do 
            if v:IsA("Model") then 
              if table.find(Curses, v.Name) and v:FindFirstChild("HumanoidRootPart") then 
                CursesSpawned = true 
                local RootPart = v.HumanoidRootPart.CFrame Target = CFrame.new(RootPart.Position + Vector3.new(0, 3, 0) + RootPart.LookVector * -3, RootPart.Position) 
              end 
            end 
          end 
          if not CursesSpawned then 
            Target = CurseLocation 
          end 
        end 
      end) 
    for i, v in ipairs(WS:GetChildren()) do 
      if v:IsA("Model") then 
        if table.find(Chests, v.Name) then 
          pcall(function() 
              task.wait() Target = v.PrimaryPart.CFrame task.wait(0.2) 
              local Prox = v:FindFirstChild("RootPart"):FindFirstChild("Interaction", true) 
              local ProxFire = fireproximityprompt(Prox) 
              if not ProxFire then 
                task.wait() Press("E") task.wait() 
              end task.wait(0.3) v.Name = "Claimed-Chest" 
            end) 
        end 
      end 
    end 
  end 
end 

local IndexCount = 0 
getgenv().Loop = game:GetService("RunService").Heartbeat:Connect(function() 
    if Switch then 
      IndexCount = IndexCount + 1 
      if LocalPlayer.Character.Head:FindFirstChild("RagdollBallSocket") then 
        LocalPlayer.Character.HumanoidRootPart.CFrame = Target + Vector3.new(0, 80, 0) FireInput("Q") 
      elseif LocalPlayer.Cooldowns:FindFirstChild("Rush Attack") then 
        LocalPlayer.Character.HumanoidRootPart.CFrame = Target + Vector3.new(0, 80, 0) 
      else 
        LocalPlayer.Character.HumanoidRootPart.CFrame = Target 
      end 
      if IndexCount%10 == 0 then 
        FireInput("MouseButton1") 
      end 
    end 
  end) 

if AutoAscend then 
  local TraitRemote = game:GetService("ReplicatedStorage").ReplicatedModules.KnitPackage.Knit.Services.TraitService.RE .TraitHand 
  if TraitListener then 
    TraitListener:Disconnect() 
  end 
  
  getgenv().TraitListener = TraitRemote.OnClientEvent:Connect(function(...) 
      local Good = false 
      for i, v in pairs(...) do 
        if table.find(TraitWishlist, v["Trait"]) then 
          Good = true 
          task.wait(0.2) RemoteServices:WaitForChild("TraitService"):WaitForChild("RF"):WaitForChild("PickTrait"):InvokeServer( tonumber(i)) 
          pcall(function() 
              SendWebhook("[" .. LocalPlayer.Name .. "]: " .. v["Trait"]) 
            end) 
          break
        end 
      end 
      
      if not Good then 
        RemoteServices:WaitForChild("TraitService"):WaitForChild("RF"):WaitForChild("DiscardTraits"):InvokeServer() 
      end 
    end) 
  
  RemoteServices:WaitForChild("TraitService"):WaitForChild("RF"):WaitForChild("DiscardTraits"):InvokeServer() 
end 

local function On() 
  Switch = true 
  LocalPlayer.PlayerGui:WaitForChild("UI").Enabled = false 
  task.spawn(MainFarm) 
end 

local function Off() 
  LocalPlayer.PlayerGui:WaitForChild("UI").Enabled = true 
  Switch = false 
end 
return { ["On"] = On, ["Off"] = Off}
