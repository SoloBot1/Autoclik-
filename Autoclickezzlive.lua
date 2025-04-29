local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Настройки эффектов
local FX = {
    colors = {
        background = Color3.fromRGB(20, 20, 30),
        header = Color3.fromRGB(15, 15, 25),
        button = Color3.fromRGB(40, 40, 60),
        buttonHover = Color3.fromRGB(60, 60, 90),
        toggleOn = Color3.fromRGB(85, 255, 127),
        toggleOff = Color3.fromRGB(255, 85, 85),
        accent = Color3.fromRGB(0, 162, 255),
        text = Color3.fromRGB(240, 240, 255)
    },
    sounds = {
        click = "rbxassetid://9046897032",  -- Мягкий клик
        toggle = "rbxassetid://9046898627", -- Электронный звук
        error = "rbxassetid://9046899801"   -- Короткий бип
    },
    animations = {
        speed = 0.15, -- Скорость анимаций
        hoverScale = 1.05 -- Эффект увеличения при наведении
    }
}

-- Создание звуков
local function createSound(id, volume)
    local sound = Instance.new("Sound")
    sound.SoundId = id
    sound.Volume = volume or 0.5
    sound.Parent = SoundService
    return sound
end

local sounds = {
    clickSound = createSound(FX.sounds.click, 0.3),
    toggleSound = createSound(FX.sounds.toggle, 0.4),
    errorSound = createSound(FX.sounds.error, 0.3)
}

-- Создание GUI с эффектом появления
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateFXAutoClicker"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

-- Основной контейнер с эффектом свечения
local MainContainer = Instance.new("Frame")
MainContainer.Size = UDim2.new(0, 360, 0, 400)
MainContainer.Position = UDim2.new(0.5, -180, 0.5, -200)
MainContainer.BackgroundTransparency = 1
MainContainer.Parent = ScreenGui

-- Эффект свечения
local GlowEffect = Instance.new("ImageLabel")
GlowEffect.Size = UDim2.new(1, 20, 1, 20)
GlowEffect.Position = UDim2.new(0, -10, 0, -10)
GlowEffect.Image = "rbxassetid://8992231221"
GlowEffect.ImageColor3 = FX.colors.accent
GlowEffect.ScaleType = Enum.ScaleType.Slice
GlowEffect.SliceCenter = Rect.new(100, 100, 100, 100)
GlowEffect.BackgroundTransparency = 1
GlowEffect.ImageTransparency = 0.8
GlowEffect.Parent = MainContainer

-- Основной фрейм
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(1, 0, 1, 0)
MainFrame.BackgroundColor3 = FX.colors.background
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = MainContainer

-- Скругление углов с анимацией
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 14)
UICorner.Parent = MainFrame

-- Эффект градиента
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, FX.colors.background),
    ColorSequenceKeypoint.new(1, Color3.new(
        FX.colors.background.R * 1.3,
        FX.colors.background.G * 1.3,
        FX.colors.background.B * 1.3
    ))
})
Gradient.Rotation = 90
Gradient.Parent = MainFrame

-- Тень с эффектом параллакса
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = FX.colors.accent
UIStroke.Thickness = 2
UIStroke.Transparency = 0.7
UIStroke.Parent = MainFrame

-- Анимация появления
MainContainer.Size = UDim2.new(0, 0, 0, 0)
MainContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
TweenService:Create(MainContainer, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
    Size = UDim2.new(0, 360, 0, 400),
    Position = UDim2.new(0.5, -180, 0.5, -200)
}):Play()

-- Заголовок с эффектом сияния
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 60)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = FX.colors.header
Title.Text = "ULTIMATE FX CLICKER"
Title.TextColor3 = FX.colors.text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.PaddingLeft = UDim.new(0, 20)
Title.Parent = MainFrame

-- Скругление только сверху
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 14)
TitleCorner.Parent = Title

-- Эффект сияния текста
local TextGlow = Instance.new("UIGradient")
TextGlow.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, FX.colors.text),
    ColorSequenceKeypoint.new(0.5, FX.colors.accent),
    ColorSequenceKeypoint.new(1, FX.colors.text)
})
TextGlow.Rotation = 90
TextGlow.Parent = Title

-- Кнопка закрытия с эффектом наведения
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 36, 0, 36)
CloseButton.Position = UDim2.new(1, -42, 0, 12)
CloseButton.BackgroundColor3 = FX.colors.toggleOff
CloseButton.Text = "×"
CloseButton.TextColor3 = FX.colors.text
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 24
CloseButton.ZIndex = 2
CloseButton.Parent = Title

