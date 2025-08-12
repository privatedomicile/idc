--idc if u skid

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- Check if script is already running
local gui = player:WaitForChild("PlayerGui"):FindFirstChild("PartsToggleGui")
if gui then
    -- Create confirmation dialog
    local dialog = Instance.new("ScreenGui")
    dialog.Name = "ScriptReloadDialog"
    dialog.ResetOnSpawn = false
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 150)
    frame.Position = UDim2.new(0.5, -150, 0.5, -75)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    frame.Parent = dialog
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0.3, 0)
    title.Position = UDim2.new(0, 0, 0.1, 0)
    title.BackgroundTransparency = 1
    title.Text = "Script Already Running"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextYAlignment = Enum.TextYAlignment.Bottom
    title.Parent = frame
    
    local message = Instance.new("TextLabel")
    message.Size = UDim2.new(0.9, 0, 0.3, 0)
    message.Position = UDim2.new(0.05, 0, 0.35, 0)
    message.BackgroundTransparency = 1
    message.Text = "Would you like to Rejoin? We are currently in BETA and are experiencing major bugs."
    message.TextColor3 = Color3.fromRGB(200, 200, 200)
    message.Font = Enum.Font.Gotham
    message.TextSize = 14
    message.TextWrapped = true
    message.Parent = frame
    
    local function createButton(text, position, color, callback)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0.4, 0, 0.3, 0)
        button.Position = position
        button.BackgroundColor3 = color
        button.TextColor3 = Color3.new(1, 1, 1)
        button.Font = Enum.Font.GothamBold
        button.TextSize = 14
        button.Text = text
        button.Parent = frame
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 4)
        corner.Parent = button
        
        button.MouseButton1Click:Connect(function()
            callback()
            dialog:Destroy()
            game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
        end)
        
        return button
    end
    
    -- Add padding to the bottom of the dialog
    frame.Size = UDim2.new(0, 300, 0, 180) -- Increased height for better spacing
    
    -- Position buttons higher up with better spacing
    createButton("Yes", UDim2.new(0.05, 0, 0.65, 0), Color3.fromRGB(0, 120, 215), function()
        -- Fade out before reloading
        local fadeOut = TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundTransparency = 1, Position = UDim2.new(0.5, -150, 0.3, 0)})
        fadeOut:Play()
        fadeOut.Completed:Wait()
        gui:Destroy()
        dialog:Destroy()
        -- Create a new script instance and run it
        local newScript = Instance.new("LocalScript")
        newScript.Source = script.Source
        newScript.Parent = script.Parent
        newScript.Name = script.Name
        script:Destroy()
    end)
    
    createButton("No", UDim2.new(0.55, 0, 0.65, 0), Color3.fromRGB(80, 80, 80), function()
        local fadeOut = TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundTransparency = 1, Position = UDim2.new(0.5, -150, 0.3, 0)})
        fadeOut:Play()
        fadeOut.Completed:Wait()
        dialog:Destroy()
    end)
    
    -- Fade in the dialog
    frame.BackgroundTransparency = 1
    frame.Position = UDim2.new(0.5, -150, 0.4, 0)
    local fadeIn = TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundTransparency = 0.2, Position = UDim2.new(0.5, -150, 0.5, -90)})
    fadeIn:Play()
    
    dialog.Parent = player:WaitForChild("PlayerGui")
    return
end

-- Initialize character and HRP references
local character, hrp
local function setupCharacter(char)
    character = char
    hrp = character:WaitForChild("HumanoidRootPart")
end

-- Handle initial character and respawns
if player.Character then
    setupCharacter(player.Character)
end
player.CharacterAdded:Connect(setupCharacter)

local positionTolerance = 0.01

local sarajineunPartsCFrames = {
    CFrame.new(33.4529037, 165.803314, 33.7354202),
    CFrame.new(33.4529037, 165.803314, 46.7354202),
    CFrame.new(33.4529037, 165.803314, 59.7354202),
}

local gudockName = "Gudock"
local gudockCFrame = CFrame.new(38.4866753, 167.326248, 86.7648621, 0, 0, -1, 1, 0, 0, 0, -1, 0)

local pyongName = "Pyong"
local pyongCFrame = CFrame.new(33.4528961, 165.803314, 72.7353821)

local function findPartsByNameAndPositions(name, cframes, tol)
    local foundParts = {}
    for _, part in ipairs(workspace:GetChildren()) do
        if part:IsA("BasePart") and part.Name == name then
            for _, cf in ipairs(cframes) do
                if (part.Position - cf.Position).Magnitude <= tol then
                    table.insert(foundParts, part)
                    break
                end
            end
        end
    end
    return foundParts
end

local function findPartByNameAndPosition(name, cf, tol)
    for _, part in ipairs(workspace:GetChildren()) do
        if part:IsA("BasePart") and part.Name == name then
            if (part.Position - cf.Position).Magnitude <= tol then
                return part
            end
        end
    end
    return nil
end

local sarajineunParts = findPartsByNameAndPositions("사라지는 파트", sarajineunPartsCFrames, positionTolerance)
local gudockPart = findPartByNameAndPosition(gudockName, gudockCFrame, positionTolerance)
local pyongPart = findPartByNameAndPosition(pyongName, pyongCFrame, positionTolerance)

local allParts = {}

for _, part in ipairs(sarajineunParts) do
    table.insert(allParts, part)
end

if gudockPart then
    table.insert(allParts, gudockPart)
else
    warn("Gudock part not found!")
end

if not pyongPart then
    warn("Pyong part not found!")
end

if #allParts == 0 then
    warn("No target parts found!")
    return
end

-- Store original states for each part
local originalStates = {}
for _, part in ipairs(allParts) do
    originalStates[part] = {
        CFrame = part.CFrame,
        Transparency = part.Transparency,
        CanCollide = part.CanCollide
    }
