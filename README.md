local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Настройки
local settings = {
    colors = {
        background = Color3.fromRGB(30, 30, 40),
        header = Color3.fromRGB(25, 25, 35),
        button = Color3.fromRGB(45, 45, 60),
        buttonHover = Color3.fromRGB(60, 60, 80),
        toggleOn = Color3.fromRGB(80, 180, 80),
        toggleOff = Color3.fromRGB(180, 80, 80),
        text = Color3.fromRGB(240, 240, 240),
        marker = Color3.fromRGB(255, 80, 80)
    },
    sounds = {
        click = "rbxassetid://131147061", -- ID звука клика
        toggle = "rbxassetid://138080526" -- ID звука переключения
    },
    quickButtonSize = 55,
    quickButtonIcon = "⚡"
}

-- Создание GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EnhancedAutoClickerGUI"
ScreenGui.Parent = game.CoreGui

-- Анимация загрузки
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Size = UDim2.new(0, 200, 0, 10)
LoadingFrame.Position = UDim2.new(0.5, -100, 0.5, 50)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
LoadingFrame.BorderSizePixel = 0
LoadingFrame.Parent = ScreenGui

local LoadingBar = Instance.new("Frame")
LoadingBar.Size = UDim2.new(0, 0, 1, 0)
LoadingBar.BackgroundColor3 = settings.colors.toggleOn
LoadingBar.BorderSizePixel = 0
LoadingBar.Parent = LoadingFrame

-- Основной фрейм (пока скрыт)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 280)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -140)
MainFrame.BackgroundColor3 = settings.colors.background
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- Анимация появления
local function showGUI()
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(MainFrame, tweenInfo, {Size = UDim2.new(0, 300, 0, 280)})
    tween:Play()
end

-- Анимация загрузки
for i = 1, 100 do
    LoadingBar.Size = UDim2.new(0, i*2, 1, 0)
    task.wait(0.02)
end

task.wait(0.5)
LoadingFrame:Destroy()
showGUI()

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = settings.colors.header
Title.Text = "ENHANCED AUTO CLICKER"
Title.TextColor3 = settings.colors.text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = MainFrame

-- Кнопка закрытия
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 70, 70)
CloseButton.Text = "×"
CloseButton.TextColor3 = settings.colors.text
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 20
CloseButton.Parent = Title

-- Кнопка сворачивания
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -70, 0, 5)
MinimizeButton.BackgroundColor3 = settings.colors.button
MinimizeButton.Text = "_"
MinimizeButton.TextColor3 = settings.colors.text
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 20
MinimizeButton.Parent = Title

-- Контейнер содержимого
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -40)
ContentFrame.Position = UDim2.new(0, 0, 0, 40)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame
-- Секция позиции клика
local PositionSection = Instance.new("Frame")
PositionSection.Size = UDim2.new(1, -20, 0, 90)
PositionSection.Position = UDim2.new(0, 10, 0, 10)
PositionSection.BackgroundColor3 = settings.colors.header
PositionSection.Parent = ContentFrame

local PositionTitle = Instance.new("TextLabel")
PositionTitle.Size = UDim2.new(1, 0, 0, 20)
PositionTitle.Position = UDim2.new(0, 5, 0, 5)
PositionTitle.BackgroundTransparency = 1
PositionTitle.Text = "Click Position:"
PositionTitle.TextColor3 = settings.colors.text
PositionTitle.Font = Enum.Font.Gotham
PositionTitle.TextXAlignment = Enum.TextXAlignment.Left
PositionTitle.Parent = PositionSection

-- Поля координат
local XLabel = Instance.new("TextLabel")
XLabel.Size = UDim2.new(0, 50, 0, 20)
XLabel.Position = UDim2.new(0, 10, 0, 30)
XLabel.BackgroundTransparency = 1
XLabel.Text = "X:"
XLabel.TextColor3 = settings.colors.text
XLabel.Font = Enum.Font.Gotham
XLabel.TextXAlignment = Enum.TextXAlignment.Left
XLabel.Parent = PositionSection

local XBox = Instance.new("TextBox")
XBox.Size = UDim2.new(0, 80, 0, 25)
XBox.Position = UDim2.new(0, 60, 0, 30)
XBox.BackgroundColor3 = settings.colors.button
XBox.TextColor3 = settings.colors.text
XBox.PlaceholderText = "X pos"
XBox.Text = "0"
XBox.Font = Enum.Font.Gotham
XBox.Parent = PositionSection