-- Эффект пульсации для кнопки закрытия
local pulseThread = coroutine.create(function()
    while true do
        TweenService:Create(CloseButton, TweenInfo.new(1, Enum.EasingStyle.Sine), {
            BackgroundColor3 = Color3.new(
                FX.colors.toggleOff.R * 1.2,
                FX.colors.toggleOff.G * 1.2,
                FX.colors.toggleOff.B * 1.2
            )
        }):Play()
        wait(1)
        TweenService:Create(CloseButton, TweenInfo.new(1, Enum.EasingStyle.Sine), {
            BackgroundColor3 = FX.colors.toggleOff
        }):Play()
        wait(1)
    end
end)
coroutine.resume(pulseThread)

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 18)
CloseCorner.Parent = CloseButton
-- Кнопка сворачивания с эффектом
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 36, 0, 36)
MinimizeButton.Position = UDim2.new(1, -84, 0, 12)
MinimizeButton.BackgroundColor3 = FX.colors.button
MinimizeButton.Text = "_"
MinimizeButton.TextColor3 = FX.colors.text
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 24
MinimizeButton.ZIndex = 2
MinimizeButton.Parent = Title

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 18)
MinimizeCorner.Parent = MinimizeButton

-- Кнопка редактирования с иконкой
local EditButton = Instance.new("TextButton")
EditButton.Size = UDim2.new(0, 36, 0, 36)
EditButton.Position = UDim2.new(1, -126, 0, 12)
EditButton.BackgroundColor3 = FX.colors.button
EditButton.Text = "✎"
EditButton.TextColor3 = FX.colors.text
EditButton.Font = Enum.Font.GothamBold
EditButton.TextSize = 18
MinimizeButton.ZIndex = 2
EditButton.Parent = Title

local EditCorner = Instance.new("UICorner")
EditCorner.CornerRadius = UDim.new(0, 18)
EditCorner.Parent = EditButton

-- Контейнер содержимого с эффектом прокрутки
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Size = UDim2.new(1, 0, 1, -60)
ContentFrame.Position = UDim2.new(0, 0, 0, 60)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ScrollBarThickness = 4
ContentFrame.ScrollBarImageColor3 = FX.colors.accent
ContentFrame.Parent = MainFrame

-- Функция для создания анимированных кнопок
local function createFXButton(name, size, position)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = size
    button.Position = position
    button.BackgroundColor3 = FX.colors.button
    button.TextColor3 = FX.colors.text
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.AutoButtonColor = false
    button.Parent = ContentFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = FX.colors.accent
    stroke.Thickness = 1
    stroke.Transparency = 0.7
    stroke.Parent = button
    
    -- Анимация наведения
    button.MouseEnter:Connect(function()
        sounds.clickSound:Play()
        TweenService:Create(button, TweenInfo.new(FX.animations.speed), {
            Size = size * UDim2.new(FX.animations.hoverScale, 0, FX.animations.hoverScale, 0),
            BackgroundColor3 = FX.colors.buttonHover,
            TextColor3 = FX.colors.accent
        }):Play()
        TweenService:Create(stroke, TweenInfo.new(FX.animations.speed), {
            Thickness = 2,
            Transparency = 0
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(FX.animations.speed), {
            Size = size,
            BackgroundColor3 = FX.colors.button,
            TextColor3 = FX.colors.text
        }):Play()
        TweenService:Create(stroke, TweenInfo.new(FX.animations.speed), {
            Thickness = 1,
            Transparency = 0.7
        }):Play()
    end)
    
    button.MouseButton1Down:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {
            Size = size * UDim2.new(0.95, 0, 0.95, 0)
        }):Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {
            Size = size * UDim2.new(FX.animations.hoverScale, 0, FX.animations.hoverScale, 0)
        }):Play()
    end)
    
    return button
end

-- Секция позиции клика с эффектом
local PositionSection = Instance.new("Frame")
PositionSection.Size = UDim2.new(1, -40, 0, 120)
PositionSection.Position = UDim2.new(0, 20, 0, 20)
PositionSection.BackgroundColor3 = FX.colors.header
PositionSection.Parent = ContentFrame

local PositionCorner = Instance.new("UICorner")
PositionCorner.CornerRadius = UDim.new(0, 12)
PositionCorner.Parent = PositionSection

