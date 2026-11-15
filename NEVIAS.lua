
-- NEVIAS UI | Japanese HUD
-- Roblox Studio LocalScript

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "NEVIAS_Japanese_HUD"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local BLUE = Color3.fromRGB(65, 130, 220)
local DARK = Color3.fromRGB(20, 20, 25)
local WHITE = Color3.fromRGB(240, 240, 245)

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = obj
end

local function label(parent, text, size, position)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = WHITE
    l.Font = Enum.Font.Gotham
    l.TextSize = 14
    l.Size = size
    l.Position = position
    l.Parent = parent
    return l
end

-- Main window
local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(430, 330)
main.Position = UDim2.new(0.5, -215, 0.5, -165)
main.BackgroundColor3 = DARK
main.BorderSizePixel = 0
main.Parent = gui
corner(main, 10)

local title = label(main, "NEVIAS UI  |  日本語HUD",
    UDim2.new(1, 0, 0, 40), UDim2.fromOffset(0, 0))
title.TextSize = 18
title.Font = Enum.Font.GothamBold

local line = Instance.new("Frame")
line.Size = UDim2.new(1, -20, 0, 2)
line.Position = UDim2.fromOffset(10, 42)
line.BackgroundColor3 = BLUE
line.BorderSizePixel = 0
line.Parent = main

-- Tabs
local tabs = Instance.new("Frame")
tabs.Size = UDim2.new(1, -20, 0, 35)
tabs.Position = UDim2.fromOffset(10, 55)
tabs.BackgroundTransparency = 1
tabs.Parent = main

local tabNames = {"メイン", "クロスヘア", "軽量化"}
local pages = {}
local currentPage

local function createPage(name)
    local page = Instance.new("Frame")
    page.Name = name
    page.Size = UDim2.new(1, -20, 1, -145)
    page.Position = UDim2.fromOffset(10, 100)
    page.BackgroundColor3 = Color3.fromRGB(29, 29, 36)
    page.BorderSizePixel = 0
    page.Visible = false
    page.Parent = main
    corner(page, 7)
    pages[name] = page
    return page
end

local function button(parent, text, y, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -20, 0, 34)
    b.Position = UDim2.fromOffset(10, y)
    b.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
    b.TextColor3 = WHITE
    b.Text = text
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.Parent = parent
    corner(b, 5)
    b.MouseButton1Click:Connect(callback)
    return b
end

local mainPage = createPage("メイン")
local crossPage = createPage("クロスヘア")
local lightPage = createPage("軽量化")

for i, name in ipairs(tabNames) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(125, 32)
    b.Position = UDim2.fromOffset((i-1)*135, 0)
    b.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
    b.TextColor3 = WHITE
    b.Text = name
    b.Font = Enum.Font.Gotham
    b.TextSize = 13
    b.Parent = tabs
    corner(b, 5)

    b.MouseButton1Click:Connect(function()
        for _, page in pairs(pages) do
            page.Visible = false
        end
        pages[name].Visible = true
        currentPage = name
    end)
end

mainPage.Visible = true
currentPage = "メイン"

-- FPS / Ping
local info = label(mainPage, "FPS: 計測中\nPing: 計測中",
    UDim2.new(1, -20, 0, 55), UDim2.fromOffset(10, 10))
info.TextXAlignment = Enum.TextXAlignment.Left

-- Crosshair
local cross = Instance.new("Frame")
cross.Name = "CustomCrosshair"
cross.Size = UDim2.fromOffset(2, 2)
cross.Position = UDim2.new(0.5, -1, 0.5, -1)
cross.BackgroundTransparency = 1
cross.Parent = gui

local pieces = {}

local function makePiece(size, pos)
    local p = Instance.new("Frame")
    p.Size = size
    p.Position = pos
    p.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    p.BorderSizePixel = 0
    p.Parent = cross
    corner(p, 2)
    table.insert(pieces, p)
end

local gap = 7
local length = 9
local thickness = 2

makePiece(UDim2.fromOffset(thickness, length),
    UDim2.fromOffset(-1, -gap-length))
makePiece(UDim2.fromOffset(thickness, length),
    UDim2.fromOffset(-1, gap))
makePiece(UDim2.fromOffset(length, thickness),
    UDim2.fromOffset(-gap-length, -1))
makePiece(UDim2.fromOffset(length, thickness),
    UDim2.fromOffset(gap, -1))

local dot = Instance.new("Frame")
dot.Size = UDim2.fromOffset(3, 3)
dot.Position = UDim2.fromOffset(-1.5, -1.5)
dot.BackgroundColor3 = BLUE
dot.BorderSizePixel = 0
dot.Parent = cross
corner(dot, 5)

local animated = true
local crossVisible = true
local animationTime = 0

button(crossPage, "アニメーション：ON", 10, function()
    animated = not animated
end)

button(crossPage, "クロスヘア表示切替", 55, function()
    crossVisible = not crossVisible
    cross.Visible = crossVisible
end)

button(crossPage, "クロスヘア色：青 / 白", 100, function()
    local color = dot.BackgroundColor3 == BLUE
        and Color3.new(1, 1, 1) or BLUE
    for _, p in ipairs(pieces) do
        p.BackgroundColor3 = color
    end
    dot.BackgroundColor3 = color
end)

-- Lightweight UI
local effects = true

button(lightPage, "UIエフェクト：ON / OFF", 10, function()
    effects = not effects
    main.BackgroundTransparency = effects and 0 or 0.08
end)

button(lightPage, "クロスヘアを非表示", 55, function()
    cross.Visible = false
    crossVisible = false
end)

label(lightPage, "不要な装飾を減らしたシンプルなHUD",
    UDim2.new(1, -20, 0, 30), UDim2.fromOffset(10, 105))

-- Menu toggle
local menuVisible = true

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end

    if input.KeyCode == Enum.KeyCode.RightShift then
        menuVisible = not menuVisible
        main.Visible = menuVisible
    end
end)

-- Drag window
local dragging = false
local dragStart
local startPos

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Performance display and animation
local frames = 0
local elapsed = 0

RunService.RenderStepped:Connect(function(dt)
    frames += 1
    elapsed += dt

    if elapsed >= 1 then
        local fps = math.floor(frames / elapsed)
        local ping = "計測不可"

        pcall(function()
            ping = math.floor(
                Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
            ) .. " ms"
        end)

        info.Text = "FPS: " .. fps .. "\nPing: " .. ping

        frames = 0
        elapsed = 0
    end

    if animated and cross.Visible then
        animationTime += dt * 3
        local pulse = 1 + math.sin(animationTime) * 0.15
        dot.Size = UDim2.fromOffset(3 * pulse, 3 * pulse)
    end
end)

print("NEVIAS UI 起動完了！")
print("右Shiftでメニュー表示切替")
