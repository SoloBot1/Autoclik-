-- LocalScript в StarterPlayerScripts
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Создаем главный GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AimBotMenu"
screenGui.ResetOnSpawn = false

-- Основное меню (прозрачное с бортами)
local mainMenu = Instance.new("Frame")
mainMenu.Size = UDim2.new(0, 300, 0, 350)
mainMenu.Position = UDim2.new(0.5, -150, 0.5, -175)
mainMenu.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainMenu.BackgroundTransparency = 0.8
mainMenu.BorderSizePixel = 2
mainMenu.BorderColor3 = Color3.fromRGB(255, 50, 50)
mainMenu.Visible = true
mainMenu.Active = true
mainMenu.Draggable = true

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0.02, 0)
menuCorner.Parent = mainMenu

-- Заголовок меню
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
titleBar.BackgroundTransparency = 0.5
titleBar.BorderSizePixel = 0

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0.02, 0)
titleCorner.Parent = titleBar

-- Текст заголовка
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.6, 0, 1, 0)
title.Position = UDim2.new(0.2, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🎯 AIM BOT"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 14
title.Font = Enum.Font.GothamBold

-- Кнопки управления в заголовке
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 2)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 16
closeButton.Font = Enum.Font.GothamBold

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0.5, 0)
closeCorner.Parent = closeButton

local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 25, 0, 25)
minimizeButton.Position = UDim2.new(1, -60, 0, 2)
minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 150, 50)
minimizeButton.Text = "─"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 16
minimizeButton.Font = Enum.Font.GothamBold

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0.5, 0)
minimizeCorner.Parent = minimizeButton

-- Кнопка Rage
local rageButton = Instance.new("TextButton")
rageButton.Size = UDim2.new(0, 70, 0, 70)
rageButton.Position = UDim2.new(1, -80, 0, 100)
rageButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
rageButton.BackgroundTransparency = 0.3
rageButton.Text = "🔥\nRAGE"
rageButton.TextSize = 12
rageButton.TextColor3 = Color3.fromRGB(255, 255, 255)
rageButton.TextWrapped = true
rageButton.Visible = false

local rageCorner = Instance.new("UICorner")
rageCorner.CornerRadius = UDim.new(0.2, 0)
rageCorner.Parent = rageButton

-- Кнопка свернуть/развернуть меню
local toggleMenuButton = Instance.new("TextButton")
toggleMenuButton.Size = UDim2.new(0, 40, 0, 40)
toggleMenuButton.Position = UDim2.new(0, 10, 0, 10)
toggleMenuButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
toggleMenuButton.BackgroundTransparency = 0.3
toggleMenuButton.Text = "⚙️"
toggleMenuButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleMenuButton.TextSize = 16
toggleMenuButton.Visible = false
toggleMenuButton.Active = true
toggleMenuButton.Draggable = true

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0.2, 0)
toggleCorner.Parent = toggleMenuButton

-- Настройки
local SETTINGS = {
    AimBotEnabled = false,
    RageEnabled = false,
    ThroughWalls = false,  -- Можно вкл/выкл
    ESPEnabled = true,
    MaxDistance = 500,
    AimSpeed = 0.3,
    MenuVisible = true
}

-- Создаем элементы меню
local function createToggle(settingName, displayName, currentVal, yPos)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -20, 0, 25)
    container.Position = UDim2.new(0, 10, 0, yPos)
    container.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Text = displayName
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 40, 0, 20)
    toggle.Position = UDim2.new(0.8, 0, 0, 0)
    toggle.BackgroundColor3 = currentVal and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(100, 100, 100)
    toggle.Text = currentVal and "ON" or "OFF"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.TextSize = 9
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0.2, 0)
    toggleCorner.Parent = toggle
    
    toggle.MouseButton1Click:Connect(function()
        SETTINGS[settingName] = not SETTINGS[settingName]
        toggle.BackgroundColor3 = SETTINGS[settingName] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(100, 100, 100)
        toggle.Text = SETTINGS[settingName] and "ON" or "OFF"
        
        if settingName == "AimBotEnabled" then
            rageButton.Visible = SETTINGS[settingName]
            if not SETTINGS[settingName] then
                SETTINGS.RageEnabled = false
                rageButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                rageButton.Text = "🔥\nRAGE"
            end
        end
    end)
    
    container.Parent = mainMenu
    label.Parent = container
    toggle.Parent = container
    
    return container
