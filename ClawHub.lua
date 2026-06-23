--[[
    CLAW HUB ULTIMATE - DEATH BALL FULL
    Dengan Sistem Deteksi User
    Fitur:
    - Deteksi dan tampilkan user
    - Validasi izin
    - Leaderboard Booster
    - Auto Parry, Spam, Curve
    - Stat Booster & Quest Claim
]]

-- // ========== DETEKSI USER ==========
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerName = player.Name
local playerId = player.UserId
local playerDisplayName = player.DisplayName

-- // ========== TAMPILAN USER ==========
print("========================================")
print("🔥 CLAW HUB ULTIMATE - USER DETECTION")
print("========================================")
print("👤 Username: " .. playerName)
print("🆔 User ID: " .. playerId)
print("📛 Display Name: " .. playerDisplayName)
print("🖥️ Platform: " .. (player:IsInGroup(1) and "PC" or "Mobile"))
print("========================================")

-- // ========== NOTIFIKASI USER ==========
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🔥 CLAW HUB",
    Text = "Welcome " .. playerName .. "! Script loaded.",
    Duration = 3
})

-- // ========== VALIDASI IZIN ==========
local allowedUsers = {
    -- ["Username"] = true,
    -- Tambahkan username yang diizinkan di sini
    [playerName] = true, -- Allow current user
}

if not allowedUsers[playerName] then
    print("❌ User not authorized!")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "❌ Access Denied",
        Text = "You are not authorized to use this script.",
        Duration = 5
    })
    return
end

print("✅ User authorized: " .. playerName)

-- // ========== SERVICE ==========
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- // ========== REMOTE DETECTION ==========
local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
local Values = ReplicatedStorage:FindFirstChild("Values")
local Actions = ReplicatedStorage:FindFirstChild("Actions")

local LeaderboardChanged = Remotes and Remotes:FindFirstChild("LeaderboardChanged")
local InventoryChanged = Remotes and Remotes:FindFirstChild("InventoryChanged")
local AbilityRemote = Remotes and Remotes:FindFirstChild("AbilityRemote")
local SetValue = Values and Values:FindFirstChild("Set")
local ActionRemote = Actions and Actions:FindFirstChild("Action")

-- Cari RemoteEvent (parented ke nil)
local MainRemote = nil
for _, obj in ipairs(Workspace:GetDescendants()) do
    if obj:IsA("RemoteEvent") and obj.Name == "RemoteEvent" then
        MainRemote = obj
        break
    end
end
if not MainRemote then
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") and obj.Name == "RemoteEvent" then
            MainRemote = obj
            break
        end
    end
end

print("[CLAW] Remote ditemukan untuk user: " .. playerName)
print("  LeaderboardChanged:", LeaderboardChanged and "✅" or "❌")
print("  InventoryChanged:", InventoryChanged and "✅" or "❌")
print("  AbilityRemote:", AbilityRemote and "✅" or "❌")
print("  SetValue:", SetValue and "✅" or "❌")
print("  ActionRemote:", ActionRemote and "✅" or "❌")
print("  MainRemote:", MainRemote and "✅" or "❌")

-- // ========== FITUR ==========
local features = {
    parry = false,
    spam = false,
    curve = false,
    claim = false,
    boost = false,
    leaderboard = false,
    ability = false,
    shop = false
}

-- // ========== FUNGSI-FUNGSI ==========

-- 1. LEADERBOARD BOOSTER
local function doLeaderboard()
    if not features.leaderboard or not LeaderboardChanged then return end
    
    local leaderboardData = {
        {key = "GemtokiWins_10", value = 100000},
        {key = "TorokaiWins_10", value = 100000},
        {key = "FoxuroWins_10", value = 100000},
        {key = "GazoWins_10", value = 100000},
        {key = "WuWins_10", value = 100000},
        {key = "KeiloWins_10", value = 100000},
        {key = "GloomWins_10", value = 100000},
        {key = "KamekiWins_10", value = 100000},
        {key = "SaitoWins_10", value = 100000},
        {key = "JJWins_10", value = 100000},
        {key = "FrieraWins_10", value = 100000},
        {key = "DenjinWins_10", value = 100000},
    }
    
    for _, data in ipairs(leaderboardData) do
        LeaderboardChanged:FireServer(data.key, "AllTime", {}, data.value)
    end
    LeaderboardChanged:FireServer("Wins", "Weekly", {}, 12615)
end

