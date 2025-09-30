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
mainMenu.Size = UDim2.new(0, 320, 0, 420)
mainMenu.Position = UDim2.new(0.5, -160, 0.5, -210)
mainMenu.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainMenu.BackgroundTransparency = 0.8  -- Прозрачный
mainMenu.BorderSizePixel = 2
mainMenu.BorderColor3 = Color3.fromRGB(255, 50, 50)
mainMenu.Visible = true
mainMenu.Active = true
mainMenu.Draggable = true  -- Можно перемещать

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

-- Кнопка Rage (появляется когда включен aim bot)
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

-- Кнопка свернуть/развернуть меню (маленькая подвижная)
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
toggleMenuButton.Draggable = true  -- Подвижная кнопка

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0.2, 0)
toggleCorner.Parent = toggleMenuButton

-- Настройки
local SETTINGS = {
    AimBotEnabled = false,
    RageEnabled = false,
    ThroughWalls = true,  -- Всегда работает
    ESPEnabled = true,
    MaxDistance = 500,
    AimSpeed = 0.3,  -- Скорость наводки
    CanBreakAim = true,
    MenuVisible = true
}

-- Создаем элементы меню
local function createButton(text, yPos, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 35)
    button.Position = UDim2.new(0, 10, 0, yPos)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.BackgroundTransparency = 0.5
    button.BorderSizePixel = 1
    button.BorderColor3 = Color3.fromRGB(100, 100, 100)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 12
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0.05, 0)
    buttonCorner.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    button.Parent = mainMenu
    
    return button
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

-- Создаем элементы меню
local yPos = 40

-- Включить Aim Bot
createToggle("AimBotEnabled", "Включить Aim Bot", SETTINGS.AimBotEnabled, yPos)
yPos = yPos + 30

-- ESP
createToggle("ESPEnabled", "ESP", SETTINGS.ESPEnabled, yPos)
yPos = yPos + 30

-- Срыв Aim Bot
createToggle("CanBreakAim", "Срыв Aim Bot", SETTINGS.CanBreakAim, yPos)
yPos = yPos + 30

-- Дистанция
local distanceSlider, distanceLabel = createSlider("MaxDistance", "Дистанция", 1, 1000, SETTINGS.MaxDistance, yPos)
yPos = yPos + 50

-- Скорость наводки
local speedSlider, speedLabel = createSlider("AimSpeed", "Скорость наводки", 0.1, 1, SETTINGS.AimSpeed, yPos)
yPos = yPos + 50

-- Информация
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -20, 0, 40)
infoLabel.Position = UDim2.new(0, 10, 0, yPos)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Наводка сквозь стены: ВКЛ"
infoLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
infoLabel.TextSize = 11
infoLabel.TextXAlignment = Enum.TextXAlignment.Center
infoLabel.Parent = mainMenu
yPos = yPos + 45

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
local isAiming = false
local espFolders = {}

-- Функции Aim Bot
function checkVisibility(targetPart)
    if SETTINGS.ThroughWalls then return true end  -- Всегда true
    
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

-- Основной цикл
RunService.RenderStepped:Connect(function()
    if SETTINGS.AimBotEnabled and SETTINGS.RageEnabled then
        local target, distance = findTarget()
        
        if target then
            -- Проверка срыва прицела
            if SETTINGS.CanBreakAim and isAiming then
                local camera = workspace.CurrentCamera
                local screenPoint = camera:WorldToViewportPoint(target.Position)
                local center = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
                local targetPos = Vector2.new(screenPoint.X, screenPoint.Y)
                
                if (targetPos - center).Magnitude > 50 then
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
        isAiming = false
        currentTarget = nil
    end
end)

print("🎯 AIM BOT MENU ЗАГРУЖЕНО!")
print("Дизайн: прозрачный с бортами")
print("Настройки:")
print("- Наводка сквозь стены: ВСЕГДА ВКЛ")
print("- Скорость наводки: 0.1-1")
print("- Подвижная кнопка меню")
