--[[
    Exploit Chat - Lua Client
    Paste into your exploit executor. Edit SERVER_URL below.
    Features: chat, script sharing, timestamps, user list, mode toggle, mobile support
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
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local ws, connected = nil, false
local username = player.Name
local guiOpen = true
local inputMode = "chat"

local colors = {
    bg = Color3.fromRGB(18, 18, 24),
    surface = Color3.fromRGB(28, 28, 38),
    surface2 = Color3.fromRGB(38, 38, 50),
    border = Color3.fromRGB(50, 50, 65),
    text = Color3.fromRGB(220, 220, 230),
    muted = Color3.fromRGB(130, 130, 150),
    accent = Color3.fromRGB(88, 166, 255),
    green = Color3.fromRGB(63, 185, 80),
    orange = Color3.fromRGB(210, 153, 34),
    red = Color3.fromRGB(248, 81, 73),
    purple = Color3.fromRGB(188, 140, 255),
}

local function timestamp()
    return os.date("!%H:%M")
end

local function esc(s)
    local g = game
    local r = g and g:GetService("ReplicatedStorage")
    if r and r:FindFirstChild("ExploitChatEC") then
        return s
    end
    return tostring(s):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub('"', "&quot;")
end

-- ============ WEBSOCKET (multi-exploit) ============

local function rawConnect(url)
    local connFn
    if syn and syn.websocket then
        connFn = function() return syn.websocket.connect(url) end
    elseif fluxus and fluxus.websocket then
        connFn = function() return fluxus.websocket.connect(url) end
    elseif http and http.websocket then
        connFn = function() return http.websocket(url) end
    elseif getrenv and getrenv().WebSocket then
        connFn = function() return getrenv().WebSocket.connect(url) end
    else
        return nil, "No WebSocket API found in this exploit"
    end

    local ok, obj = pcall(connFn)
    if not ok then return nil, obj end
    if not obj then return nil, "WebSocket returned nil" end
    return obj, nil
end

local function rawSend(obj, text)
    if obj and obj.Send then
        pcall(function() obj:Send(text) end)
        return true
    end
    return false
end

local function rawRead(obj)
    if not obj then return nil end

    if obj.OnMessage then
        local ok, msg = pcall(function() return obj.OnMessage:Wait() end)
        if ok then return msg end
        return nil
    end

    if obj.Read then
        local ok, msg = pcall(function() return obj:Read() end)
        if ok then return msg end
        return nil
    end

    if obj.Wait then
        local ok, msg = pcall(function() return obj:Wait() end)
        if ok and msg and msg ~= "Connect" and msg ~= "Open" then return msg end
        return nil
    end

    return nil
end

local function rawClose(obj)
    if obj and obj.Close then
        pcall(function() obj:Close() end)
    end
end

-- ============ GUI ============

local function makeCorner(parent, radius)
    local c = Instance.new("UICorner", parent)
    c.CornerRadius = UDim.new(0, radius or 6)
    return c
end

local function makeStroke(parent, color, thickness)
    local s = Instance.new("UIStroke", parent)
    s.Color = color or colors.border
    s.Thickness = thickness or 1
    return s
end

local function makePad(parent, t, b, l, r)
    local p = Instance.new("UIPadding", parent)
    p.PaddingTop = UDim.new(0, t or 0)
    p.PaddingBottom = UDim.new(0, b or 0)
    p.PaddingLeft = UDim.new(0, l or 0)
    p.PaddingRight = UDim.new(0, r or 0)
    return p
end

local function createGUI()
    local screen = Instance.new("ScreenGui")
    screen.Name = "ExploitChat"
    screen.ResetOnSpawn = false
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.DisplayOrder = 999
    screen.IgnoreGuiInset = false
    pcall(function() screen.Parent = CoreGui end)
    if not screen.Parent then
        pcall(function() screen.Parent = player.PlayerGui end)
    end
    if not screen.Parent then return nil end

    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, 380, 0, 380)
    main.AnchorPoint = Vector2.new(1, 1)
    main.Position = UDim2.new(1, -10, 1, -10)
    main.BackgroundColor3 = colors.bg
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Parent = screen
    makeCorner(main, 10)
    makeStroke(main, colors.border, 1)

    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 32)
    titleBar.BackgroundColor3 = colors.surface
    titleBar.BorderSizePixel = 0
    titleBar.ZIndex = 2
    titleBar.Parent = main
    makeCorner(titleBar, 10)

    local titleFix = Instance.new("Frame")
    titleFix.Size = UDim2.new(1, 0, 0, 10)
    titleFix.Position = UDim2.new(0, 0, 1, -10)
    titleFix.BackgroundColor3 = colors.surface
    titleFix.BorderSizePixel = 0
    titleFix.ZIndex = 2
    titleFix.Parent = titleBar

    local statusDot = Instance.new("Frame")
    statusDot.Size = UDim2.new(0, 8, 0, 8)
    statusDot.Position = UDim2.new(0, 12, 0.5, -4)
    statusDot.BackgroundColor3 = colors.orange
    statusDot.BorderSizePixel = 0
    statusDot.ZIndex = 3
    statusDot.Parent = titleBar
    makeCorner(statusDot, 10)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -140, 1, 0)
    titleLabel.Position = UDim2.new(0, 28, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Exploit Chat"
    titleLabel.TextColor3 = colors.text
    titleLabel.TextSize = 13
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 3
    titleLabel.Parent = titleBar

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "Status"
    statusLabel.Size = UDim2.new(0, 80, 1, 0)
    statusLabel.Position = UDim2.new(1, -90, 0, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = ""
    statusLabel.TextColor3 = colors.muted
    statusLabel.TextSize = 10
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextXAlignment = Enum.TextXAlignment.Right
    statusLabel.ZIndex = 3
    statusLabel.Parent = titleBar

    -- User list (collapsible)
    local userListFrame = Instance.new("Frame")
    userListFrame.Name = "UserList"
    userListFrame.Size = UDim2.new(1, -8, 0, 0)
    userListFrame.Position = UDim2.new(0, 4, 0, 34)
    userListFrame.BackgroundColor3 = colors.surface2
    userListFrame.BorderSizePixel = 0
    userListFrame.ZIndex = 2
    userListFrame.ClipsDescendants = true
    userListFrame.Parent = main
    makeCorner(userListFrame, 4)

    local userListLayout = Instance.new("UIListLayout", userListFrame)
    userListLayout.Padding = UDim.new(0, 1)
    userListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Messages scroll
    local msgScroll = Instance.new("ScrollingFrame")
    msgScroll.Name = "Messages"
    msgScroll.Size = UDim2.new(1, -8, 1, -108)
    msgScroll.Position = UDim2.new(0, 4, 0, 36)
    msgScroll.BackgroundTransparency = 1
    msgScroll.ScrollBarThickness = 3
    msgScroll.ScrollBarImageColor3 = colors.border
    msgScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    msgScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    msgScroll.BorderSizePixel = 0
    msgScroll.ZIndex = 2
    msgScroll.Parent = main

    local msgLayout = Instance.new("UIListLayout", msgScroll)
    msgLayout.Padding = UDim.new(0, 2)
    msgLayout.SortOrder = Enum.SortOrder.LayoutOrder

    makePad(msgScroll, 4, 4, 8, 8)

    -- Bottom input area
    local inputArea = Instance.new("Frame")
    inputArea.Name = "InputArea"
    inputArea.Size = UDim2.new(1, 0, 0, 68)
    inputArea.Position = UDim2.new(0, 0, 1, -68)
    inputArea.BackgroundColor3 = colors.surface
    inputArea.BorderSizePixel = 0
    inputArea.ZIndex = 2
    inputArea.Parent = main

    local inputAreaFix = Instance.new("Frame")
    inputAreaFix.Size = UDim2.new(1, 0, 0, 10)
    inputAreaFix.Position = UDim2.new(0, 0, 0, -10)
    inputAreaFix.BackgroundColor3 = colors.surface
    inputAreaFix.BorderSizePixel = 0
    inputAreaFix.ZIndex = 2
    inputAreaFix.Parent = inputArea

    -- Mode toggle
    local modeFrame = Instance.new("Frame")
    modeFrame.Size = UDim2.new(1, -16, 0, 24)
    modeFrame.Position = UDim2.new(0, 8, 0, 6)
    modeFrame.BackgroundTransparency = 1
    modeFrame.ZIndex = 3
    modeFrame.Parent = inputArea

    local chatModeBtn = Instance.new("TextButton")
    chatModeBtn.Name = "ChatMode"
    chatModeBtn.Size = UDim2.new(0, 60, 1, 0)
    chatModeBtn.Position = UDim2.new(0, 0, 0, 0)
    chatModeBtn.BackgroundColor3 = colors.accent
    chatModeBtn.Text = "Chat"
    chatModeBtn.TextColor3 = Color3.new(1, 1, 1)
    chatModeBtn.TextSize = 11
    chatModeBtn.Font = Enum.Font.GothamBold
    chatModeBtn.BorderSizePixel = 0
    chatModeBtn.ZIndex = 4
    chatModeBtn.Parent = modeFrame
    makeCorner(chatModeBtn, 5)

    local scriptModeBtn = Instance.new("TextButton")
    scriptModeBtn.Name = "ScriptMode"
    scriptModeBtn.Size = UDim2.new(0, 60, 1, 0)
    scriptModeBtn.Position = UDim2.new(0, 64, 0, 0)
    scriptModeBtn.BackgroundColor3 = colors.surface2
    scriptModeBtn.Text = "Script"
    scriptModeBtn.TextColor3 = colors.muted
    scriptModeBtn.TextSize = 11
    scriptModeBtn.Font = Enum.Font.GothamBold
    scriptModeBtn.BorderSizePixel = 0
    scriptModeBtn.ZIndex = 4
    scriptModeBtn.Parent = modeFrame
    makeCorner(scriptModeBtn, 5)

    local onlineLabel = Instance.new("TextLabel")
    onlineLabel.Name = "OnlineLabel"
    onlineLabel.Size = UDim2.new(1, -130, 1, 0)
    onlineLabel.Position = UDim2.new(0, 130, 0, 0)
    onlineLabel.BackgroundTransparency = 1
    onlineLabel.Text = "0 online"
    onlineLabel.TextColor3 = colors.muted
    onlineLabel.TextSize = 10
    onlineLabel.Font = Enum.Font.Gotham
    onlineLabel.TextXAlignment = Enum.TextXAlignment.Right
    onlineLabel.ZIndex = 4
    onlineLabel.Parent = modeFrame

    -- Input box + send button
    local inputBox = Instance.new("Frame")
    inputBox.Size = UDim2.new(1, -16, 0, 30)
    inputBox.Position = UDim2.new(0, 8, 0, 34)
    inputBox.BackgroundColor3 = colors.bg
    inputBox.BorderSizePixel = 0
    inputBox.ZIndex = 3
    inputBox.Parent = inputArea
    makeCorner(inputBox, 6)
    makeStroke(inputBox, colors.border, 1)

    local textbox = Instance.new("TextBox")
    textbox.Name = "Input"
    textbox.Size = UDim2.new(1, -68, 1, -4)
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
    textbox.ZIndex = 4
    textbox.Parent = inputBox

    local sendBtn = Instance.new("TextButton")
    sendBtn.Name = "Send"
    sendBtn.Size = UDim2.new(0, 56, 0, 22)
    sendBtn.Position = UDim2.new(1, -62, 0.5, -11)
    sendBtn.BackgroundColor3 = colors.accent
    sendBtn.Text = "Send"
    sendBtn.TextColor3 = Color3.new(1, 1, 1)
    sendBtn.TextSize = 11
    sendBtn.Font = Enum.Font.GothamBold
    sendBtn.BorderSizePixel = 0
    sendBtn.ZIndex = 4
    sendBtn.Parent = inputBox
    makeCorner(sendBtn, 5)

    return {
        screen = screen,
        main = main,
        titleBar = titleBar,
        statusDot = statusDot,
        statusLabel = statusLabel,
        userListFrame = userListFrame,
        onlineLabel = onlineLabel,
        messages = msgScroll,
        input = textbox,
        sendBtn = sendBtn,
        chatModeBtn = chatModeBtn,
        scriptModeBtn = scriptModeBtn,
    }
end

local gui = createGUI()
if not gui then
    warn("[ExploitChat] Failed to create GUI")
    return
end

-- ============ DRAGGING (title bar + mobile button) ============

local function makeDraggable(frame, handle)
    local dragging = false
    local dragStart, startPos

    local function updateDrag(input)
        local delta = input.Position - dragStart
        local newX = startPos.X + delta.X
        local newY = startPos.Y + delta.Y
        local vp = workspace.CurrentCamera.ViewportSize
        local frameSize = frame.AbsoluteSize
        newX = math.clamp(newX, 0, vp.X - frameSize.X)
        newY = math.clamp(newY, 0, vp.Y - frameSize.Y)
        frame.Position = UDim2.new(0, newX, 0, newY)
    end

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.AbsolutePosition

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

-- Make the main frame draggable by its title bar
makeDraggable(gui.main, gui.titleBar)

-- ============ MOBILE BUTTON ============

local isTouchDevice = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local mobileBtn

if isTouchDevice then
    mobileBtn = Instance.new("TextButton")
    mobileBtn.Name = "ChatToggle"
    mobileBtn.Size = UDim2.new(0, 52, 0, 52)
    mobileBtn.Position = UDim2.new(0, 10, 1, -70)
    mobileBtn.BackgroundColor3 = colors.accent
    mobileBtn.Text = "Chat"
    mobileBtn.TextColor3 = Color3.new(1, 1, 1)
    mobileBtn.TextSize = 11
    mobileBtn.Font = Enum.Font.GothamBold
    mobileBtn.ZIndex = 1000
    mobileBtn.Parent = gui.screen
    makeCorner(mobileBtn, 26)
    makeStroke(mobileBtn, colors.green, 2)

    makeDraggable(mobileBtn, mobileBtn)

    mobileBtn.MouseButton1Click:Connect(function()
        guiOpen = not guiOpen
        gui.main.Visible = guiOpen
    end)
end

-- ============ MESSAGE RENDERING ============

local msgOrder = 0

local function pruneMessages()
    local kids = gui.messages:GetChildren()
    local count = 0
    for _, k in ipairs(kids) do
        if k:IsA("Frame") or k:IsA("TextLabel") then count += 1 end
    end
    if count > MAX_MESSAGES then
        table.sort(kids, function(a, b) return a.LayoutOrder < b.LayoutOrder end)
        for i = 1, count - MAX_MESSAGES do
            if kids[i] and (kids[i]:IsA("Frame") or kids[i]:IsA("TextLabel")) then
                kids[i]:Destroy()
            end
        end
    end
end

local function addTextMessage(text, color, font, size)
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
    label.ZIndex = 3
    label.Parent = gui.messages
    pruneMessages()
end

local function addChatMsg(user, text, ts)
    msgOrder += 1
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 0)
    f.AutomaticSize = Enum.AutomaticSize.Y
    f.BackgroundTransparency = 1
    f.LayoutOrder = msgOrder
    f.ZIndex = 3
    f.Parent = gui.messages

    local layout = Instance.new("UIListLayout", f)
    layout.Padding = UDim.new(0, 1)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    local headerRow = Instance.new("TextLabel")
    headerRow.Size = UDim2.new(1, 0, 0, 0)
    headerRow.AutomaticSize = Enum.AutomaticSize.Y
    headerRow.BackgroundTransparency = 1
    headerRow.Text = user .. "  " .. (ts or "")
    headerRow.TextColor3 = colors.accent
    headerRow.TextSize = 12
    headerRow.Font = Enum.Font.GothamBold
    headerRow.TextXAlignment = Enum.TextXAlignment.Left
    headerRow.LayoutOrder = 1
    headerRow.ZIndex = 3
    headerRow.Parent = f

    local body = Instance.new("TextLabel")
    body.Size = UDim2.new(1, 0, 0, 0)
    body.AutomaticSize = Enum.AutomaticSize.Y
    body.BackgroundTransparency = 1
    body.Text = text
    body.TextColor3 = colors.text
    body.TextSize = 12
    body.Font = Enum.Font.Gotham
    body.TextWrapped = true
    body.TextXAlignment = Enum.TextXAlignment.Left
    body.LayoutOrder = 2
    body.ZIndex = 3
    body.Parent = f

    pruneMessages()
end

local function addScriptMsg(user, text, ts)
    msgOrder += 1
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 0)
    f.AutomaticSize = Enum.AutomaticSize.Y
    f.BackgroundColor3 = colors.surface
    f.BorderSizePixel = 0
    f.LayoutOrder = msgOrder
    f.ZIndex = 3
    f.Parent = gui.messages
    makeCorner(f, 6)
    makeStroke(f, colors.border, 1)

    local layout = Instance.new("UIListLayout", f)
    layout.Padding = UDim.new(0, 4)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    makePad(f, 6, 6, 8, 8)

    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, 0, 0, 0)
    header.AutomaticSize = Enum.AutomaticSize.Y
    header.BackgroundTransparency = 1
    header.Text = user .. " shared a script  " .. (ts or "")
    header.TextColor3 = colors.purple
    header.TextSize = 11
    header.Font = Enum.Font.GothamBold
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.LayoutOrder = 1
    header.ZIndex = 3
    header.Parent = f

    local codeBg = Instance.new("Frame")
    codeBg.Size = UDim2.new(1, 0, 0, 0)
    codeBg.AutomaticSize = Enum.AutomaticSize.Y
    codeBg.BackgroundColor3 = colors.bg
    codeBg.BorderSizePixel = 0
    codeBg.LayoutOrder = 2
    codeBg.ZIndex = 3
    codeBg.Parent = f
    makeCorner(codeBg, 4)

    local maxLen = 800
    local displayText = #text > maxLen and string.sub(text, 1, maxLen) .. "\n-- (truncated) --" or text

    local codePad = Instance.new("UIPadding", codeBg)
    codePad.PaddingTop = UDim.new(0, 6)
    codePad.PaddingBottom = UDim.new(0, 6)
    codePad.PaddingLeft = UDim.new(0, 8)
    codePad.PaddingRight = UDim.new(0, 8)

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
    code.ZIndex = 3
    code.Parent = codeBg

    local actions = Instance.new("Frame")
    actions.Size = UDim2.new(1, 0, 0, 24)
    actions.BackgroundTransparency = 1
    actions.LayoutOrder = 3
    actions.ZIndex = 3
    actions.Parent = f

    local actionsLayout = Instance.new("UIListLayout", actions)
    actionsLayout.FillDirection = Enum.FillDirection.Horizontal
    actionsLayout.Padding = UDim.new(0, 6)
    actionsLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local copyBtn = Instance.new("TextButton")
    copyBtn.Size = UDim2.new(0, 60, 1, 0)
    copyBtn.BackgroundColor3 = colors.surface2
    copyBtn.BorderSizePixel = 0
    copyBtn.Text = "Copy"
    copyBtn.TextColor3 = colors.muted
    copyBtn.TextSize = 11
    copyBtn.Font = Enum.Font.GothamBold
    copyBtn.ZIndex = 4
    copyBtn.Parent = actions
    makeCorner(copyBtn, 4)

    copyBtn.MouseButton1Click:Connect(function()
        pcall(function() setclipboard(text) end)
        copyBtn.Text = "Copied!"
        copyBtn.TextColor3 = colors.green
        task.delay(1.5, function()
            copyBtn.Text = "Copy"
            copyBtn.TextColor3 = colors.muted
        end)
    end)

    pruneMessages()
