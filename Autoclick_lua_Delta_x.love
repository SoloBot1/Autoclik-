local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Генератор уникального ID для сохранения настроек
local SAVE_ID = "AutoClicker_"..HttpService:GenerateGUID(false)

-- Премиальная цветовая палитра
local colorSchemes = {
    {
        name = "Neon Cyberpunk",
        main = Color3.fromRGB(20, 5, 40),
        secondary = Color3.fromRGB(80, 0, 120),
        accent = Color3.fromRGB(0, 200, 255),
        text = Color3.fromRGB(255, 255, 255),
        success = Color3.fromRGB(0, 255, 100),
        warning = Color3.fromRGB(255, 100, 0),
        error = Color3.fromRGB(255, 30, 30)
    },
    {
        name = "Dark Elegance",
        main = Color3.fromRGB(15, 15, 25),
        secondary = Color3.fromRGB(40, 40, 60),
        accent = Color3.fromRGB(170, 120, 255),
        text = Color3.fromRGB(230, 230, 230),
        success = Color3.fromRGB(120, 255, 150),
        warning = Color3.fromRGB(255, 180, 50),
        error = Color3.fromRGB(255, 80, 80)
    },
    {
        name = "Ocean Depth",
        main = Color3.fromRGB(5, 15, 30),
        secondary = Color3.fromRGB(10, 40, 70),
        accent = Color3.fromRGB(0, 180, 255),
        text = Color3.fromRGB(220, 240, 255),
        success = Color3.fromRGB(0, 230, 200),
        warning = Color3.fromRGB(255, 150, 0),
        error = Color3.fromRGB(255, 70, 90)
    }
}

local currentScheme = 1
local settings = {
    clickSound = true,
    animationEffects = true,
    clickParticles = true,
    savePosition = true
}

-- Загрузка сохраненных настроек
local function LoadSettings()
    local success, saved = pcall(function()
        return HttpService:JSONDecode(readfile(SAVE_ID..".json"))
    end)
    if success and saved then
        currentScheme = saved.colorScheme or 1
        settings = saved.settings or settings
        return saved.quickTogglePosition or UDim2.new(1, -65, 1, -65)
    end
    return UDim2.new(1, -65, 1, -65)
end

-- Сохранение настроек
local function SaveSettings(position)
    local data = {
        colorScheme = currentScheme,
        settings = settings,
        quickTogglePosition = position
    }
    writefile(SAVE_ID..".json", HttpService:JSONEncode(data))
end

-- Создание звукового эффекта
local clickSound = Instance.new("Sound")
clickSound.SoundId = "rbxassetid://3570577707" -- Стандартный звук клика
clickSound.Volume = 0.4
clickSound.Parent = SoundService

-- Создание частиц для кликов
local clickParticles = Instance.new("ParticleEmitter")
clickParticles.LightEmission = 0.8
clickParticles.Size = NumberSequence.new(0.2)
clickParticles.Texture = "rbxassetid://296874871"
clickParticles.Lifetime = NumberRange.new(0.3)
clickParticles.Speed = NumberRange.new(5)
clickParticles.Rate = 20
clickParticles.Enabled = false
-- Создание основного GUI с эффектом стекла
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PremiumAutoClickerFX"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game.CoreGui

-- Основной контейнер с эффектом размытого стекла
local MainContainer = Instance.new("Frame")
MainContainer.Size = UDim2.new(0, 360, 0, 400)
MainContainer.Position = UDim2.new(0.5, -180, 0.5, -200)
MainContainer.BackgroundColor3 = colorSchemes[currentScheme].main
MainContainer.BackgroundTransparency = 0.15
MainContainer.BorderSizePixel = 0
MainContainer.ClipsDescendants = true
MainContainer.Active = true
MainContainer.Draggable = true
MainContainer.Parent = ScreenGui

-- Эффект стекла (размытие)
local GlassEffect = Instance.new("ImageLabel")
GlassEffect.Size = UDim2.new(1, 0, 1, 0)
GlassEffect.BackgroundTransparency = 1
GlassEffect.Image = "rbxassetid://2990522939"
GlassEffect.ImageTransparency = 0.9
GlassEffect.ScaleType = Enum.ScaleType.Slice
GlassEffect.SliceCenter = Rect.new(100, 100, 100, 100)
GlassEffect.Parent = MainContainer