-- Эффект внутреннего свечения
local InnerGlow = Instance.new("ImageLabel")
InnerGlow.Size = UDim2.new(1, 0, 1, 0)
InnerGlow.Image = "rbxassetid://8992231221"
InnerGlow.ImageColor3 = FX.colors.accent
InnerGlow.ScaleType = Enum.ScaleType.Slice
InnerGlow.SliceCenter = Rect.new(100, 100, 100, 100)
InnerGlow.BackgroundTransparency = 1
InnerGlow.ImageTransparency = 0.9
InnerGlow.Parent = PositionSection

local PositionTitle = Instance.new("TextLabel")
PositionTitle.Size = UDim2.new(1, -20, 0, 30)
PositionTitle.Position = UDim2.new(0, 10, 0, 5)
PositionTitle.BackgroundTransparency = 1
PositionTitle.Text = "CLICK POSITION"
PositionTitle.TextColor3 = FX.colors.text
PositionTitle.Font = Enum.Font.GothamBold
PositionTitle.TextXAlignment = Enum.TextXAlignment.Left
PositionTitle.Parent = PositionSection

-- Поля ввода с эффектом фокуса
local function createFXInput(name, position)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 120, 0, 36)
    frame.Position = position
    frame.BackgroundTransparency = 1
    frame.Parent = PositionSection
    
    local box = Instance.new("TextBox")
    box.Name = name
    box.Size = UDim2.new(1, 0, 1, 0)
    box.BackgroundColor3 = FX.colors.button
    box.TextColor3 = FX.colors.text
    box.Font = Enum.Font.Gotham
    box.PlaceholderColor3 = Color3.new(0.7, 0.7, 0.7)
    box.Text = "0"
    box.Parent = frame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = box
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = FX.colors.accent
    stroke.Thickness = 1
    stroke.Transparency = 0.7
    stroke.Parent = box
    
    -- Анимация фокуса
    box.Focused:Connect(function()
        sounds.clickSound:Play()
        TweenService:Create(box, TweenInfo.new(FX.animations.speed), {
            BackgroundColor3 = FX.colors.buttonHover
        }):Play()
        TweenService:Create(stroke, TweenInfo.new(FX.animations.speed), {
            Thickness = 2,
            Transparency = 0
        }):Play()
    end)
    
    box.FocusLost:Connect(function()
        TweenService:Create(box, TweenInfo.new(FX.animations.speed), {
            BackgroundColor3 = FX.colors.button
        }):Play()
        TweenService:Create(stroke, TweenInfo.new(FX.animations.speed), {
            Thickness = 1,
            Transparency = 0.7
        }):Play()
    end)
    
    return box
end

-- Создание полей ввода
local XLabel = Instance.new("TextLabel")
XLabel.Size = UDim2.new(0, 50, 0, 30)
XLabel.Position = UDim2.new(0, 20, 0, 45)
XLabel.BackgroundTransparency = 1
XLabel.Text = "X:"
XLabel.TextColor3 = FX.colors.text
XLabel.Font = Enum.Font.Gotham
XLabel.TextXAlignment = Enum.TextXAlignment.Left
XLabel.Parent = PositionSection

local XBox = createFXInput("XBox", UDim2.new(0, 140, 0, 45))

local YLabel = Instance.new("TextLabel")
YLabel.Size = UDim2.new(0, 50, 0, 30)
YLabel.Position = UDim2.new(0, 20, 0, 85)
YLabel.BackgroundTransparency = 1
YLabel.Text = "Y:"
YLabel.TextColor3 = FX.colors.text
YLabel.Font = Enum.Font.Gotham
YLabel.TextXAlignment = Enum.TextXAlignment.Left
YLabel.Parent = PositionSection
local YBox = createFXInput("YBox", UDim2.new(0, 140, 0, 85))
-- Кнопка установки позиции с эффектом
local SetPosButton = createFXButton("SetPosButton", UDim2.new(0, 180, 0, 40), UDim2.new(0, 170, 0, 40))
SetPosButton.Text = "SET POSITION BY CLICK"
SetPosButton.Font = Enum.Font.GothamBold

-- Секция настроек с эффектом
local SettingsSection = Instance.new("Frame")
SettingsSection.Size = UDim2.new(1, -40, 0, 110)
SettingsSection.Position = UDim2.new(0, 20, 0, 160)
SettingsSection.BackgroundColor3 = FX.colors.header
SettingsSection.Parent = ContentFrame

local SettingsCorner = Instance.new("UICorner")
SettingsCorner.CornerRadius = UDim.new(0, 12)
SettingsCorner.Parent = SettingsSection

