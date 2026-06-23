--[[
    CLAW HUB ULTIMATE - BERDASARKAN DATA INCOMING
    - RemoteEvent (Parented to nil): Parry, Curve, Player Status
    - Actions.Action: Target, Damage, Position
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- // ========== REMOTE DETECTION ==========
-- Cari RemoteEvent (Parented to nil)
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

-- Cari Actions.Action
local ActionRemote = ReplicatedStorage:FindFirstChild("Actions")
local Action = ActionRemote and ActionRemote:FindFirstChild("Action")

print("[CLAW] Remote ditemukan:")
print("  MainRemote:", MainRemote and "✅" or "❌")
print("  Action:", Action and "✅" or "❌")

-- // ========== FITUR ==========
local features = {
    parry = false,
    spam = false,
    curve = false
}

-- 1. AUTO PARRY (berdasarkan Incoming Call #1, #4, #7, #10)
local function doParry()
    if not features.parry then return end
    
    -- Method 1: MainRemote (Type 4)
    if MainRemote and character and character:FindFirstChild("HumanoidRootPart") then
        MainRemote:FireServer(4, character.HumanoidRootPart)
    end
    
    -- Method 2: VirtualUser (Backup)
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

-- 2. AUTO SPAM (Action berdasarkan Incoming Call #1, #4, #5, #6, #7)
local function doSpam()
    if not features.spam then return end
    
    if Action then
        -- Gunakan hash yang sama dari Incoming
        Action:FireServer("2fe73be7e2d9ead9", character.HumanoidRootPart)
    end
end

-- 3. AUTO CURVE (berdasarkan Incoming Call #3, #6, #9)
local function doCurve()
    if not features.curve then return end
    
    if MainRemote then
        -- Kirim Type 5 dengan arah acak dan kekuatan
        local direction = Vector3.new(math.random(-100, 100)/100, -0.01, math.random(-100, 100)/100)
        local power = math.random(80, 200)
        MainRemote:FireServer(5, direction, power)
    end
end

-- // ========== GUI ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ClawHubUltimate"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 300)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Title
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(0.8, 0, 1, 0)
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "🔥 CLAW HUB ULTIMATE"
titleText.TextColor3 = Color3.fromRGB(255, 50, 50)
titleText.TextScaled = true
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- Minimize
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -65, 0, 2)
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
    mainFrame.Size = isMinimized and UDim2.new(0, 350, 0, 35) or UDim2.new(0, 350, 0, 300)
end)

-- Close
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -32, 0, 2)
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

-- Scroll
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, -35)
scrollFrame.Position = UDim2.new(0, 0, 0, 35)
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

-- // ========== MAIN LOOP ==========
RunService.Heartbeat:Connect(function()
    if not character or not humanoid or humanoid.Health <= 0 then
        return
    end
    
    doParry()
    doSpam()
    doCurve()
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

print("========================================")
print("🔥 CLAW HUB ULTIMATE - READY")
print("📌 Data dari Incoming:")
print("   - RemoteEvent (nil): Type 4 = Parry, Type 5 = Curve")
print("   - Actions.Action: Hash 2fe... = Target/Hit")
print("========================================")
