--[[
    SPY ULTIMATE - Full Game Scanner
    Mendeteksi:
    - Semua RemoteEvent & RemoteFunction
    - Struktur data FireServer
    - Nilai-nilai di Values
    - Aksi-aksi di Actions
    - Semua objek di Workspace
]]

-- // ========== SERVICE ==========
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local playerName = player.Name
local playerId = player.UserId

-- // ========== BANNER ==========
print("========================================")
print("🕵️ SPY ULTIMATE - FULL GAME SCANNER")
print("========================================")
print("👤 User: " .. playerName)
print("🆔 ID: " .. playerId)
print("========================================\n")

-- // ========== FUNGSI UTAMA ==========

-- 1. SCAN REMOTE EVENTS
local function scanRemoteEvents()
    print("📡 SCANNING REMOTE EVENTS & FUNCTIONS")
    print("========================================")
    
    local results = {
        events = {},
        functions = {},
        others = {}
    }
    
    -- Scan ReplicatedStorage
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            table.insert(results.events, {
                name = obj.Name,
                path = obj:GetFullName(),
                parent = obj.Parent and obj.Parent.Name or "nil"
            })
            print("✅ RemoteEvent: " .. obj:GetFullName())
        elseif obj:IsA("RemoteFunction") then
            table.insert(results.functions, {
                name = obj.Name,
                path = obj:GetFullName()
            })
            print("✅ RemoteFunction: " .. obj:GetFullName())
        end
    end
    
    -- Scan Workspace (untuk RemoteEvent yang parented ke nil)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("RemoteEvent") and obj.Parent == nil then
            table.insert(results.events, {
                name = obj.Name,
                path = "Parented to nil (Workspace)",
                parent = "nil"
            })
            print("✅ RemoteEvent (nil parent): " .. obj.Name)
        end
    end
    
    print("\n📊 TOTAL REMOTE EVENTS FOUND: " .. #results.events)
    print("📊 TOTAL REMOTE FUNCTIONS FOUND: " .. #results.functions)
    print("========================================\n")
    
    return results
end

-- 2. SCAN VALUES
local function scanValues()
    print("⚙️ SCANNING VALUES")
    print("========================================")
    
    local Values = ReplicatedStorage:FindFirstChild("Values")
    if not Values then
        print("❌ No 'Values' folder found in ReplicatedStorage")
        print("========================================\n")
        return {}
    end
    
    local results = {}
    for _, obj in ipairs(Values:GetChildren()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            print("✅ Value Remote: " .. obj.Name)
            table.insert(results, obj.Name)
        else
            print("📌 Value Object: " .. obj.Name .. " (" .. obj.ClassName .. ")")
        end
    end
    
    print("========================================\n")
    return results
end

-- 3. SCAN ACTIONS
local function scanActions()
    print("🎯 SCANNING ACTIONS")
    print("========================================")
    
    local Actions = ReplicatedStorage:FindFirstChild("Actions")
    if not Actions then
        print("❌ No 'Actions' folder found in ReplicatedStorage")
        print("========================================\n")
        return {}
    end
    
    for _, obj in ipairs(Actions:GetChildren()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            print("✅ Action Remote: " .. obj.Name)
        else
            print("📌 Action Object: " .. obj.Name .. " (" .. obj.ClassName .. ")")
        end
    end
    
    print("========================================\n")
end

-- 4. LIVE MONITOR (Real-time RemoteEvent Capture)
local function startLiveMonitor()
    print("🔄 STARTING LIVE MONITOR")
    print("========================================")
    print("📌 Lakukan aksi di game (Parry, Attack, dll)")
    print("📌 Hasil akan muncul di console")
    print("📌 Tekan Ctrl+C untuk berhenti\n")
    
    -- Hook ke semua RemoteEvent
    local function hookRemoteEvent(remote)
        if not remote then return end
        
        local oldFire = remote.FireServer
        remote.FireServer = function(self, ...)
            local args = {...}
            local argStr = ""
            for i, arg in ipairs(args) do
                local typeStr = typeof(arg)
                local valueStr = tostring(arg)
                if typeStr == "Instance" then
                    valueStr = arg:GetFullName()
                end
                argStr = argStr .. "[" .. i .. "] " .. typeStr .. ": " .. valueStr .. " "
            end
            
            print("🔥 " .. remote:GetFullName() .. " FIRED WITH:")
            print("   " .. argStr)
            print("")
            
            return oldFire(self, ...)
        end
    end
    
    -- Cari semua RemoteEvent dan hook
    local hooked = 0
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            hookRemoteEvent(obj)
            hooked = hooked + 1
        end
    end
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("RemoteEvent") and obj.Parent == nil then
            hookRemoteEvent(obj)
            hooked = hooked + 1
        end
    end
    
    print("✅ " .. hooked .. " RemoteEvent(s) hooked!")
    print("========================================\n")
    
    -- Keep script running
    RunService.Heartbeat:Wait()
end

-- 5. SCAN PLAYER CHARACTER
local function scanPlayer()
    print("👤 SCANNING PLAYER CHARACTER")
    print("========================================")
    
    if not player or not player.Character then
        print("❌ Character not found!")
        return
    end
    
    local character = player.Character
    print("📌 Character: " .. character.Name)
    
    for _, obj in ipairs(character:GetDescendants()) do
        if obj:IsA("BasePart") then
            print("   - Part: " .. obj.Name)
        elseif obj:IsA("Humanoid") then
            print("   - Humanoid: Health " .. obj.Health .. "/" .. obj.MaxHealth)
        elseif obj:IsA("Tool") then
            print("   - Tool: " .. obj.Name)
        end
    end
    
    print("========================================\n")
end

-- 6. SCAN WORKSPACE
local function scanWorkspace()
    print("🌐 SCANNING WORKSPACE")
    print("========================================")
    
    local balls = {}
    local players = {}
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Size.Magnitude > 1 then
            if obj.Name:lower():find("ball") or obj.Name:lower():find("projectile") then
                table.insert(balls, obj.Name)
            end
        end
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
            if obj ~= player.Character then
                table.insert(players, obj.Name)
            end
        end
    end
    
    print("📌 BALLS FOUND:")
    for i, name in ipairs(balls) do
        print("   " .. i .. ". " .. name)
    end
    
    print("\n📌 OTHER PLAYERS FOUND:")
    for i, name in ipairs(players) do
        print("   " .. i .. ". " .. name)
    end
    
    print("========================================\n")
end

-- 7. EXPORT ALL DATA
local function exportAllData()
    print("📋 EXPORTING ALL DATA")
    print("========================================")
    
    local data = {
        player = {
            name = playerName,
            id = playerId,
            displayName = player.DisplayName
        },
        remoteEvents = scanRemoteEvents(),
        values = scanValues(),
        actions = scanActions(),
        workspace = scanWorkspace(),
        timestamp = os.time()
    }
    
    -- Save to JSON (simulasi)
    print("✅ Data collected successfully!")
    print("📌 Total Remote Events: " .. #data.remoteEvents.events)
    print("📌 Total Remote Functions: " .. #data.remoteEvents.functions)
    print("========================================\n")
    
    return data
end

-- // ========== GUI SPY ==========
local function createGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SpyUltimate"
    screenGui.Parent = player:WaitForChild("PlayerGui")
    screenGui.ResetOnSpawn = false
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 350, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
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
    titleText.Text = "🕵️ SPY ULTIMATE"
    titleText.TextColor3 = Color3.fromRGB(0, 200, 255)
    titleText.TextScaled = true
    titleText.Font = Enum.Font.GothamBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    
    -- Close
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 2)
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
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
    scrollFrame.Parent = mainFrame
    
    local uiList = Instance.new("UIListLayout")
    uiList.Padding = UDim.new(0, 5)
    uiList.SortOrder = Enum.SortOrder.LayoutOrder
    uiList.Parent = scrollFrame
    
    -- Buttons
    local function createButton(text, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -20, 0, 35)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 14
        btn.Font = Enum.Font.GothamMedium
        btn.BorderSizePixel = 0
        btn.Parent = scrollFrame
        btn.MouseButton1Click:Connect(callback)
        return btn
    end
    
    createButton("📡 Scan Remote Events", function()
        scanRemoteEvents()
    end)
    
    createButton("⚙️ Scan Values", function()
        scanValues()
    end)
    
    createButton("🎯 Scan Actions", function()
        scanActions()
    end)
    
    createButton("🌐 Scan Workspace", function()
        scanWorkspace()
    end)
    
    createButton("👤 Scan Player", function()
        scanPlayer()
    end)
    
    createButton("🔄 Start Live Monitor", function()
        startLiveMonitor()
    end)
    
    createButton("📋 Export All Data", function()
        exportAllData()
    end)
end

-- // ========== MAIN ==========
print("🕵️ SPY ULTIMATE LOADED!")
print("📌 Commands available:")
print("   scanRemoteEvents() - Scan all RemoteEvents")
print("   scanValues() - Scan Values folder")
print("   scanActions() - Scan Actions folder")
print("   scanWorkspace() - Scan Workspace")
print("   scanPlayer() - Scan player character")
print("   startLiveMonitor() - Real-time event capture")
print("   exportAllData() - Export all data")

-- Auto scan
scanRemoteEvents()
scanValues()
scanActions()
scanWorkspace()
scanPlayer()

-- Create GUI
createGUI()

-- Notification
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🕵️ Spy Ultimate",
    Text = "Script loaded! Click buttons to scan.",
    Duration = 3
})

print("========================================")
print("✅ SPY ULTIMATE READY!")
print("👤 User: " .. playerName)
print("📌 Lakukan aksi di game untuk live monitor")
print("========================================")