-- Скругление углов
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 14)
UICorner.Parent = MainContainer

-- Тень с анимацией
local DropShadow = Instance.new("ImageLabel")
DropShadow.Name = "DropShadow"
DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
DropShadow.BackgroundTransparency = 1
DropShadow.Position = UDim2.new(0.5, 0, 0.5, 4)
DropShadow.Size = UDim2.new(1, 24, 1, 24)
DropShadow.Image = "rbxassetid://2990522939"
DropShadow.ImageColor3 = Color3.new(0, 0, 0)
DropShadow.ImageTransparency = 0.8
DropShadow.ScaleType = Enum.ScaleType.Slice
DropShadow.SliceCenter = Rect.new(100, 100, 100, 100)
DropShadow.SliceScale = 0.04
DropShadow.ZIndex = -1
DropShadow.Parent = MainContainer

-- Анимация тени при наведении
MainContainer.MouseEnter:Connect(function()
    TweenService:Create(DropShadow, TweenInfo.new(0.3), {
        ImageTransparency = 0.7,
        Size = UDim2.new(1, 28, 1, 28)
    }):Play()
end)

MainContainer.MouseLeave:Connect(function()
    TweenService:Create(DropShadow, TweenInfo.new(0.3), {
        ImageTransparency = 0.8,
        Size = UDim2.new(1, 24, 1, 24)
    }):Play()
end)

-- Заголовок с градиентом
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = colorSchemes[currentScheme].secondary
TitleBar.BackgroundTransparency = 0.3
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainContainer

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 14)
TitleCorner.Parent = TitleBar

-- Градиент для заголовка
local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, colorSchemes[currentScheme].secondary),
    ColorSequenceKeypoint.new(1, colorSchemes[currentScheme].accent)
})
TitleGradient.Rotation = 90
TitleGradient.Parent = TitleBar

-- Текст заголовка с эффектом свечения
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -100, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "AUTO CLICKER DELUXE"
TitleLabel.TextColor3 = colorSchemes[currentScheme].text
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 18
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- Эффект свечения текста
local TextGlow = Instance.new("ImageLabel")
TextGlow.Size = UDim2.new(1, 10, 1, 10)
TextGlow.Position = UDim2.new(0, -5, 0, -5)
TextGlow.BackgroundTransparency = 1
TextGlow.Image = "rbxassetid://5028857084"
TextGlow.ImageColor3 = colorSchemes[currentScheme].accent
TextGlow.ImageTransparency = 0.9
TextGlow.ScaleType = Enum.ScaleType.Slice
TextGlow.SliceCenter = Rect.new(24, 24, 24, 24)
TextGlow.Parent = TitleLabel

-- Кнопка закрытия с анимацией
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 34, 0, 34)
CloseButton.Position = UDim2.new(1, -40, 0.5, -17)
CloseButton.AnchorPoint = Vector2.new(1, 0.5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 20
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

-- Анимация кнопки закрытия
CloseButton.MouseEnter:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(255, 120, 120),
        Size = UDim2.new(0, 36, 0, 36),
        Position = UDim2.new(1, -39, 0.5, -18)
    }):Play()
end)

CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(255, 80, 80),
        Size = UDim2.new(0, 34, 0, 34),
        Position = UDim2.new(1, -40, 0.5, -17)
    }):Play()
end)
-- Контейнер содержимого
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -70)
ContentFrame.Position = UDim2.new(0, 10, 0, 60)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainContainer

-- Индикатор загрузки (анимированный)
local LoadingIndicator = Instance.new("Frame")
LoadingIndicator.Size = UDim2.new(1, 0, 0, 3)
LoadingIndicator.Position = UDim2.new(0, 0, 0, -3)
LoadingIndicator.BackgroundColor3 = colorSchemes[currentScheme].accent
LoadingIndicator.BorderSizePixel = 0
LoadingIndicator.Parent = ContentFrame

local LoadingAnimation = Instance.new("Frame")
LoadingAnimation.Size = UDim2.new(0, 100, 1, 0)
LoadingAnimation.BackgroundColor3 = colorSchemes[currentScheme].text
LoadingAnimation.BorderSizePixel = 0
LoadingAnimation.Parent = LoadingIndicator

