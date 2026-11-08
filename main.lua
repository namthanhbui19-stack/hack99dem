-- [[ 99 NIGHTS IN THE FOREST - ULTIMATE GOD HUB V6 ]]
-- Integrated all custom features requested: Auto collect, God mode, Infinite hunger, 1 Sapling glitch, Auto chop glitch tree, Anti-traps, Anti-freeze, Auto stunt boss, Auto revive, and Day multiplier booster.

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- [[ GLOBAL STATUS VARIABLES ]]
_G.GodMode = false
_G.InfiniteHunger = false
_G.AutoCollect = false
_G.OneSaplingGlitch = false
_G.AutoChopGlitchTree = false
_G.AntiTraps = false
_G.AntiFreeze = false
_G.AutoStuntBoss = false
_G.AutoRevive = false
_G.DayBooster = false

local TargetItems = {"Wood", "Scrap", "Stone", "Coal", "Morsel", "Cooked Morsel", "Steak", "Cooked Steak", "Ribs", "Cooked Ribs", "Stew", "Cake"}

-- [[ MAIN GUI SETUP ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateGodHubV6"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 520)
MainFrame.Position = UDim2.new(0.15, 0, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Title.Text = "99 NIGHTS ULTIMATE HUB V6"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.Parent = MainFrame

-- Scroll Frame to handle multiple buttons seamlessly
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 1, -45)
ScrollFrame.Position = UDim2.new(0, 0, 0, 45)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.Parent = MainFrame

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 80, 0, 30)
ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleBtn.Text = "Ẩn/Hiện"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Parent = ScreenGui
ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

local btnCount = 0
local function AddToggle(text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 260, 0, 38)
    Btn.Position = UDim2.new(0, 20, 0, 15 + (btnCount * 44))
    Btn.BackgroundColor3 = Color3.fromRGB(45, 50, 55)
    Btn.Text = text .. ": TẮT"
    Btn.TextColor3 = Color3.fromRGB(255, 100, 100)
    Btn.Font = Enum.Font.SourceSansSemibold
    Btn.TextSize = 13
    Btn.Parent = ScrollFrame
    
    local state = false
    Btn.MouseButton1Click:Connect(function()
        state = not state
        Btn.BackgroundColor3 = state and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(45, 50, 55)
        Btn.Text = text .. (state and ": BẬT" or ": TẮT")
        Btn.TextColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 100, 100)
        callback(state)
    end)
    btnCount = btnCount + 1
end

-- [[ INTEGRATED SCRIPT LOGIC ]]

-- 1. Bug 1 Mầm Cây Ra Vô Hạn Cây (1 Sapling Glitch)
AddToggle("Bug 1 Mầm Ra Vô Hạn Cây", function(state)
    _G.OneSaplingGlitch = state
    task.spawn(function()
        while _G.OneSaplingGlitch do
            pcall(function()
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local HasSapling = LocalPlayer.Backpack:FindFirstChild("Sapling") or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Sapling"))
                if hrp and HasSapling then
                    local spawnPos = hrp.CFrame - Vector3.new(0, 2, 0)
                    for i = 1, 5 do 
                        ReplicatedStorage.Events.PlantSapling:FireServer(spawnPos) 
                    end
                end
            end)
            task.wait(0.001)
        end
    end)
end)

-- 2. Tự Động Chặt Cây Glitch Tại Chỗ (Auto Chop Glitch Tree)
AddToggle("Auto Chặt Cây Tại Chỗ", function(state)
    _G.AutoChopGlitchTree = state
    task.spawn(function()
        while _G.AutoChopGlitchTree do
            pcall(function()
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    for _, obj in ipairs(workspace:GetChildren()) do
                        if (obj.Name:lower():find("tree") or obj.Name:lower():find("log")) and obj:IsA("BasePart") then
                            if (obj.Position - hrp.Position).Magnitude < 20 then
                                ReplicatedStorage.Events.ChopTree:FireServer(obj)
                            end
                        end
                    end
                end
            end)
            task.wait(0.05)
        end
    end)
end)

-- 3. Hút Vật Phẩm Gần Bên (Auto Collect Items)
AddToggle("Hút Vật Phẩm (Thịt/Gỗ)", function(state)
    _G.AutoCollect = state
    task.spawn(function()
        while _G.AutoCollect do
            pcall(function()
                for _, obj in ipairs(workspace:GetChildren()) do
                    if table.find(TargetItems, obj.Name) and obj:IsA("BasePart") then
                        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then obj.CFrame = hrp.CFrame end
                    end
                end
            end)
            task.wait(0.4)
        end
    end)
end)