end

local function createSlider(settingName, displayName, minVal, maxVal, currentVal, yPos)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -20, 0, 45)
    container.Position = UDim2.new(0, 10, 0, yPos)
    container.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 0, 20)
    label.Text = displayName
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.3, 0, 0, 20)
    valueLabel.Position = UDim2.new(0.65, 0, 0, 0)
    valueLabel.Text = tostring(currentVal)
    valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueLabel.TextSize = 11
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.BackgroundTransparency = 1
    
    local valueBox = Instance.new("TextBox")
    valueBox.Size = UDim2.new(1, 0, 0, 20)
    valueBox.Position = UDim2.new(0, 0, 0, 25)
    valueBox.Text = tostring(currentVal)
    valueBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    valueBox.BackgroundTransparency = 0.5
    valueBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueBox.TextSize = 11
    valueBox.PlaceholderText = tostring(currentVal)
    
    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0.05, 0)
    boxCorner.Parent = valueBox
    
    valueBox.FocusLost:Connect(function()
        local num = tonumber(valueBox.Text)
        if num and num >= minVal and num <= maxVal then
            SETTINGS[settingName] = num
            valueLabel.Text = tostring(num)
            valueBox.Text = tostring(num)
        else
            valueBox.Text = tostring(SETTINGS[settingName])
        end
    end)
    
    container.Parent = mainMenu
    label.Parent = container
    valueLabel.Parent = container
    valueBox.Parent = container
    
    return container, valueLabel
end

-- Создаем элементы меню
local yPos = 40

-- Включить Aim Bot
createToggle("AimBotEnabled", "Включить Aim Bot", SETTINGS.AimBotEnabled, yPos)
yPos = yPos + 30

-- Наводка сквозь стены
createToggle("ThroughWalls", "Наводка сквозь стены", SETTINGS.ThroughWalls, yPos)
yPos = yPos + 30

-- ESP
createToggle("ESPEnabled", "ESP", SETTINGS.ESPEnabled, yPos)
yPos = yPos + 30

-- Дистанция
local distanceSlider, distanceLabel = createSlider("MaxDistance", "Дистанция", 1, 1000, SETTINGS.MaxDistance, yPos)
yPos = yPos + 50

-- Скорость наводки
local speedSlider, speedLabel = createSlider("AimSpeed", "Скорость наводки", 0.1, 1, SETTINGS.AimSpeed, yPos)
yPos = yPos + 50

-- Добавляем все в GUI
titleBar.Parent = mainMenu
title.Parent = titleBar
closeButton.Parent = titleBar
minimizeButton.Parent = titleBar
mainMenu.Parent = screenGui
rageButton.Parent = screenGui
toggleMenuButton.Parent = screenGui
screenGui.Parent = playerGui

-- Обработка кнопок управления
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    return
end)

minimizeButton.MouseButton1Click:Connect(function()
    SETTINGS.MenuVisible = false
    mainMenu.Visible = false
    toggleMenuButton.Visible = true
end)

toggleMenuButton.MouseButton1Click:Connect(function()
    SETTINGS.MenuVisible = true
    mainMenu.Visible = true
    toggleMenuButton.Visible = false
end)

-- Обработка кнопки Rage
rageButton.MouseButton1Click:Connect(function()
    if not SETTINGS.AimBotEnabled then return end
    
    SETTINGS.RageEnabled = not SETTINGS.RageEnabled
    
    if SETTINGS.RageEnabled then
        rageButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        rageButton.Text = "🔥\nON"
    else
        rageButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        rageButton.Text = "🔥\nRAGE"
    end
end)

-- Переменные для Aim Bot
local currentTarget = nil

-- Функции Aim Bot
function checkVisibility(targetPart)
    if SETTINGS.ThroughWalls then 
        return true  -- Сквозь стены включено
    end
    
    local character = player.Character
    if not character or not targetPart then return false end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    
    local origin = root.Position + Vector3.new(0, 1.5, 0)
    local targetPosition = targetPart.Position
    
    local direction = (targetPosition - origin).Unit
    local distance = (targetPosition - origin).Magnitude
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {character, targetPart.Parent}
    
    local raycastResult = workspace:Raycast(origin, direction * distance, raycastParams)
    
    return raycastResult == nil
end

