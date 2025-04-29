local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Стильные настройки
local colors = {
    background = Color3.fromRGB(30, 35, 45),
    header = Color3.fromRGB(20, 25, 35),
    button = Color3.fromRGB(50, 55, 70),
    buttonHover = Color3.fromRGB(70, 75, 90),
    toggleOn = Color3.fromRGB(0, 180, 120),
    toggleOff = Color3.fromRGB(180, 50, 50),
    text = Color3.fromRGB(240, 240, 240),
    accent = Color3.fromRGB(0, 150, 200)
}

-- Создание GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PremiumAutoClicker"
ScreenGui.Parent = game.CoreGui

-- Главный фрейм с возможностью перемещения
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 340, 0, 380)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.BackgroundColor3 = colors.background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Selectable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Скругленные углы
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Тень с акцентным цветом
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = colors.accent
UIStroke.Thickness = 2
UIStroke.Transparency = 0.7
UIStroke.Parent = MainFrame

-- Заголовок с эффектом
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = colors.header
Title.Text = "PREMIUM CLICKER"
Title.TextColor3 = colors.text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

-- Скругление только сверху
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

-- Кнопка закрытия
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(1, -45, 0, 5)
CloseButton.BackgroundColor3 = colors.button
CloseButton.Text = "×"
CloseButton.TextColor3 = colors.text
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 24
CloseButton.Parent = Title

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 20)
CloseCorner.Parent = CloseButton

-- Кнопка сворачивания
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 40, 0, 40)
MinimizeButton.Position = UDim2.new(1, -90, 0, 5)
MinimizeButton.BackgroundColor3 = colors.button
MinimizeButton.Text = "_"
MinimizeButton.TextColor3 = colors.text
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 24
MinimizeButton.Parent = Title

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 20)
MinimizeCorner.Parent = MinimizeButton

-- Контейнер содержимого
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -50)
ContentFrame.Position = UDim2.new(0, 0, 0, 50)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame
-- Секция позиции клика
local PositionSection = Instance.new("Frame")
PositionSection.Size = UDim2.new(1, -20, 0, 120)
PositionSection.Position = UDim2.new(0, 10, 0, 10)
PositionSection.BackgroundColor3 = colors.header
PositionSection.Parent = ContentFrame

local PositionCorner = Instance.new("UICorner")
PositionCorner.CornerRadius = UDim.new(0, 8)
PositionCorner.Parent = PositionSection

local PositionTitle = Instance.new("TextLabel")
PositionTitle.Size = UDim2.new(1, -10, 0, 30)
PositionTitle.Position = UDim2.new(0, 10, 0, 5)
PositionTitle.BackgroundTransparency = 1
PositionTitle.Text = "CLICK POSITION"
PositionTitle.TextColor3 = colors.text
PositionTitle.Font = Enum.Font.GothamBold
PositionTitle.TextXAlignment = Enum.TextXAlignment.Left
PositionTitle.Parent = PositionSection

-- Поля координат
local XLabel = Instance.new("TextLabel")
XLabel.Size = UDim2.new(0, 50, 0, 30)
XLabel.Position = UDim2.new(0, 15, 0, 45)
XLabel.BackgroundTransparency = 1
XLabel.Text = "X:"
XLabel.TextColor3 = colors.text
XLabel.Font = Enum.Font.Gotham
XLabel.TextXAlignment = Enum.TextXAlignment.Left
XLabel.Parent = PositionSection

local XBox = Instance.new("TextBox")
XBox.Size = UDim2.new(0, 100, 0, 30)
XBox.Position = UDim2.new(0, 70, 0, 45)
XBox.BackgroundColor3 = colors.button
XBox.TextColor3 = colors.text
XBox.PlaceholderText = "X position"
XBox.Text = "0"
XBox.Font = Enum.Font.Gotham
XBox.Parent = PositionSection

