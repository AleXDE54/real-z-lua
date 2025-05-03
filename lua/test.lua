local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
while not player do
    Players.PlayerAdded:Wait()
    player = Players.LocalPlayer
end

local MAIN_COLOR = Color3.fromRGB(70, 130, 180)
local WINDOW_SIZE = UDim2.new(0, 300, 0, 500)
local WINDOW_POSITION = UDim2.new(0.5, -150, 0.5, -250)
local COLLAPSED_SIZE = UDim2.new(0, 40, 0, 40)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RealiizGUI"
screenGui.Parent = player:FindFirstChildOfClass("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = WINDOW_SIZE
mainFrame.Position = WINDOW_POSITION
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local collapseIcon = Instance.new("TextButton")
collapseIcon.Name = "CollapseIcon"
collapseIcon.Size = UDim2.new(0, 30, 0, 30)
collapseIcon.Position = UDim2.new(1, -35, 0, 5)
collapseIcon.BackgroundColor3 = MAIN_COLOR
collapseIcon.BorderSizePixel = 0
collapseIcon.Text = "_"
collapseIcon.TextColor3 = Color3.new(1, 1, 1)
collapseIcon.TextScaled = true
collapseIcon.Font = Enum.Font.GothamBold
collapseIcon.Parent = mainFrame

local collapseCorner = Instance.new("UICorner")
collapseCorner.CornerRadius = UDim.new(1, 0)
collapseCorner.Parent = collapseIcon

local isCollapsed = false
local fullSize = mainFrame.Size

local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -20, 1, -50)
contentFrame.Position = UDim2.new(0, 10, 0, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.ScrollBarThickness = 0
contentFrame.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 10)
layout.FillDirection = Enum.FillDirection.Vertical
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = contentFrame

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
end)

collapseIcon.MouseButton1Click:Connect(function()
    if not isCollapsed then
        TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = COLLAPSED_SIZE}):Play()
        contentFrame.Visible = false
        collapseIcon.Text = "🌀"
    else
        TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = fullSize}):Play()
        contentFrame.Visible = true
        collapseIcon.Text = "_"
    end
    isCollapsed = not isCollapsed
end)

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
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = btn

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 14, 0, 14)
    indicator.Position = UDim2.new(1, -20, 0.5, -7)
    indicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    indicator.BorderSizePixel = 0
    indicator.Parent = btn

    local icorner = Instance.new("UICorner")
    icorner.CornerRadius = UDim.new(1, 0)
    icorner.Parent = indicator

    local state = false
    label.MouseButton1Click:Connect(function()
        state = not state
        indicator.BackgroundColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        if callback then callback(state) end
    end)

    return {
        SetState = function(newState)
            state = newState
            indicator.BackgroundColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            if callback then callback(state) end
        end,
        GetState = function() return state end
    }
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

    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
end

local function createSlider(parent, labelText, minVal, maxVal, defaultVal, callback)
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

    slider.FocusLost:Connect(function(enterPressed)
        local val = tonumber(slider.Text)
        if val and val >= minVal and val <= maxVal then
            label.Text = labelText..": "..val
            if callback then callback(val) end
        else
            slider.Text = tostring(defaultVal)
        end
    end)
end

local function createCategory(parent, labelText)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 30)
    container.BackgroundTransparency = 1
    container.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = MAIN_COLOR
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    return container
end

local spawnedParts = {}
local godModeToggle, noClipToggle, flyToggle
local speedHackValue = 16
local jumpPowerValue = 50

createCategory(contentFrame, "Tools")

createButton(contentFrame, "Give F3X", function()
    local f3x = game:GetObjects("rbxassetid://11040063484")[1]
    f3x.Parent = player.Backpack
end)

createButton(contentFrame, "Spawn Coil Gun", function()
    local coil = Instance.new("Part")
    coil.Size = Vector3.new(2, 2, 4)
    coil.Position = player.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0)
    coil.BrickColor = BrickColor.new("Really red")
    coil.Anchored = false
    coil.CanCollide = true
    
    local weld = Instance.new("Weld")
    weld.Part0 = coil
    weld.Part1 = player.Character.HumanoidRootPart
    weld.C0 = CFrame.new(0, 0, -3)
    weld.Parent = coil
    
    local clickDetector = Instance.new("ClickDetector")
    clickDetector.Parent = coil
    
    clickDetector.MouseClick:Connect(function()
        local projectile = Instance.new("Part")
        projectile.Size = Vector3.new(0.5, 0.5, 2)
        projectile.Position = coil.Position
        projectile.Velocity = coil.CFrame.LookVector * 500
        projectile.BrickColor = BrickColor.new("Bright yellow")
        projectile.Parent = workspace
    end)
