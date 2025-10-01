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

-- Основное меню
local mainMenu = Instance.new("Frame")
mainMenu.Size = UDim2.new(0, 320, 0, 450)
mainMenu.Position = UDim2.new(0.5, -160, 0.5, -225)
mainMenu.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
mainMenu.BackgroundTransparency = 0.1
mainMenu.BorderSizePixel = 3
mainMenu.BorderColor3 = Color3.fromRGB(255, 50, 50)
mainMenu.Visible = true
mainMenu.Active = true
mainMenu.Draggable = true

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0.03, 0)
menuCorner.Parent = mainMenu

-- Заголовок
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
titleBar.BorderSizePixel = 0

local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 0, 0))
})
titleGradient.Rotation = 90
titleGradient.Parent = titleBar

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0.03, 0)
titleCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.6, 0, 1, 0)
title.Position = UDim2.new(0.2, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🔫 AIM BOT"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBlack
title.TextStrokeTransparency = 0.8
title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

-- Кнопки управления
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 14
closeButton.Font = Enum.Font.GothamBold

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0.5, 0)
closeCorner.Parent = closeButton

local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 25, 0, 25)
minimizeButton.Position = UDim2.new(1, -60, 0, 5)
minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 150, 50)
minimizeButton.Text = "─"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 14
minimizeButton.Font = Enum.Font.GothamBold

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0.5, 0)
minimizeCorner.Parent = minimizeButton

-- Главная кнопка Aim Bot
local aimButton = Instance.new("TextButton")
aimButton.Size = UDim2.new(0, 70, 0, 70)
aimButton.Position = UDim2.new(1, -80, 0, 100)
aimButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
aimButton.BackgroundTransparency = 0.3
aimButton.Text = "🎯\nOFF"
aimButton.TextSize = 12
aimButton.TextColor3 = Color3.fromRGB(255, 255, 255)
aimButton.TextWrapped = true
aimButton.Visible = false

local aimButtonCorner = Instance.new("UICorner")
aimButtonCorner.CornerRadius = UDim.new(0.2, 0)
aimButtonCorner.Parent = aimButton

-- Круг прицеливания (полностью настраиваемый)
local aimCircle = Instance.new("Frame")
aimCircle.Size = UDim2.new(0, 100, 0, 100)
aimCircle.AnchorPoint = Vector2.new(0.5, 0.5)
aimCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
aimCircle.BackgroundTransparency = 1
aimCircle.BorderSizePixel = 2
aimCircle.BorderColor3 = Color3.fromRGB(0, 255, 0)
aimCircle.Visible = false
aimCircle.Active = true
aimCircle.Draggable = true  -- Можно двигать

local circleCorner = Instance.new("UICorner")
circleCorner.CornerRadius = UDim.new(1, 0)
circleCorner.Parent = aimCircle

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
    ThroughWalls = false,
    ESPEnabled = true,
    MaxDistance = 500,
    AimSpeed = 0.3,
    CircleRadius = 100,      -- Размер круга
    CircleFOV = 360,         -- Угол обзора (360 = везде)
    CircleX = 0.5,           -- Позиция X (0-1)
    CircleY = 0.5,           -- Позиция Y (0-1)
    CanBreakAim = true,
    MenuVisible = true
}

-- Переменные
local espFolders = {}
local currentTarget = nil
local isAiming = false

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
            aimButton.Visible = SETTINGS[settingName]
            if not SETTINGS[settingName] then
                aimButton.Text = "🎯\nOFF"
                aimButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                aimCircle.Visible = false
            end
        end
        
        if settingName == "ESPEnabled" and not SETTINGS[settingName] then
            clearESP()
        end
    end)
    
    container.Parent = mainMenu
    label.Parent = container
    toggle.Parent = container
    
    return container
end

local function createSlider(settingName, displayName, minVal, maxVal, currentVal, yPos, isPosition)
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
            
            if settingName == "CircleRadius" then
                aimCircle.Size = UDim2.new(0, num, 0, num)
            elseif settingName == "CircleX" then
                aimCircle.Position = UDim2.new(SETTINGS.CircleX, 0, SETTINGS.CircleY, 0)
            elseif settingName == "CircleY" then
                aimCircle.Position = UDim2.new(SETTINGS.CircleX, 0, SETTINGS.CircleY, 0)
            end
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
local yPos = 45

