
--[[
    NEVIAS RIVALS UI
    Japanese HUD
    Roblox Studio LocalScript
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Settings = {
    Crosshair = true,
    FOV = true,
    Performance = false,
    Animated = true,
    FOVSize = 120
}

local GUI = Instance.new("ScreenGui")
GUI.Name = "NEVIAS_UI"
GUI.ResetOnSpawn = false
GUI.Parent = Player:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(300, 330)
Main.Position = UDim2.new(0, 25, 0.35, 0)
Main.BackgroundColor3 = Color3.fromRGB(12, 15, 22)
Main.BorderSizePixel = 0
Main.Parent = GUI

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = Main

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0, 200, 255)
Stroke.Thickness = 1.5
Stroke.Parent = Main

local function Label(text, y, size)
    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, -20, 0, size or 35)
    L.Position = UDim2.fromOffset(10, y)
    L.BackgroundTransparency = 1
    L.Text = text
    L.TextColor3 = Color3.fromRGB(230, 240, 255)
    L.TextSize = 16
    L.Font = Enum.Font.GothamBold
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.Parent = Main
    return L
end

Label("NEVIAS  |  RIVALS", 10, 35)
Label("日本語コントロールパネル", 45, 25)

local function Button(text, y, callback)
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1, -20, 0, 36)
    B.Position = UDim2.fromOffset(10, y)
    B.BackgroundColor3 = Color3.fromRGB(25, 35, 48)
    B.TextColor3 = Color3.new(1, 1, 1)
    B.Text = text
    B.TextSize = 14
    B.Font = Enum.Font.GothamBold
    B.Parent = Main

    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0, 6)
    C.Parent = B

    B.MouseButton1Click:Connect(callback)
    return B
end

local function Toggle(name, key, y)
    local B
    local function Update()
        B.Text = name .. " : " ..
            (Settings[key] and "ON" or "OFF")
    end

    B = Button("", y, function()
        Settings[key] = not Settings[key]
        Update()
    end)

    Update()
end

Toggle("カスタムクロスヘア", "Crosshair", 85)
Toggle("FOVサークル", "FOV", 130)
Toggle("アニメーション", "Animated", 175)
Toggle("軽量化モード", "Performance", 220)

Button("UIを閉じる [右Ctrlで再表示]", 270, function()
    Main.Visible = false
end)

-- クロスヘア
local Crosshair = Instance.new("TextLabel")
Crosshair.Size = UDim2.fromOffset(40, 40)
Crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
Crosshair.Position = UDim2.fromScale(0.5, 0.5)
Crosshair.BackgroundTransparency = 1
Crosshair.Text = "+"
Crosshair.TextSize = 30
Crosshair.TextColor3 = Color3.fromRGB(0, 220, 255)
Crosshair.Font = Enum.Font.GothamBold
Crosshair.Parent = GUI

-- FOVサークル
local Circle = Instance.new("Frame")
Circle.AnchorPoint = Vector2.new(0.5, 0.5)
Circle.Position = UDim2.fromScale(0.5, 0.5)
Circle.Size = UDim2.fromOffset(
    Settings.FOVSize * 2,
    Settings.FOVSize * 2
)
Circle.BackgroundTransparency = 1
Circle.Parent = GUI

local CircleCorner = Instance.new("UICorner")
CircleCorner.CornerRadius = UDim.new(1, 0)
CircleCorner.Parent = Circle

local CircleStroke = Instance.new("UIStroke")
CircleStroke.Color = Color3.fromRGB(0, 200, 255)
CircleStroke.Thickness = 1.5
CircleStroke.Parent = Circle

-- アニメーション
local Rotation = 0

RunService.RenderStepped:Connect(function(dt)
    Crosshair.Visible = Settings.Crosshair
    Circle.Visible = Settings.FOV

    if Settings.Animated then
        Rotation += dt * 90
        Crosshair.Rotation = math.sin(Rotation / 30) * 8
    else
        Crosshair.Rotation = 0
    end
end)

-- UI再表示
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightControl then
        Main.Visible = not Main.Visible
    end
end)

print("[NEVIAS] Loaded successfully")