-- Анимация загрузки
coroutine.wrap(function()
    while true do
        TweenService:Create(LoadingAnimation, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {
            Position = UDim2.new(1, -100, 0, 0)
        }):Play()
        wait(1.5)
        LoadingAnimation.Position = UDim2.new(0, 0, 0, 0)
        wait(0.5)
    end
end)()

-- Секция позиции клика
local PositionSection = Instance.new("Frame")
PositionSection.Size = UDim2.new(1, 0, 0, 120)
PositionSection.BackgroundColor3 = colorSchemes[currentScheme].secondary
PositionSection.BackgroundTransparency = 0.7
PositionSection.Parent = ContentFrame

local PositionCorner = Instance.new("UICorner")
PositionCorner.CornerRadius = UDim.new(0, 10)
PositionCorner.Parent = PositionSection

-- Визуальный разделитель
local SectionDivider = Instance.new("Frame")
SectionDivider.Size = UDim2.new(1, -20, 0, 1)
SectionDivider.Position = UDim2.new(0, 10, 0, 40)
SectionDivider.BackgroundColor3 = colorSchemes[currentScheme].accent
SectionDivider.BackgroundTransparency = 0.7
SectionDivider.BorderSizePixel = 0
SectionDivider.Parent = PositionSection

-- Поля ввода с анимацией фокуса
local function CreateInputField(name, positionY)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -20, 0, 30)
    container.Position = UDim2.new(0, 10, 0, positionY)
    container.BackgroundTransparency = 1
    container.Parent = PositionSection
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 30, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name..":"
    label.TextColor3 = colorSchemes[currentScheme].text
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local inputFrame = Instance.new("Frame")
    inputFrame.Size = UDim2.new(0, 100, 1, 0)
    inputFrame.Position = UDim2.new(0, 40, 0, 0)
    inputFrame.BackgroundColor3 = colorSchemes[currentScheme].secondary
    inputFrame.BackgroundTransparency = 0.8
    inputFrame.Parent = container
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 6)
    inputCorner.Parent = inputFrame
    
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1, -10, 1, -6)
    textBox.Position = UDim2.new(0, 5, 0, 3)
    textBox.BackgroundTransparency = 1
    textBox.TextColor3 = colorSchemes[currentScheme].text
    textBox.Font = Enum.Font.Gotham
    textBox.TextSize = 14
    textBox.Text = "0"
    textBox.Parent = inputFrame
    
    -- Анимация фокуса
    textBox.Focused:Connect(function()
        TweenService:Create(inputFrame, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.6,
            BackgroundColor3 = colorSchemes[currentScheme].accent
        }):Play()
    end)
    
    textBox.FocusLost:Connect(function()
        TweenService:Create(inputFrame, TweenInfo.new(0.3), {
            BackgroundTransparency = 0.8,
            BackgroundColor3 = colorSchemes[currentScheme].secondary
        }):Play()
    end)
    
    return textBox
end

local XBox = CreateInputField("X", 50)
local YBox = CreateInputField("Y", 85)

-- Кнопка установки позиции
local SetPosButton = Instance.new("TextButton")
SetPosButton.Size = UDim2.new(0, 150, 0, 35)
SetPosButton.Position = UDim2.new(1, -160, 0, 50)
SetPosButton.AnchorPoint = Vector2.new(1, 0)
SetPosButton.BackgroundColor3 = colorSchemes[currentScheme].accent
SetPosButton.BackgroundTransparency = 0.7
SetPosButton.TextColor3 = colorSchemes[currentScheme].text
SetPosButton.Text = "SET POSITION"
SetPosButton.Font = Enum.Font.GothamBold
SetPosButton.TextSize = 14
SetPosButton.Parent = PositionSection

local SetPosCorner = Instance.new("UICorner")
SetPosCorner.CornerRadius = UDim.new(0, 8)
SetPosCorner.Parent = SetPosButton

-- Анимация кнопки
SetPosButton.MouseEnter:Connect(function()
    TweenService:Create(SetPosButton, TweenInfo.new(0.2), {
        BackgroundTransparency = 0.5,
        TextColor3 = colorSchemes[currentScheme].text
    }):Play()
end)