-- Основные настройки
local function createSection(text, yPos)
    local section = Instance.new("TextLabel")
    section.Size = UDim2.new(1, -20, 0, 20)
    section.Position = UDim2.new(0, 10, 0, yPos)
    section.BackgroundTransparency = 1
    section.Text = "► " .. text
    section.TextColor3 = Color3.fromRGB(255, 100, 100)
    section.TextSize = 12
    section.Font = Enum.Font.GothamBold
    section.TextXAlignment = Enum.TextXAlignment.Left
    section.Parent = mainMenu
    return section
end

createSection("ОСНОВНЫЕ НАСТРОЙКИ", yPos)
yPos = yPos + 25

-- Включить Aim Bot
createToggle("AimBotEnabled", "Включить Aim Bot", SETTINGS.AimBotEnabled, yPos)
yPos = yPos + 30

-- Наводка сквозь стены
createToggle("ThroughWalls", "Наводка сквозь стены", SETTINGS.ThroughWalls, yPos)
yPos = yPos + 30

-- ESP
createToggle("ESPEnabled", "ESP", SETTINGS.ESPEnabled, yPos)
yPos = yPos + 30

-- Срыв аим бота
createToggle("CanBreakAim", "Срыв аим бота", SETTINGS.CanBreakAim, yPos)
yPos = yPos + 30

createSection("ПРИЦЕЛИВАНИЕ", yPos)
yPos = yPos + 25

-- Дистанция
local distanceSlider, distanceLabel = createSlider("MaxDistance", "Дистанция", 1, 1000, SETTINGS.MaxDistance, yPos)
yPos = yPos + 50

-- Скорость наводки
local speedSlider, speedLabel = createSlider("AimSpeed", "Скорость наводки", 0.1, 1, SETTINGS.AimSpeed, yPos)
yPos = yPos + 50

createSection("НАСТРОЙКА КРУГА", yPos)
yPos = yPos + 25

-- Размер круга
local radiusSlider, radiusLabel = createSlider("CircleRadius", "Размер круга", 10, 500, SETTINGS.CircleRadius, yPos)
yPos = yPos + 50

-- Угол обзора
local fovSlider, fovLabel = createSlider("CircleFOV", "Угол обзора", 1, 360, SETTINGS.CircleFOV, yPos)
yPos = yPos + 50

-- Позиция X
local posXSlider, posXLabel = createSlider("CircleX", "Позиция X", 0, 1, SETTINGS.CircleX, yPos, true)
yPos = yPos + 50

-- Позиция Y
local posYSlider, posYLabel = createSlider("CircleY", "Позиция Y", 0, 1, SETTINGS.CircleY, yPos, true)

-- Добавляем все в GUI
titleBar.Parent = mainMenu
title.Parent = titleBar
closeButton.Parent = titleBar
minimizeButton.Parent = titleBar
mainMenu.Parent = screenGui
aimButton.Parent = screenGui
aimCircle.Parent = screenGui
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

-- Обработка главной кнопки
aimButton.MouseButton1Click:Connect(function()
    if not SETTINGS.AimBotEnabled then return end
    
    local isActive = aimButton.Text:find("ON")
    
    if isActive then
        aimButton.Text = "🎯\nOFF"
        aimButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        aimCircle.Visible = false
    else
        aimButton.Text = "🎯\nON"
        aimButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        aimCircle.Visible = true
    end
end)

-- Функция проверки находится ли цель в круге
function isTargetInCircle(targetPart)
    local character = player.Character
    if not character or not targetPart then return false end
    
    local camera = workspace.CurrentCamera
    local targetScreenPos, visible = camera:WorldToViewportPoint(targetPart.Position)
    
    if not visible then return false end
    
    -- Получаем позицию круга на экране
    local circleScreenPos = Vector2.new(
        camera.ViewportSize.X * SETTINGS.CircleX,
        camera.ViewportSize.Y * SETTINGS.CircleY
    )
    
    local targetPos = Vector2.new(targetScreenPos.X, targetScreenPos.Y)
    local distance = (targetPos - circleScreenPos).Magnitude
    
    -- Если FOV = 360, то цель всегда в круге
    if SETTINGS.CircleFOV == 360 then
        return true
    end
    
    -- Проверяем расстояние до центра круга
    return distance <= (SETTINGS.CircleRadius / 2)
