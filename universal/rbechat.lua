--[[
    Exploit Chat - Lua Client
    Paste into your exploit executor. Edit SERVER_URL below.
]]

-- ============ CONFIG ============
local SERVER_URL = "wss://rbechatsvr.onrender.com"
local TOGGLE_KEY = Enum.KeyCode.F2
local RECONNECT_DELAY = 5
local MAX_MESSAGES = 100
-- ================================

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local ws, connected = nil, false
local username = player.Name
local guiOpen = true

local colors = {
    bg = Color3.fromRGB(18, 18, 24),
    surface = Color3.fromRGB(28, 28, 38),
    border = Color3.fromRGB(50, 50, 65),
    text = Color3.fromRGB(220, 220, 230),
    muted = Color3.fromRGB(130, 130, 150),
    accent = Color3.fromRGB(88, 166, 255),
    green = Color3.fromRGB(63, 185, 80),
    orange = Color3.fromRGB(210, 153, 34),
    red = Color3.fromRGB(248, 81, 73),
    purple = Color3.fromRGB(188, 140, 255),
}

-- Build GUI
local function createGUI()
    local screen = Instance.new("ScreenGui")
    screen.Name = "ExploitChat"
    screen.ResetOnSpawn = false
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.DisplayOrder = 999
    pcall(function() screen.Parent = CoreGui end)
    if not screen.Parent then screen.Parent = player.PlayerGui end

    local frame = Instance.new("Frame")
    frame.Name = "Main"
    frame.Size = UDim2.new(0, 380, 0, 360)
    frame.Position = UDim2.new(1, -395, 1, -375)
    frame.BackgroundColor3 = colors.bg
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Parent = screen

    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 10)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = colors.border
    stroke.Thickness = 1

    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 32)
    titleBar.BackgroundColor3 = colors.surface
    titleBar.BorderSizePixel = 0
    titleBar.Parent = frame

    local titleCorner = Instance.new("UICorner", titleBar)
    titleCorner.CornerRadius = UDim.new(0, 10)

    local titleFix = Instance.new("Frame")
    titleFix.Size = UDim2.new(1, 0, 0, 10)
    titleFix.Position = UDim2.new(0, 0, 1, -10)
    titleFix.BackgroundColor3 = colors.surface
    titleFix.BorderSizePixel = 0
    titleFix.Parent = titleBar

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 8, 0, 8)
    dot.Position = UDim2.new(0, 12, 0.5, -4)
    dot.BackgroundColor3 = colors.green
    dot.BorderSizePixel = 0
    dot.Parent = titleBar

    local dotCorner = Instance.new("UICorner", dot)
    dotCorner.CornerRadius = UDim.new(1, 0)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -24, 1, 0)
    title.Position = UDim2.new(0, 28, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Exploit Chat"
    title.TextColor3 = colors.text
    title.TextSize = 13
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleBar

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "Status"
    statusLabel.Size = UDim2.new(1, -100, 1, 0)
    statusLabel.Position = UDim2.new(0, 120, 0, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = ""
    statusLabel.TextColor3 = colors.muted
    statusLabel.TextSize = 11
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = titleBar

    -- Dragging via title bar
    do
        local dragging, dragStart, startPos

        local function updateDrag(input)
            local delta = input.Position - dragStart
            local newX = startPos.X.Offset + delta.X
            local newY = startPos.Y.Offset + delta.Y
            local vp = workspace.CurrentCamera.ViewportSize
            newX = math.clamp(newX, -frame.AbsolutePosition.X, vp.X - frame.AbsolutePosition.X - frame.AbsoluteSize.X)
            newY = math.clamp(newY, -frame.AbsolutePosition.Y, vp.Y - frame.AbsolutePosition.Y - frame.AbsoluteSize.Y)
            frame.Position = UDim2.new(0, newX, 0, newY)
        end

        titleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateDrag(input)
            end
        end)
    end

    -- Messages
    local msgFrame = Instance.new("ScrollingFrame")
    msgFrame.Name = "Messages"
    msgFrame.Size = UDim2.new(1, -8, 1, -72)
    msgFrame.Position = UDim2.new(0, 4, 0, 36)
    msgFrame.BackgroundTransparency = 1
    msgFrame.ScrollBarThickness = 3
    msgFrame.ScrollBarImageColor3 = colors.border
    msgFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    msgFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    msgFrame.BorderSizePixel = 0
    msgFrame.Parent = frame

    local listLayout = Instance.new("UIListLayout", msgFrame)
    listLayout.Padding = UDim.new(0, 2)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local padding = Instance.new("UIPadding", msgFrame)
    padding.PaddingTop = UDim.new(0, 4)
    padding.PaddingBottom = UDim.new(0, 4)
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)

    -- Input area
    local inputBg = Instance.new("Frame")
    inputBg.Size = UDim2.new(1, -8, 0, 30)
    inputBg.Position = UDim2.new(0, 4, 1, -34)
    inputBg.BackgroundColor3 = colors.surface
    inputBg.BorderSizePixel = 0
    inputBg.Parent = frame

    local inputCorner = Instance.new("UICorner", inputBg)
    inputCorner.CornerRadius = UDim.new(0, 6)

    local inputStroke = Instance.new("UIStroke", inputBg)
    inputStroke.Color = colors.border
    inputStroke.Thickness = 1

    local textbox = Instance.new("TextBox")
    textbox.Name = "Input"
    textbox.Size = UDim2.new(1, -16, 1, -4)
    textbox.Position = UDim2.new(0, 8, 0, 2)
    textbox.BackgroundTransparency = 1
    textbox.Text = ""
    textbox.PlaceholderText = "Type a message..."
    textbox.PlaceholderColor3 = colors.muted
    textbox.TextColor3 = colors.text
    textbox.TextSize = 13
    textbox.Font = Enum.Font.Gotham
    textbox.ClearTextOnFocus = false
    textbox.TextXAlignment = Enum.TextXAlignment.Left
    textbox.Parent = inputBg

    return { screen = screen, frame = frame, messages = msgFrame, input = textbox, status = statusLabel, dot = dot }