SetPosButton.MouseLeave:Connect(function()
    TweenService:Create(SetPosButton, TweenInfo.new(0.2), {
        BackgroundTransparency = 0.7,
        TextColor3 = colorSchemes[currentScheme].text
    }):Play()
end)

-- Маркер позиции клика
local ClickMarker = Instance.new("ImageLabel")
ClickMarker.Size = UDim2.new(0, 24, 0, 24)
ClickMarker.AnchorPoint = Vector2.new(0.5, 0.5)
ClickMarker.BackgroundTransparency = 1
ClickMarker.Image = "rbxassetid://3926305904"
ClickMarker.ImageRectOffset = Vector2.new(524, 204)
ClickMarker.ImageRectSize = Vector2.new(36, 36)
ClickMarker.ImageColor3 = colorSchemes[currentScheme].accent
ClickMarker.Visible = false
ClickMarker.ZIndex = 10
ClickMarker.Parent = ScreenGui

-- Эффект пульсации для маркера
coroutine.wrap(function()
    while true do
        TweenService:Create(ClickMarker, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            Size = UDim2.new(0, 28, 0, 28),
            ImageTransparency = 0.3
        }):Play()
        wait(0.8)
        TweenService:Create(ClickMarker, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            Size = UDim2.new(0, 24, 0, 24),
            ImageTransparency = 0
        }):Play()
        wait(0.8)
    end
end)()
-- Основная кнопка включения
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(1, -20, 0, 50)
ToggleButton.Position = UDim2.new(0, 10, 1, -70)
ToggleButton.AnchorPoint = Vector2.new(0, 1)
ToggleButton.BackgroundColor3 = colorSchemes[currentScheme].secondary
ToggleButton.BackgroundTransparency = 0.7
ToggleButton.TextColor3 = colorSchemes[currentScheme].text
ToggleButton.Text = "START AUTO CLICKER"
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 16
ToggleButton.Parent = ContentFrame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 10)
ToggleCorner.Parent = ToggleButton

-- Эффект свечения при включении
local ToggleGlow = Instance.new("ImageLabel")
ToggleGlow.Size = UDim2.new(1, 10, 1, 10)
ToggleGlow.Position = UDim2.new(0, -5, 0, -5)
ToggleGlow.BackgroundTransparency = 1
ToggleGlow.Image = "rbxassetid://5028857084"
ToggleGlow.ImageColor3 = colorSchemes[currentScheme].accent
ToggleGlow.ImageTransparency = 1
ToggleGlow.ScaleType = Enum.ScaleType.Slice
ToggleGlow.SliceCenter = Rect.new(24, 24, 24, 24)
ToggleGlow.Parent = ToggleButton

-- Быстрая кнопка (загружаем сохраненную позицию)
local QuickToggle = Instance.new("TextButton")
QuickToggle.Size = UDim2.new(0, 60, 0, 60)
QuickToggle.Position = LoadSettings()
QuickToggle.BackgroundColor3 = colorSchemes[currentScheme].secondary
QuickToggle.BackgroundTransparency = 0.7
QuickToggle.TextColor3 = colorSchemes[currentScheme].text
QuickToggle.Text = "⚡"
QuickToggle.Font = Enum.Font.GothamBold
QuickToggle.TextSize = 24
QuickToggle.Visible = false
QuickToggle.ZIndex = 5
QuickToggle.Parent = ScreenGui

local QuickCorner = Instance.new("UICorner")
QuickCorner.CornerRadius = UDim.new(0, 30)
QuickCorner.Parent = QuickToggle

-- Тень быстрой кнопки
local QuickShadow = Instance.new("ImageLabel")
QuickShadow.Size = UDim2.new(1, 10, 1, 10)
QuickShadow.Position = UDim2.new(0, -5, 0, -5)
QuickShadow.BackgroundTransparency = 1
QuickShadow.Image = "rbxassetid://5028857084"
QuickShadow.ImageColor3 = Color3.new(0, 0, 0)
QuickShadow.ImageTransparency = 0.8
QuickShadow.ScaleType = Enum.ScaleType.Slice
QuickShadow.SliceCenter = Rect.new(24, 24, 24, 24)
QuickShadow.ZIndex = 4
QuickShadow.Parent = QuickToggle