end

-- Функции Aim Bot
function checkVisibility(targetPart)
    if SETTINGS.ThroughWalls then return true end
    
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
                local inCircle = isTargetInCircle(head)
                local visible = checkVisibility(head)
                
                if distance <= closestDistance and inCircle and visible then
                    closestDistance = distance
                    closestTarget = head
                end
            end
        end
    end
    
    return closestTarget
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
function createESP(targetPlayer)
    if espFolders[targetPlayer] then return espFolders[targetPlayer] end
    
    local folder = Instance.new("Folder")
    folder.Name = targetPlayer.Name .. "_ESP"
    espFolders[targetPlayer] = folder
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 12
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.Size = UDim2.new(0, 100, 0, 20)
    nameLabel.Visible = false
    
    nameLabel.Parent = folder
    folder.Parent = screenGui
    
    return folder
end

function updateESP()
    if not SETTINGS.ESPEnabled then
        clearESP()
        return
    end
    
    local character = player.Character
    if not character then return end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    for targetPlayer, folder in pairs(espFolders) do
        if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("Humanoid") or targetPlayer.Character.Humanoid.Health <= 0 then
            folder:Destroy()
            espFolders[targetPlayer] = nil
        end
    end
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local targetChar = otherPlayer.Character
            local humanoid = targetChar:FindFirstChild("Humanoid")
            local head = targetChar:FindFirstChild("Head")
            
            if head and humanoid and humanoid.Health > 0 then
                local folder = createESP(otherPlayer)
                local nameLabel = folder:FindFirstChild("NameLabel")
                
                if nameLabel then
                    local distance = (root.Position - head.Position).Magnitude
                    local isVisible = checkVisibility(head)
                    
                    local camera = workspace.CurrentCamera
                    local screenPoint, onScreen = camera:WorldToViewportPoint(head.Position)
                    
                    if onScreen then
                        local color = isVisible and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                        
                        nameLabel.Visible = true
                        nameLabel.TextColor3 = color
                        
                        local shortName = otherPlayer.Name
                        if #shortName > 8 then shortName = string.sub(shortName, 1, 8)..".." end
                        
                        nameLabel.Text = string.format("%s [%.0f]", shortName, distance)
                        nameLabel.Position = UDim2.new(0, screenPoint.X - 50, 0, screenPoint.Y - 35)
                    else
                        nameLabel.Visible = false
                    end
                end
            end
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
    -- Aim Bot
    local isActive = aimButton.Text:find("ON") and SETTINGS.AimBotEnabled
    
    if isActive then
        local target = findTarget()
        
        if target then
            -- Проверка срыва прицела
       if SETTINGS.CanBreakAim and isAiming then
                if not isTargetInCircle(target) then
                    isAiming = false
                    currentTarget = nil
                    return
                end
            end
            
            currentTarget = target
            isAiming = true
            aimAtTarget(target)
        else
            currentTarget = nil
            isAiming = false
        end
    else
        currentTarget = nil
        isAiming = false
    end
    
    -- ESP
    updateESP()
end)

-- Очистка
Players.PlayerRemoving:Connect(function(leftPlayer)
    if espFolders[leftPlayer] then
        espFolders[leftPlayer]:Destroy()
        espFolders[leftPlayer] = nil
    end
end)

player.CharacterAdded:Connect(function()
    clearESP()
end)

-- Инициализация
aimCircle.Size = UDim2.new(0, SETTINGS.CircleRadius, 0, SETTINGS.CircleRadius)
aimCircle.Position = UDim2.new(SETTINGS.CircleX, 0, SETTINGS.CircleY, 0)

print("🎯 AIM BOT ЗАГРУЖЕНО!")
print("Один режим с настраиваемым кругом")
print("FOV 360 = прицел везде")
print("Круг можно двигать и менять размер")
