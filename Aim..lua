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
mainMenu.Size = UDim2.new(0, 300, 0, 380)
mainMenu.Position = UDim2.new(0.5, -150, 0.5, -190)
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

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.6, 0, 1, 0)
title.Position = UDim2.new(0.2, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🎯 AIM BOT"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 14
title.Font = Enum.Font.GothamBold

-- Кнопки управления
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

-- Кнопка Rage (только для Rage режима)
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

-- Кольцо для Legit режима
local legitCircle = Instance.new("Frame")
legitCircle.Size = UDim2.new(0, 50, 0, 50)
legitCircle.AnchorPoint = Vector2.new(0.5, 0.5)
legitCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
legitCircle.BackgroundTransparency = 1
legitCircle.BorderSizePixel = 2
legitCircle.BorderColor3 = Color3.fromRGB(0, 255, 0)
legitCircle.Visible = false

local circleCorner = Instance.new("UICorner")
circleCorner.CornerRadius = UDim.new(1, 0)
circleCorner.Parent = legitCircle

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
    Mode = "Legit", -- "Legit" или "Rage"
    RageEnabled = false,
    ThroughWalls = false,
    ESPEnabled = true,
    MaxDistance = 500,
    AimSpeed = 0.3,
    CircleRadius = 50, -- Ширина кольца для Legit
    CanBreakAim = true, -- Срыв аим бота
    MenuVisible = true
}

-- Переменные для ESP
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
            updateModeVisuals()
            if not SETTINGS[settingName] then
                SETTINGS.RageEnabled = false
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
            
            if settingName == "CircleRadius" then
                legitCircle.Size = UDim2.new(0, num, 0, num)
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

-- Переключатель режимов
local function createModeSwitch(yPos)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -20, 0, 30)
    container.Position = UDim2.new(0, 10, 0, yPos)
    container.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.Text = "Режим:"
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    
    local legitButton = Instance.new("TextButton")
    legitButton.Size = UDim2.new(0, 60, 0, 25)
    legitButton.Position = UDim2.new(0.4, 0, 0, 0)
    legitButton.BackgroundColor3 = SETTINGS.Mode == "Legit" and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(100, 100, 100)
    legitButton.Text = "LEGIT"
    legitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    legitButton.TextSize = 9
    
    local rageButton = Instance.new("TextButton")
    rageButton.Size = UDim2.new(0, 60, 0, 25)
    rageButton.Position = UDim2.new(0.7, 0, 0, 0)
    rageButton.BackgroundColor3 = SETTINGS.Mode == "Rage" and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(100, 100, 100)
    rageButton.Text = "RAGE"
    rageButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    rageButton.TextSize = 9
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0.2, 0)
    buttonCorner.Parent = legitButton
    buttonCorner:Clone().Parent = rageButton
    
    legitButton.MouseButton1Click:Connect(function()
        SETTINGS.Mode = "Legit"
        legitButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        rageButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        updateModeVisuals()
    end)
    
    rageButton.MouseButton1Click:Connect(function()
        SETTINGS.Mode = "Rage"
        rageButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        legitButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        updateModeVisuals()
    end)
    
    container.Parent = mainMenu
    label.Parent = container
    legitButton.Parent = container
    rageButton.Parent = container
    
    return container
end

-- Создаем элементы меню
local yPos = 40

-- Включить Aim Bot
createToggle("AimBotEnabled", "Включить Aim Bot", SETTINGS.AimBotEnabled, yPos)
yPos = yPos + 30

-- Переключатель режимов
createModeSwitch(yPos)
yPos = yPos + 35

-- Наводка сквозь стены
createToggle("ThroughWalls", "Наводка сквозь стены", SETTINGS.ThroughWalls, yPos)
yPos = yPos + 30

-- ESP
createToggle("ESPEnabled", "ESP", SETTINGS.ESPEnabled, yPos)
yPos = yPos + 30

-- Срыв аим бота
createToggle("CanBreakAim", "Срыв аим бота", SETTINGS.CanBreakAim, yPos)
yPos = yPos + 30

-- Дистанция
local distanceSlider, distanceLabel = createSlider("MaxDistance", "Дистанция", 1, 1000, SETTINGS.MaxDistance, yPos)
yPos = yPos + 50