end

-- ============ USER LIST ============

local function updateUserList(users)
    for _, child in ipairs(gui.userListFrame:GetChildren()) do
        if child:IsA("TextLabel") then child:Destroy() end
    end

    gui.onlineLabel.Text = #users .. " online"

    for i, u in ipairs(users) do
        local item = Instance.new("TextLabel")
        item.Size = UDim2.new(1, -8, 0, 18)
        item.Position = UDim2.new(0, 4, 0, (i - 1) * 19 + 2)
        item.BackgroundTransparency = 1
        item.Text = "  " .. u
        item.TextColor3 = colors.green
        item.TextSize = 11
        item.Font = Enum.Font.Gotham
        item.TextXAlignment = Enum.TextXAlignment.Left
        item.ZIndex = 3
        item.Parent = gui.userListFrame
    end

    local h = math.min(#users, 6) * 19 + 6
    gui.userListFrame.Size = UDim2.new(1, -8, 0, h)
end

-- ============ WEBSOCKET LOGIC ============

local function wsSend(data)
    if ws and connected then
        rawSend(ws, HttpService:JSONEncode(data))
    end
end

local function connect()
    if connected then return end
    gui.statusLabel.Text = "Connecting"
    gui.statusDot.BackgroundColor3 = colors.orange

    local obj, err = rawConnect(SERVER_URL)
    if not obj then
        gui.statusLabel.Text = "Failed"
        gui.statusDot.BackgroundColor3 = colors.red
        warn("[ExploitChat] " .. tostring(err))
        return false
    end

    ws = obj
    connected = true
    gui.statusLabel.Text = "Online"
    gui.statusDot.BackgroundColor3 = colors.green

    rawSend(ws, HttpService:JSONEncode({
        type = "join",
        username = username,
        client = "lua",
    }))

    addTextMessage("Connected to server", colors.green, Enum.Font.GothamBold)
    return true
end

local function disconnect()
    if ws then rawClose(ws) end
    connected = false
    ws = nil
    gui.statusLabel.Text = "Offline"
    gui.statusDot.BackgroundColor3 = colors.red
end

local function handleMessage(data)
    if data.type == "joined" then
        username = data.username
        addTextMessage("Joined as " .. data.username, colors.green, Enum.Font.GothamBold)

    elseif data.type == "userlist" then
        updateUserList(data.users)

    elseif data.type == "chat" then
        local ts = data.ts and os.date("!%H:%M", math.floor(data.ts / 1000)) or ""
        addChatMsg(data.user, data.text, ts)

    elseif data.type == "script" then
        local ts = data.ts and os.date("!%H:%M", math.floor(data.ts / 1000)) or ""
        addScriptMsg(data.user, data.text, ts)

    elseif data.type == "system" then
        addTextMessage(data.text, colors.muted, Enum.Font.Gotham, 11)

    elseif data.type == "exec" then
        addTextMessage("Executing script from " .. tostring(data.from) .. "...", colors.orange, Enum.Font.GothamBold)
        wsSend({ type = "output", text = "Running script from " .. tostring(data.from) })

        local func, err = loadstring(data.text)
        if func then
            local ok, runErr = pcall(func)
            if ok then
                addTextMessage("Script executed successfully", colors.green)
                wsSend({ type = "output", text = "Script completed successfully" })
            else
                addTextMessage("Runtime error: " .. tostring(runErr), colors.red)
                wsSend({ type = "output", text = "Error: " .. tostring(runErr) })
            end
        else
            addTextMessage("Load error: " .. tostring(err), colors.red)
            wsSend({ type = "output", text = "Load error: " .. tostring(err) })
        end
    end
end

local function listen()
    while connected do
        local msg = rawRead(ws)
        if not msg then
            task.wait(0.1)
            -- Check if still connected by trying to read a close
            if not ws then
                disconnect()
                break
            end
            continue
        end

        if msg == "Close" or msg == "Disconnect" or msg == "" then
            disconnect()
            break
        end

        local ok, data = pcall(function() return HttpService:JSONDecode(msg) end)
        if ok and data then
            handleMessage(data)
        end
    end
end

-- ============ INPUT ============

local function sendInput()
    local text = gui.input.Text
    if text == "" or not text then return end
    gui.input.Text = ""

    if inputMode == "chat" then
        wsSend({ type = "chat", text = text })
    else
        wsSend({ type = "script", text = text })
    end
end

gui.input.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        sendInput()
        return
    end
end)