end

local gui = createGUI()
local msgOrder = 0

-- Mobile toggle button (movable)
local isTouch = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local mobileBtn

if isTouch then
    mobileBtn = Instance.new("TextButton")
    mobileBtn.Name = "ChatToggle"
    mobileBtn.Size = UDim2.new(0, 48, 0, 48)
    mobileBtn.Position = UDim2.new(0, 12, 0.5, -24)
    mobileBtn.BackgroundColor3 = colors.accent
    mobileBtn.Text = "Chat"
    mobileBtn.TextColor3 = Color3.new(1, 1, 1)
    mobileBtn.TextSize = 12
    mobileBtn.Font = Enum.Font.GothamBold
    mobileBtn.ZIndex = 1000
    mobileBtn.Parent = gui.screen

    local btnCorner = Instance.new("UICorner", mobileBtn)
    btnCorner.CornerRadius = UDim.new(1, 0)

    -- Make button draggable
    do
        local dragging, dragStart, startPos
        local function updateDrag(input)
            local delta = input.Position - dragStart
            mobileBtn.Position = UDim2.new(
                0, math.clamp(startPos.X.Offset + delta.X, 0, workspace.CurrentCamera.ViewportSize.X - 48),
                0, math.clamp(startPos.Y.Offset + delta.Y, 0, workspace.CurrentCamera.ViewportSize.Y - 48)
            )
        end

        mobileBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = mobileBtn.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
                updateDrag(input)
            end
        end)
    end

    mobileBtn.MouseButton1Click:Connect(function()
        guiOpen = not guiOpen
        gui.frame.Visible = guiOpen
    end)
end

local function addMessage(text, color, font, size)
    msgOrder += 1
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 0)
    label.AutomaticSize = Enum.AutomaticSize.Y
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or colors.text
    label.TextSize = size or 12
    label.Font = font or Enum.Font.Gotham
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Top
    label.LayoutOrder = msgOrder
    label.Parent = gui.messages

    local kids = gui.messages:GetChildren()
    if #kids > MAX_MESSAGES then
        for i = 1, #kids - MAX_MESSAGES do
            if kids[i]:IsA("TextLabel") then kids[i]:Destroy() end
        end
    end
end

local function addChatMessage(user, text)
    msgOrder += 1
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 0)
    frame.AutomaticSize = Enum.AutomaticSize.Y
    frame.BackgroundTransparency = 1
    frame.LayoutOrder = msgOrder
    frame.Parent = gui.messages

    local layout = Instance.new("UIListLayout", frame)
    layout.Padding = UDim.new(0, 1)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    local userLabel = Instance.new("TextLabel")
    userLabel.Size = UDim2.new(1, 0, 0, 0)
    userLabel.AutomaticSize = Enum.AutomaticSize.Y
    userLabel.BackgroundTransparency = 1
    userLabel.Text = user
    userLabel.TextColor3 = colors.accent
    userLabel.TextSize = 12
    userLabel.Font = Enum.Font.GothamBold
    userLabel.TextXAlignment = Enum.TextXAlignment.Left
    userLabel.LayoutOrder = 1
    userLabel.Parent = frame

    local bodyLabel = Instance.new("TextLabel")
    bodyLabel.Size = UDim2.new(1, 0, 0, 0)
    bodyLabel.AutomaticSize = Enum.AutomaticSize.Y
    bodyLabel.BackgroundTransparency = 1
    bodyLabel.Text = text
    bodyLabel.TextColor3 = colors.text
    bodyLabel.TextSize = 12
    bodyLabel.Font = Enum.Font.Gotham
    bodyLabel.TextWrapped = true
    bodyLabel.TextXAlignment = Enum.TextXAlignment.Left
    bodyLabel.LayoutOrder = 2
    bodyLabel.Parent = frame
