_G.TeleportConfig = {
    ["Mầm cây (Saplings)"] = false,
    ["Vũ khí (Rìu, Súng, Kiếm)"] = false,
    ["Trang bị (Giáp, Mũ)"] = false,
    ["Dầu / Xăng / Biofuel"] = false,
    ["Than / Than đá"] = false,
    ["Gỗ / Củi nhóm lửa"] = false,
    ["Băng gạc / Y tế"] = false,
    ["Kim cương / Ngọc"] = false,
    ["Sắt / Quặng sắt"] = false,
    ["Đá / Kháng sản khác"] = false,
    ["Thức ăn / Nước uống"] = false,
    ["Rương báu / Hộp đồ"] = false,
    ["Tất cả đồ rơi (Loot)"] = false
}
_G.AutoChop = false 
_G.AutoOpenChest = false 
_G.FlyActive = false          
_G.FullBrightActive = false   
_G.InfStamina = false         

local BAN_KINH_CHAT = 400
local FlySpeed = 50

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

local function checkItemType(objectName)
    local name = string.lower(objectName)
    if _G.TeleportConfig["Mầm cây (Saplings)"] and (name == "sapling" or name == "seed" or string.find(name, "seed") or string.find(name, "sapling")) then return true end
    if _G.TeleportConfig["Vũ khí (Rìu, Súng, Kiếm)"] and (name == "axe" or name == "shotgun" or name == "rifle" or name == "pistol" or name == "gun" or name == "sword" or name == "chainsaw" or name == "weapon") then return true end
    if _G.TeleportConfig["Trang bị (Giáp, Mũ)"] and (name == "armor" or name == "helmet" or name == "vest" or string.find(name, "armor") or string.find(name, "vest")) then return true end
    if _G.TeleportConfig["Dầu / Xăng / Biofuel"] and (name == "oil" or name == "gas" or name == "biofuel" or name == "fuel" or name == "gasoline" or string.find(name, "fuel")) then return true end
    if _G.TeleportConfig["Than / Than đá"] and (name == "coal" or name == "coalore" or name == "carbon") then return true end
    if _G.TeleportConfig["Gỗ / Củi nhóm lửa"] and (name == "log" or name == "wood" or name == "woodlog" or name == "firewood") then return true end
    if _G.TeleportConfig["Băng gạc / Y tế"] and (name == "bandage" or name == "medkit" or name == "gauze" or name == "heal" or name == "splint") then return true end
    if _G.TeleportConfig["Kim cương / Ngọc"] and (name == "diamond" or name == "gem" or name == "crystal" or name == "ruby") then return true end
    if _G.TeleportConfig["Sắt / Quặng sắt"] and (name == "iron" or name == "ironore" or name == "scrap" or name == "metal") then return true end
    if _G.TeleportConfig["Đá / Kháng sản khác"] and (name == "stone" or name == "rock" or name == "stoneore" or name == "copper") then return true end
    if _G.TeleportConfig["Thức ăn / Nước uống"] and (name == "food" or name == "meat" or name == "apple" or name == "berry" or name == "water") then return true end
    if _G.TeleportConfig["Rương báu / Hộp đồ"] and (name == "chest" or name == "box" or name == "crate" or string.find(name, "chest") or string.find(name, "crate")) then return true end
    if _G.TeleportConfig["Tất cả đồ rơi (Loot)"] and (name == "item" or name == "pickup" or name == "loot") then return true end
    return false
end

local function bringAndInteractItems()
    if not localPlayer.Character or not localPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local myRoot = localPlayer.Character.HumanoidRootPart
    local targetCFrame = myRoot.CFrame + Vector3.new(0, 1, 0)
    
    for _, object in pairs(Workspace:GetDescendants()) do
        if object:IsA("BasePart") and checkItemType(object.Name) then
            object.CFrame = targetCFrame
            object.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            object.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            
            local prompt = object:FindFirstChildOfClass("ProximityPrompt") or object.Parent:FindFirstChildOfClass("ProximityPrompt")
            if prompt then
                if string.find(string.lower(object.Name), "chest") or string.find(string.lower(object.Name), "crate") then
                    if _G.AutoOpenChest then fireproximityprompt(prompt) end
                else
                    fireproximityprompt(prompt)
                end
            end
        end
    end
end

local function autoChopTrees()
    if not localPlayer.Character or not localPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local myRoot = localPlayer.Character.HumanoidRootPart
    
    for _, object in pairs(Workspace:GetDescendants()) do
        if object:IsA("BasePart") and (object.Name == "Trunk" or object.Name == "Tree" or object.Name == "BreakableTree") then
            local distance = (myRoot.Position - object.Position).Magnitude
            if distance <= BAN_KINH_CHAT then
                local tool = localPlayer.Character:FindFirstChildOfClass("Tool")
                if tool and tool:FindFirstChild("Handle") then
                    firetouchinterest(object, tool.Handle, 0)
                    task.wait(0.01)
                    firetouchinterest(object, tool.Handle, 1)
                end
                local prompt = object:FindFirstChildOfClass("ProximityPrompt") or object.Parent:FindFirstChildOfClass("ProximityPrompt")
                if prompt then fireproximityprompt(prompt) end
            end
        end
    end