-- 2. STAT BOOSTER (InventoryChanged)
local function doBoost()
    if not features.boost or not InventoryChanged then return end
    
    local stats = {
        ["Statistics.PlayerXP:Total"] = 999999,
        ["Statistics.Damage:Total"] = 999999,
        ["Statistics.Wins:Total"] = 9999,
        ["Items.Gems"] = 999999,
        ["Statistics.Kills:Total"] = 9999,
        ["Statistics.Deaths:Total"] = 0,
        ["Statistics.Matches:Total"] = 9999,
        ["Statistics.Playtime:Total"] = 99999,
        ["Statistics.Deflects:Total"] = 9999,
    }
    
    InventoryChanged:FireServer({}, stats)
end

-- 3. AUTO CLAIM QUEST (InventoryChanged)
local function doClaim()
    if not features.claim or not InventoryChanged then return end
    
    local questData = {
        ["LiveOpsEvents.WheelSpinSpecial10.Quests"] = {
            ["Summon_1"] = {Current = 8, Required = 8, Claimed = false},
            ["Matches2_1"] = {Current = 30, Required = 30, Claimed = false},
            ["Wins_1"] = {Current = 12, Required = 12, Claimed = false},
            ["Matches_1"] = {Current = 2, Required = 2, Claimed = false},
            ["Playtime_1"] = {Current = 13500, Required = 13500, Claimed = false},
            ["Dash_1"] = {Current = 135, Required = 135, Claimed = false},
            ["Deflects_1"] = {Current = 600, Required = 600, Claimed = false},
            ["Kills_1"] = {Current = 45, Required = 45, Claimed = false},
            ["Damage_1"] = {Current = 113, Required = 113, Claimed = false},
            ["FriendMatch_1"] = {Current = 12, Required = 12, Claimed = false},
        }
    }
    
    InventoryChanged:FireServer({}, questData)
end

-- 4. ABILITY REMOTE
local function doAbility()
    if not features.ability or not AbilityRemote then return end
    
    -- Call #1 & #2 style
    AbilityRemote:FireServer("1f8e514d-75b5-4c8b-89ea-c1c2e16cb1c9", 2, true)
    AbilityRemote:FireServer("1f8e514d-75b5-4c8b-89ea-c1c2e16cb1c9", 1, false)
    AbilityRemote:FireServer("b3aa6b43-5dbf-4909-95ac-bdd529e4ffdb")
end

-- 5. AUTO PARRY
local function doParry()
    if not features.parry then return end
    
    -- Method 1: VirtualUser
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
    
    -- Method 2: Key F
    pcall(function()
        UserInputService:SendKeyEvent(true, Enum.KeyCode.F, false)
        UserInputService:SendKeyEvent(false, Enum.KeyCode.F, false)
    end)
    
    -- Method 3: MainRemote (Call #2, #5, #10)
    if MainRemote then
        local ball = nil
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Size.Magnitude > 2 and obj.Size.Magnitude < 8 then
                if obj.Parent and obj.Parent.Name ~= player.Name then
                    ball = obj
                    break
                end
            end
        end
        
        if ball and character and character:FindFirstChild("HumanoidRootPart") then
            local dist = (ball.Position - character.HumanoidRootPart.Position).Magnitude
            if dist < 25 then
                MainRemote:FireServer(4, character.HumanoidRootPart)
                MainRemote:FireServer(4, character.HumanoidRootPart.Position)
            end
        end
    end
end

-- 6. AUTO SPAM (Action Based)
local spamCount = 0
local function doSpam()
    if not features.spam then return end
    spamCount = spamCount + 1
    
    if spamCount % 4 == 0 and ActionRemote then
        ActionRemote:FireServer("81be4dbe73f189f1", "BoxHit", Vector3.new(0, 0, 0), true)
    end
end

-- 7. AUTO CURVE (RemoteEvent)
local function doCurve()
    if not features.curve then return end
    
    if MainRemote then
        local direction = Vector3.new(
            math.random(-100, 100)/100,
            -0.01,
            math.random(-100, 100)/100
        )
        local power = math.random(80, 200)
        MainRemote:FireServer(5, direction, power)
    end
end

-- 8. SHOP BOOSTER
local function doShop()
    if not features.shop or not SetValue then return end
    
    -- Set GLOBAL_ITEM_RAP (Call #4 style)
    SetValue:FireServer("GLOBAL_ITEM_RAP", {})
end

-- // ========== GUI ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ClawHubUltimate"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 380, 0, 480)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -240)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Title with User Info
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.Position = UDim2.new(0, 0, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "🔥 CLAW HUB ULTIMATE\n👤 " .. playerName
titleText.TextColor3 = Color3.fromRGB(255, 50, 50)
titleText.TextScaled = true
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Center
titleText.TextYAlignment = Enum.TextYAlignment.Top
titleText.Parent = titleBar

-- Minimize
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -65, 0, 7)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
minimizeBtn.Text = "─"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextScaled = true
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = titleBar

local isMinimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    scrollFrame.Visible = not isMinimized
    minimizeBtn.Text = isMinimized and "□" or "─"
    mainFrame.Size = isMinimized and UDim2.new(0, 380, 0, 45) or UDim2.new(0, 380, 0, 480)
end)

-- Close
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -32, 0, 7)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- User Info Display
local userFrame = Instance.new("Frame")
userFrame.Size = UDim2.new(1, 0, 0, 30)
userFrame.Position = UDim2.new(0, 0, 0, 45)
userFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
userFrame.BorderSizePixel = 0
userFrame.Parent = mainFrame