-- Эффект внутреннего свечения
local SettingsGlow = InnerGlow:Clone()
SettingsGlow.Parent = SettingsSection

local SettingsTitle = Instance.new("TextLabel")
SettingsTitle.Size = UDim2.new(1, -20, 0, 30)
SettingsTitle.Position = UDim2.new(0, 10, 0, 5)
SettingsTitle.BackgroundTransparency = 1
SettingsTitle.Text = "SETTINGS"
SettingsTitle.TextColor3 = FX.colors.text
SettingsTitle.Font = Enum.Font.GothamBold
SettingsTitle.TextXAlignment = Enum.TextXAlignment.Left
SettingsTitle.Parent = SettingsSection

-- Настройка интервала
local IntervalLabel = Instance.new("TextLabel")
IntervalLabel.Size = UDim2.new(0, 120, 0, 30)
IntervalLabel.Position = UDim2.new(0, 20, 0, 45)
IntervalLabel.BackgroundTransparency = 1
IntervalLabel.Text = "INTERVAL (sec):"
IntervalLabel.TextColor3 = FX.colors.text
IntervalLabel.Font = Enum.Font.Gotham
IntervalLabel.TextXAlignment = Enum.TextXAlignment.Left
IntervalLabel.Parent = SettingsSection

local IntervalBox = createFXInput("IntervalBox", UDim2.new(0, 140, 0, 45))
IntervalBox.Text = "0.1"

-- Главная кнопка с эффектом переключения
local ToggleButton = createFXButton("ToggleButton", UDim2.new(1, -40, 0, 50), UDim2.new(0, 20, 0, 290))
ToggleButton.Text = "START AUTO CLICKER"
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 16

-- Индикатор состояния
local StatusIndicator = Instance.new("Frame")
StatusIndicator.Size = UDim2.new(0, 10, 0, 10)
StatusIndicator.Position = UDim2.new(1, -25, 0.5, -5)
StatusIndicator.BackgroundColor3 = FX.colors.toggleOff
StatusIndicator.Parent = ToggleButton

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 5)
StatusCorner.Parent = StatusIndicator

-- Эффект пульсации для индикатора
local pulseThread = coroutine.create(function()
    while true do
        TweenService:Create(StatusIndicator, TweenInfo.new(1, Enum.EasingStyle.Sine), {
            Size = UDim2.new(0, 12, 0, 12),
            Position = UDim2.new(1, -26, 0.5, -6)
        }):Play()
        wait(1)
        TweenService:Create(StatusIndicator, TweenInfo.new(1, Enum.EasingStyle.Sine), {
            Size = UDim2.new(0, 10, 0, 10),
            Position = UDim2.new(1, -25, 0.5, -5)
        }):Play()
        wait(1)
    end
end)
coroutine.resume(pulseThread)

-- Быстрая кнопка с эффектом
local QuickToggle = Instance.new("TextButton")
QuickToggle.Size = UDim2.new(0, FX.quickButtonSize, 0, FX.quickButtonSize)
QuickToggle.Position = UDim2.new(1, -FX.quickButtonSize-20, 1, -FX.quickButtonSize-20)
QuickToggle.BackgroundColor3 = FX.colors.toggleOff
QuickToggle.TextColor3 = FX.colors.text
QuickToggle.Text = FX.quickButtonIcon
QuickToggle.Font = Enum.Font.GothamBold
QuickToggle.TextSize = 24
QuickToggle.Visible = false
QuickToggle.ZIndex = 2
QuickToggle.Parent = ScreenGui

-- Эффект свечения для быстрой кнопки
local QuickGlow = Instance.new("ImageLabel")
QuickGlow.Size = UDim2.new(1, 10, 1, 10)
QuickGlow.Position = UDim2.new(0, -5, 0, -5)
QuickGlow.Image = "rbxassetid://8992231221"
QuickGlow.ImageColor3 = FX.colors.accent
QuickGlow.ScaleType = Enum.ScaleType.Slice
QuickGlow.SliceCenter = Rect.new(100, 100, 100, 100)
QuickGlow.BackgroundTransparency = 1
QuickGlow.ImageTransparency = 0.9
QuickGlow.Parent = QuickToggle

local QuickCorner = Instance.new("UICorner")
QuickCorner.CornerRadius = UDim.new(0, FX.quickButtonSize/2)
QuickCorner.Parent = QuickToggle

