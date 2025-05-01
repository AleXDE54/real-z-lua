-- Roblox Cheater GUI — Unified Menu
-- Paste into LocalScript inside ScreenGui under StarterGui

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local gui = script.Parent
local MAIN_COLOR = Color3.fromRGB(70, 130, 180)

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.35, 0, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Collapse Button
local collapseIcon = Instance.new("TextButton")
collapseIcon.Name = "CollapseIcon"
collapseIcon.Size = UDim2.new(0, 30, 0, 30)
collapseIcon.Position = UDim2.new(1, -35, 0, 5)
collapseIcon.BackgroundColor3 = MAIN_COLOR
collapseIcon.BorderSizePixel = 0
collapseIcon.Text = "-"
collapseIcon.TextColor3 = Color3.new(1, 1, 1)
collapseIcon.TextScaled = true
collapseIcon.Font = Enum.Font.GothamBold
collapseIcon.Parent = mainFrame

local collapseCorner = Instance.new("UICorner")
collapseCorner.CornerRadius = UDim.new(1, 0)
collapseCorner.Parent = collapseIcon

local isCollapsed = false
local fullSize = mainFrame.Size

-- Unified Content Area
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -20, 1, -50)
contentFrame.Position = UDim2.new(0, 10, 0, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.ScrollBarThickness = 0
contentFrame.Parent = mainFrame

-- Layout for content
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 10)
layout.FillDirection = Enum.FillDirection.Vertical
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = contentFrame

-- Update CanvasSize dynamically after layout
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
end)

-- Collapse Logic
collapseIcon.MouseButton1Click:Connect(function()
    if not isCollapsed then
        TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 40, 0, 40)}):Play()
        contentFrame.Visible = false
        collapseIcon.Text = "*"
    else
        TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = fullSize}):Play()
        contentFrame.Visible = true
        collapseIcon.Text = "-"
    end
    isCollapsed = not isCollapsed
end)

-- Factories
local function createToggle(parent, text, callback)
    local btn = Instance.new("Frame")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = MAIN_COLOR
    btn.BorderSizePixel = 0
    btn.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    local label = Instance.new("TextButton")
    label.Size = UDim2.new(1, -30, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 18
    label.Parent = btn

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 14, 0, 14)
    indicator.Position = UDim2.new(1, -20, 0.5, -7)
    indicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    indicator.BorderSizePixel = 0
    indicator.Parent = btn

    local indCorner = Instance.new("UICorner")
    indCorner.CornerRadius = UDim.new(1, 0)
    indCorner.Parent = indicator

    local state = false
    label.MouseButton1Click:Connect(function()
        state = not state
        indicator.BackgroundColor3 = state and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
        callback(state)
    end)
end

local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = MAIN_COLOR
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 18
    btn.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(callback)
end

local function createSlider(parent, labelText, minVal, maxVal, defaultVal)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 50)
    container.BackgroundTransparency = 1
    container.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = labelText..": "..defaultVal
    label.TextColor3 = MAIN_COLOR
    label.Font = Enum.Font.Gotham
    label.TextSize = 16
    label.Parent = container

    local slider = Instance.new("TextBox")
    slider.Size = UDim2.new(1, 0, 0, 25)
    slider.Position = UDim2.new(0, 0, 0, 25)
    slider.BackgroundColor3 = MAIN_COLOR
    slider.ClearTextOnFocus = false
    slider.Text = tostring(defaultVal)
    slider.TextColor3 = Color3.new(1,1,1)
    slider.Font = Enum.Font.Gotham
    slider.TextSize = 16
    slider.Parent = container

    local scorner = Instance.new("UICorner")
    scorner.CornerRadius = UDim.new(0,6)
    scorner.Parent = slider

    slider.FocusLost:Connect(function()
        local val = tonumber(slider.Text)
        if val and val>=minVal and val<=maxVal then
            label.Text = labelText..": "..val
            local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if string.find(labelText, "WalkSpeed") then
                    humanoid.WalkSpeed = val
                elseif string.find(labelText, "JumpPower") then
                    humanoid.UseJumpPower = true
                    humanoid.JumpPower = val
                end
            end
        else slider.Text=tostring(defaultVal) end
    end)
end

-- Unified Content
createSlider(contentFrame, "WalkSpeed", 16, 300, 100)
createSlider(contentFrame, "JumpPower", 50, 300, 150)

-- Fly logic
local flyConnection
createToggle(contentFrame, "Toggle Fly", function(on)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if on then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "FlyVelocity"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Parent = hrp
        flyConnection = RunService.RenderStepped:Connect(function()
            bv.Velocity = Vector3.new(0,50,0)
        end)
    else
        if flyConnection then flyConnection:Disconnect() end
        local v = hrp:FindFirstChild("FlyVelocity")
        if v then v:Destroy() end
    end
end)

createToggle(contentFrame, "Toggle Gravity", function(on)
    workspace.Gravity = on and 0 or 196.2
end)

createButton(contentFrame, "Spawn Random Block", function()
    local part=Instance.new("Part")
    part.Size=Vector3.new(3,3,3)
    part.Position=player.Character and player.Character:FindFirstChild("HumanoidRootPart").Position+Vector3.new(0,10,0)
    part.BrickColor=BrickColor.Random()
    part.Parent=workspace
end)

createButton(contentFrame, "Explosion", function()
    local e = Instance.new("Explosion")
    e.Position = player.Character.HumanoidRootPart.Position
    e.Parent = workspace
end)