end)

createButton(contentFrame, "Infinite Yield", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

createCategory(contentFrame, "Movement")

createSlider(contentFrame, "Walk Speed", 16, 1000, 16, function(value)
    speedHackValue = value
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.WalkSpeed = value end
end)

createSlider(contentFrame, "Jump Power", 50, 1000, 50, function(value)
    jumpPowerValue = value
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.UseJumpPower = true
        humanoid.JumpPower = value
    end
end)

flyToggle = createToggle(contentFrame, "Fly", function(state)
    if state then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
        bodyVelocity.Name = "FlyBodyVelocity"
        bodyVelocity.Parent = player.Character.HumanoidRootPart
        
        local flySpeed = 50
        local flyConnection
        
        flyConnection = RunService.Heartbeat:Connect(function()
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local root = player.Character.HumanoidRootPart
                local velocity = root:FindFirstChild("FlyBodyVelocity")
                
                if velocity then
                    local direction = Vector3.new(0, 0, 0)
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction += root.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction -= root.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction -= root.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction += root.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then direction += Vector3.new(0, 1, 0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then direction -= Vector3.new(0, 1, 0) end
                    
                    if direction.Magnitude > 0 then
                        direction = direction.Unit * flySpeed
                    end
                    
                    velocity.Velocity = direction
                end
            else
                flyConnection:Disconnect()
            end
        end)
    else
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local velocity = player.Character.HumanoidRootPart:FindFirstChild("FlyBodyVelocity")
            if velocity then velocity:Destroy() end
        end
    end
end)

noClipToggle = createToggle(contentFrame, "NoClip", function(state)
    if state then
        local noclipConnection
        noclipConnection = RunService.Stepped:Connect(function()
            if player.Character then
                for _, child in ipairs(player.Character:GetDescendants()) do
                    if child:IsA("BasePart") then
                        child.CanCollide = false
                    end
                end
            else
                noclipConnection:Disconnect()
            end
        end)
    end
end)

createCategory(contentFrame, "Player")

godModeToggle = createToggle(contentFrame, "God Mode", function(state)
    if state then
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
        end
        
        local godModeConnection
        godModeConnection = player.CharacterAdded:Connect(function(character)
            local humanoid = character:WaitForChild("Humanoid")
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
        end)
    else
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.MaxHealth = 100
            humanoid.Health = 100
        end
    end
end)

createButton(contentFrame, "BOOM!", function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local explosion = Instance.new("Explosion")
        explosion.Position = player.Character.HumanoidRootPart.Position
        explosion.BlastPressure = 100000
        explosion.BlastRadius = 20
        explosion.Parent = workspace
    end
end)

createButton(contentFrame, "Reset Character", function()
    player:LoadCharacter()
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speedHackValue
        humanoid.JumpPower = jumpPowerValue
    end
end)

createCategory(contentFrame, "World")

local originalGravity = workspace.Gravity
createToggle(contentFrame, "Toggle Gravity", function(state)
    workspace.Gravity = state and 0.1 or originalGravity
    if not state then
        for _, part in ipairs(spawnedParts) do
            if part and part.Parent then
                part:ApplyImpulse(Vector3.new(0, 0.0001, 0))
            end
        end
    end
end)

createButton(contentFrame, "Spawn Part", function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local part = Instance.new("Part")
        part.Size = Vector3.new(4, 4, 4)
        part.Position = player.Character.HumanoidRootPart.Position + Vector3.new(0, 10, 0)
        part.BrickColor = BrickColor.Random()
        part.Anchored = false
        part.CanCollide = true
        part.Massless = false
        part.Parent = workspace
        part:ApplyImpulse(Vector3.new(0, 0.1, 0))
        table.insert(spawnedParts, part)
    end
end)

createButton(contentFrame, "Delete All Parts", function()
    for _, part in ipairs(spawnedParts) do
        if part and part.Parent then part:Destroy() end
    end
    spawnedParts = {}
end)

player.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.WalkSpeed = speedHackValue
    humanoid.JumpPower = jumpPowerValue
    
    if godModeToggle and godModeToggle.GetState() then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
    end
    
    if noClipToggle and noClipToggle.GetState() then noClipToggle.SetState(true) end
    if flyToggle and flyToggle.GetState() then flyToggle.SetState(true) end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F5 then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 80)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "real'iiz GUI\nSpecial thanks to:\nrealalexde (AleXDENSK54)\nw1smate (pizxamm)\nPress F5 to toggle GUI"
infoLabel.TextColor3 = Color3.new(1, 1, 1)
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 14
infoLabel.TextWrapped = true
infoLabel.Parent = contentFrame