gui.sendBtn.MouseButton1Click:Connect(sendInput)

gui.chatModeBtn.MouseButton1Click:Connect(function()
    inputMode = "chat"
    gui.chatModeBtn.BackgroundColor3 = colors.accent
    gui.chatModeBtn.TextColor3 = Color3.new(1, 1, 1)
    gui.scriptModeBtn.BackgroundColor3 = colors.surface2
    gui.scriptModeBtn.TextColor3 = colors.muted
    gui.input.PlaceholderText = "Type a message..."
    gui.input.Text = ""
    gui.input.Focus()
end)

gui.scriptModeBtn.MouseButton1Click:Connect(function()
    inputMode = "script"
    gui.scriptModeBtn.BackgroundColor3 = colors.purple
    gui.scriptModeBtn.TextColor3 = Color3.new(1, 1, 1)
    gui.chatModeBtn.BackgroundColor3 = colors.surface2
    gui.chatModeBtn.TextColor3 = colors.muted
    gui.input.PlaceholderText = "-- Paste Lua script here --"
    gui.input.Text = ""
    gui.input.Focus()
end)

-- ============ TOGGLE ============

local function toggleGUI()
    guiOpen = not guiOpen
    gui.main.Visible = guiOpen
    if mobileBtn then mobileBtn.Visible = guiOpen end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == TOGGLE_KEY then
        toggleGUI()
    end
end)

-- ============ RECONNECT LOOP ============

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

-- ============ PUBLIC API ============

getgenv().ExploitChat = {
    sendChat = function(text) wsSend({ type = "chat", text = tostring(text) }) end,
    sendScript = function(text) wsSend({ type = "script", text = tostring(text) }) end,
    setUsername = function(name)
        username = tostring(name):sub(1, 24)
        if connected then
            wsSend({ type = "join", username = username, client = "lua" })
        end
    end,
    toggle = toggleGUI,
    disconnect = disconnect,
    reconnect = function() disconnect() end,
}

-- ============ STARTUP ============

addTextMessage("Exploit Chat loaded", colors.accent, Enum.Font.GothamBold)
if isTouchDevice then
    addTextMessage("Tap the floating button to toggle", colors.muted, Enum.Font.Gotham, 11)
else
    addTextMessage("Press F2 to toggle | /help for commands", colors.muted, Enum.Font.Gotham, 11)
end