local YLabel = Instance.new("TextLabel")
YLabel.Size = UDim2.new(0, 50, 0, 20)
YLabel.Position = UDim2.new(0, 10, 0, 60)
YLabel.BackgroundTransparency = 1
YLabel.Text = "Y:"
YLabel.TextColor3 = settings.colors.text
YLabel.Font = Enum.Font.Gotham
YLabel.TextXAlignment = Enum.TextXAlignment.Left
YLabel.Parent = PositionSection

local YBox = Instance.new("TextBox")
YBox.Size = UDim2.new(0, 80, 0, 25)
YBox.Position = UDim2.new(0, 60, 0, 60)
YBox.BackgroundColor3 = settings.colors.button
YBox.TextColor3 = settings.colors.text
YBox.PlaceholderText = "Y pos"
YBox.Text = "0"
YBox.Font = Enum.Font.Gotham
YBox.Parent = PositionSection

-- Кнопка установки позиции
local SetPosButton = Instance.new("TextButton")
SetPosButton.Size = UDim2.new(0, 150, 0, 30)
SetPosButton.Position = UDim2.new(0, 150, 0, 30)
SetPosButton.BackgroundColor3 = settings.colors.button
SetPosButton.TextColor3 = settings.colors.text
SetPosButton.Text = "Set by Click"
SetPosButton.Font = Enum.Font.Gotham
SetPosButton.Parent = PositionSection

-- Секция настроек
local SettingsSection = Instance.new("Frame")
SettingsSection.Size = UDim2.new(1, -20, 0, 80)
SettingsSection.Position = UDim2.new(0, 10, 0, 110)
SettingsSection.BackgroundColor3 = settings.colors.header
SettingsSection.Parent = ContentFrame

local SettingsTitle = Instance.new("TextLabel")
SettingsTitle.Size = UDim2.new(1, 0, 0, 20)
SettingsTitle.Position = UDim2.new(0, 5, 0, 5)
SettingsTitle.BackgroundTransparency = 1
SettingsTitle.Text = "Settings:"
SettingsTitle.TextColor3 = settings.colors.text
SettingsTitle.Font = Enum.Font.Gotham
SettingsTitle.TextXAlignment = Enum.TextXAlignment.Left
SettingsTitle.Parent = SettingsSection

-- Интервал кликов
local IntervalLabel = Instance.new("TextLabel")
IntervalLabel.Size = UDim2.new(0, 100, 0, 20)
IntervalLabel.Position = UDim2.new(0, 10, 0, 30)
IntervalLabel.BackgroundTransparency = 1
IntervalLabel.Text = "Interval (sec):"
IntervalLabel.TextColor3 = settings.colors.text
IntervalLabel.Font = Enum.Font.Gotham
IntervalLabel.TextXAlignment = Enum.TextXAlignment.Left
IntervalLabel.Parent = SettingsSection

local IntervalBox = Instance.new("TextBox")
IntervalBox.Size = UDim2.new(0, 50, 0, 25)
IntervalBox.Position = UDim2.new(0, 120, 0, 30)
IntervalBox.BackgroundColor3 = settings.colors.button
IntervalBox.TextColor3 = settings.colors.text
IntervalBox.Text = "0.1"
IntervalBox.Font = Enum.Font.Gotham
IntervalBox.Parent = SettingsSection

-- Кнопка включения/выключения
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(1, -20, 0, 40)
ToggleButton.Position = UDim2.new(0, 10, 0, 200)
ToggleButton.BackgroundColor3 = settings.colors.toggleOff
ToggleButton.TextColor3 = settings.colors.text
ToggleButton.Text = "START AUTO CLICKER"
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 14
ToggleButton.Parent = ContentFrame

-- Быстрая кнопка
local QuickToggle = Instance.new("TextButton")
QuickToggle.Size = UDim2.new(0, 55, 0, 55)
QuickToggle.Position = UDim2.new(1, -65, 1, -65)
QuickToggle.BackgroundColor3 = settings.colors.toggleOff
QuickToggle.TextColor3 = settings.colors.text
QuickToggle.Text = "⚡"
QuickToggle.Font = Enum.Font.GothamBold
QuickToggle.TextSize = 24
QuickToggle.Visible = false
QuickToggle.ZIndex = 2
QuickToggle.Parent = ScreenGui