end

local originalSarajineunTransparency = {}
for _, part in ipairs(sarajineunParts) do
    originalSarajineunTransparency[part] = part.Transparency
end

local isFollowing = false

-- Create GUI
-- Create notification
local function createNotification(title, text, duration)
    duration = duration or 5
    local notification = Instance.new("ScreenGui")
    notification.Name = "NotificationGui"
    notification.ResetOnSpawn = false
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 100)
    frame.Position = UDim2.new(1, 20, 1, -120) -- Adjusted position
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    frame.BackgroundTransparency = 1 -- Start transparent
    frame.Parent = notification
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    -- Title with better spacing
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0.3, 0)
    titleLabel.Position = UDim2.new(0, 10, 0.1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextYAlignment = Enum.TextYAlignment.Bottom
    titleLabel.Parent = frame
    
    -- Text with better spacing below title
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -20, 0.4, 0)
    textLabel.Position = UDim2.new(0, 10, 0.4, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    textLabel.Font = Enum.Font.GothamMedium
    textLabel.TextSize = 14
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextYAlignment = Enum.TextYAlignment.Top
    textLabel.TextWrapped = true
    textLabel.Parent = frame
    
    -- Fade in animation
    local fadeIn = TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundTransparency = 0.2, Position = UDim2.new(1, -320, 1, -120)})
    fadeIn:Play()
    
    -- Fade out and remove after duration
    task.delay(duration - 0.5, function()
        local fadeOut = TweenService:Create(frame, TweenInfo.new(0.5), {BackgroundTransparency = 1, Position = UDim2.new(1, -300, 1, -120)})
        fadeOut:Play()
        fadeOut.Completed:Wait()
        notification:Destroy()
    end)
    
    notification.Parent = player:WaitForChild("PlayerGui")
    
    -- Auto-remove after duration
    task.delay(duration or 5, function()
        notification:Destroy()
    end)
    
    return notification
end

-- Show welcome notification
createNotification("Welcome!", "Script made by @dread.w", 5)

-- Create main UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PartsToggleGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Create container frame
local container = Instance.new("Frame")
container.Size = UDim2.new(0, 160, 0, 120)
container.Position = UDim2.new(0, 10, 1, -130)
container.BackgroundTransparency = 0.4  -- Made less transparent than notification
container.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
container.BorderSizePixel = 0
container.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 6)
corner.Parent = container

-- Create toggle button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.9, 0, 0, 45)
toggleButton.Position = UDim2.new(0.05, 0, 0.05, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 16
toggleButton.Text = "OFF"
toggleButton.Parent = container

-- Style toggle button
local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 4)
toggleCorner.Parent = toggleButton

-- Create teleport button
local tpButton = Instance.new("TextButton")
tpButton.Size = UDim2.new(0.9, 0, 0, 45)
tpButton.Position = UDim2.new(0.05, 0, 0.55, 0)
tpButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
tpButton.TextColor3 = Color3.new(1, 1, 1)
tpButton.Font = Enum.Font.GothamBold
tpButton.TextSize = 16
tpButton.Text = "TELEPORT"
tpButton.Parent = container

-- Style teleport button
local tpCorner = Instance.new("UICorner")
tpCorner.CornerRadius = UDim.new(0, 4)
tpCorner.Parent = tpButton

-- Add hover effects
local function onButtonHover(button, defaultColor, hoverColor)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = defaultColor}):Play()
    end)
end

onButtonHover(toggleButton, Color3.fromRGB(60, 60, 60), Color3.fromRGB(80, 80, 80))
onButtonHover(tpButton, Color3.fromRGB(0, 120, 215), Color3.fromRGB(0, 140, 255))

local function toggleParts()
    isFollowing = not isFollowing

    if isFollowing then
        -- Hide parts & disable collisions
        for _, part in ipairs(allParts) do
            if table.find(sarajineunParts, part) then
                part.Transparency = 1 -- fully invisible for "사라지는 파트"
            else
                part.Transparency = 1 -- also hide other parts like Gudock when following
            end
            part.CanCollide = false
        end
        toggleButton.Text = "ON"
    else
        -- Restore original states
        for part, state in pairs(originalStates) do
            part.CFrame = state.CFrame
            part.Transparency = state.Transparency
            part.CanCollide = false -- keep CanCollide false to prevent glitches
        end
        toggleButton.Text = "OFF"
    end
end

toggleButton.MouseButton1Click:Connect(toggleParts)

tpButton.MouseButton1Click:Connect(function()
    if not character or not character:IsDescendantOf(workspace) or not hrp then
        -- If character is invalid, try to get a new reference
        if player.Character then
            setupCharacter(player.Character)
            if hrp then
                hrp.CFrame = CFrame.new(34, 169, 99)
            end
        end
    else
        hrp.CFrame = CFrame.new(34, 169, 99)
    end
end)

RunService.Heartbeat:Connect(function()
    if isFollowing and hrp then
        for _, part in ipairs(allParts) do
            if part then
                -- Force transparency and disable collisions every frame while toggled ON
                part.Transparency = 1
                part.CanCollide = false

                if part == gudockPart then
                    if pyongPart and pyongPart.Transparency == 0 then
                        part.CFrame = hrp.CFrame
                    else
                        part.CFrame = hrp.CFrame * CFrame.new(0, 0, -10)
                    end
                else
                    part.CFrame = hrp.CFrame
                end
            end
        end
    else
        -- Restore original properties when toggled OFF
        for part, state in pairs(originalStates) do
            if part then
                part.CFrame = state.CFrame
                part.Transparency = state.Transparency
                part.CanCollide = state.CanCollide -- restore original collision
            end
        end
    end
end)