end

local function addScriptMessage(user, text)
    msgOrder += 1
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 0)
    frame.AutomaticSize = Enum.AutomaticSize.Y
    frame.BackgroundColor3 = colors.surface
    frame.BorderSizePixel = 0
    frame.LayoutOrder = msgOrder
    frame.Parent = gui.messages

    local fCorner = Instance.new("UICorner", frame)
    fCorner.CornerRadius = UDim.new(0, 6)
    local fStroke = Instance.new("UIStroke", frame)
    fStroke.Color = colors.border
    fStroke.Thickness = 1

    local layout = Instance.new("UIListLayout", frame)
    layout.Padding = UDim.new(0, 4)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    local pad = Instance.new("UIPadding", frame)
    pad.PaddingTop = UDim.new(0, 6)
    pad.PaddingBottom = UDim.new(0, 6)
    pad.PaddingLeft = UDim.new(0, 8)
    pad.PaddingRight = UDim.new(0, 8)

    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, 0, 0, 0)
    header.AutomaticSize = Enum.AutomaticSize.Y
    header.BackgroundTransparency = 1
    header.Text = user .. " shared a script:"
    header.TextColor3 = colors.purple
    header.TextSize = 11
    header.Font = Enum.Font.GothamBold
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.LayoutOrder = 1
    header.Parent = frame

    local codeBg = Instance.new("Frame")
    codeBg.Size = UDim2.new(1, 0, 0, 0)
    codeBg.AutomaticSize = Enum.AutomaticSize.Y
    codeBg.BackgroundColor3 = colors.bg
    codeBg.BorderSizePixel = 0
    codeBg.LayoutOrder = 2
    codeBg.Parent = frame

    local codeCorner = Instance.new("UICorner", codeBg)
    codeCorner.CornerRadius = UDim.new(0, 4)

    local codePad = Instance.new("UIPadding", codeBg)
    codePad.PaddingTop = UDim.new(0, 6)
    codePad.PaddingBottom = UDim.new(0, 6)
    codePad.PaddingLeft = UDim.new(0, 8)
    codePad.PaddingRight = UDim.new(0, 8)

    local maxLen = 600
    local displayText = #text > maxLen and string.sub(text, 1, maxLen) .. "\n... (truncated)" or text

    local code = Instance.new("TextLabel")
    code.Size = UDim2.new(1, 0, 0, 0)
    code.AutomaticSize = Enum.AutomaticSize.Y
    code.BackgroundTransparency = 1
    code.Text = displayText
    code.TextColor3 = colors.green
    code.TextSize = 11
    code.Font = Enum.Font.Code
    code.TextWrapped = true
    code.TextXAlignment = Enum.TextXAlignment.Left
    code.TextYAlignment = Enum.TextYAlignment.Top
    code.Parent = codeBg

    -- Copy button
    local copyBtn = Instance.new("TextButton")
    copyBtn.Size = UDim2.new(0, 60, 0, 22)
    copyBtn.BackgroundColor3 = colors.surface
    copyBtn.BorderSizePixel = 0
    copyBtn.Text = "Copy"
    copyBtn.TextColor3 = colors.muted
    copyBtn.TextSize = 11
    copyBtn.Font = Enum.Font.GothamBold
    copyBtn.LayoutOrder = 3
    copyBtn.Parent = frame

    local copyCorner = Instance.new("UICorner", copyBtn)
    copyCorner.CornerRadius = UDim.new(0, 4)
    local copyStroke = Instance.new("UIStroke", copyBtn)
    copyStroke.Color = colors.border

    copyBtn.MouseButton1Click:Connect(function()
        pcall(function() setclipboard(text) end)
        copyBtn.Text = "Copied!"
        copyBtn.TextColor3 = colors.green
        task.delay(1.5, function()
            copyBtn.Text = "Copy"
            copyBtn.TextColor3 = colors.muted
        end)
    end)
end

-- WebSocket
local function wsSend(data)
    if ws and connected then
        pcall(function() ws:Send(HttpService:JSONEncode(data)) end)
    end
end