-- Маркер клика
local ClickMarker = Instance.new("Frame")
ClickMarker.Size = UDim2.new(0, 12, 0, 12)
ClickMarker.AnchorPoint = Vector2.new(0.5, 0.5)
ClickMarker.BackgroundColor3 = settings.colors.marker
ClickMarker.BorderSizePixel = 0
ClickMarker.Visible = false
ClickMarker.ZIndex = 2
ClickMarker.Parent = ScreenGui
-- Переменные состояния
local clickPosition = Vector2.new(0, 0)
local isRunning = false
local isMinimized = false
local connection
local lastClickTime = 0

-- Воспроизведение звука
local function playSound(soundName)
    local sound = Instance.new("Sound")
    sound.SoundId = settings.sounds[soundName]
    sound.Parent = SoundService
    sound:Play()
    game:GetService("Debris"):AddItem(sound, 2)
end

-- Анимация кнопок
local function animateButton(button)
    local originalSize = button.Size
    
    button.MouseButton1Down:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {Size = originalSize - UDim2.new(0, 5, 0, 5)}):Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {Size = originalSize}):Play()
    end)
    
    button.MouseEnter:Connect(function()
        if button ~= ToggleButton and button ~= QuickToggle then
            button.BackgroundColor3 = settings.colors.buttonHover
        end
    end)
    
    button.MouseLeave:Connect(function()
        if button ~= ToggleButton and button ~= QuickToggle then
            button.BackgroundColor3 = settings.colors.button
        end
    end)
end

-- Применяем анимации
animateButton(SetPosButton)
animateButton(ToggleButton)
animateButton(QuickToggle)
animateButton(CloseButton)
animateButton(MinimizeButton)

-- Функция клика с визуальной обратной связью
local function doClick()
    if not isRunning then return end
    
    -- Визуальный эффект клика
    ClickMarker.Size = UDim2.new(0, 16, 0, 16)
    TweenService:Create(ClickMarker, TweenInfo.new(0.1), {Size = UDim2.new(0, 12, 0, 12)}):Play()
    
    -- Звук клика
    playSound("click")
    
    -- Сам клик
    local vim = game:GetService("VirtualInputManager")
    vim:SendMouseButtonEvent(clickPosition.X, clickPosition.Y, 0, true, game, 1)
    task.wait(0.02)
    vim:SendMouseButtonEvent(clickPosition.X, clickPosition.Y, 0, false, game, 1)
end

-- Обновление маркера
local function updateMarker()
    ClickMarker.Position = UDim2.new(0, clickPosition.X, 0, clickPosition.Y)
    ClickMarker.Visible = true
end

-- Установка позиции клика
SetPosButton.MouseButton1Click:Connect(function()
    clickPosition = Vector2.new(mouse.X, mouse.Y)
    XBox.Text = tostring(math.floor(clickPosition.X))
    YBox.Text = tostring(math.floor(clickPosition.Y))
    updateMarker()
    playSound("click")
end)

-- Включение/выключение кликера
local function toggleAutoClicker(state)
    isRunning = state
    playSound("toggle")
    
    if isRunning then
        ToggleButton.Text = "STOP AUTO CLICKER"
        ToggleButton.BackgroundColor3 = settings.colors.toggleOn
        QuickToggle.BackgroundColor3 = settings.colors.toggleOn
        QuickToggle.Text = "⏸️"
        
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
        ToggleButton.Text = "START AUTO CLICKER"
        ToggleButton.BackgroundColor3 = settings.colors.toggleOff
        QuickToggle.BackgroundColor3 = settings.colors.toggleOff
        QuickToggle.Text = "⚡"
        
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
    toggleAutoClicker(not isRunning)
end)

CloseButton.MouseButton1Click:Connect(function()
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)})
    tween:Play()
    tween.Completed:Wait()
    ScreenGui:Destroy()
    if connection then
        connection:Disconnect()
    end
end)

MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    
    if isMinimized then
        TweenService:Create(MainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 300, 0, 40)}):Play()
        QuickToggle.Visible = true
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 300, 0, 280)}):Play()
        QuickToggle.Visible = false
    end
end)

-- Инициализация
updateMarker()