local userLabel = Instance.new("TextLabel")
userLabel.Size = UDim2.new(1, 0, 1, 0)
userLabel.BackgroundTransparency = 1
userLabel.Text = "✅ Authorized: " .. playerName .. " | ID: " .. playerId
userLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
userLabel.TextSize = 14
userLabel.Font = Enum.Font.GothamMedium
userLabel.Parent = userFrame

-- Scroll
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, -75)
scrollFrame.Position = UDim2.new(0, 0, 0, 75)
scrollFrame.BackgroundTransparency = 1
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 5
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0)
scrollFrame.Parent = mainFrame

local uiList = Instance.new("UIListLayout")
uiList.Padding = UDim.new(0, 5)
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Parent = scrollFrame

-- // ========== TOGGLE ==========
local function createToggle(text, key)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 35)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    frame.BorderSizePixel = 0
    frame.Parent = scrollFrame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextSize = 14
    label.Font = Enum.Font.GothamMedium
    label.Parent = frame

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 40, 0, 22)
    toggle.Position = UDim2.new(1, -50, 0.5, -11)
    toggle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    toggle.Text = "OFF"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.TextSize = 12
    toggle.Font = Enum.Font.GothamBold
    toggle.BorderSizePixel = 0
    toggle.Parent = frame

    local state = false
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(100, 100, 100)
        toggle.Text = state and "ON" or "OFF"
        features[key] = state
        print("[CLAW] " .. text .. ":", state and "ON" or "OFF")
    end)
end

-- // ========== MENU ==========
createToggle("🔴 Auto Parry", "parry")
createToggle("⚡ Auto Spam", "spam")
createToggle("🌀 Auto Curve", "curve")
createToggle("🎯 Auto Claim Quest", "claim")
createToggle("📊 Stat Booster", "boost")
createToggle("🏆 Leaderboard Booster", "leaderboard")
createToggle("⚡ Ability Remote", "ability")
createToggle("🛒 Shop Booster", "shop")

-- // ========== MAIN LOOP ==========
RunService.Heartbeat:Connect(function()
    if not character or not humanoid or humanoid.Health <= 0 then
        return
    end
    
    doParry()
    doSpam()
    doCurve()
    doClaim()
    doBoost()
    doLeaderboard()
    doAbility()
    doShop()
end)

-- // ========== NOTIFIKASI ==========
local function notify(text, color)
    local notif = Instance.new("TextLabel")
    notif.Size = UDim2.new(0, 300, 0, 35)
    notif.Position = UDim2.new(0.5, -150, 0, 10)
    notif.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    notif.BackgroundTransparency = 0.2
    notif.Text = text
    notif.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    notif.TextScaled = true
    notif.Font = Enum.Font.GothamMedium
    notif.BorderSizePixel = 0
    notif.Parent = screenGui
    game:GetService("Debris"):AddItem(notif, 3)
end

notify("✅ CLAW HUB ULTIMATE LOADED!", Color3.fromRGB(0, 255, 0))
notify("👤 User: " .. playerName, Color3.fromRGB(255, 255, 0))

print("========================================")
print("🔥 CLAW HUB ULTIMATE - READY")
print("👤 User: " .. playerName)
print("🆔 ID: " .. playerId)
print("📌 Fitur aktif sesuai toggle di GUI")
print("========================================")