-- Скорость наводки
local speedSlider, speedLabel = createSlider("AimSpeed", "Скорость наводки", 0.1, 1, SETTINGS.AimSpeed, yPos)
yPos = yPos + 50

-- Ширина кольца (только для Legit)
local circleSlider, circleLabel = createSlider("CircleRadius", "Ширина кольца", 10, 200, SETTINGS.CircleRadius, yPos)

-- Добавляем все в GUI
titleBar.Parent = mainMenu
title.Parent = titleBar
closeButton.Parent = titleBar
minimizeButton.Parent = titleBar
mainMenu.Parent = screenGui
rageButton.Parent = screenGui
legitCircle.Parent = screenGui
toggleMenuButton.Parent = screenGui
screenGui.Parent = playerGui

-- Функция обновления визуалов режимов
function updateModeVisuals()
    if SETTINGS.AimBotEnabled then
        if SETTINGS.Mode == "Legit" then
            rageButton.Visible = false
            legitCircle.Visible = true
            SETTINGS.RageEnabled = false
        else -- Rage режим
            rageButton.Visible = true
            legitCircle.Visible = false
        end
    else
        rageButton.Visible = false
        legitCircle.Visible = false
        SETTINGS.RageEnabled = false
    end
    
    -- Обновляем кнопку Rage
    if SETTINGS.RageEnabled then
        rageButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        rageButton.Text = "🔥\nON"
    else
        rageButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        rageButton.Text = "🔥\nRAGE"
    end
end

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
    if not SETTINGS.AimBotEnabled or SETTINGS.Mode ~= "Rage" then return end
    
    SETTINGS.RageEnabled = not SETTINGS.RageEnabled
    updateModeVisuals()
end)

-- Функции Aim Bot
function checkVisibility(targetPart)
    if SETTINGS.ThroughWalls then 
        return true
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

-- Поиск цели для Legit режима (внутри кольца)
function findTargetLegit()
    local character = player.Character
    if not character then return nil end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    
    local camera = workspace.CurrentCamera
    local centerScreen = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    
    local closestTarget = nil
    local closestDistance = SETTINGS.CircleRadius
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local targetChar = otherPlayer.Character
            local humanoid = targetChar:FindFirstChild("Humanoid")
            local head = targetChar:FindFirstChild("Head")
            
            if head and humanoid and humanoid.Health > 0 then
                local screenPoint, visible = camera:WorldToViewportPoint(head.Position)
                
                if visible then
                    local targetPos = Vector2.new(screenPoint.X, screenPoint.Y)
                    local distanceFromCenter = (targetPos - centerScreen).Magnitude
                    local worldDistance = (root.Position - head.Position).Magnitude
                    
                    if distanceFromCenter <= closestDistance and worldDistance <= SETTINGS.MaxDistance and checkVisibility(head) then
                        closestDistance = distanceFromCenter
                        closestTarget = head
                    end
                end
            end
        end
    end
    
    return closestTarget
end

-- Поиск цели для Rage режима (любая видимая цель)
function findTargetRage()
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

-- ESP функции (оставляем как было)
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
    if SETTINGS.AimBotEnabled then
        local target = nil
        
        if SETTINGS.Mode == "Legit" then
            -- Legit режим: ищем цели только внутри кольца
            target = findTargetLegit()
        elseif SETTINGS.Mode == "Rage" and SETTINGS.RageEnabled then
            -- Rage режим: ищем любые видимые цели
            target = findTargetRage()
        end
        
        if target then
            -- Проверка срыва прицела для Legit режима
            if SETTINGS.Mode == "Legit" and SETTINGS.CanBreakAim and isAiming then
                local camera = workspace.CurrentCamera
                local screenPoint = camera:WorldToViewportPoint(target.Position)
                local center = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
                local targetPos = Vector2.new(screenPoint.X, screenPoint.Y)
                
                if (targetPos - center).Magnitude > SETTINGS.CircleRadius then
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
legitCircle.Size = UDim2.new(0, SETTINGS.CircleRadius, 0, SETTINGS.CircleRadius)
updateModeVisuals()

print("🎯 AIM BOT MENU ЗАГРУЖЕНО!")
print("Два режима: Legit и Rage")
print("Legit: кольцо + срыв аим бота")
print("Rage: кнопка Rage + 360° прицел")