-- Переменные состояния
local clickPosition = Vector2.new(0, 0)
local isRunning = false
local connection
local lastClickTime = 0

-- Функция клика с эффектами
local function PerformClick()
    if not isRunning then return end
    
    -- Проверка на слишком частые клики
    local currentTime = tick()
    if currentTime - lastClickTime < 0.02 then return end
    lastClickTime = currentTime
    
    -- Визуальные эффекты
    if settings.animationEffects then
        ClickMarker.Position = UDim2.new(0, clickPosition.X, 0, clickPosition.Y)
        ClickMarker.Visible = true
        
        if settings.clickParticles then
            clickParticles:Emit(10)
        end
    end
    
    -- Звуковой эффект
    if settings.clickSound then
        clickSound:Play()
    end
    
    -- Сам клик
    local vim = game:GetService("VirtualInputManager")
    vim:SendMouseButtonEvent(clickPosition.X, clickPosition.Y, 0, true, game, 1)
    task.wait(0.02)
    vim:SendMouseButtonEvent(clickPosition.X, clickPosition.Y, 0, false, game, 1)
end

-- Управление кликером
local function ToggleAutoClicker(state)
    isRunning = state
    
    if isRunning then
        -- Анимация включения
        TweenService:Create(ToggleButton, TweenInfo.new(0.3), {
            BackgroundColor3 = colorSchemes[currentScheme].success,
            BackgroundTransparency = 0.4
        }):Play()
        
        TweenService:Create(ToggleGlow, TweenInfo.new(0.5), {
            ImageTransparency = 0.7
        }):Play()
        
        ToggleButton.Text = "STOP CLICKER"
        QuickToggle.Text = "⏸️"
        
        -- Запуск кликера
        local interval = tonumber(IntervalBox.Text) or 0.1
        if interval <= 0 then interval = 0.1 end
        
        if connection then
            connection:Disconnect()
        end
        
        connection = RunService.Heartbeat:Connect(function()
            PerformClick()
            task.wait(interval)
        end)
    else
        -- Анимация выключения
        TweenService:Create(ToggleButton, TweenInfo.new(0.3), {
            BackgroundColor3 = colorSchemes[currentScheme].secondary,
            BackgroundTransparency = 0.7
        }):Play()
        
        TweenService:Create(ToggleGlow, TweenInfo.new(0.5), {
            ImageTransparency = 1
        }):Play()
        
        ToggleButton.Text = "START AUTO CLICKER"
        QuickToggle.Text = "⚡"
        
        -- Остановка кликера
        if connection then
            connection:Disconnect()
            connection = nil
        end
    end
end

-- Обработчики событий
ToggleButton.MouseButton1Click:Connect(function()
    ToggleAutoClicker(not isRunning)
end)

QuickToggle.MouseButton1Click:Connect(function()
    ToggleAutoClicker(not isRunning)
end)

SetPosButton.MouseButton1Click:Connect(function()
    clickPosition = Vector2.new(mouse.X, mouse.Y)
    XBox.Text = tostring(math.floor(clickPosition.X))
    YBox.Text = tostring(math.floor(clickPosition.Y))
    
    -- Анимация установки позиции
    ClickMarker.Position = UDim2.new(0, clickPosition.X, 0, clickPosition.Y)
    ClickMarker.Visible = true
    
    local pulse = ClickMarker:Clone()
    pulse.Parent = ScreenGui
    pulse.ZIndex = 9
    
    TweenService:Create(pulse, TweenInfo.new(0.5), {
        Size = UDim2.new(0, 40, 0, 40),
        ImageTransparency = 1
    }):Play()
    
    delay(0.5, function()
        pulse:Destroy()
    end)
end)

CloseButton.MouseButton1Click:Connect(function()
    -- Анимация закрытия
    TweenService:Create(MainContainer, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    
    -- Сохранение позиции быстрой кнопки
    if settings.savePosition then
        SaveSettings(QuickToggle.Position)
    end
    
    wait(0.3)
    ScreenGui:Destroy()
    
    if connection then
        connection:Disconnect()
    end
end)

-- Инициализация
QuickToggle.Visible = true
LoadingIndicator.Visible = false