-- 4. Bất Tử Khóa Máu (God Mode)
AddToggle("Bất Tử (God Mode)", function(state)
    _G.GodMode = state
    task.spawn(function()
        while _G.GodMode do
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then 
                    char.Humanoid.Health = char.Humanoid.MaxHealth 
                end
            end)
            task.wait(0.1)
        end
    end)
end)

-- 5. Khóa Thanh Đói 100% (Infinite Hunger)
AddToggle("Khóa Thanh Đói 100%", function(state)
    _G.InfiniteHunger = state
    task.spawn(function()
        while _G.InfiniteHunger do
            pcall(function()
                local stats = LocalPlayer:FindFirstChild("leaderstats") or LocalPlayer:FindFirstChild("Data")
                if stats and stats:FindFirstChild("Hunger") then 
                    stats.Hunger.Value = 100 
                end
            end)
            task.wait(1)
        end
    end)
end)

-- 6. Chặn Bẫy Sập & Hố (Anti-Traps)
AddToggle("Chặn Bẫy Sập (Anti-Traps)", function(state)
    _G.AntiTraps = state
    task.spawn(function()
        while _G.AntiTraps do
            pcall(function()
                for _, v in ipairs(workspace:GetDescendants()) do
                    if v.Name:lower():find("trap") or v.Name:lower():find("snare") then
                        if v:IsA("BasePart") then v.CanTouch = false end
                    end
                end
            end)
            task.wait(1)
        end
    end)
end)

-- 7. Kháng Lạnh Vùng Tuyết (Anti-Freeze)
AddToggle("Kháng Đóng Băng", function(state)
    _G.AntiFreeze = state
    task.spawn(function()
        while _G.AntiFreeze do
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("Temperature") then
                    char.Temperature.Value = 100
                elseif LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Temperature") then
                    LocalPlayer.Data.Temperature.Value = 100
                end
            end)
            task.wait(0.5)
        end
    end)
end)

-- 8. Tự Động Làm Choáng Quái Vật (Auto Stunt Boss)
AddToggle("Auto Choáng Quái & Boss", function(state)
    _G.AutoStuntBoss = state
    task.spawn(function()
        while _G.AutoStuntBoss do
            pcall(function()
                for _, obj in ipairs(workspace:GetChildren()) do
                    if obj:FindFirstChild("Humanoid") and obj.Name ~= LocalPlayer.Name then
                        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        local eHrp = obj:FindFirstChild("HumanoidRootPart")
                        if hrp and eHrp and (eHrp.Position - hrp.Position).Magnitude < 35 then
                            ReplicatedStorage.Events.StunEntity:FireServer(obj)
                        end
                    end
                end
            end)
            task.wait(0.3)
        end
    end)
end)

-- 9. Tự Động Hồi Sinh Đồng Đội (Auto Revive)
AddToggle("Auto Hồi Sinh Đồng Đội", function(state)
    _G.AutoRevive = state
    task.spawn(function()
        while _G.AutoRevive do
            pcall(function()
                for _, p in ipairs(game.Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("BleedingOut") then
                        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local oldCFrame = hrp.CFrame
                            hrp.CFrame = p.Character.HumanoidRootPart.CFrame
                            ReplicatedStorage.Events.RevivePlayer:FireServer(p)
                            task.wait(0.5)
                            hrp.CFrame = oldCFrame
                        end
                    end
                end
            end)
            task.wait(1)
        end
    end)
end)

-- 10. Hack Tăng Tốc Nhân Số Ngày (Day Multiplier Booster via Bed Logic)
AddToggle("Hack Nhân Số Ngày", function(state)
    _G.DayBooster = state
    task.spawn(function()
        while _G.DayBooster do
            pcall(function()
                local stats = LocalPlayer:FindFirstChild("leaderstats") or LocalPlayer:FindFirstChild("Data")
                if stats and stats:FindFirstChild("Days") then
                    ReplicatedStorage.Events.AddDayMultiplier:FireServer()
                end
            end)
            task.wait(1)
        end
    end)
end)

print("Ultimate V6 Script Loaded Successfully!")