end

task.spawn(function()
    while true do
        if _G.InfStamina and localPlayer.Character then
            local stamina = localPlayer.Character:FindFirstChild("Stamina") or localPlayer:FindFirstChild("Stamina")
            if stamina and (stamina:IsA("NumberValue") or stamina:IsA("IntValue")) then
                stamina.Value = 100
            end
        end
        task.wait(0.5)
    end
end)

RunService.RenderStepped:Connect(function()
    if _G.FlyActive and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local root = localPlayer.Character.HumanoidRootPart
        local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.PlatformStand = true end
        
        local moveDirection = humanoid and humanoid.MoveDirection or Vector3.new(0,0,0)
        root.Velocity = moveDirection * FlySpeed
        
        if moveDirection.Magnitude == 0 then
            root.Velocity = Vector3.new(0, 0.1, 0)
        end
    else
        if localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid") then
            localPlayer.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false
        end
    end
end)

task.spawn(function()
    while true do
        if _G.FullBrightActive then
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            Lighting.Brightness = 2
        end
        task.wait(1)
    end
end)

task.spawn(function() while true do bringAndInteractItems() task.wait(1.0) end end)
task.spawn(function() while true do if _G.AutoChop then autoChopTrees() end task.wait(0.8) end end)

if CoreGui:FindFirstChild("PremiumIntegratedMenuV5") then CoreGui.PremiumIntegratedMenuV5:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PremiumIntegratedMenuV5"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 270, 0, 450)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.BorderSizePixel = 2
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Text = "99 NIGHTS GOD MODE V5"
Title.TextColor3 = Color3.fromRGB(0, 255, 0)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 15
Title.Parent = MainFrame

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, 0, 1, -40)
ScrollingFrame.Position = UDim2.new(0, 0, 0, 40)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 750)
ScrollingFrame.ScrollBarThickness = 6
ScrollingFrame.Parent = MainFrame

local function createSpecialButton(text, pos, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 230, 0, 35)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 100, 100)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 13
    btn.Parent = ScrollingFrame
    btn.MouseButton1Click:Connect(function()
        local active = callback()
        btn.Text = text .. (active and ": ON" or ": OFF")
        btn.BackgroundColor3 = active and color or Color3.fromRGB(40, 40, 40)
        btn.TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 100, 100)
    end)
end

createSpecialButton("🪓 AUTO CHẶT CÂY 400M", UDim2.new(0, 15, 0, 15), Color3.fromRGB(160, 90, 0), function() _G.AutoChop = not _G.AutoChop return _G.AutoChop end)
createSpecialButton("🔓 TỰ ĐỘNG MỞ RƯƠNG", UDim2.new(0, 15, 0, 55), Color3.fromRGB(130, 0, 130), function() _G.AutoOpenChest = not _G.AutoOpenChest return _G.AutoOpenChest end)
createSpecialButton("⚡ VÔ HẠN THỂ LỰC (STAMINA)", UDim2.new(0, 15, 0, 95), Color3.fromRGB(180, 140, 0), function() _G.InfStamina = not _G.InfStamina return _G.InfStamina end)
createSpecialButton("🦅 BẬT BAY (FLY)", UDim2.new(0, 15, 0, 135), Color3.fromRGB(0, 100, 200), function() _G.FlyActive = not _G.FlyActive return _G.FlyActive end)
createSpecialButton("🌙 BẬT SÁNG ĐÊM (FULLBRIGHT)", UDim2.new(0, 15, 0, 175), Color3.fromRGB(0, 150, 120), function() _G.FullBrightActive = not _G.FullBrightActive return _G.FullBrightActive end)

local function buildLootButtons()
    local currentY = 220
    for itemName, _ in pairs(_G.TeleportConfig) do
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(0, 230, 0, 32)
        Button.Position = UDim2.new(0, 15, 0, currentY)
        Button.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
        Button.Text = "🎯 Hút " .. itemName .. ": OFF"
        Button.TextColor3 = Color3.fromRGB(200, 200, 200)
        Button.Font = Enum.Font.SourceSans
        Button.TextSize = 13
        Button.Parent = ScrollingFrame

        Button.MouseButton1Click:Connect(function()
            _G.TeleportConfig[itemName] = not _G.TeleportConfig[itemName]
            Button.Text = _G.TeleportConfig[itemName] and "🎯 Hút " .. itemName .. ": ON" or "🎯 Hút " .. itemName .. ": OFF"
            Button.BackgroundColor3 = _G.TeleportConfig[itemName] and Color3.fromRGB(35, 110, 35) or Color3.fromRGB(48, 48, 48)
            Button.TextColor3 = _G.TeleportConfig[itemName] and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
        end)
        currentY = currentY + 38
    end
end
buildLootButtons()