local YLabel = Instance.new("TextLabel")
YLabel.Size = UDim2.new(0, 50, 0, 30)
YLabel.Position = UDim2.new(0, 15, 0, 85)
YLabel.BackgroundTransparency = 1
YLabel.Text = "Y:"
YLabel.TextColor3 = colors.text
YLabel.Font = Enum.Font.Gotham
YLabel.TextXAlignment = Enum.TextXAlignment.Left
YLabel.Parent = PositionSection

local YBox = Instance.new("TextBox")
YBox.Size = UDim2.new(0, 100, 0, 30)
YBox.Position = UDim2.new(0, 70, 0, 85)
YBox.BackgroundColor3 = colors.button
YBox.TextColor3 = colors.text
YBox.PlaceholderText = "Y position"
YBox.Text = "0"
YBox.Font = Enum.Font.Gotham
YBox.Parent = PositionSection

-- Кнопка установки позиции
local SetPosButton = Instance.new("TextButton")
SetPosButton.Size = UDim2.new(0, 180, 0, 35)
SetPosButton.Position = UDim2.new(0, 150, 0, 45)
SetPosButton.BackgroundColor3 = colors.button
SetPosButton.TextColor3 = colors.text
SetPosButton.Text = "SET BY CLICK"
SetPosButton.Font = Enum.Font.GothamBold
SetPosButton.Parent = PositionSection

local SetPosCorner = Instance.new("UICorner")
SetPosCorner.CornerRadius = UDim.new(0, 8)
SetPosCorner.Parent = SetPosButton

-- Секция настроек
local SettingsSection = Instance.new("Frame")
SettingsSection.Size = UDim2.new(1, -20, 0, 100)
SettingsSection.Position = UDim2.new(0, 10, 0, 140)
SettingsSection.BackgroundColor3 = colors.header
SettingsSection.Parent = ContentFrame

local SettingsCorner = Instance.new("UICorner")
SettingsCorner.CornerRadius = UDim.new(0, 8)
SettingsCorner.Parent = SettingsSection

local SettingsTitle = Instance.new("TextLabel")
SettingsTitle.Size = UDim2.new(1, -10, 0, 30)
SettingsTitle.Position = UDim2.new(0, 10, 0, 5)
SettingsTitle.BackgroundTransparency = 1
SettingsTitle.Text = "SETTINGS"
SettingsTitle.TextColor3 = colors.text
SettingsTitle.Font = Enum.Font.GothamBold
SettingsTitle.TextXAlignment = Enum.TextXAlignment.Left
SettingsTitle.Parent = SettingsSection

-- Интервал кликов
local IntervalLabel = Instance.new("TextLabel")
IntervalLabel.Size = UDim2.new(0, 120, 0, 30)
IntervalLabel.Position = UDim2.new(0, 15, 0, 45)
IntervalLabel.BackgroundTransparency = 1
IntervalLabel.Text = "INTERVAL (sec):"
IntervalLabel.TextColor3 = colors.text
IntervalLabel.Font = Enum.Font.Gotham
IntervalLabel.TextXAlignment = Enum.TextXAlignment.Left
IntervalLabel.Parent = SettingsSection

local IntervalBox = Instance.new("TextBox")
IntervalBox.Size = UDim2.new(0, 80, 0, 30)
IntervalBox.Position = UDim2.new(0, 140, 0, 45)
IntervalBox.BackgroundColor3 = colors.button
IntervalBox.TextColor3 = colors.text
IntervalBox.Text = "0.1"
IntervalBox.Font = Enum.Font.Gotham
IntervalBox.Parent = SettingsSection

local IntervalCorner = Instance.new("UICorner")
IntervalCorner.CornerRadius = UDim.new(0, 8)
IntervalCorner.Parent = IntervalBox