function findTarget()
    local character = player.Character
    if not character then return nil end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    
    local closestTarget = nil
    local closestDistance = SETTINGS.MaxDistance
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local targetChar = otherPlayer.Character
            local humanoid = targetChar:FindFirstChild("Humanoid")
            local head = targetChar:FindFirstChild("Head")
            
            if head and humanoid and humanoid.Health > 0 then
                local distance = (root.Position - head.Position).Magnitude
                
                if distance <= closestDistance and checkVisibility(head) then
                    closestDistance = distance
                    closestTarget = head
                end
            end
        end
    end
    
    return closestTarget, closestDistance
end

function aimAtTarget(targetPart)
    if not targetPart then return end
    
    local camera = workspace.CurrentCamera
    local targetPosition = targetPart.Position
    
    local currentCFrame = camera.CFrame
    local targetCFrame = CFrame.lookAt(
        currentCFrame.Position,
        targetPosition
    )
    
    camera.CFrame = currentCFrame:Lerp(targetCFrame, SETTINGS.AimSpeed)
end

-- ESP функции
local espFolders = {}

function updateESP()
    if not SETTINGS.ESPEnabled then
        clearESP()
        return
    end
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            createESP(otherPlayer)
        end
    end
end

function createESP(targetPlayer)
    if espFolders[targetPlayer] then return end
    
    local folder = Instance.new("Folder")
    folder.Name = targetPlayer.Name .. "_ESP"
    espFolders[targetPlayer] = folder
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 10
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.TextStrokeTransparency = 0.8
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.Size = UDim2.new(0, 80, 0, 15)
    nameLabel.Visible = false
    
    nameLabel.Parent = folder
    folder.Parent = screenGui
    
    return folder
end

function updateESPVisual(targetPlayer, distance, isVisible)
    local folder = espFolders[targetPlayer]
    if not folder then return end
    
    local character = targetPlayer.Character
    if not character then return end
    
    local head = character:FindFirstChild("Head")
    if not head then return end
    
    local camera = workspace.CurrentCamera
    local headScreenPos, headVisible = camera:WorldToViewportPoint(head.Position)
    
    local nameLabel = folder:FindFirstChild("NameLabel")
    
    if headVisible then
        local color = isVisible and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        
        if nameLabel then
            nameLabel.Visible = true
            nameLabel.TextColor3 = color
            
            local shortName = targetPlayer.Name
            if #shortName > 8 then
                shortName = string.sub(shortName, 1, 6) .. ".."
            end
            
            nameLabel.Text = string.format("%s [%.0f]", shortName, distance)
            nameLabel.Position = UDim2.new(0, headScreenPos.X - 40, 0, headScreenPos.Y - 30)
        end
    else
        if nameLabel then
            nameLabel.Visible = false
        end
    end
end

function clearESP()
    for player, folder in pairs(espFolders) do
        folder:Destroy()
    end
    espFolders = {}
end

-- Основной цикл
RunService.RenderStepped:Connect(function()
    if SETTINGS.AimBotEnabled and SETTINGS.RageEnabled then
        local target, distance = findTarget()
        
        if target then
            currentTarget = target
            aimAtTarget(target)
        else
            currentTarget = nil
        end
    else
        currentTarget = nil
    end
    
    -- Обновляем ESP для всех игроков
    if SETTINGS.ESPEnabled then
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
                local targetChar = otherPlayer.Character
                local humanoid = targetChar:FindFirstChild("Humanoid")
                local head = targetChar:FindFirstChild("Head")
                
                if head and humanoid and humanoid.Health > 0 then
                    local distance = 0
                    local playerRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if playerRoot then
                        distance = (playerRoot.Position - head.Position).Magnitude
                    end
                    
                    local isVisible = checkVisibility(head)
                    updateESPVisual(otherPlayer, distance, isVisible)
                end
            end
        end
    else
        clearESP()
    end
end)

-- Очистка при выходе игрока
Players.PlayerRemoving:Connect(function(leftPlayer)
    if espFolders[leftPlayer] then
        espFolders[leftPlayer]:Destroy()
        espFolders[leftPlayer] = nil
    end
end)

print("🎯 AIM BOT MENU ЗАГРУЖЕНО!")
print("Механика стен: ВКЛ/ВЫКЛ")
print("ESP: ВКЛ/ВЫКЛ")
print("Срыв aim bot: УБРАН")