-- Маркер клика с эффектом
local ClickMarker = Instance.new("Frame")
ClickMarker.Size = UDim2.new(0, 16, 0, 16)
ClickMarker.AnchorPoint = Vector2.new(0.5, 0.5)
ClickMarker.BackgroundColor3 = FX.colors.toggleOff
ClickMarker.BorderSizePixel = 0
ClickMarker.Visible = false
ClickMarker.ZIndex = 2
ClickMarker.Parent = ScreenGui

-- Эффект пульсации для маркера
local markerThread = coroutine.create(function()
    while true do
        if ClickMarker.Visible then
            TweenService:Create(ClickMarker, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {
                Size = UDim2.new(0, 20, 0, 20)
            }):Play()
            wait(0.5)
            TweenService:Create(ClickMarker, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {
                Size = UDim2.new(0, 16, 0, 16)
            }):Play()
            wait(0.5)
        else
            wait(1)
        end
    end
end)
coroutine.resume(markerThread)

local MarkerCorner = Instance.new("UICorner")
MarkerCorner.CornerRadius = UDim.new(0, 8)
MarkerCorner.Parent = ClickMarker

-- Эффект свечения для маркера
local MarkerGlow = QuickGlow:Clone()
MarkerGlow.ImageColor3 = FX.colors.toggleOff
MarkerGlow.Parent = ClickMarker

-- Переменные состояния
local clickPosition = Vector2.new(0, 0)
local isRunning = false
local isMinimized = false
local isEditing = false
local connection
local lastClickTime = 0
local performanceWarningShown = false
-- Функция клика с эффектом
local function doClick()
    if not isRunning then return end
    
    local currentTime = tick()
    if currentTime - lastClickTime < 0.02 then
        if not performanceWarningShown then
            sounds.errorSound:Play()
            warn("Auto Clicker: Too fast clicks! May cause lag.")
            performanceWarningShown = true
            
            -- Эффект ошибки
            TweenService:Create(ToggleButton, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.new(1, 0.2, 0.2)
            }):Play()
            wait(0.1)
            TweenService:Create(ToggleButton, TweenInfo.new(0.3), {
                BackgroundColor3 = isRunning and FX.colors.toggleOn or FX.colors.toggleOff
            }):Play()
        end
        return
    end
    lastClickTime = currentTime
    
    -- Эффект клика
    ClickMarker.Size = UDim2.new(0, 24, 0, 24)
    TweenService:Create(ClickMarker, TweenInfo.new(0.2), {
        Size = UDim2.new(0, 16, 0, 16)
    }):Play()
    
    local vim = game:GetService("VirtualInputManager")
    vim:SendMouseButtonEvent(clickPosition.X, clickPosition.Y, 0, true, game, 1)
    task.wait(0.02)
    vim:SendMouseButtonEvent(clickPosition.X, clickPosition.Y, 0, false, game, 1)
end

-- Обновление маркера позиции
local function updateMarker()
    ClickMarker.Position = UDim2.new(0, clickPosition.X, 0, clickPosition.Y)
    ClickMarker.Visible = true
end

-- Установка позиции клика с эффектом
SetPosButton.MouseButton1Click:Connect(function()
    sounds.toggleSound:Play()
    clickPosition = Vector2.new(mouse.X, mouse.Y)
    XBox.Text = tostring(math.floor(clickPosition.X))
    YBox.Text = tostring(math.floor(clickPosition.Y))
    updateMarker()
    
    -- Эффект подтверждения
    local originalColor = SetPosButton.BackgroundColor3
    TweenService:Create(SetPosButton, TweenInfo.new(0.2), {
        BackgroundColor3 = FX.colors.toggleOn
    }):Play()
    wait(0.2)
    TweenService:Create(SetPosButton, TweenInfo.new(0.2), {
        BackgroundColor3 = originalColor
    }):Play()
end)

XBox.FocusLost:Connect(function()
    local x = tonumber(XBox.Text) or 0
    clickPosition = Vector2.new(x, clickPosition.Y)
    updateMarker()
end)

YBox.FocusLost:Connect(function()
    local y = tonumber(YBox.Text) or 0
    clickPosition = Vector2.new(clickPosition.Y, y)
    updateMarker()
end)