-- Главная кнопка
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(1, -20, 0, 50)
ToggleButton.Position = UDim2.new(0, 10, 0, 250)
ToggleButton.BackgroundColor3 = colors.toggleOff
ToggleButton.TextColor3 = colors.text
ToggleButton.Text = "START AUTO CLICKER"
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 16
ToggleButton.Parent = ContentFrame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleButton
-- Быстрая кнопка
local QuickToggle = Instance.new("TextButton")
QuickToggle.Size = UDim2.new(0, 55, 0, 55)
QuickToggle.Position = UDim2.new(1, -65, 1, -65)
QuickToggle.BackgroundColor3 = colors.toggleOff
QuickToggle.TextColor3 = colors.text
QuickToggle.Text = "⚡"
QuickToggle.Font = Enum.Font.GothamBold
QuickToggle.TextSize = 24
QuickToggle.Visible = false
QuickToggle.ZIndex = 2
QuickToggle.Parent = ScreenGui

local QuickCorner = Instance.new("UICorner")
QuickCorner.CornerRadius = UDim.new(0, 28)
QuickCorner.Parent = QuickToggle

-- Маркер клика
local ClickMarker = Instance.new("Frame")
ClickMarker.Size = UDim2.new(0, 12, 0, 12)
ClickMarker.AnchorPoint = Vector2.new(0.5, 0.5)
ClickMarker.BackgroundColor3 = colors.toggleOff
ClickMarker.BorderSizePixel = 0
ClickMarker.Visible = false
ClickMarker.ZIndex = 2
ClickMarker.Parent = ScreenGui

local MarkerCorner = Instance.new("UICorner")
MarkerCorner.CornerRadius = UDim.new(0, 6)
MarkerCorner.Parent = ClickMarker

-- Переменные состояния
local clickPosition = Vector2.new(0, 0)
local isRunning = false
local isMinimized = false
local connection

-- Функция клика
local function doClick()
    if not isRunning then return end
    
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

-- Установка позиции
SetPosButton.MouseButton1Click:Connect(function()
    clickPosition = Vector2.new(mouse.X, mouse.Y)
    XBox.Text = tostring(math.floor(clickPosition.X))
    YBox.Text = tostring(math.floor(clickPosition.Y))
    updateMarker()
end)

XBox.FocusLost:Connect(function()
    local x = tonumber(XBox.Text) or 0
    clickPosition = Vector2.new(x, clickPosition.Y)
    updateMarker()
end)

YBox.FocusLost:Connect(function()
    local y = tonumber(YBox.Text) or 0
    clickPosition = Vector2.new(clickPosition.X, y)
    updateMarker()
end)

-- Включение/выключение кликера
local function toggleAutoClicker(state)
    isRunning = state
    
    if isRunning then
        ToggleButton.Text = "STOP AUTO CLICKER"
        ToggleButton.BackgroundColor3 = colors.toggleOn
        QuickToggle.BackgroundColor3 = colors.toggleOn
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
        ToggleButton.BackgroundColor3 = colors.toggleOff
        QuickToggle.BackgroundColor3 = colors.toggleOff
        QuickToggle.Text = "⚡"
        
        if connection then
            connection:Disconnect()
            connection = nil
        end
    end
end

-- Основные кнопки
ToggleButton.MouseButton1Click:Connect(function()
    toggleAutoClicker(not isRunning)
end)

QuickToggle.MouseButton1Click:Connect(function()
    toggleAutoClicker(not isRunning)
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    if connection then
        connection:Disconnect()
    end
end)

-- Сворачивание/разворачивание
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    
    if isMinimized then
        MainFrame.Size = UDim2.new(0, 340, 0, 50)
        QuickToggle.Visible = true
    else
        MainFrame.Size = UDim2.new(0, 340, 0, 380)
        QuickToggle.Visible = false
    end
end)

-- Анимация при наведении
local function setupButtonHover(button)
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = colors.buttonHover
    end)
    button.MouseLeave:Connect(function()
        if button ~= ToggleButton and button ~= QuickToggle then
            button.BackgroundColor3 = colors.button
        end
    end)
end

setupButtonHover(SetPosButton)
setupButtonHover(ToggleButton)
setupButtonHover(QuickToggle)
setupButtonHover(CloseButton)
setupButtonHover(MinimizeButton)

-- Инициализация
updateMarker()