local function connect()
    if connected then return end
    gui.status.Text = "Connecting..."
    gui.dot.BackgroundColor3 = colors.orange

    local ok, w = pcall(function()
        if syn and syn.websocket then return syn.websocket.connect(SERVER_URL) end
        if fluxus and fluxus.websocket then return fluxus.websocket.connect(SERVER_URL) end
        if http and http.websocket then return http.websocket(SERVER_URL) end
        error("No WebSocket API found")
    end)

    if not ok or not w then
        gui.status.Text = "Connection failed"
        gui.dot.BackgroundColor3 = colors.red
        warn("[ExploitChat] " .. tostring(w))
        return false
    end

    ws = w
    connected = true
    gui.status.Text = "Connected"
    gui.dot.BackgroundColor3 = colors.green

    wsSend({ type = "join", username = username, client = "lua" })
    addMessage("Connected to server", colors.green, Enum.Font.GothamBold)
    return true
end

local function disconnect()
    connected = false
    ws = nil
    gui.status.Text = "Disconnected"
    gui.dot.BackgroundColor3 = colors.red
end

local function handleMessage(data)
    if data.type == "joined" then
        username = data.username
        addMessage("Joined as " .. data.username, colors.green, Enum.Font.GothamBold)

    elseif data.type == "chat" then
        addChatMessage(data.user, data.text)

    elseif data.type == "script" then
        addScriptMessage(data.user, data.text)

    elseif data.type == "system" then
        addMessage(data.text, colors.muted, Enum.Font.Gotham, 11)

    elseif data.type == "exec" then
        addMessage("Executing script from " .. data.from .. "...", colors.orange, Enum.Font.GothamBold)
        wsSend({ type = "output", text = "Running script from " .. data.from })

        local func, err = loadstring(data.text)
        if func then
            local ok2, err2 = pcall(func)
            if ok2 then
                addMessage("Script completed", colors.green)
                wsSend({ type = "output", text = "Script completed successfully" })
            else
                addMessage("Error: " .. tostring(err2), colors.red)
                wsSend({ type = "output", text = "Error: " .. tostring(err2) })
            end
        else
            addMessage("Load error: " .. tostring(err), colors.red)
            wsSend({ type = "output", text = "Load error: " .. tostring(err) })
        end
    end
end

local function listen()
    while connected do
        local ok, msg = pcall(function() return ws:Wait() end)
        if not ok or not msg then disconnect() break end
        if msg == "Connect" or msg == "Open" then continue end
        if msg == "Close" or msg == "Disconnect" then disconnect() break end

        local ok2, data = pcall(function() return HttpService:JSONDecode(msg) end)
        if ok2 and data then handleMessage(data) end
    end
end

-- Input
gui.input.FocusLost:Connect(function(enterPressed)
    if not enterPressed then return end
    local text = gui.input.Text
    if text == "" then return end
    gui.input.Text = ""

    if text:sub(1, 1) == "/" then
        local cmd = text:sub(2)
        if cmd:sub(1, 7) == "rename " then
            local newName = cmd:sub(8)
            username = newName:sub(1, 24)
            wsSend({ type = "join", username = username, client = "lua" })
            addMessage("Renamed to " .. username, colors.accent)
        elseif cmd == "help" then
            addMessage("/rename <name> - Change username", colors.muted)
            addMessage("/help - Show this help", colors.muted)
        else
            addMessage("Unknown command. /help for commands.", colors.orange)
        end
    else
        wsSend({ type = "chat", text = text })
    end
end)

-- Toggle
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == TOGGLE_KEY then
        guiOpen = not guiOpen
        gui.frame.Visible = guiOpen
        if mobileBtn then mobileBtn.Visible = guiOpen end
    end
end)

-- Reconnect loop
task.spawn(function()
    while true do
        if not connected then
            if connect() then
                task.spawn(listen)
            end
            task.wait(RECONNECT_DELAY)
        else
            task.wait(1)
        end
    end
end)

-- API
getgenv().ExploitChat = {
    sendChat = function(text) wsSend({ type = "chat", text = tostring(text) }) end,
    setUsername = function(name)
        username = tostring(name):sub(1, 24)
        if connected then wsSend({ type = "join", username = username, client = "lua" }) end
    end,
    toggle = function()
        guiOpen = not guiOpen
        gui.frame.Visible = guiOpen
        if mobileBtn then mobileBtn.Visible = guiOpen end
    end,
    disconnect = function() disconnect() end,
}

addMessage("Exploit Chat loaded", colors.accent, Enum.Font.GothamBold)
addMessage(isTouch and "Tap the Chat button to toggle" or "Press F2 to toggle | /help for commands", colors.muted, Enum.Font.Gotham, 11)