-- Включение/выключение кликера с эффектами
local function toggleAutoClicker(state)
    isRunning = state
    
    if isRunning then
        sounds.toggleSound:Play()
        ToggleButton.Text = "STOP AUTO CLICKER"
        ToggleButton.BackgroundColor3 = FX.colors.toggleOn
        StatusIndicator.BackgroundColor3 = FX.colors.toggleOn
        QuickToggle.BackgroundColor3 = FX.colors.toggleOn
        QuickToggle.Text = "⏸️"
        MarkerGlow.ImageColor3 = FX.colors.toggleOn
        
        local interval = tonumber(IntervalBox.Text) or 0.1
        if interval <= 0 then interval = 0.1 end
        
        if connection then
            connection:Disconnect()
        end
        
        connection = RunService.Heartbeat:Connect(function()
            doClick()
            task.wait(interval)
        end)
    else
        sounds.toggleSound:Play()
        ToggleButton.Text = "START AUTO CLICKER"
        ToggleButton.BackgroundColor3 = FX.colors.toggleOff
        StatusIndicator.BackgroundColor3 = FX.colors.toggleOff
        QuickToggle.BackgroundColor3 = FX.colors.toggleOff
        QuickToggle.Text = FX.quickButtonIcon
        MarkerGlow.ImageColor3 = FX.colors.toggleOff
        
        if connection then
            connection:Disconnect()
            connection = nil
        end
    end
end

-- Основные кнопки управления
ToggleButton.MouseButton1Click:Connect(function()
    toggleAutoClicker(not isRunning)
end)

QuickToggle.MouseButton1Click:Connect(function()
    if not isEditing then
        toggleAutoClicker(not isRunning)
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    sounds.clickSound:Play()
    local tween = TweenService:Create(MainContainer, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    tween:Play()
    tween.Completed:Wait()
    
    ScreenGui:Destroy()
    if connection then
        connection:Disconnect()
    end
end)

-- Сворачивание интерфейса
MinimizeButton.MouseButton1Click:Connect(function()
    sounds.clickSound:Play()
    isMinimized = not isMinimized
    
    if isMinimized then
        TweenService:Create(MainContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 200, 0, 60),
            Position = UDim2.new(1, -210, 0, 10)
        }):Play()
        QuickToggle.Visible = true
    else
        TweenService:Create(MainContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 360, 0, 400),
            Position = UDim2.new(0.5, -180, 0.5, -200)
        }):Play()
        QuickToggle.Visible = false
    end
end)

-- Режим редактирования быстрой кнопки
EditButton.MouseButton1Click:Connect(function()
    sounds.clickSound:Play()
    isEditing = not isEditing
    
    if isEditing then
        EditButton.BackgroundColor3 = FX.colors.accent
        QuickToggle.Text = "✎"
        
        -- Подсказка
        local hint = Instance.new("TextLabel")
        hint.Size = UDim2.new(0, 200, 0, 40)
        hint.Position = UDim2.new(0.5, -100, 0, -50)
        hint.Text = "Click where you want the button"
        hint.TextColor3 = FX.colors.text
        hint.BackgroundColor3 = FX.colors.header
        hint.Font = Enum.Font.Gotham
        hint.Parent = ScreenGui
        
        -- Анимация появления
        hint.TextTransparency = 1
        hint.BackgroundTransparency = 1
        TweenService:Create(hint, TweenInfo.new(0.3), {
            TextTransparency = 0,
            BackgroundTransparency = 0.5
        }):Play()
        
        -- Ожидание клика
        local inputConnection
        inputConnection = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                sounds.toggleSound:Play()
                local mousePos = UserInputService:GetMouseLocation()
                QuickToggle.Position = UDim2.new(0, mousePos.X - FX.quickButtonSize/2, 0, mousePos.Y - FX.quickButtonSize/2)
                
                -- Анимация перемещения
                QuickToggle.Size = UDim2.new(0, 0, 0, 0)
                TweenService:Create(QuickToggle, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                    Size = UDim2.new(0, FX.quickButtonSize, 0, FX.quickButtonSize)
                }):Play()
                
                -- Удаление подсказки
                TweenService:Create(hint, TweenInfo.new(0.3), {
                    TextTransparency = 1,
                    BackgroundTransparency = 1
                }):Play()
                wait(0.3)
                hint:Destroy()
                
                isEditing = false
                EditButton.BackgroundColor3 = FX.colors.button
                QuickToggle.Text = isRunning and "⏸️" or FX.quickButtonIcon
                inputConnection:Disconnect()
            end
        end)
    else
        EditButton.BackgroundColor3 = FX.colors.button
        QuickToggle.Text = isRunning and "⏸️" or FX.quickButtonIcon
    end
end)

-- Инициализация
updateMarker()
