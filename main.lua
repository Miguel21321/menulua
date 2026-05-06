local Menu = {}
Menu.Visible = false
Menu.CurrentCategory = 2
Menu.CurrentPage = 1
Menu.ItemsPerPage = 9
Menu.scrollbarY = nil
Menu.scrollbarHeight = nil
Menu.OpenedCategory = nil
Menu.CurrentItem = 1
Menu.CurrentTab = 1
Menu.ItemScrollOffset = 0
Menu.CategoryScrollOffset = 0
Menu.EditorDragging = false
Menu.EditorDragOffsetX = 0
Menu.EditorDragOffsetY = 0
Menu.EditorMode = false
Menu.OverlayPanelRects = {}
Menu.OverlayPanelDragging = false
Menu.OverlayPanelDragOffsetX = 0
Menu.OverlayPanelDragOffsetY = 0
Menu.ShowSnowflakes = false
Menu.SelectorY = 0
Menu.CategorySelectorY = 0
Menu.TabSelectorX = 0
Menu.TabSelectorWidth = 0
Menu.SmoothFactor = 0.2
Menu.GradientType = 1
Menu.ScrollbarPosition = 1

Menu.LoadingBarAlpha = 0.0
Menu.KeySelectorAlpha = 0.0
Menu.KeybindsInterfaceAlpha = 0.0

Menu.LoadingProgress = 0.0
Menu.IsLoading = true
Menu.LoadingComplete = false
Menu.LoadingStartTime = nil
Menu.LoadingDuration = 3000

Menu.SelectingKey = false
Menu.SelectedKey = nil
Menu.SelectedKeyName = nil

Menu.SelectingBind = false
Menu.BindingItem = nil
Menu.BindingKey = nil
Menu.BindingKeyName = nil

Menu.ShowKeybinds = false
Menu.ShowBlossoms = false
Menu.ShowSpectatorList = false
Menu.SpectatorEntries = {}
Menu.SpectatorListAlpha = 0.0
Menu.ClickableMenu = false
Menu.DisplayMenu = false
Menu.DisplayMenuHoverCategory = nil
Menu.DisplayMenuHoverTab = nil
Menu.DisplayMenuHoverItem = nil
Menu.DisplayMenuActiveSlider = nil
Menu.DisplayMenuLeftWasDown = false
Menu.DisplayMenuRightWasDown = false
Menu.DisplayMenuItemScrollOffset = 0
Menu.DisplayMenuCurrentMap = nil
Menu.MouseLeftWasDown = false
Menu.MouseRightWasDown = false
Menu.ActiveMouseSlider = nil
Menu.KeybindsPanelOffsetX = 0
Menu.KeybindsPanelOffsetY = 0
Menu.SpectatorPanelOffsetX = 0
Menu.SpectatorPanelOffsetY = 0
Menu.KeybindsPositionMode = false
Menu.SpectatorPositionMode = false
Menu.BindShortcutKey = 0x79
Menu.BindShortcutLabel = "F10"
Menu.SuppressCaptureUntilRelease = nil


Menu.CurrentTopTab = 1
function Menu.UpdateCategoriesFromTopTab()
    if not Menu.TopLevelTabs then return end
    local currentTop = Menu.TopLevelTabs[Menu.CurrentTopTab]
    if not currentTop then return end

    Menu.Categories = {}
    table.insert(Menu.Categories, { name = currentTop.name })
    for _, cat in ipairs(currentTop.categories) do
        table.insert(Menu.Categories, cat)
    end
    
    Menu.CurrentCategory = 2
    Menu.CategoryScrollOffset = 0
    Menu.OpenedCategory = nil
    
    if currentTop.autoOpen then
        Menu.OpenedCategory = 2
        Menu.CurrentTab = 1
        Menu.ItemScrollOffset = 0
        Menu.CurrentItem = 1
    end
end

Menu.Banner = {
    enabled = true,
    imageUrl = "https://i.imgur.com/0wsZY4t.png",
    height = 100
}

Menu.bannerTexture = nil
Menu.bannerWidth = 0
Menu.bannerHeight = 0

function Menu.LoadBannerTexture(url)
    if not url or url == "" then return end
    if not Susano or not Susano.HttpGet or not Susano.LoadTextureFromBuffer then return end

    if CreateThread then
        CreateThread(function()
            local success, result = pcall(function()
                local status, body = Susano.HttpGet(url)
                if status == 200 and body and #body > 0 then
                    local textureId, width, height = Susano.LoadTextureFromBuffer(body)
                    if textureId and textureId ~= 0 then
                        Menu.bannerTexture = textureId
                        Menu.bannerWidth = width
                        Menu.bannerHeight = height
                        return textureId
                    end
                end
                return nil
            end)
            if not success then
            end
        end)
    else
        local success, result = pcall(function()
            local status, body = Susano.HttpGet(url)
            if status == 200 and body and #body > 0 then
                local textureId, width, height = Susano.LoadTextureFromBuffer(body)
                if textureId and textureId ~= 0 then
                    Menu.bannerTexture = textureId
                    Menu.bannerWidth = width
                    Menu.bannerHeight = height
                    print("Banner texture loaded successfully")
                    return textureId
                end
            end
            return nil
        end)
        if not success then
        end
    end
end

Menu.Colors = {
    HeaderPink = { r = 148, g = 0, b = 211 },
    SelectedBg = { r = 148, g = 0, b = 211 },
    TextWhite = { r = 255, g = 255, b = 255 },
    BackgroundDark = { r = 0, g = 0, b = 0 },
    FooterBlack = { r = 0, g = 0, b = 0 }
}

Menu.CurrentTheme = "Blue"

function Menu.ApplyTheme(themeName)
    if not themeName or type(themeName) ~= "string" then
        themeName = "Blue"
    end
    

    local themeLower = string.lower(themeName)
    Menu.CurrentTheme = themeName
    
    if themeLower == "blue" or themeLower == "red" then
        Menu.Colors.HeaderPink = { r = 0, g = 221, b = 255 }
        Menu.Colors.SelectedBg = { r = 0, g = 221, b = 255 }
        Menu.Banner.imageUrl = "https://i.imgur.com/0wsZY4t.png"
        Menu.CurrentTheme = "Blue"
    elseif themeLower == "purple" then
        Menu.Colors.HeaderPink = { r = 148, g = 0, b = 211 }
        Menu.Colors.SelectedBg = { r = 148, g = 0, b = 211 }
        Menu.Banner.imageUrl = "https://i.imgur.com/0wsZY4t.png"
        Menu.CurrentTheme = "Purple"
    elseif themeLower == "gray" then
        Menu.Colors.HeaderPink = { r = 128, g = 128, b = 128 }
        Menu.Colors.SelectedBg = { r = 128, g = 128, b = 128 }
        Menu.Banner.imageUrl = "https://i.imgur.com/0wsZY4t.png"
        Menu.CurrentTheme = "Gray"
    elseif themeLower == "pink" then
        Menu.Colors.HeaderPink = { r = 255, g = 20, b = 147 }
        Menu.Colors.SelectedBg = { r = 255, g = 20, b = 147 }
        Menu.Banner.imageUrl = "https://i.imgur.com/0wsZY4t.png"
        Menu.CurrentTheme = "pink"
    else
        Menu.Colors.HeaderPink = { r = 0, g = 221, b = 255 }
        Menu.Colors.SelectedBg = { r = 0, g = 221, b = 255 }
        Menu.Banner.imageUrl = "https://i.imgur.com/0wsZY4t.png"
        Menu.CurrentTheme = "Blue"
    end

    if Menu.Banner.enabled and Menu.Banner.imageUrl then
        Menu.LoadBannerTexture(Menu.Banner.imageUrl)
    end
end

Menu.Position = {
    x = 50,
    y = 170,
    width = 360,
    itemHeight = 34,
    mainMenuHeight = 26,
    headerHeight = 100,
    footerHeight = 26,
    footerSpacing = 5,
    mainMenuSpacing = 5,
    footerRadius = 4,
    itemRadius = 4,
    scrollbarWidth = 12,
    scrollbarPadding = 3,
    headerRadius = 6
}
Menu.DefaultScaleMultiplier = 1.16
Menu.Scale = Menu.DefaultScaleMultiplier
Menu.TextRenderer = "susano"
Menu.TextFont = 0
Menu.TextNativeScaleDivisor = 50.0
Menu.TextNativeUseOutline = false
Menu.TextShadowEnabled = true
Menu.Notifications = {}
Menu.NotificationDuration = 5000
Menu.NotificationMaxVisible = 4
Menu.BlockInputWhileOpen = true
Menu.BlockedControlsWhileOpen = {
    38, -- E / INPUT_CONTEXT
    44  -- Q / INPUT_COVER
}

function Menu.GetScaledPosition()
    local scale = Menu.Scale or 1.0
    return {
        x = Menu.Position.x,
        y = Menu.Position.y,
        width = Menu.Position.width * scale,
        itemHeight = Menu.Position.itemHeight * scale,
        mainMenuHeight = Menu.Position.mainMenuHeight * scale,
        headerHeight = Menu.Position.headerHeight * scale,
        footerHeight = Menu.Position.footerHeight * scale,
        footerSpacing = Menu.Position.footerSpacing * scale,
        mainMenuSpacing = Menu.Position.mainMenuSpacing * scale,
        footerRadius = Menu.Position.footerRadius * scale,
        itemRadius = Menu.Position.itemRadius * scale,
        scrollbarWidth = Menu.Position.scrollbarWidth * scale,
        scrollbarPadding = Menu.Position.scrollbarPadding * scale,
        headerRadius = Menu.Position.headerRadius * scale
    }
end

function Menu.DrawRect(x, y, width, height, r, g, b, a)
    a = a or 1.0
    r = r or 1.0
    g = g or 1.0
    b = b or 1.0

    if r > 1.0 then r = r / 255.0 end
    if g > 1.0 then g = g / 255.0 end
    if b > 1.0 then b = b / 255.0 end
    if a > 1.0 then a = a / 255.0 end

    if Susano.DrawFilledRect then
        Susano.DrawFilledRect(x, y, width, height, r, g, b, a)
    elseif Susano.FillRect then
        Susano.FillRect(x, y, width, height, r, g, b, a)
    elseif Susano.DrawRect then
        for i = 0, height - 1 do
            Susano.DrawRect(x, y + i, width, 1, r, g, b, a)
        end
    end
end

local NativeSetTextFont = SetTextFont
local NativeSetTextScale = SetTextScale
local NativeSetTextColour = SetTextColour
local NativeSetTextProportional = SetTextProportional
local NativeSetTextEntry = SetTextEntry
local NativeAddTextComponentString = AddTextComponentString
local NativeAddTextComponentSubstringPlayerName = AddTextComponentSubstringPlayerName
local NativeDrawText = DrawText
local NativeSetTextCentre = SetTextCentre
local NativeSetTextJustification = SetTextJustification
local NativeSetTextWrap = SetTextWrap
local NativeSetTextDropshadow = SetTextDropshadow
local NativeSetTextDropShadow = SetTextDropShadow
local NativeSetTextOutline = SetTextOutline
local NativeBeginTextCommandGetWidth = BeginTextCommandGetWidth
local NativeBeginTextCommandWidth = BeginTextCommandWidth
local NativeEndTextCommandGetWidth = EndTextCommandGetWidth
local NativeTextPipelineReady = nil

local function RoundToNearestPixel(value)
    return math.floor((value or 0) + 0.5)
end

local function GetTextRenderScreenSize()
    if Susano and Susano.GetScreenWidth and Susano.GetScreenHeight then
        local width = Susano.GetScreenWidth()
        local height = Susano.GetScreenHeight()
        if width and height and width > 0 and height > 0 then
            return width, height
        end
    end

    if GetActiveScreenResolution then
        return GetActiveScreenResolution()
    end

    return 1920, 1080
end

local function ResolveTextSize(size_px)
    local scale = Menu.Scale or 1.0
    return math.max(1, (size_px or 16) * scale)
end

local function CanUseNativeTextRenderer()
    return false
        and Menu.TextRenderer ~= "susano"
        and type(NativeSetTextFont) == "function"
        and type(NativeSetTextScale) == "function"
        and type(NativeSetTextColour) == "function"
        and type(NativeSetTextProportional) == "function"
        and type(NativeSetTextEntry) == "function"
        and type(NativeDrawText) == "function"
        and (type(NativeAddTextComponentSubstringPlayerName) == "function" or type(NativeAddTextComponentString) == "function")
end

local function GetNativeTextAdder()
    if type(NativeAddTextComponentSubstringPlayerName) == "function" then
        return NativeAddTextComponentSubstringPlayerName
    end

    return NativeAddTextComponentString
end

local function SetupNativeTextStyle(resolvedSize, r, g, b, a, emphasis)
    local nativeScale = math.max(0.18, resolvedSize / (Menu.TextNativeScaleDivisor or 50.0))
    local alpha255 = math.max(0, math.min(255, RoundToNearestPixel(a * 255)))

    NativeSetTextFont(Menu.TextFont or 0)
    NativeSetTextScale(nativeScale, nativeScale)
    NativeSetTextProportional(1)
    NativeSetTextColour(
        math.max(0, math.min(255, RoundToNearestPixel(r * 255))),
        math.max(0, math.min(255, RoundToNearestPixel(g * 255))),
        math.max(0, math.min(255, RoundToNearestPixel(b * 255))),
        alpha255
    )

    if NativeSetTextCentre then
        NativeSetTextCentre(false)
    end

    if NativeSetTextJustification then
        NativeSetTextJustification(0)
    end

    if NativeSetTextWrap then
        NativeSetTextWrap(0.0, 1.0)
    end

    if NativeSetTextDropshadow then
        local shadowAlpha = emphasis and math.min(255, RoundToNearestPixel(alpha255 * 0.92)) or math.min(210, RoundToNearestPixel(alpha255 * 0.72))
        NativeSetTextDropshadow(1, 0, 0, 0, shadowAlpha)
    elseif NativeSetTextDropShadow then
        NativeSetTextDropShadow()
    end

    if emphasis and Menu.TextNativeUseOutline and NativeSetTextOutline then
        NativeSetTextOutline()
    end
end

local function ShouldUseNativeTextRenderer()
    if not CanUseNativeTextRenderer() then
        return false
    end

    if NativeTextPipelineReady ~= nil then
        return NativeTextPipelineReady
    end

    local beginWidthCommand = NativeBeginTextCommandGetWidth or NativeBeginTextCommandWidth
    if type(beginWidthCommand) ~= "function" or type(NativeEndTextCommandGetWidth) ~= "function" then
        NativeTextPipelineReady = false
        return false
    end

    local addTextComponent = GetNativeTextAdder()
    SetupNativeTextStyle(16, 1.0, 1.0, 1.0, 1.0, false)
    beginWidthCommand("STRING")
    addTextComponent("W")

    local width = NativeEndTextCommandGetWidth(true)
    NativeTextPipelineReady = type(width) == "number" and width > 0
    return NativeTextPipelineReady
end

local function DrawTextRaw(x, y, text, resolvedSize, r, g, b, a, emphasis)
    local resolvedText = tostring(text or "")

    if ShouldUseNativeTextRenderer() then
        local screenWidth, screenHeight = GetTextRenderScreenSize()
        local addTextComponent = GetNativeTextAdder()

        SetupNativeTextStyle(resolvedSize, r, g, b, a, emphasis)
        NativeSetTextEntry("STRING")
        addTextComponent(resolvedText)
        NativeDrawText(RoundToNearestPixel(x) / screenWidth, RoundToNearestPixel(y) / screenHeight)
        return
    end

    if not Susano or not Susano.DrawText then
        return
    end

    Susano.DrawText(
        RoundToNearestPixel(x),
        RoundToNearestPixel(y),
        resolvedText,
        resolvedSize,
        r,
        g,
        b,
        a
    )
end

function Menu.GetTextWidth(text, size_px)
    local resolvedText = tostring(text or "")
    local resolvedSize = ResolveTextSize(size_px)

    if Susano and Susano.GetTextWidth then
        return Susano.GetTextWidth(resolvedText, resolvedSize)
    end

    return string.len(resolvedText) * (resolvedSize * 0.58)
end

function Menu.DrawText(x, y, text, size_px, r, g, b, a)
    local resolvedSize = ResolveTextSize(size_px)
    r = r or 1.0
    g = g or 1.0
    b = b or 1.0
    a = a or 1.0

    if r > 1.0 then r = r / 255.0 end
    if g > 1.0 then g = g / 255.0 end
    if b > 1.0 then b = b / 255.0 end
    if a > 1.0 then a = a / 255.0 end

    if Susano and Susano.DrawText then
        Susano.DrawText(x, y, tostring(text or ""), resolvedSize, r, g, b, a)
    end
end

function Menu.DrawTextEmphasis(x, y, text, size_px, r, g, b, a)
    local resolvedSize = ResolveTextSize(size_px)
    r = r or 1.0
    g = g or 1.0
    b = b or 1.0
    a = a or 1.0

    if r > 1.0 then r = r / 255.0 end
    if g > 1.0 then g = g / 255.0 end
    if b > 1.0 then b = b / 255.0 end
    if a > 1.0 then a = a / 255.0 end

    if not Susano or not Susano.DrawText then
        return
    end

    local shadowOffset = resolvedSize >= 20 and 1 or 1
    local shadowAlpha = math.min(a * 0.38, 0.42)

    Susano.DrawText(x, y + shadowOffset, tostring(text or ""), resolvedSize, 0.0, 0.0, 0.0, shadowAlpha)
    Susano.DrawText(x, y, tostring(text or ""), resolvedSize, r, g, b, a)
end

local function MenuGetScreenSize()
    if Susano and Susano.GetScreenWidth and Susano.GetScreenHeight then
        local w = Susano.GetScreenWidth()
        local h = Susano.GetScreenHeight()
        if w and h and w > 0 and h > 0 then
            return w, h
        end
    end

    if GetActiveScreenResolution then
        return GetActiveScreenResolution()
    end

    return 1920, 1080
end

local function SetInteractiveOverlayState(enable)
    local desiredState = enable == true
    if Menu.InteractiveOverlayEnabled == desiredState then
        return
    end

    if Susano and Susano.EnableOverlay then
        Susano.EnableOverlay(desiredState)
    end

    Menu.InteractiveOverlayEnabled = desiredState
end

local function IsInteractiveOverlayActive()
    return (Menu.Visible and Menu.ClickableMenu)
        or (Menu.Visible and Menu.DisplayMenu)
        or Menu.EditorMode
        or Menu.KeybindsPositionMode
        or Menu.SpectatorPositionMode
        or Menu.SelectingBind
        or Menu.SelectingKey
        or Menu.InputOpen
end

local DrawClickableCursor
local ResolveOverlayCursorPosition
local GetOverlayMouseState
local IsPointInRect

local function CleanupNotifications()
    if not Menu.Notifications then
        Menu.Notifications = {}
        return
    end

    local now = GetGameTimer and GetGameTimer() or 0
    for i = #Menu.Notifications, 1, -1 do
        local notification = Menu.Notifications[i]
        if not notification or now >= (notification.expiresAt or 0) then
            table.remove(Menu.Notifications, i)
        end
    end
end

local function FormatNotificationValue(value)
    if type(value) == "number" then
        local rounded = math.floor((value * 100) + 0.5) / 100
        if rounded == math.floor(rounded) then
            return tostring(math.floor(rounded))
        end

        local text = string.format("%.2f", rounded)
        text = string.gsub(text, "0+$", "")
        text = string.gsub(text, "%.$", "")
        return text
    end

    if type(value) == "boolean" then
        return value and "Activado" or "Desactivado"
    end

    return tostring(value or "")
end

local function MeasureNotificationTextWidth(text, textSize)
    return Menu.GetTextWidth(text, textSize)
end

local function SplitNotificationWord(word, textSize, maxWidth)
    local fragments = {}
    local currentFragment = ""

    for i = 1, string.len(word) do
        local character = string.sub(word, i, i)
        local candidate = currentFragment .. character

        if currentFragment ~= "" and MeasureNotificationTextWidth(candidate, textSize) > maxWidth then
            table.insert(fragments, currentFragment)
            currentFragment = character
        else
            currentFragment = candidate
        end
    end

    if currentFragment ~= "" then
        table.insert(fragments, currentFragment)
    end

    return fragments
end

local function WrapNotificationText(text, textSize, maxWidth)
    local wrappedLines = {}
    local longestLineWidth = 0
    local sourceText = tostring(text or "")

    for rawLine in string.gmatch(sourceText .. "\n", "(.-)\n") do
        local currentLine = ""

        for word in string.gmatch(rawLine, "%S+") do
            if MeasureNotificationTextWidth(word, textSize) > maxWidth then
                if currentLine ~= "" then
                    local currentWidth = MeasureNotificationTextWidth(currentLine, textSize)
                    table.insert(wrappedLines, currentLine)
                    if currentWidth > longestLineWidth then
                        longestLineWidth = currentWidth
                    end
                    currentLine = ""
                end

                local fragments = SplitNotificationWord(word, textSize, maxWidth)
                for _, fragment in ipairs(fragments) do
                    local fragmentWidth = MeasureNotificationTextWidth(fragment, textSize)
                    table.insert(wrappedLines, fragment)
                    if fragmentWidth > longestLineWidth then
                        longestLineWidth = fragmentWidth
                    end
                end
            else
                local candidate = currentLine == "" and word or (currentLine .. " " .. word)
                local candidateWidth = MeasureNotificationTextWidth(candidate, textSize)

                if currentLine == "" or candidateWidth <= maxWidth then
                    currentLine = candidate
                else
                    local currentWidth = MeasureNotificationTextWidth(currentLine, textSize)
                    table.insert(wrappedLines, currentLine)
                    if currentWidth > longestLineWidth then
                        longestLineWidth = currentWidth
                    end
                    currentLine = word
                end
            end
        end

        if currentLine ~= "" then
            local currentWidth = MeasureNotificationTextWidth(currentLine, textSize)
            table.insert(wrappedLines, currentLine)
            if currentWidth > longestLineWidth then
                longestLineWidth = currentWidth
            end
        elseif rawLine == "" then
            table.insert(wrappedLines, "")
        end
    end

    if #wrappedLines == 0 then
        local lineWidth = MeasureNotificationTextWidth(sourceText, textSize)
        table.insert(wrappedLines, sourceText)
        longestLineWidth = lineWidth
    end

    return wrappedLines, longestLineWidth
end

function Menu.PushNotification(text, kind, replaceKey, duration)
    if not text or text == "" then
        return
    end

    CleanupNotifications()

    local now = GetGameTimer and GetGameTimer() or 0
    local notificationDuration = duration or Menu.NotificationDuration or 2200

    if replaceKey then
        for _, notification in ipairs(Menu.Notifications) do
            if notification.key == replaceKey then
                notification.text = text
                notification.kind = kind or "info"
                notification.createdAt = now
                notification.expiresAt = now + notificationDuration
                return
            end
        end
    end

    table.insert(Menu.Notifications, 1, {
        text = text,
        kind = kind or "info",
        key = replaceKey,
        createdAt = now,
        expiresAt = now + notificationDuration
    })

    while #Menu.Notifications > (Menu.NotificationMaxVisible or 5) do
        table.remove(Menu.Notifications)
    end
end

function Menu.HasNotifications()
    CleanupNotifications()
    return Menu.Notifications and #Menu.Notifications > 0
end

function Menu.NotifyInteraction(item, mode, value)
    if not item or item.isSeparator then
        return
    end

    local itemName = item.name or "Opcion"
    local notificationText = nil
    local kind = "info"
    local replaceKey = mode .. ":" .. itemName
    local duration = nil

    if mode == "toggle" then
        local state = value
        if state == nil then
            state = item.value
        end
        local isEnabled = state == true
        notificationText = itemName .. (isEnabled and " activado" or " desactivado")
        kind = isEnabled and "success" or "danger"
    elseif mode == "action" then
        notificationText = itemName .. " ejecutado"
        kind = "info"
    elseif mode == "selector" then
        local optionValue = value
        if optionValue == nil and item.options and item.selected then
            optionValue = item.options[item.selected]
        end
        notificationText = itemName .. ": " .. tostring(optionValue or item.selected or "")
        kind = "info"
    elseif mode == "slider" then
        notificationText = itemName .. ": " .. FormatNotificationValue(value ~= nil and value or item.value)
        kind = "info"
    elseif mode == "toggle_slider" then
        notificationText = itemName .. ": " .. FormatNotificationValue(value ~= nil and value or item.sliderValue)
        kind = "info"
    elseif mode == "bind" then
        notificationText = itemName .. ": " .. tostring(value or "")
        kind = "info"
    end

    if notificationText then
        Menu.PushNotification(notificationText, kind, replaceKey, duration)
    end
end

function Menu.DrawNotifications()
    CleanupNotifications()
    if not Menu.Notifications or #Menu.Notifications == 0 then
        return
    end

    local screenWidth, _ = MenuGetScreenSize()
    local scale = Menu.Scale or 1.0
    local textSize = 18
    local minToastWidth = 220 * scale
    local maxToastWidth = math.max(minToastWidth, math.min(screenWidth - (40 * scale), 960 * scale))
    local horizontalPadding = 28 * scale
    local textTopPadding = 14 * scale
    local lineAdvance = 22 * scale
    local progressGap = 13 * scale
    local bottomPadding = 8 * scale
    local toastSpacing = 12 * scale
    local startY = 30 * scale
    local progressHeight = math.max(4, 5 * scale)
    local progressInset = 20 * scale
    local cornerRadius = 10 * scale
    local roundedCornerRadius = math.max(1, math.floor(cornerRadius + 0.5))
    local topHighlightInset = 16 * scale
    local topHighlightOffset = 7 * scale
    local topHighlightHeight = math.max(2, 2 * scale)
    local highlightRadius = math.max(1, math.floor((topHighlightHeight / 2) + 0.5))
    local currentY = startY

    for _, notification in ipairs(Menu.Notifications) do
        local now = GetGameTimer and GetGameTimer() or 0
        local fadeIn = math.min(1.0, (now - notification.createdAt) / 180.0)
        local fadeOut = math.min(1.0, (notification.expiresAt - now) / 220.0)
        local alpha = math.max(0.0, math.min(fadeIn, fadeOut))
        local text = tostring(notification.text or "")
        local wrappedLines, longestLineWidth = WrapNotificationText(text, textSize, math.max(1, maxToastWidth - (horizontalPadding * 2)))
        local toastWidth = math.max(minToastWidth, math.min(maxToastWidth, longestLineWidth + (horizontalPadding * 2)))
        local lineCount = math.max(1, #wrappedLines)
        local toastHeight = textTopPadding + ((lineCount - 1) * lineAdvance) + (textSize * scale) + progressGap + progressHeight + bottomPadding
        local x = math.floor((screenWidth / 2) - (toastWidth / 2))
        local y = math.floor(currentY)
        local progressWidth = math.max(0, toastWidth - (progressInset * 2))
        local progressX = x + progressInset
        local progressY = y + toastHeight - bottomPadding - progressHeight
        local progressRadius = math.max(1, math.floor((progressHeight / 2) + 0.5))
        local topHighlightWidth = math.max(0, toastWidth - (topHighlightInset * 2))
        local topHighlightX = x + topHighlightInset
        local topHighlightY = y + topHighlightOffset

        if alpha > 0.0 then
            local lifeSpan = math.max(1, (notification.expiresAt or now) - (notification.createdAt or now))
            local remaining = math.max(0, (notification.expiresAt or now) - now)
            local progress = math.max(0.0, math.min(1.0, remaining / lifeSpan))
            local progressFillWidth = math.max(0, progressWidth * progress)

            local bgR, bgG, bgB = 0.08, 0.09, 0.11
            local borderR, borderG, borderB = 0.18, 0.20, 0.24
            local accentR, accentG, accentB = Menu.Colors.SelectedBg.r / 255.0, Menu.Colors.SelectedBg.g / 255.0, Menu.Colors.SelectedBg.b / 255.0

            if notification.kind == "success" then
                bgR, bgG, bgB = 0.07, 0.15, 0.10
                borderR, borderG, borderB = 0.17, 0.35, 0.23
                accentR, accentG, accentB = 0.23, 0.84, 0.39
            elseif notification.kind == "danger" then
                bgR, bgG, bgB = 0.18, 0.07, 0.08
                borderR, borderG, borderB = 0.33, 0.16, 0.17
                accentR, accentG, accentB = 0.92, 0.29, 0.29
            end

            if Susano and Susano.DrawRectFilled then
                Susano.DrawRectFilled(x, y + (4 * scale), toastWidth, toastHeight, 0.0, 0.0, 0.0, 0.20 * alpha, cornerRadius)
                Susano.DrawRectFilled(x, y, toastWidth, toastHeight, bgR, bgG, bgB, 0.97 * alpha, cornerRadius)
                if topHighlightWidth > 0 then
                    Susano.DrawRectFilled(topHighlightX, topHighlightY, topHighlightWidth, topHighlightHeight, borderR, borderG, borderB, 0.42 * alpha, topHighlightHeight / 2)
                end
                Susano.DrawRectFilled(progressX, progressY, progressWidth, progressHeight, 0.17, 0.18, 0.21, 0.90 * alpha, progressHeight / 2)
                if progressFillWidth > 0 then
                    Susano.DrawRectFilled(progressX, progressY, progressFillWidth, progressHeight, accentR, accentG, accentB, 1.0 * alpha, progressHeight / 2)
                end
            else
                Menu.DrawRoundedRect(x, y + (4 * scale), toastWidth, toastHeight, 0.0, 0.0, 0.0, 0.20 * alpha, roundedCornerRadius)
                Menu.DrawRoundedRect(x, y, toastWidth, toastHeight, bgR, bgG, bgB, 0.97 * alpha, roundedCornerRadius)
                if topHighlightWidth > 0 then
                    Menu.DrawRoundedRect(topHighlightX, topHighlightY, topHighlightWidth, topHighlightHeight, borderR, borderG, borderB, 0.42 * alpha, highlightRadius)
                end
                Menu.DrawRoundedRect(progressX, progressY, progressWidth, progressHeight, 0.17, 0.18, 0.21, 0.90 * alpha, progressRadius)
                if progressFillWidth > 0 then
                    if progressFillWidth > (progressRadius * 2) then
                        Menu.DrawRoundedRect(progressX, progressY, progressFillWidth, progressHeight, accentR, accentG, accentB, 1.0 * alpha, progressRadius)
                    else
                        Menu.DrawRect(progressX, progressY, progressFillWidth, progressHeight, accentR, accentG, accentB, 1.0 * alpha)
                    end
                end
            end

            for lineIndex, lineText in ipairs(wrappedLines) do
                local lineWidth = MeasureNotificationTextWidth(lineText, textSize)
                local textX = math.floor(x + (toastWidth / 2) - (lineWidth / 2))
                local textY = math.floor(y + textTopPadding + ((lineIndex - 1) * lineAdvance))

                Menu.DrawTextEmphasis(textX, textY, lineText, textSize, 1.0, 1.0, 1.0, alpha)
            end
        end

        currentY = currentY + toastHeight + toastSpacing
    end
end

function Menu.BlockGameplayInput()
    if not Menu.Visible or not Menu.BlockInputWhileOpen then
        return
    end

    if Menu.DisplayMenu then
        return
    end

    if not DisableControlAction then
        return
    end

    for group = 0, 2 do
        for _, control in ipairs(Menu.BlockedControlsWhileOpen or {}) do
            DisableControlAction(group, control, true)

            if DisableDisabledControlAction then
                DisableDisabledControlAction(group, control, true)
            end
        end
    end
end

function Menu.DrawHeader()
    local scaledPos = Menu.GetScaledPosition()
    local scale = Menu.Scale or 1.0
    local x = scaledPos.x
    local y = scaledPos.y
    local width = scaledPos.width - 1
    local height = scaledPos.headerHeight
    local radius = scaledPos.headerRadius
    local bannerHeight = Menu.Banner.height * scale

    if Menu.Banner.enabled then
        if Menu.bannerTexture and Menu.bannerTexture > 0 and Susano and Susano.DrawImage then
            
            Susano.DrawImage(Menu.bannerTexture, x, y, width, bannerHeight, 1, 1, 1, 1, 0)
        else
            Menu.DrawRect(x, y, width, height, Menu.Colors.HeaderPink.r, Menu.Colors.HeaderPink.g, Menu.Colors.HeaderPink.b, 255)

            local logoX = x + width / 2 - 12
            local logoY = y + height / 2 - 20
            Menu.DrawText(logoX, logoY, "P", 44, 1.0, 1.0, 1.0, 1.0)
        end
    else
        Menu.DrawRect(x, y, width, height, Menu.Colors.HeaderPink.r, Menu.Colors.HeaderPink.g, Menu.Colors.HeaderPink.b, 255)

        local logoX = x + width / 2 - 12
        local logoY = y + height / 2 - 20
        Menu.DrawText(logoX, logoY, "P", 44, 1.0, 1.0, 1.0, 1.0)
    end
end

function Menu.DrawScrollbar(x, startY, visibleHeight, selectedIndex, totalItems, isMainMenu, menuWidth)
    if totalItems < 1 then
        return
    end

    local scaledPos = Menu.GetScaledPosition()
    local scrollbarWidth = scaledPos.scrollbarWidth
    local scrollbarPadding = scaledPos.scrollbarPadding
    local width = menuWidth or scaledPos.width

    local scrollbarX
    if Menu.ScrollbarPosition == 2 then
        scrollbarX = x + width + scrollbarPadding
    else
        scrollbarX = x - scrollbarWidth - scrollbarPadding
    end

    local scrollbarY = startY
    local scrollbarHeight = visibleHeight

    local adjustedIndex = selectedIndex
    if isMainMenu then
        adjustedIndex = selectedIndex - 1
    end


    local thumbHeight = scrollbarHeight  
    local thumbY
    
    if totalItems <= Menu.ItemsPerPage then
 
        thumbY = scrollbarY
    else
  
        local scrollOffset = 0
        if not isMainMenu and Menu.ItemScrollOffset then
            scrollOffset = Menu.ItemScrollOffset
        elseif isMainMenu and Menu.CategoryScrollOffset then
            scrollOffset = Menu.CategoryScrollOffset
        end
        
        local totalScrollable = totalItems - Menu.ItemsPerPage
        local scrollProgress = scrollOffset / math.max(1, totalScrollable)
        scrollProgress = math.min(1.0, math.max(0.0, scrollProgress))
        
      
        local maxThumbY = scrollbarY + scrollbarHeight - thumbHeight
        thumbY = scrollbarY + scrollProgress * (scrollbarHeight - thumbHeight)
        thumbY = math.max(scrollbarY, math.min(maxThumbY, thumbY))
    end

    if not Menu.scrollbarY then
        Menu.scrollbarY = thumbY
    end
    if not Menu.scrollbarHeight then
        Menu.scrollbarHeight = thumbHeight
    end

    local smoothSpeed = 0.15
    Menu.scrollbarY = Menu.scrollbarY + (thumbY - Menu.scrollbarY) * smoothSpeed
    Menu.scrollbarHeight = Menu.scrollbarHeight + (thumbHeight - Menu.scrollbarHeight) * smoothSpeed

    local thumbPadding = 2
    local bgR = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.r) and (Menu.Colors.SelectedBg.r / 255.0) or 1.0
    local bgG = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.g) and (Menu.Colors.SelectedBg.g / 255.0) or 0.0
    local bgB = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.b) and (Menu.Colors.SelectedBg.b / 255.0) or 1.0
    
    
    if Susano and Susano.DrawRectFilled then
      
        Susano.DrawRectFilled(scrollbarX + thumbPadding - 1, Menu.scrollbarY + thumbPadding - 1,
            scrollbarWidth - (thumbPadding * 2) + 2, Menu.scrollbarHeight - (thumbPadding * 2) + 2,
            bgR * 0.3, bgG * 0.3, bgB * 0.3, 0.4,
            (scrollbarWidth - (thumbPadding * 2) + 2) / 2)
       
        Susano.DrawRectFilled(scrollbarX + thumbPadding, Menu.scrollbarY + thumbPadding,
            scrollbarWidth - (thumbPadding * 2), Menu.scrollbarHeight - (thumbPadding * 2),
            bgR, bgG, bgB, 1.0,
            (scrollbarWidth - (thumbPadding * 2)) / 2)
    else
    
        Menu.DrawRoundedRect(scrollbarX + thumbPadding - 1, Menu.scrollbarY + thumbPadding - 1,
            scrollbarWidth - (thumbPadding * 2) + 2, Menu.scrollbarHeight - (thumbPadding * 2) + 2,
            math.floor(bgR * 0.3 * 255), math.floor(bgG * 0.3 * 255), math.floor(bgB * 0.3 * 255), 102,
            (scrollbarWidth - (thumbPadding * 2) + 2) / 2)
     
        Menu.DrawRoundedRect(scrollbarX + thumbPadding, Menu.scrollbarY + thumbPadding,
            scrollbarWidth - (thumbPadding * 2), Menu.scrollbarHeight - (thumbPadding * 2),
            bgR * 255, bgG * 255, bgB * 255, 255,
            (scrollbarWidth - (thumbPadding * 2)) / 2)
    end
end

function Menu.DrawTabs(category, x, startY, width, tabHeight)
    local scale = Menu.Scale or 1.0
    if not category or not category.hasTabs or not category.tabs then
        return
    end

    local numTabs = #category.tabs
    local tabWidth = width / numTabs
    local currentX = x

    for i, tab in ipairs(category.tabs) do
        local tabX = currentX
        local currentTabWidth
        if i == numTabs then
            currentTabWidth = (x + width) - currentX
        else
            currentTabWidth = tabWidth + (0.5 * scale)
        end

        local isSelected = (i == Menu.CurrentTab)

        if isSelected then
            local targetWidth = currentTabWidth
            if i == numTabs then
                targetWidth = math.min(currentTabWidth, (x + width) - tabX - (1 * scale))
            end

            if Menu.TabSelectorX == 0 then
                Menu.TabSelectorX = tabX
                Menu.TabSelectorWidth = targetWidth
            end

            local smoothSpeed = Menu.SmoothFactor
            Menu.TabSelectorX = Menu.TabSelectorX + (tabX - Menu.TabSelectorX) * smoothSpeed
            Menu.TabSelectorWidth = Menu.TabSelectorWidth + (targetWidth - Menu.TabSelectorWidth) * smoothSpeed

            if math.abs(Menu.TabSelectorX - tabX) < (0.5 * scale) then Menu.TabSelectorX = tabX end
            if math.abs(Menu.TabSelectorWidth - targetWidth) < (0.5 * scale) then Menu.TabSelectorWidth = targetWidth end

            local drawX = Menu.TabSelectorX
            local drawWidth = Menu.TabSelectorWidth

            local baseR = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.r) and (Menu.Colors.SelectedBg.r / 255.0) or 1.0
            local baseG = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.g) and (Menu.Colors.SelectedBg.g / 255.0) or 0.0
            local baseB = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.b) and (Menu.Colors.SelectedBg.b / 255.0) or 1.0
            local darkenAmount = 0.4

            local gradientSteps = 20
            local stepHeight = tabHeight / gradientSteps
            local selectorWidth = drawWidth
            local selectorX = drawX

            for step = 0, gradientSteps - 1 do
                local stepY = startY + (step * stepHeight)
                local actualStepHeight = stepHeight
                local maxY = startY + tabHeight
                if stepY + actualStepHeight > maxY then
                    actualStepHeight = maxY - stepY
                end
                if actualStepHeight > 0 and stepY < maxY then
                    local stepGradientFactor = step / (gradientSteps - 1)
                    local stepDarken = (1 - stepGradientFactor) * darkenAmount

                    local stepR = math.max(0, baseR - stepDarken)
                    local stepG = math.max(0, baseG - stepDarken)
                    local stepB = math.max(0, baseB - stepDarken)

                    if Susano and Susano.DrawRectFilled then
                        Susano.DrawRectFilled(selectorX, stepY, selectorWidth, actualStepHeight, stepR, stepG, stepB, 0.9, 0.0)
                    else
                        Menu.DrawRect(selectorX, stepY, selectorWidth, actualStepHeight, stepR * 255, stepG * 255, stepB * 255, 220)
                    end
                end
            end

            Menu.DrawRect(selectorX, startY, (3 * scale), tabHeight, Menu.Colors.SelectedBg.r, Menu.Colors.SelectedBg.g, Menu.Colors.SelectedBg.b, 255)
        end

        Menu.DrawRect(tabX, startY, currentTabWidth, tabHeight, Menu.Colors.BackgroundDark.r, Menu.Colors.BackgroundDark.g, Menu.Colors.BackgroundDark.b, isSelected and 0 or 50)

        local textSize = 17
        local scaledTextSize = ResolveTextSize(textSize)
        local textY = startY + tabHeight / 2 - (scaledTextSize / 2) + (1 * scale)
        local textWidth = Menu.GetTextWidth(tab.name, textSize)
        local textX = tabX + (currentTabWidth / 2) - (textWidth / 2)
        Menu.DrawText(textX, textY, tab.name, textSize, Menu.Colors.TextWhite.r / 255.0, Menu.Colors.TextWhite.g / 255.0, Menu.Colors.TextWhite.b / 255.0, 1.0)

        currentX = currentX + tabWidth
    end
end

local function findNextNonSeparator(items, startIndex, direction)
    local index = startIndex
    local attempts = 0
    local maxAttempts = #items

    while attempts < maxAttempts do
        index = index + direction
        if index < 1 then
            index = #items
        elseif index > #items then
            index = 1
        end

        if items[index] and not items[index].isSeparator then
            return index
        end

        attempts = attempts + 1
    end

    return startIndex
end

function Menu.DrawItem(x, itemY, width, itemHeight, item, isSelected)
    local scale = Menu.Scale or 1.0
    
    if item.isSeparator then
        Menu.DrawRect(x, itemY, width, itemHeight, Menu.Colors.BackgroundDark.r, Menu.Colors.BackgroundDark.g, Menu.Colors.BackgroundDark.b, 50)

        if item.separatorText then
            local textY = itemY + itemHeight / 2 - (7 * scale)
            local textWidth = Menu.GetTextWidth(item.separatorText, 14)

            local textX = x + (width / 2) - (textWidth / 2)

            Menu.DrawText(textX, textY, item.separatorText, 14, Menu.Colors.TextWhite.r / 255.0, Menu.Colors.TextWhite.g / 255.0, Menu.Colors.TextWhite.b / 255.0, 1.0)

            local barY = itemY + (itemHeight / 2)
            local barSpacing = 8 * scale
            local barMaxLength = 80 * scale
            local barHeight = 1 * scale
            local barRadius = 0.5 * scale

            local leftBarX = textX - barSpacing - barMaxLength
            local leftBarWidth = math.min(barMaxLength, textX - leftBarX - barSpacing)
            if leftBarWidth > 0 and leftBarX >= x + 15 then
                if Susano and Susano.DrawRectFilled then
                    Susano.DrawRectFilled(leftBarX, math.floor(barY), leftBarWidth, barHeight,
                        Menu.Colors.TextWhite.r / 255.0, Menu.Colors.TextWhite.g / 255.0, Menu.Colors.TextWhite.b / 255.0, 100 / 255.0,
                        barRadius)
                else
                    Menu.DrawRect(leftBarX, math.floor(barY), leftBarWidth, barHeight, Menu.Colors.TextWhite.r, Menu.Colors.TextWhite.g, Menu.Colors.TextWhite.b, 100)
                end
            end

            local rightBarX = textX + textWidth + barSpacing
            local rightBarWidth = math.min(barMaxLength, (x + width - 15) - rightBarX)
            if rightBarWidth > 0 and rightBarX + rightBarWidth <= x + width - 15 then
                if Susano and Susano.DrawRectFilled then
                    Susano.DrawRectFilled(rightBarX, math.floor(barY), rightBarWidth, barHeight,
                        Menu.Colors.TextWhite.r / 255.0, Menu.Colors.TextWhite.g / 255.0, Menu.Colors.TextWhite.b / 255.0, 100 / 255.0,
                        barRadius)
                else
                    Menu.DrawRect(rightBarX, math.floor(barY), rightBarWidth, barHeight, Menu.Colors.TextWhite.r, Menu.Colors.TextWhite.g, Menu.Colors.TextWhite.b, 100)
                end
            end
        end
        return
    end

    Menu.DrawRect(x, itemY, width, itemHeight, Menu.Colors.BackgroundDark.r, Menu.Colors.BackgroundDark.g, Menu.Colors.BackgroundDark.b, 50)

    if isSelected then
        if Menu.SelectorY == 0 then
            Menu.SelectorY = itemY
        end

        local smoothSpeed = Menu.SmoothFactor
        Menu.SelectorY = Menu.SelectorY + (itemY - Menu.SelectorY) * smoothSpeed
        if math.abs(Menu.SelectorY - itemY) < 0.5 then
            Menu.SelectorY = itemY
        end
        
        local drawY = Menu.SelectorY

        local baseR = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.r) and (Menu.Colors.SelectedBg.r / 255.0) or 1.0
        local baseG = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.g) and (Menu.Colors.SelectedBg.g / 255.0) or 0.0
        local baseB = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.b) and (Menu.Colors.SelectedBg.b / 255.0) or 1.0
        local darkenAmount = 0.4

        local selectorX = x
        
        if Menu.GradientType == 2 then
            local gradientSteps = 120
            local drawWidth = width - 1
            local stepWidth = drawWidth / gradientSteps
            local selectorY = drawY
            local selectorHeight = itemHeight

            for step = 0, gradientSteps - 1 do
                local stepX = x + (step * stepWidth)
                local actualStepWidth = stepWidth
                
                if actualStepWidth > 0 then
                    local stepGradientFactor = step / (gradientSteps - 1)
                   
                    local easedFactor = stepGradientFactor < 0.5 
                        and 4 * stepGradientFactor * stepGradientFactor * stepGradientFactor
                        or 1 - math.pow(-2 * stepGradientFactor + 2, 3) / 2
                    local darkenFactor = easedFactor * easedFactor
                    local stepDarken = darkenFactor * 0.75

                    local stepR = math.max(0, baseR - stepDarken)
                    local stepG = math.max(0, baseG - stepDarken)
                    local stepB = math.max(0, baseB - stepDarken)
                    
                 
                    local brightness = 1.0
                    if step < gradientSteps * 0.1 then
                        brightness = 1.0 + (0.15 * (1.0 - step / (gradientSteps * 0.1)))
                    end
                    stepR = math.min(1.0, stepR * brightness)
                    stepG = math.min(1.0, stepG * brightness)
                    stepB = math.min(1.0, stepB * brightness)
                    
                    local alpha = 0.95
                    if step > gradientSteps - 20 then
                        alpha = 0.95 * (1.0 - ((step - (gradientSteps - 20)) / 20))
                    end

                    if Susano and Susano.DrawRectFilled then
                        Susano.DrawRectFilled(stepX, selectorY, actualStepWidth, selectorHeight, stepR, stepG, stepB, alpha, 0.0)
                    else
                        Menu.DrawRect(stepX, selectorY, actualStepWidth, selectorHeight, stepR * 255, stepG * 255, stepB * 255, math.floor(alpha * 255))
                    end
                end
            end
        else
            local gradientSteps = 50
            local stepHeight = itemHeight / gradientSteps
            local selectorWidth = width - 1
    
            for step = 0, gradientSteps - 1 do
                local stepY = drawY + (step * stepHeight)
                local actualStepHeight = math.min(stepHeight, (drawY + itemHeight) - stepY)
                if actualStepHeight > 0 then
                    local stepGradientFactor = step / (gradientSteps - 1)
                    
                    local easedFactor = stepGradientFactor * stepGradientFactor * (3.0 - 2.0 * stepGradientFactor)
                    
                    local stepDarken = easedFactor * darkenAmount * 1.0

                    local stepR = math.max(0, baseR - stepDarken)
                    local stepG = math.max(0, baseG - stepDarken)
                    local stepB = math.max(0, baseB - stepDarken)
                    
                   
                    local brightness = 1.0
                    if step < gradientSteps * 0.15 then
                        brightness = 1.0 + (0.12 * (1.0 - step / (gradientSteps * 0.15)))
                    end
                    stepR = math.min(1.0, stepR * brightness)
                    stepG = math.min(1.0, stepG * brightness)
                    stepB = math.min(1.0, stepB * brightness)

                    if Susano and Susano.DrawRectFilled then
                        Susano.DrawRectFilled(selectorX, stepY, selectorWidth, actualStepHeight, stepR, stepG, stepB, 0.95, 0.0)
                    else
                        Menu.DrawRect(selectorX, stepY, selectorWidth, actualStepHeight, stepR * 255, stepG * 255, stepB * 255, 242)
                    end
                end
            end
        end

        Menu.DrawRect(selectorX, drawY, 3, itemHeight, Menu.Colors.SelectedBg.r, Menu.Colors.SelectedBg.g, Menu.Colors.SelectedBg.b, 255)
    end

    local textX = x + (16 * scale)
    local textY = itemY + itemHeight / 2 - (8 * scale)
    local textSize = 17 * scale
    Menu.DrawText(textX, textY, item.name, 17, Menu.Colors.TextWhite.r / 255.0, Menu.Colors.TextWhite.g / 255.0, Menu.Colors.TextWhite.b / 255.0, 1.0)

    if item.type == "toggle" then
        local toggleWidth = 36 * scale
        local toggleHeight = 16 * scale
        local toggleX = x + width - toggleWidth - (16 * scale)
        local toggleY = itemY + (itemHeight / 2) - (toggleHeight / 2)
        local toggleRadius = toggleHeight / 2

        if item.value then
            local tR = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.r) and (Menu.Colors.SelectedBg.r / 255.0) or 1.0
            local tG = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.g) and (Menu.Colors.SelectedBg.g / 255.0) or 0.0
            local tB = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.b) and (Menu.Colors.SelectedBg.b / 255.0) or 1.0

            if Susano and Susano.DrawRectFilled then
                Susano.DrawRectFilled(toggleX, toggleY, toggleWidth, toggleHeight,
                    tR, tG, tB, 0.95,
                    toggleRadius)
            else
                Menu.DrawRoundedRect(toggleX, toggleY, toggleWidth, toggleHeight,
                    tR * 255, tG * 255, tB * 255, 242,
                    toggleRadius)
            end
        else
            if Susano and Susano.DrawRectFilled then
                Susano.DrawRectFilled(toggleX, toggleY, toggleWidth, toggleHeight,
                    0.2, 0.2, 0.2, 0.95,
                    toggleRadius)
            else
                Menu.DrawRoundedRect(toggleX, toggleY, toggleWidth, toggleHeight,
                    51, 51, 51, 242,
                    toggleRadius)
            end
        end

        local circleSize = toggleHeight - 4
        local circleY = toggleY + 2
        local circleX
        if item.value then
            circleX = toggleX + toggleWidth - circleSize - 2
        else
            circleX = toggleX + 2
        end

        local isGrayTheme = (Menu.CurrentTheme == "Gray")
        local circleR, circleG, circleB
        if isGrayTheme then
            circleR = 1.0
            circleG = 1.0
            circleB = 1.0
        else
            circleR = 0.0
            circleG = 0.0
            circleB = 0.0
        end

        if Susano and Susano.DrawRectFilled then
            Susano.DrawRectFilled(circleX, circleY, circleSize, circleSize,
                circleR, circleG, circleB, 1.0,
                circleSize / 2)
        else
            Menu.DrawRoundedRect(circleX, circleY, circleSize, circleSize,
                circleR * 255, circleG * 255, circleB * 255, 255,
                circleSize / 2)
        end

        if item.hasSlider then
            local sliderWidth = 85 * scale
            local sliderHeight = 6 * scale
            local sliderX = x + width - sliderWidth - (95 * scale)
            local sliderY = itemY + (itemHeight / 2) - (sliderHeight / 2)

            local currentValue = item.sliderValue or item.sliderMin or 0.0
            local minValue = item.sliderMin or 0.0
            local maxValue = item.sliderMax or 100.0

            local percent = (currentValue - minValue) / (maxValue - minValue)
            percent = math.max(0.0, math.min(1.0, percent))

            if Susano and Susano.DrawRectFilled then
                Susano.DrawRectFilled(sliderX, sliderY, sliderWidth, sliderHeight,
                    0.12, 0.12, 0.12, 0.7, 3.0)
            else
                Menu.DrawRoundedRect(sliderX, sliderY, sliderWidth, sliderHeight,
                    31, 31, 31, 180, 3.0)
            end

            if percent > 0 then
                if Susano and Susano.DrawRectFilled then
                    local accentR = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.r) and (Menu.Colors.SelectedBg.r / 255.0 * 1.3) or 1.0
                    local accentG = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.g) and (Menu.Colors.SelectedBg.g / 255.0 * 1.3) or 0.0
                    local accentB = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.b) and (Menu.Colors.SelectedBg.b / 255.0 * 1.3) or 1.0
                    accentR = math.min(1.0, accentR)
                    accentG = math.min(1.0, accentG)
                    accentB = math.min(1.0, accentB)
                    Susano.DrawRectFilled(sliderX, sliderY, sliderWidth * percent, sliderHeight,
                        accentR, accentG, accentB, 1.0, 3.0)
                else
                    local accentR = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.r) and math.min(255, Menu.Colors.SelectedBg.r * 1.3) or 255
                    local accentG = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.g) and math.min(255, Menu.Colors.SelectedBg.g * 1.3) or 0
                    local accentB = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.b) and math.min(255, Menu.Colors.SelectedBg.b * 1.3) or 255
                    Menu.DrawRoundedRect(sliderX, sliderY, sliderWidth * percent, sliderHeight,
                        accentR, accentG, accentB, 255, 3.0)
                end
            end

            local thumbSize = 10 * scale
            local thumbX = sliderX + (sliderWidth * percent) - (thumbSize / 2)
            local thumbY = itemY + (itemHeight / 2) - (thumbSize / 2)

            if Susano and Susano.DrawRectFilled then
                Susano.DrawRectFilled(thumbX, thumbY, thumbSize, thumbSize,
                    1.0, 1.0, 1.0, 1.0, 5.0)
            else
                Menu.DrawRoundedRect(thumbX, thumbY, thumbSize, thumbSize,
                    255, 255, 255, 255, 5.0)
            end

            local valueText
            if item.name == "Freecam" then
                valueText = string.format("%.1f", currentValue)
            else
                valueText = string.format("%.1f", currentValue)
            end
            local valuePadding = 10 * scale
            local valueX = sliderX + sliderWidth + valuePadding
            local valueY = sliderY + (sliderHeight / 2) - (6 * scale)
            local valueTextSize = 10 * scale
            Menu.DrawText(valueX, valueY, valueText, 10, Menu.Colors.TextWhite.r / 255.0, Menu.Colors.TextWhite.g / 255.0, Menu.Colors.TextWhite.b / 255.0, 0.8)
        end
    elseif item.type == "toggle_selector" then
        local toggleWidth = 32 * scale
        local toggleHeight = 14 * scale
        local toggleX = x + width - toggleWidth - (15 * scale)
        local toggleY = itemY + (itemHeight / 2) - (toggleHeight / 2)
        local toggleRadius = toggleHeight / 2

        if item.value then
            local tR = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.r) and (Menu.Colors.SelectedBg.r / 255.0) or 1.0
            local tG = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.g) and (Menu.Colors.SelectedBg.g / 255.0) or 0.0
            local tB = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.b) and (Menu.Colors.SelectedBg.b / 255.0) or 1.0

            if Susano and Susano.DrawRectFilled then
                Susano.DrawRectFilled(toggleX, toggleY, toggleWidth, toggleHeight, tR, tG, tB, 0.95, toggleRadius)
            else
                Menu.DrawRoundedRect(toggleX, toggleY, toggleWidth, toggleHeight, tR * 255, tG * 255, tB * 255, 242, toggleRadius)
            end
        else
            if Susano and Susano.DrawRectFilled then
                Susano.DrawRectFilled(toggleX, toggleY, toggleWidth, toggleHeight, 0.2, 0.2, 0.2, 0.95, toggleRadius)
            else
                Menu.DrawRoundedRect(toggleX, toggleY, toggleWidth, toggleHeight, 51, 51, 51, 242, toggleRadius)
            end
        end

        local circleSize = toggleHeight - 4
        local circleY = toggleY + 2
        local circleX
        if item.value then
            circleX = toggleX + toggleWidth - circleSize - 2
        else
            circleX = toggleX + 2
        end

        local isGrayTheme = (Menu.CurrentTheme == "Gray")
        local circleR, circleG, circleB
        if isGrayTheme then
            circleR = 1.0
            circleG = 1.0
            circleB = 1.0
        else
            circleR = 0.0
            circleG = 0.0
            circleB = 0.0
        end

        if Susano and Susano.DrawRectFilled then
            Susano.DrawRectFilled(circleX, circleY, circleSize, circleSize, circleR, circleG, circleB, 1.0, circleSize / 2)
        else
            Menu.DrawRoundedRect(circleX, circleY, circleSize, circleSize, circleR * 255, circleG * 255, circleB * 255, 255, circleSize / 2)
        end

        if item.options then
            local selectedIndex = item.selected or 1
            local selectedOption = item.options[selectedIndex] or ""
            local textY = itemY + itemHeight / 2 - (7 * scale)

            local fullText = "< " .. selectedOption .. " >"
            local selectorWidth = Menu.GetTextWidth(fullText, 16)

            local selectorX = toggleX - selectorWidth - (15 * scale)

            Menu.DrawText(selectorX, textY, "<", 16,
                Menu.Colors.TextWhite.r / 255.0 * 0.8, Menu.Colors.TextWhite.g / 255.0 * 0.8, Menu.Colors.TextWhite.b / 255.0 * 0.8, 0.8)

            local leftArrowWidth = Menu.GetTextWidth("< ", 16)
            Menu.DrawText(selectorX + leftArrowWidth, textY, selectedOption, 16, 1.0, 1.0, 1.0, 1.0)

            local optionWidth = Menu.GetTextWidth(selectedOption, 16)
            Menu.DrawText(selectorX + leftArrowWidth + optionWidth + (5 * scale), textY, ">", 16,
                Menu.Colors.TextWhite.r / 255.0 * 0.8, Menu.Colors.TextWhite.g / 255.0 * 0.8, Menu.Colors.TextWhite.b / 255.0 * 0.8, 0.8)
        end
    elseif item.type == "slider" then
        local sliderWidth = 100 * scale
        local sliderHeight = 7 * scale
        local sliderX = x + width - sliderWidth - (60 * scale)
        local sliderY = itemY + (itemHeight / 2) - (sliderHeight / 2)

        local currentValue = item.value or item.min or 0.0
        local minValue = item.min or 0.0
        local maxValue = item.max or 100.0

        local percent = (currentValue - minValue) / (maxValue - minValue)
        percent = math.max(0.0, math.min(1.0, percent))

        if Susano and Susano.DrawRectFilled then
            Susano.DrawRectFilled(sliderX, sliderY, sliderWidth, sliderHeight,
                0.12, 0.12, 0.12, 0.7, 3.0)
        else
            Menu.DrawRoundedRect(sliderX, sliderY, sliderWidth, sliderHeight,
                31, 31, 31, 180, 3.0)
        end

        if percent > 0 then
            if Susano and Susano.DrawRectFilled then
                local accentR = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.r) and (Menu.Colors.SelectedBg.r / 255.0 * 1.3) or 1.0
                local accentG = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.g) and (Menu.Colors.SelectedBg.g / 255.0 * 1.3) or 0.0
                local accentB = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.b) and (Menu.Colors.SelectedBg.b / 255.0 * 1.3) or 1.0
                accentR = math.min(1.0, accentR)
                accentG = math.min(1.0, accentG)
                accentB = math.min(1.0, accentB)
                Susano.DrawRectFilled(sliderX, sliderY, sliderWidth * percent, sliderHeight,
                    accentR, accentG, accentB, 1.0, 3.0)
            else
                local accentR = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.r) and math.min(255, Menu.Colors.SelectedBg.r * 1.3) or 255
                local accentG = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.g) and math.min(255, Menu.Colors.SelectedBg.g * 1.3) or 0
                local accentB = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.b) and math.min(255, Menu.Colors.SelectedBg.b * 1.3) or 255
                Menu.DrawRoundedRect(sliderX, sliderY, sliderWidth * percent, sliderHeight,
                    accentR, accentG, accentB, 255, 3.0)
            end
        end

        local thumbSize = 11 * scale
        local thumbX = sliderX + (sliderWidth * percent) - (thumbSize / 2)
        local thumbY = itemY + (itemHeight / 2) - (thumbSize / 2)

        if Susano and Susano.DrawRectFilled then
                Susano.DrawRectFilled(thumbX, thumbY, thumbSize, thumbSize,
                    1.0, 1.0, 1.0, 1.0, 5.0 * scale)
            else
                Menu.DrawRoundedRect(thumbX, thumbY, thumbSize, thumbSize,
                    255, 255, 255, 255, 5.0 * scale)
            end

        local valueText = string.format("%.0f", currentValue)
        local valuePadding = 10 * scale
        local valueX = sliderX + sliderWidth + valuePadding
        local valueY = sliderY + (sliderHeight / 2) - (6 * scale)
        local valueTextSize = 11 * scale
        Menu.DrawText(valueX, valueY, valueText, 11, Menu.Colors.TextWhite.r / 255.0, Menu.Colors.TextWhite.g / 255.0, Menu.Colors.TextWhite.b / 255.0, 0.8)
    elseif item.type == "selector" and item.options then
        local selectedIndex = item.selected or 1
        local selectedOption = item.options[selectedIndex] or ""
        local selectorSize = 17 * scale

        local isWardrobeSelector = false
        local wardrobeItemNames = {"Hat", "Mask", "Glasses", "Torso", "Tshirt", "Pants", "Shoes"}
        for _, name in ipairs(wardrobeItemNames) do
            if item.name == name then
                isWardrobeSelector = true
                break
            end
        end

        if isWardrobeSelector then
            local displayValue = selectedIndex
            local selectorText = "- " .. tostring(displayValue) .. " -"
            local selectorWidth = Menu.GetTextWidth(selectorText, 17)
            local selectorX = x + width - selectorWidth - (16 * scale)
            Menu.DrawText(selectorX, textY, selectorText, 17, 1.0, 1.0, 1.0, 1.0)
        else
            local fullText = "< " .. selectedOption .. " >"
            local selectorWidth = Menu.GetTextWidth(fullText, 17)

            local selectorX = x + width - selectorWidth - (16 * scale)

            Menu.DrawText(selectorX, textY, "<", 17,
                Menu.Colors.TextWhite.r / 255.0 * 0.8, Menu.Colors.TextWhite.g / 255.0 * 0.8, Menu.Colors.TextWhite.b / 255.0 * 0.8, 0.8)

            local leftArrowWidth = Menu.GetTextWidth("< ", 17)
            Menu.DrawText(selectorX + leftArrowWidth, textY, selectedOption, 17,
                1.0, 1.0, 1.0, 1.0)

            local optionWidth = Menu.GetTextWidth(selectedOption, 17)
            Menu.DrawText(selectorX + leftArrowWidth + optionWidth + (5 * scale), textY, ">", 17,
                Menu.Colors.TextWhite.r / 255.0 * 0.8, Menu.Colors.TextWhite.g / 255.0 * 0.8, Menu.Colors.TextWhite.b / 255.0 * 0.8, 0.8)
        end
    end
end

function Menu.DrawCategories()
    if Menu.OpenedCategory then
        local category = Menu.Categories[Menu.OpenedCategory]
        if not category or not category.hasTabs or not category.tabs then
            Menu.OpenedCategory = nil
            return
        end

        local scaledPos = Menu.GetScaledPosition()
        local x = scaledPos.x
        local startY = scaledPos.y + scaledPos.headerHeight
        local width = scaledPos.width
        local itemHeight = scaledPos.itemHeight
        local mainMenuHeight = scaledPos.mainMenuHeight
        local mainMenuSpacing = scaledPos.mainMenuSpacing

        Menu.DrawTabs(category, x, startY, width, mainMenuHeight)

        local currentTab = category.tabs[Menu.CurrentTab]
        if currentTab and currentTab.items then
            local itemY = startY + mainMenuHeight + mainMenuSpacing
            local totalItems = #currentTab.items
            local maxVisible = Menu.ItemsPerPage

            local nonSeparatorCount = 0
            for _, item in ipairs(currentTab.items) do
                if not item.isSeparator then
                    nonSeparatorCount = nonSeparatorCount + 1
                end
            end

            if Menu.CurrentItem > Menu.ItemScrollOffset + maxVisible then
                Menu.ItemScrollOffset = Menu.CurrentItem - maxVisible
            elseif Menu.CurrentItem <= Menu.ItemScrollOffset then
                Menu.ItemScrollOffset = math.max(0, Menu.CurrentItem - 1)
            end

            local actualVisibleCount = 0
            for i = 1, math.min(maxVisible, totalItems) do
                local itemIndex = i + Menu.ItemScrollOffset
                if itemIndex <= totalItems then
                    actualVisibleCount = actualVisibleCount + 1
                    local item = currentTab.items[itemIndex]
                    local itemYPos = itemY + (i - 1) * itemHeight
                    local isSelected = (itemIndex == Menu.CurrentItem)
                    Menu.DrawItem(x, itemYPos, width, itemHeight, item, isSelected)
                end
            end

            local visibleHeight = actualVisibleCount * itemHeight
            if nonSeparatorCount > 0 then
                Menu.DrawScrollbar(x, itemY, visibleHeight, Menu.CurrentItem, nonSeparatorCount, false, width)
            end
        end
        return
    end

    local scaledPos = Menu.GetScaledPosition()
    local scale = Menu.Scale or 1.0
    local x = scaledPos.x
    local bannerHeight = Menu.Banner.enabled and (Menu.Banner.height * scale) or scaledPos.headerHeight
    local startY = scaledPos.y + bannerHeight
    local width = scaledPos.width
    local itemHeight = scaledPos.itemHeight
    local mainMenuHeight = scaledPos.mainMenuHeight
    local mainMenuSpacing = scaledPos.mainMenuSpacing

    local totalCategories = #Menu.Categories - 1
    local maxVisible = Menu.ItemsPerPage

    if Menu.CurrentCategory > Menu.CategoryScrollOffset + maxVisible + 1 then
        Menu.CategoryScrollOffset = Menu.CurrentCategory - maxVisible - 1
    elseif Menu.CurrentCategory <= Menu.CategoryScrollOffset + 1 then
        Menu.CategoryScrollOffset = math.max(0, Menu.CurrentCategory - 2)
    end

    local itemY = startY
    
   
    local baseR = (Menu.Colors.HeaderPink and Menu.Colors.HeaderPink.r) and (Menu.Colors.HeaderPink.r / 255.0) or 0.58
    local baseG = (Menu.Colors.HeaderPink and Menu.Colors.HeaderPink.g) and (Menu.Colors.HeaderPink.g / 255.0) or 0.0
    local baseB = (Menu.Colors.HeaderPink and Menu.Colors.HeaderPink.b) and (Menu.Colors.HeaderPink.b / 255.0) or 0.83
    
    local gradientSteps = 40
    local stepHeight = mainMenuHeight / gradientSteps
    local gradStartY = itemY
    
    for step = 0, gradientSteps - 1 do
        local stepY = gradStartY + (step * stepHeight)
        local actualStepHeight = stepHeight
        local maxY = gradStartY + mainMenuHeight
        if stepY + actualStepHeight > maxY then
             actualStepHeight = maxY - stepY
        end
        
        local stepGradientFactor = step / (gradientSteps - 1)
      
        local easedFactor = stepGradientFactor * stepGradientFactor * (3.0 - 2.0 * stepGradientFactor)
        local alpha = 0.5 + (easedFactor * 0.5)
        
      
        local brightness = 1.0
        if step < gradientSteps * 0.3 then
            brightness = 1.0 + (0.2 * (1.0 - step / (gradientSteps * 0.3)))
        end
        local stepR = math.min(1.0, baseR * brightness)
        local stepG = math.min(1.0, baseG * brightness)
        local stepB = math.min(1.0, baseB * brightness)
        
        if Susano and Susano.DrawRectFilled then
            Susano.DrawRectFilled(x, stepY, width, actualStepHeight, stepR, stepG, stepB, alpha, 0)
        else
             Menu.DrawRect(x, stepY, width, actualStepHeight, math.floor(stepR*255), math.floor(stepG*255), math.floor(stepB*255), math.floor(alpha*255))
        end
    end
    
    if Menu.TopLevelTabs then
        local tabCount = #Menu.TopLevelTabs
        local tabWidth = width / tabCount
        
        for i, tab in ipairs(Menu.TopLevelTabs) do
            local tabX = x + (i - 1) * tabWidth
            local isSelected = (i == Menu.CurrentTopTab)
            
            if isSelected then
                if not Menu.TopTabSelectorX then
                    Menu.TopTabSelectorX = tabX
                    Menu.TopTabSelectorWidth = tabWidth
                end
                
                local smoothSpeed = Menu.SmoothFactor
                Menu.TopTabSelectorX = Menu.TopTabSelectorX + (tabX - Menu.TopTabSelectorX) * smoothSpeed
                Menu.TopTabSelectorWidth = Menu.TopTabSelectorWidth + (tabWidth - Menu.TopTabSelectorWidth) * smoothSpeed
                
                if math.abs(Menu.TopTabSelectorX - tabX) < 0.5 then Menu.TopTabSelectorX = tabX end
                if math.abs(Menu.TopTabSelectorWidth - tabWidth) < 0.5 then Menu.TopTabSelectorWidth = tabWidth end
                
                local drawX = Menu.TopTabSelectorX
                local drawWidth = Menu.TopTabSelectorWidth
                
                local baseR = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.r) and (Menu.Colors.SelectedBg.r / 255.0) or 1.0
                local baseG = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.g) and (Menu.Colors.SelectedBg.g / 255.0) or 0.0
                local baseB = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.b) and (Menu.Colors.SelectedBg.b / 255.0) or 1.0
                
                local gradientSteps = 40
                local stepHeight = mainMenuHeight / gradientSteps
                local gradStartY = itemY
                
                for step = 0, gradientSteps - 1 do
                    local stepY = gradStartY + (step * stepHeight)
                    local actualStepHeight = stepHeight
                    local maxY = gradStartY + mainMenuHeight
                    if stepY + actualStepHeight > maxY then
                         actualStepHeight = maxY - stepY
                    end
                    
                    local stepGradientFactor = step / (gradientSteps - 1)
                    
                    local easedFactor = stepGradientFactor * stepGradientFactor * (3.0 - 2.0 * stepGradientFactor)
                    local alpha = easedFactor * 0.65
                    
                    
                    local brightness = 1.0
                    if step < gradientSteps * 0.2 then
                        brightness = 1.0 + (0.1 * (1.0 - step / (gradientSteps * 0.2)))
                    end
                    local stepR = math.min(1.0, baseR * brightness)
                    local stepG = math.min(1.0, baseG * brightness)
                    local stepB = math.min(1.0, baseB * brightness)
                    
                    if Susano and Susano.DrawRectFilled then
                        Susano.DrawRectFilled(drawX, stepY, drawWidth, actualStepHeight, stepR, stepG, stepB, alpha, 0)
                    else
                         Menu.DrawRect(drawX, stepY, drawWidth, actualStepHeight, math.floor(stepR*255), math.floor(stepG*255), math.floor(stepB*255), math.floor(alpha*255))
                    end
                end
                
               
                if Susano and Susano.DrawRectFilled then
                    Susano.DrawRectFilled(drawX, itemY + mainMenuHeight - 3, drawWidth, 1, baseR * 0.5, baseG * 0.5, baseB * 0.5, 0.6, 0)
                    Susano.DrawRectFilled(drawX, itemY + mainMenuHeight - 2, drawWidth, 2, baseR, baseG, baseB, 1.0, 0)
                else
                    Menu.DrawRect(drawX, itemY + mainMenuHeight - 3, drawWidth, 1, math.floor(baseR*0.5*255), math.floor(baseG*0.5*255), math.floor(baseB*0.5*255), 153)
                    Menu.DrawRect(drawX, itemY + mainMenuHeight - 2, drawWidth, 2, math.floor(baseR*255), math.floor(baseG*255), math.floor(baseB*255), 255)
                end
            end
            
            local text = tab.name
            local textSize = 16
            local textWidth = Menu.GetTextWidth(text, textSize)
            
            local textX = tabX + (tabWidth / 2) - (textWidth / 2)
            local textY = itemY + mainMenuHeight / 2 - 7
            
            local r, g, b = Menu.Colors.TextWhite.r, Menu.Colors.TextWhite.g, Menu.Colors.TextWhite.b
            if not isSelected then
                r, g, b = 150, 150, 150
            end
            
            Menu.DrawText(textX, textY, text, textSize, r/255.0, g/255.0, b/255.0, 1.0)
        end
    else
        local textY = itemY + mainMenuHeight / 2 - 7
        local estimatedTextWidth = Menu.GetTextWidth(Menu.Categories[1].name, 16)
        local textX = x + (width / 2) - (estimatedTextWidth / 2)
        Menu.DrawText(textX, textY, Menu.Categories[1].name, 16, Menu.Colors.TextWhite.r / 255.0, Menu.Colors.TextWhite.g / 255.0, Menu.Colors.TextWhite.b / 255.0, 1.0)
    end

    local actualVisibleCount = 0
    for displayIndex = 1, math.min(maxVisible, totalCategories) do
        local categoryIndex = displayIndex + Menu.CategoryScrollOffset + 1
        if categoryIndex <= #Menu.Categories then
            actualVisibleCount = actualVisibleCount + 1
            local category = Menu.Categories[categoryIndex]
            local isSelected = (categoryIndex == Menu.CurrentCategory)

            local itemY = startY + mainMenuHeight + mainMenuSpacing + (displayIndex - 1) * itemHeight
            Menu.DrawRect(x, itemY, width, itemHeight, Menu.Colors.BackgroundDark.r, Menu.Colors.BackgroundDark.g, Menu.Colors.BackgroundDark.b, 50)

            if isSelected then
                if Menu.CategorySelectorY == 0 then
                    Menu.CategorySelectorY = itemY
                end

                local smoothSpeed = Menu.SmoothFactor
                Menu.CategorySelectorY = Menu.CategorySelectorY + (itemY - Menu.CategorySelectorY) * smoothSpeed
                if math.abs(Menu.CategorySelectorY - itemY) < 0.5 then
                    Menu.CategorySelectorY = itemY
                end

                local drawY = Menu.CategorySelectorY

                local baseR = Menu.Colors.SelectedBg.r / 255.0
                local baseG = Menu.Colors.SelectedBg.g / 255.0
                local baseB = Menu.Colors.SelectedBg.b / 255.0
                local darkenAmount = 0.4

                local selectorX = x

                if Menu.GradientType == 2 then
                    local gradientSteps = 120
                    local drawWidth = width - 1
                    local stepWidth = drawWidth / gradientSteps
                    local selectorY = drawY
                    local selectorHeight = itemHeight

                    for step = 0, gradientSteps - 1 do
                        local stepX = x + (step * stepWidth)
                        local actualStepWidth = stepWidth
                        
                        if actualStepWidth > 0 then
                            local stepGradientFactor = step / (gradientSteps - 1)
                           
                            local easedFactor = stepGradientFactor < 0.5 
                                and 4 * stepGradientFactor * stepGradientFactor * stepGradientFactor
                                or 1 - math.pow(-2 * stepGradientFactor + 2, 3) / 2
                            local darkenFactor = easedFactor * easedFactor
                            local stepDarken = darkenFactor * 0.75

                            local stepR = math.max(0, baseR - stepDarken)
                            local stepG = math.max(0, baseG - stepDarken)
                            local stepB = math.max(0, baseB - stepDarken)
                            
                           
                            local brightness = 1.0
                            if step < gradientSteps * 0.1 then
                                brightness = 1.0 + (0.15 * (1.0 - step / (gradientSteps * 0.1)))
                            end
                            stepR = math.min(1.0, stepR * brightness)
                            stepG = math.min(1.0, stepG * brightness)
                            stepB = math.min(1.0, stepB * brightness)
                            
                            local alpha = 0.95
                            if step > gradientSteps - 20 then
                                alpha = 0.95 * (1.0 - ((step - (gradientSteps - 20)) / 20))
                            end

                            if Susano and Susano.DrawRectFilled then
                                Susano.DrawRectFilled(stepX, selectorY, actualStepWidth, selectorHeight, stepR, stepG, stepB, alpha, 0.0)
                            else
                                Menu.DrawRect(stepX, selectorY, actualStepWidth, selectorHeight, stepR * 255, stepG * 255, stepB * 255, math.floor(alpha * 255))
                            end
                        end
                    end
                else
                    local gradientSteps = 50
                    local stepHeight = itemHeight / gradientSteps
                    local selectorWidth = width - 1
            
                    for step = 0, gradientSteps - 1 do
                        local stepY = drawY + (step * stepHeight)
                        local actualStepHeight = math.min(stepHeight, (drawY + itemHeight) - stepY)
                        if actualStepHeight > 0 then
                            local stepGradientFactor = step / (gradientSteps - 1)
                            
                            local easedFactor = stepGradientFactor * stepGradientFactor * (3.0 - 2.0 * stepGradientFactor)
                           
                            local stepDarken = easedFactor * darkenAmount * 0.8

                            local stepR = math.max(0, baseR - stepDarken)
                            local stepG = math.max(0, baseG - stepDarken)
                            local stepB = math.max(0, baseB - stepDarken)
                            
                           
                            local brightness = 1.0
                            if step < gradientSteps * 0.15 then
                                brightness = 1.0 + (0.12 * (1.0 - step / (gradientSteps * 0.15)))
                            end
                            stepR = math.min(1.0, stepR * brightness)
                            stepG = math.min(1.0, stepG * brightness)
                            stepB = math.min(1.0, stepB * brightness)

                            if Susano and Susano.DrawRectFilled then
                                Susano.DrawRectFilled(selectorX, stepY, selectorWidth, actualStepHeight, stepR, stepG, stepB, 0.95, 0.0)
                            else
                                Menu.DrawRect(selectorX, stepY, selectorWidth, actualStepHeight, stepR * 255, stepG * 255, stepB * 255, 242)
                            end
                        end
                    end
                end

                Menu.DrawRect(selectorX, drawY, 3, itemHeight, Menu.Colors.SelectedBg.r, Menu.Colors.SelectedBg.g, Menu.Colors.SelectedBg.b, 255)
            end

            local textX = x + 16
            local textY = itemY + itemHeight / 2 - 8
            Menu.DrawText(textX, textY, category.name, 17, Menu.Colors.TextWhite.r / 255.0, Menu.Colors.TextWhite.g / 255.0, Menu.Colors.TextWhite.b / 255.0, 1.0)

            local chevronX = x + width - 22
            Menu.DrawText(chevronX, textY, ">", 17, Menu.Colors.TextWhite.r / 255.0, Menu.Colors.TextWhite.g / 255.0, Menu.Colors.TextWhite.b / 255.0, 1.0)
        end
    end

    if totalCategories > 0 then
        local scrollbarStartY = startY + mainMenuHeight + mainMenuSpacing
        local visibleHeight = actualVisibleCount * itemHeight
        Menu.DrawScrollbar(x, scrollbarStartY, visibleHeight, Menu.CurrentCategory, totalCategories, true, width)
    end
end

function Menu.DrawTopRoundedRect(x, y, width, height, r, g, b, a, radius)
    Menu.DrawRect(x, y + radius, width, height - radius, r, g, b, a)
    Menu.DrawRect(x + radius, y, width - 2 * radius, radius, r, g, b, a)

    for i = 0, radius - 1 do
        local slice_width = math.ceil(math.sqrt(radius * radius - i * i))
        local y_pos = y + radius - 1 - i

        Menu.DrawRect(x + radius - slice_width, y_pos, slice_width, 1, r, g, b, a)

        Menu.DrawRect(x + width - radius, y_pos, slice_width, 1, r, g, b, a)
    end
end

function Menu.DrawRoundedRect(x, y, width, height, r, g, b, a, radius)
    radius = radius or 0
    if radius <= 0 then
        Menu.DrawRect(x, y, width, height, r, g, b, a)
        return
    end
    
    Menu.DrawRect(x + radius, y, width - 2 * radius, height, r, g, b, a)
    Menu.DrawRect(x, y + radius, radius, height - 2 * radius, r, g, b, a)
    Menu.DrawRect(x + width - radius, y + radius, radius, height - 2 * radius, r, g, b, a)
    
    for i = 0, radius - 1 do
        local slice_width = math.ceil(math.sqrt(radius * radius - i * i))
        
        local top_y = y + radius - 1 - i
        Menu.DrawRect(x + radius - slice_width, top_y, slice_width, 1, r, g, b, a)
        Menu.DrawRect(x + width - radius, top_y, slice_width, 1, r, g, b, a)
        
        local bottom_y = y + height - radius + i
        Menu.DrawRect(x + radius - slice_width, bottom_y, slice_width, 1, r, g, b, a)
        Menu.DrawRect(x + width - radius, bottom_y, slice_width, 1, r, g, b, a)
    end
end

function Menu.DrawLoadingBar(alpha)
    if alpha <= 0 then return end
    
    local screenWidth = 1920
    local screenHeight = 1080
    if Susano and Susano.GetScreenWidth and Susano.GetScreenHeight then
        screenWidth = Susano.GetScreenWidth()
        screenHeight = Susano.GetScreenHeight()
    end

    local centerX = screenWidth / 2
    local centerY = screenHeight - 150
    local radius = 40
    local thickness = 8

    local currentTime = GetGameTimer() or 0
    local elapsedTime = 0
    if Menu.LoadingStartTime then
        elapsedTime = currentTime - Menu.LoadingStartTime
    end

    local loadingText = ""
    if elapsedTime < 1000 then
        loadingText = "Injecting"
    elseif elapsedTime < 2000 then
        loadingText = "Arcane Services"
    else
        loadingText = "Arcane Services"
    end

    if loadingText ~= "" then
        local textSize = 18
        local textWidth = Menu.GetTextWidth(loadingText, textSize)
        local textX = centerX - (textWidth / 2)
        local textY = centerY - radius - 40
        Menu.DrawText(textX, textY, loadingText, textSize, 1.0, 1.0, 1.0, 1.0 * alpha)
    end

    local segments = 90
    local step = 360 / segments
    local startAngle = -90

    for i = 0, segments do
        local angle = math.rad(startAngle + (i * step))
        local px = centerX + radius * math.cos(angle)
        local py = centerY + radius * math.sin(angle)
        local outlineSize = thickness + 4
        
        if Susano and Susano.DrawRectFilled then
            Susano.DrawRectFilled(px - outlineSize/2, py - outlineSize/2, outlineSize, outlineSize, 0.0, 0.0, 0.0, 1.0 * alpha, outlineSize/2)
        else
            Menu.DrawRect(px - outlineSize/2, py - outlineSize/2, outlineSize, outlineSize, 0, 0, 0, 255 * alpha)
        end
    end

    for i = 0, segments do
        local angle = math.rad(startAngle + (i * step))
        local px = centerX + radius * math.cos(angle)
        local py = centerY + radius * math.sin(angle)
        
        if Susano and Susano.DrawRectFilled then
            Susano.DrawRectFilled(px - thickness/2, py - thickness/2, thickness, thickness, 0.15, 0.15, 0.15, 1.0 * alpha, thickness/2)
        else
            Menu.DrawRect(px - thickness/2, py - thickness/2, thickness, thickness, 38, 38, 38, 255 * alpha)
        end
    end

    local progressSegments = math.floor(segments * (Menu.LoadingProgress / 100.0))
    local accentR = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.r) and (Menu.Colors.SelectedBg.r / 255.0) or 1.0
    local accentG = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.g) and (Menu.Colors.SelectedBg.g / 255.0) or 0.0
    local accentB = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.b) and (Menu.Colors.SelectedBg.b / 255.0) or 1.0

    for i = 0, progressSegments do
        local angle = math.rad(startAngle + (i * step))
        local px = centerX + radius * math.cos(angle)
        local py = centerY + radius * math.sin(angle)
        
        if Susano and Susano.DrawRectFilled then
            Susano.DrawRectFilled(px - thickness/2, py - thickness/2, thickness + 1, thickness + 1, accentR, accentG, accentB, 1.0 * alpha, (thickness + 1)/2)
        else
            Menu.DrawRect(px - thickness/2, py - thickness/2, thickness + 1, thickness + 1, accentR * 255, accentG * 255, accentB * 255, 255 * alpha)
        end
    end

    local percentText = string.format("%.0f%%", Menu.LoadingProgress)
    local percentTextSize = 16
    local percentTextWidth = Menu.GetTextWidth(percentText, percentTextSize)
    local percentTextX = centerX - (percentTextWidth / 2)
    local percentTextY = centerY - (percentTextSize / 2)
    Menu.DrawText(percentTextX, percentTextY, percentText, percentTextSize, 1.0, 1.0, 1.0, 1.0 * alpha)
end

function Menu.DrawFooter()
    local scaledPos = Menu.GetScaledPosition()
    local scale = Menu.Scale or 1.0
    local x = scaledPos.x
    local footerY
    local totalHeight
    
    local bannerHeight = Menu.Banner.enabled and (Menu.Banner.height * scale) or scaledPos.headerHeight

    if Menu.OpenedCategory then
        local category = Menu.Categories[Menu.OpenedCategory]
        if category and category.hasTabs and category.tabs then
            local currentTab = category.tabs[Menu.CurrentTab]
            if currentTab and currentTab.items then
                local maxVisible = Menu.ItemsPerPage
                local totalItems = #currentTab.items
                local visibleItems = math.min(maxVisible, totalItems)
                totalHeight = bannerHeight + scaledPos.mainMenuHeight + scaledPos.mainMenuSpacing + (visibleItems * scaledPos.itemHeight)
            else
                totalHeight = bannerHeight + scaledPos.mainMenuHeight + scaledPos.mainMenuSpacing
            end
        else
            totalHeight = bannerHeight + scaledPos.mainMenuHeight + scaledPos.mainMenuSpacing
        end
    else
        local maxVisible = Menu.ItemsPerPage
        local totalCategories = #Menu.Categories - 1
        local visibleCategories = math.min(maxVisible, totalCategories)
        totalHeight = bannerHeight + scaledPos.mainMenuHeight + scaledPos.mainMenuSpacing + (visibleCategories * scaledPos.itemHeight)
    end

    footerY = scaledPos.y + totalHeight + scaledPos.footerSpacing
    local footerWidth = scaledPos.width - 1
    local footerHeight = scaledPos.footerHeight
    local footerRounding = scaledPos.footerRadius

    if Susano and Susano.DrawRectFilled then
        Susano.DrawRectFilled(x, footerY, footerWidth, footerHeight,
            0.0, 0.0, 0.0, 1.0,
            footerRounding)
    else
        Menu.DrawRoundedRect(x, footerY, footerWidth, footerHeight, 0, 0, 0, 255, footerRounding)
    end

    local footerPadding = 15 * scale
    local footerSize = 13
    local scaledFooterSize = footerSize * scale
    local footerTextY = footerY + (footerHeight / 2) - (scaledFooterSize / 2) + (1 * scale)

    local footerText = "discord.gg/arcaneservices"
    local currentX = x + footerPadding

    local textWidth = Menu.GetTextWidth(footerText, footerSize)

    Menu.DrawText(currentX, footerTextY, footerText, footerSize, Menu.Colors.TextWhite.r / 255.0, Menu.Colors.TextWhite.g / 255.0, Menu.Colors.TextWhite.b / 255.0, 1.0)

    local displayIndex
    local totalItems

    if Menu.OpenedCategory then
        local category = Menu.Categories[Menu.OpenedCategory]
        if category and category.hasTabs and category.tabs then
            local currentTab = category.tabs[Menu.CurrentTab]
            if currentTab and currentTab.items then
                displayIndex = Menu.CurrentItem
                totalItems = #currentTab.items
            else
                displayIndex = 1
                totalItems = 1
            end
        else
            displayIndex = 1
            totalItems = 1
        end
    else
        displayIndex = Menu.CurrentCategory - 1
        if displayIndex < 1 then displayIndex = 1 end
        totalItems = #Menu.Categories - 1
    end

    local posText = string.format("%d/%d", displayIndex, totalItems)

    local posWidth = Menu.GetTextWidth(posText, footerSize)

    local posX = x + footerWidth - posWidth - footerPadding
    Menu.DrawText(posX, footerTextY, posText, footerSize, Menu.Colors.TextWhite.r / 255.0, Menu.Colors.TextWhite.g / 255.0, Menu.Colors.TextWhite.b / 255.0, 1.0)

    local bindHint = tostring(Menu.BindShortcutLabel or Menu.GetKeyName(Menu.BindShortcutKey or 0x79)) .. " Keybind"
    local bindHintWidth = Menu.GetTextWidth(bindHint, 12)
    local bindHintX = x + (footerWidth / 2) - (bindHintWidth / 2)
    Menu.DrawText(bindHintX, footerTextY, bindHint, 12, Menu.Colors.TextWhite.r / 255.0, Menu.Colors.TextWhite.g / 255.0, Menu.Colors.TextWhite.b / 255.0, 0.75)
end

function Menu.DrawKeySelector(alpha)
    if alpha <= 0 then return end

    local screenWidth = 1920
    local screenHeight = 1080
    if Susano and Susano.GetScreenWidth and Susano.GetScreenHeight then
        screenWidth = Susano.GetScreenWidth()
        screenHeight = Susano.GetScreenHeight()
    end

    local padding = 15
    local cornerRadius = 8
    local barHeight = 4
    local lineHeight = 28
    local textSize = 14
    local headerHeight = 42

    local width = 400
    local startX = math.floor((screenWidth - width) / 2)
    local startY = math.floor(screenHeight - 160)

    local itemName = Menu.BindingItem and (Menu.BindingItem.name or "Option") or "Menu Toggle"
    local keyName = Menu.BindingItem and Menu.BindingKeyName or Menu.SelectedKeyName
    if not keyName then keyName = "..." end
    local status = "press a key"
    local rowText = itemName .. " [" .. keyName .. "] - " .. status

    local totalHeight = headerHeight + barHeight + padding + lineHeight + padding

    local menuR = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.r) and (Menu.Colors.SelectedBg.r / 255.0) or 0.4
    local menuG = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.g) and (Menu.Colors.SelectedBg.g / 255.0) or 0.2
    local menuB = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.b) and (Menu.Colors.SelectedBg.b / 255.0) or 0.8

    local bgAlpha = 0.65 * alpha
    if Susano and Susano.DrawRectFilled then
        Susano.DrawRectFilled(startX, startY, width, totalHeight, 0.0, 0.0, 0.0, bgAlpha, cornerRadius)
    else
        Menu.DrawRoundedRect(startX, startY, width, totalHeight, 0, 0, 0, math.floor(255 * bgAlpha), cornerRadius)
    end

    local title = "KEYBIND"
    local titleX = startX + padding
    local titleY = startY + padding - 2
    Menu.DrawTextEmphasis(titleX, titleY, title, textSize, 1.0, 1.0, 1.0, 1.0 * alpha)

    local barY = startY + headerHeight
    local barLabel = "Choose a key"
    local barLabelSize = 12
    local barLabelW = Menu.GetTextWidth(barLabel, barLabelSize)
    local barLabelX = startX + (width / 2) - (barLabelW / 2)
    local barLabelY = barY - barLabelSize - 4
    Menu.DrawText(barLabelX, barLabelY, barLabel, barLabelSize, 0.9, 0.9, 0.9, 1.0 * alpha)

    if Susano and Susano.DrawRectFilled then
        Susano.DrawRectFilled(startX + padding, barY, width - 2 * padding, barHeight, menuR, menuG, menuB, 1.0 * alpha, 0)
    else
        Menu.DrawRect(startX + padding, barY, width - 2 * padding, barHeight, math.floor(menuR * 255), math.floor(menuG * 255), math.floor(menuB * 255), math.floor(255 * alpha))
    end

    local rowY = barY + barHeight + padding
    local textX = startX + padding
    local textY = rowY + (lineHeight / 2) - (textSize / 2)

    Menu.DrawTextEmphasis(textX, textY, rowText, textSize, 1.0, 1.0, 1.0, 1.0 * alpha)

    local keySize = 18
    local keyW = Menu.GetTextWidth(keyName, keySize)
    local boxHeight = 34
    local boxPaddingX = 12
    local boxWidth = math.max(boxHeight, math.floor(keyW + (boxPaddingX * 2)))
    local boxX = startX + width - padding - boxWidth
    local boxY = rowY + (lineHeight / 2) - (boxHeight / 2)
    if Susano and Susano.DrawRectFilled then
        Susano.DrawRectFilled(boxX, boxY, boxWidth, boxHeight, 0.12, 0.12, 0.12, 1.0 * alpha, 6)
    else
        Menu.DrawRect(boxX, boxY, boxWidth, boxHeight, 30, 30, 30, 255 * alpha)
    end

    Menu.DrawText(math.floor(boxX + (boxWidth / 2) - (keyW / 2)), math.floor(boxY + (boxHeight / 2) - (keySize / 2)), keyName, keySize, 1.0, 1.0, 1.0, 1.0 * alpha)
end

local function clampNumber(value, minValue, maxValue)
    if value < minValue then return minValue end
    if value > maxValue then return maxValue end
    return value
end

local function randomFloat(minValue, maxValue)
    return minValue + ((math.random(0, 1000) / 1000) * (maxValue - minValue))
end

local function getOverlayScreenSize()
    local screenWidth = 1920
    local screenHeight = 1080
    if Susano and Susano.GetScreenWidth and Susano.GetScreenHeight then
        screenWidth = Susano.GetScreenWidth()
        screenHeight = Susano.GetScreenHeight()
    elseif GetActiveScreenResolution then
        screenWidth, screenHeight = GetActiveScreenResolution()
    end
    return screenWidth, screenHeight
end

local function getOverlayAccentColor()
    local base = Menu.Colors.SelectedBg or { r = 148, g = 0, b = 211 }
    return clampNumber(base.r / 255.0, 0.0, 1.0),
        clampNumber(base.g / 255.0, 0.0, 1.0),
        clampNumber(base.b / 255.0, 0.0, 1.0)
end

local function drawFilledCircle(x, y, radius, r, g, b, a)
    if radius <= 0 then
        return
    end

    if Susano and Susano.DrawCircle then
        Susano.DrawCircle(x, y, radius, true, r, g, b, a, 1.0, 26)
    else
        Menu.DrawRoundedRect(x - radius, y - radius, radius * 2, radius * 2,
            math.floor(r * 255), math.floor(g * 255), math.floor(b * 255), math.floor(a * 255), radius)
    end
end

local function drawSoftGlow(x, y, radius, r, g, b, alpha)
    for i = 3, 1, -1 do
        local factor = i / 3
        drawFilledCircle(x, y, radius * factor, r, g, b, alpha * factor * 0.36)
    end
end

local function trimOverlayText(text, size, maxWidth)
    local safeText = tostring(text or "")
    if maxWidth <= 0 then
        return ""
    end

    if Menu.GetTextWidth(safeText, size) <= maxWidth then
        return safeText
    end

    local trimmed = safeText
    while #trimmed > 0 do
        trimmed = string.sub(trimmed, 1, #trimmed - 1)
        local candidate = trimmed .. "..."
        if Menu.GetTextWidth(candidate, size) <= maxWidth then
            return candidate
        end
    end

    return "..."
end

local function measureOverlayWidth(rows, rowSize, paddingX, gapWidth, minWidth)
    local maxWidth = minWidth or 0
    for _, row in ipairs(rows or {}) do
        local leftWidth = Menu.GetTextWidth(tostring(row.leftText or ""), rowSize)
        local rightWidth = 0
        if row.rightText and row.rightText ~= "" then
            rightWidth = math.max(44, Menu.GetTextWidth(tostring(row.rightText), rowSize - 1) + 18)
        end
        local totalWidth = (paddingX * 2) + leftWidth + rightWidth + gapWidth
        if totalWidth > maxWidth then
            maxWidth = totalWidth
        end
    end
    return math.max(minWidth or 180, maxWidth)
end

function Menu.DrawOverlayPanel(title, rows, startX, startY, alpha, options)
    if alpha <= 0 or not rows or #rows == 0 then
        return 0, 0
    end

    options = options or {}

    local paddingX = options.paddingX or 12
    local paddingY = options.paddingY or 10
    local titleSize = options.titleSize or 13
    local rowSize = options.rowSize or 14
    local rowHeight = options.rowHeight or 24
    local headerHeight = options.headerHeight or 34
    local cornerRadius = options.cornerRadius or 7
    local minWidth = options.minWidth or 205
    local width = options.width or measureOverlayWidth(rows, rowSize, paddingX, 18, minWidth)
    local height = headerHeight + (#rows * rowHeight) + paddingY
    local panelX = options.alignRight and (startX - width) or startX
    local panelY = startY
    if options.clampToScreen then
        local screenWidth, screenHeight = getOverlayScreenSize()
        panelX = clampNumber(panelX, 8, math.max(8, screenWidth - width - 8))
        panelY = clampNumber(panelY, 8, math.max(8, screenHeight - height - 8))
    end

    local accentR, accentG, accentB = getOverlayAccentColor()
    local bgAlpha = (options.backgroundAlpha or 0.84) * alpha

    if Susano and Susano.DrawRectFilled then
        Susano.DrawRectFilled(panelX + 4, panelY + 6, width, height, 0.0, 0.0, 0.0, 0.18 * alpha, cornerRadius)
        Susano.DrawRectFilled(panelX, panelY, width, height, 0.02, 0.03, 0.05, bgAlpha, cornerRadius)
    else
        Menu.DrawRoundedRect(panelX + 4, panelY + 6, width, height, 0, 0, 0, math.floor(46 * alpha), cornerRadius)
        Menu.DrawRoundedRect(panelX, panelY, width, height, 5, 7, 10, math.floor(bgAlpha * 255), cornerRadius)
    end

    if Susano and Susano.DrawRectGradient then
        Susano.DrawRectGradient(panelX, panelY, width, 3,
            accentR * 0.45, accentG * 0.45, accentB * 0.45, 0.65 * alpha,
            accentR, accentG, accentB, 1.0 * alpha,
            accentR, accentG, accentB, 1.0 * alpha,
            accentR * 0.35, accentG * 0.35, accentB * 0.35, 0.65 * alpha,
            cornerRadius)
    elseif Susano and Susano.DrawRectFilled then
        Susano.DrawRectFilled(panelX, panelY, width, 3, accentR, accentG, accentB, 1.0 * alpha, 0)
    else
        Menu.DrawRect(panelX, panelY, width, 3, math.floor(accentR * 255), math.floor(accentG * 255), math.floor(accentB * 255), math.floor(255 * alpha))
    end

    if Susano and Susano.DrawRect then
        Susano.DrawRect(panelX, panelY, width, height, accentR * 0.45, accentG * 0.45, accentB * 0.45, 0.60 * alpha, 1.0)
    else
        Menu.DrawRoundedRect(panelX, panelY, width, height,
            math.floor(accentR * 115), math.floor(accentG * 115), math.floor(accentB * 115), math.floor(90 * alpha), cornerRadius)
    end

    Menu.DrawTextEmphasis(panelX + paddingX, panelY + 10, string.upper(tostring(title or "")), titleSize, 1.0, 1.0, 1.0, 0.96 * alpha)

    for i, row in ipairs(rows) do
        local rowTop = panelY + headerHeight + ((i - 1) * rowHeight)
        local rowCenterY = rowTop + (rowHeight / 2)
        local rowAlpha = clampNumber((row.alpha or 1.0) * alpha, 0.0, 1.0)
        local barAlpha = (row.active and 0.95 or 0.38) * alpha

        if i > 1 then
            if Susano and Susano.DrawRectFilled then
                Susano.DrawRectFilled(panelX + paddingX, rowTop, width - (paddingX * 2), 1, 1.0, 1.0, 1.0, 0.06 * alpha, 0)
            else
                Menu.DrawRect(panelX + paddingX, rowTop, width - (paddingX * 2), 1, 255, 255, 255, math.floor(15 * alpha))
            end
        end

        if row.bar ~= false then
            local rowR, rowG, rowB = accentR, accentG, accentB
            if row.barColor then
                rowR, rowG, rowB = row.barColor.r, row.barColor.g, row.barColor.b
            end

            if Susano and Susano.DrawRectFilled then
                Susano.DrawRectFilled(panelX + 6, rowTop + 5, 2, rowHeight - 9, rowR, rowG, rowB, barAlpha, 2)
            else
                Menu.DrawRect(panelX + 6, rowTop + 5, 2, rowHeight - 9, math.floor(rowR * 255), math.floor(rowG * 255), math.floor(rowB * 255), math.floor(barAlpha * 255))
            end
        end

        local rightBadgeWidth = 0
        local rightText = row.rightText and tostring(row.rightText) or ""
        if rightText ~= "" then
            rightText = trimOverlayText(rightText, rowSize - 1, 120)
            local rightTextWidth = Menu.GetTextWidth(rightText, rowSize - 1)
            rightBadgeWidth = math.max(44, rightTextWidth + 18)
            local badgeX = panelX + width - paddingX - rightBadgeWidth
            local badgeY = rowCenterY - 9

            local badgeR = row.active and accentR * 0.55 or 0.09
            local badgeG = row.active and accentG * 0.55 or 0.10
            local badgeB = row.active and accentB * 0.55 or 0.12
            local badgeAlpha = row.active and 0.82 * alpha or 0.62 * alpha

            if Susano and Susano.DrawRectFilled then
                Susano.DrawRectFilled(badgeX, badgeY, rightBadgeWidth, 18, badgeR, badgeG, badgeB, badgeAlpha, 5)
            else
                Menu.DrawRoundedRect(badgeX, badgeY, rightBadgeWidth, 18,
                    math.floor(badgeR * 255), math.floor(badgeG * 255), math.floor(badgeB * 255), math.floor(badgeAlpha * 255), 5)
            end

            local badgeTextWidth = Menu.GetTextWidth(rightText, rowSize - 1)
            local badgeTextX = badgeX + (rightBadgeWidth / 2) - (badgeTextWidth / 2)
            local badgeTextY = rowCenterY - ((rowSize - 1) / 2)
            Menu.DrawText(badgeTextX, badgeTextY, rightText, rowSize - 1, 1.0, 1.0, 1.0, rowAlpha)
        end

        local labelX = panelX + paddingX + 2
        local labelMaxWidth = width - (paddingX * 2) - rightBadgeWidth - (rightBadgeWidth > 0 and 14 or 0)
        local labelText = trimOverlayText(row.leftText or "", rowSize, labelMaxWidth)
        local labelY = rowCenterY - (rowSize / 2)
        Menu.DrawTextEmphasis(labelX, labelY, labelText, rowSize, 1.0, 1.0, 1.0, rowAlpha)
    end

    Menu.LastOverlayPanelRect = {
        title = tostring(title or ""),
        x = panelX,
        y = panelY,
        width = width,
        height = height
    }

    return width, height
end

local function buildKeybindRows()
    local rows = {}
    local menuKeyName = (Menu.SelectedKeyName and Menu.SelectedKeyName ~= "" and Menu.SelectedKeyName) or "Unassigned"

    table.insert(rows, {
        leftText = "Toggle Menu",
        rightText = menuKeyName,
        active = Menu.Visible,
        priority = -1
    })

    for _, cat in ipairs(Menu.Categories or {}) do
        if cat.hasTabs and cat.tabs then
            for _, tab in ipairs(cat.tabs) do
                if tab.items then
                    for _, item in ipairs(tab.items) do
                        if item.bindKey and item.bindKeyName and (item.type == "toggle" or item.type == "action") then
                            table.insert(rows, {
                                leftText = item.name,
                                rightText = item.bindKeyName,
                                active = item.type == "toggle" and (item.value or false) or false,
                                alpha = item.type == "toggle" and ((item.value and 1.0) or 0.80) or 0.94,
                                priority = item.type == "toggle" and ((item.value and 0) or 2) or 1
                            })
                        end
                    end
                end
            end
        end
    end

    table.sort(rows, function(a, b)
        if (a.priority or 0) ~= (b.priority or 0) then
            return (a.priority or 0) < (b.priority or 0)
        end
        return string.lower(tostring(a.leftText or "")) < string.lower(tostring(b.leftText or ""))
    end)

    return rows
end

function Menu.DrawKeybindsInterface(alpha, startY)
    if alpha <= 0 then
        if Menu.OverlayPanelRects then
            Menu.OverlayPanelRects.keybinds = nil
        end
        return 0, 0
    end

    local rows = buildKeybindRows()
    local screenWidth = getOverlayScreenSize()
    local panelX = (screenWidth - 20) + (tonumber(Menu.KeybindsPanelOffsetX) or 0)
    local panelY = (startY or 20) + (tonumber(Menu.KeybindsPanelOffsetY) or 0)
    local width, height = Menu.DrawOverlayPanel("Keybinds", rows, panelX, panelY, alpha, {
        alignRight = true,
        minWidth = 230,
        clampToScreen = true
    })

    if Menu.OverlayPanelRects and Menu.LastOverlayPanelRect then
        Menu.OverlayPanelRects.keybinds = {
            x = Menu.LastOverlayPanelRect.x,
            y = Menu.LastOverlayPanelRect.y,
            width = Menu.LastOverlayPanelRect.width,
            height = Menu.LastOverlayPanelRect.height
        }
    end

    return width, height
end

function Menu.DrawSpectatorList(alpha, startY)
    if alpha <= 0 then
        if Menu.OverlayPanelRects then
            Menu.OverlayPanelRects.spectators = nil
        end
        return 0, 0
    end

    local rows = {}
    if Menu.SpectatorEntries and #Menu.SpectatorEntries > 0 then
        for _, entry in ipairs(Menu.SpectatorEntries) do
            table.insert(rows, {
                leftText = entry.name or "Unknown spectator",
                rightText = entry.rightText or "",
                active = entry.active ~= false,
                alpha = entry.alpha or 0.96,
                barColor = entry.barColor
            })
        end
    else
        table.insert(rows, {
            leftText = "No suspicious players",
            active = false,
            alpha = 0.72,
            bar = false
        })
    end

    local screenWidth = getOverlayScreenSize()
    local panelX = (screenWidth - 20) + (tonumber(Menu.SpectatorPanelOffsetX) or 0)
    local panelY = (startY or 20) + (tonumber(Menu.SpectatorPanelOffsetY) or 0)
    local width, height = Menu.DrawOverlayPanel("Spectators", rows, panelX, panelY, alpha, {
        alignRight = true,
        minWidth = 210,
        clampToScreen = true
    })

    if Menu.OverlayPanelRects and Menu.LastOverlayPanelRect then
        Menu.OverlayPanelRects.spectators = {
            x = Menu.LastOverlayPanelRect.x,
            y = Menu.LastOverlayPanelRect.y,
            width = Menu.LastOverlayPanelRect.width,
            height = Menu.LastOverlayPanelRect.height
        }
    end

    return width, height
end

Menu.Particles = Menu.Particles or {}
Menu.BlossomParticles = Menu.BlossomParticles or {}

local function resetSnowParticle(particle, spawnAbove)
    particle.x = randomFloat(0.02, 0.98)
    particle.y = spawnAbove and randomFloat(-0.25, -0.03) or randomFloat(0.0, 1.0)
    particle.speedY = randomFloat(0.0010, 0.0036)
    particle.speedX = randomFloat(-0.0007, 0.0007)
    particle.size = randomFloat(1.2, 3.2)
    particle.phase = randomFloat(0.0, math.pi * 2)
    particle.drift = randomFloat(0.0003, 0.0012)
    particle.sparkle = randomFloat(1.2, 2.6)
end

local function resetBlossomParticle(particle, spawnAbove)
    local palette = {
        { r = 1.0, g = 0.74, b = 0.86 },
        { r = 1.0, g = 0.82, b = 0.90 },
        { r = 1.0, g = 0.64, b = 0.78 }
    }
    local tone = palette[math.random(1, #palette)]

    particle.x = randomFloat(0.04, 0.96)
    particle.y = spawnAbove and randomFloat(-0.22, -0.04) or randomFloat(0.0, 1.0)
    particle.lastX = particle.x
    particle.lastY = particle.y
    particle.speedY = randomFloat(0.0008, 0.0020)
    particle.speedX = randomFloat(-0.0003, 0.0003)
    particle.sway = randomFloat(0.0010, 0.0024)
    particle.phase = randomFloat(0.0, math.pi * 2)
    particle.width = randomFloat(4.0, 7.4)
    particle.height = randomFloat(2.2, 3.8)
    particle.alpha = randomFloat(0.36, 0.72)
    particle.r = tone.r
    particle.g = tone.g
    particle.b = tone.b
end

local function ensureAmbientParticles()
    if #Menu.Particles == 0 then
        for i = 1, 56 do
            local particle = {}
            resetSnowParticle(particle, false)
            table.insert(Menu.Particles, particle)
        end
    end

    if #Menu.BlossomParticles == 0 then
        for i = 1, 28 do
            local particle = {}
            resetBlossomParticle(particle, false)
            table.insert(Menu.BlossomParticles, particle)
        end
    end
end

local function isParticleVisible(particleY, segments)
    for i, seg in ipairs(segments or {}) do
        if i == #segments then
            break
        end
        if particleY >= seg.y and particleY <= (seg.y + seg.h) then
            return true
        end
    end
    return false
end

local function drawSnowflakes(x, y, width, fullHeight, segments, dtScale, timeNow)
    local accentR, accentG, accentB = getOverlayAccentColor()
    local snowR = clampNumber(0.84 + (accentR * 0.10), 0.0, 1.0)
    local snowG = clampNumber(0.87 + (accentG * 0.10), 0.0, 1.0)
    local snowB = 1.0

    drawSoftGlow(x + (width * 0.78), y + 28, math.max(40, width * 0.16), accentR, accentG, accentB, 0.18)
    drawSoftGlow(x + (width * 0.20), y + fullHeight - 22, math.max(34, width * 0.12), 0.75, 0.88, 1.0, 0.14)

    for _, particle in ipairs(Menu.Particles) do
        particle.y = particle.y + (particle.speedY * dtScale)
        particle.x = particle.x + (math.sin((timeNow * particle.sparkle) + particle.phase) * particle.drift * dtScale) + (particle.speedX * dtScale)

        if particle.y > 1.06 or particle.x < -0.12 or particle.x > 1.12 then
            resetSnowParticle(particle, true)
        end

        local drawX = x + (particle.x * width)
        local drawY = y + (particle.y * fullHeight)
        if isParticleVisible(drawY, segments) then
            local alpha = clampNumber(0.28 + ((math.sin((timeNow * particle.sparkle) + particle.phase) + 1.0) * 0.20), 0.18, 0.82)
            drawFilledCircle(drawX, drawY, particle.size, snowR, snowG, snowB, alpha)

            if particle.size > 2.3 and Susano and Susano.DrawLine then
                Susano.DrawLine(drawX - particle.size, drawY, drawX + particle.size, drawY, snowR, snowG, snowB, alpha * 0.25, 1.0)
                Susano.DrawLine(drawX, drawY - particle.size, drawX, drawY + particle.size, snowR, snowG, snowB, alpha * 0.25, 1.0)
            end
        end
    end
end

local function drawBlossoms(x, y, width, fullHeight, segments, dtScale, timeNow)
    drawSoftGlow(x + (width * 0.26), y + 22, math.max(42, width * 0.15), 1.0, 0.62, 0.82, 0.16)
    drawSoftGlow(x + (width * 0.74), y + fullHeight - 18, math.max(36, width * 0.12), 1.0, 0.76, 0.88, 0.12)

    for _, particle in ipairs(Menu.BlossomParticles) do
        particle.lastX = particle.x
        particle.lastY = particle.y
        particle.y = particle.y + (particle.speedY * dtScale)
        particle.x = particle.x + (math.sin((timeNow * 1.55) + particle.phase) * particle.sway * dtScale) + (particle.speedX * dtScale)

        if particle.y > 1.08 or particle.x < -0.15 or particle.x > 1.15 then
            resetBlossomParticle(particle, true)
        end

        local drawX = x + (particle.x * width)
        local drawY = y + (particle.y * fullHeight)
        if isParticleVisible(drawY, segments) then
            local alpha = clampNumber(particle.alpha + (math.sin((timeNow * 1.25) + particle.phase) * 0.08), 0.22, 0.82)
            local lastX = x + (particle.lastX * width)
            local lastY = y + (particle.lastY * fullHeight)

            if Susano and Susano.DrawLine then
                Susano.DrawLine(lastX, lastY, drawX, drawY, particle.r, particle.g, particle.b, alpha * 0.10, 1.0)
            end

            if Susano and Susano.DrawRectFilled then
                Susano.DrawRectFilled(drawX - (particle.width / 2), drawY - (particle.height / 2),
                    particle.width, particle.height, particle.r, particle.g, particle.b, alpha, particle.height / 2)
                Susano.DrawRectFilled(drawX - (particle.width * 0.15), drawY - (particle.height * 0.48),
                    particle.width * 0.38, particle.height * 0.40, 1.0, 1.0, 1.0, alpha * 0.34, particle.height / 3)
            else
                Menu.DrawRoundedRect(drawX - (particle.width / 2), drawY - (particle.height / 2),
                    particle.width, particle.height,
                    math.floor(particle.r * 255), math.floor(particle.g * 255), math.floor(particle.b * 255), math.floor(alpha * 255), particle.height / 2)
            end
        end
    end
end

function Menu.GetLayoutSegments()
    local segments = {}
    local scaledPos = Menu.GetScaledPosition()
    local scale = Menu.Scale or 1.0
    local x = scaledPos.x
    local startY = scaledPos.y
    local width = scaledPos.width
    
    local bannerHeight = Menu.Banner.enabled and (Menu.Banner.height * scale) or scaledPos.headerHeight
    local headerH = bannerHeight
    local menuBarH = scaledPos.mainMenuHeight
    local spacing = scaledPos.mainMenuSpacing
    local itemH = scaledPos.itemHeight
    local footerSpacing = scaledPos.footerSpacing
    local footerH = scaledPos.footerHeight
    
    local topSegmentH = headerH + menuBarH
    
    local menuBarY = startY + headerH
    local menuBarSegmentH = menuBarH
    table.insert(segments, {y = menuBarY, h = menuBarSegmentH})
    
    local itemsY = startY + topSegmentH + spacing
    local itemsH = 0
    
    if Menu.OpenedCategory then
        local category = Menu.Categories[Menu.OpenedCategory]
        if category and category.hasTabs and category.tabs then
            local currentTab = category.tabs[Menu.CurrentTab]
            if currentTab and currentTab.items then
                local maxVisible = Menu.ItemsPerPage
                local totalItems = #currentTab.items
                local visibleItems = math.min(maxVisible, totalItems)
                itemsH = visibleItems * itemH
            end
        end
    else
        local maxVisible = Menu.ItemsPerPage
        local totalCategories = #Menu.Categories - 1
        local visibleCategories = math.min(maxVisible, totalCategories)
        itemsH = visibleCategories * itemH
    end
    
    if itemsH > 0 then
        table.insert(segments, {y = itemsY, h = itemsH})
    end
    
    local footerY = itemsY + itemsH + footerSpacing
    table.insert(segments, {y = footerY, h = footerH})
    
    local fullHeight = (itemsY + itemsH) - startY
    if fullHeight <= 0 then
        fullHeight = (footerY + footerH) - startY
    end
    
    return segments, fullHeight
end

function Menu.DrawBackground()
    local scaledPos = Menu.GetScaledPosition()
    local x = scaledPos.x
    local y = scaledPos.y
    local width = scaledPos.width - 1
    
    local segments, fullHeight = Menu.GetLayoutSegments()

    local r = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.r) or 148
    local g = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.g) or 0
    local b = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.b) or 211
    
    local startY = scaledPos.y
    local scale = Menu.Scale or 1.0
    local bannerHeight = Menu.Banner.enabled and (Menu.Banner.height * scale) or scaledPos.headerHeight
    local headerH = bannerHeight
    local menuBarH = scaledPos.mainMenuHeight
    local spacing = scaledPos.mainMenuSpacing
    local itemH = scaledPos.itemHeight
    
    local itemsY = 0
    local itemsH = 0
    
    if Menu.OpenedCategory then
        itemsY = startY + headerH + menuBarH + spacing
        
        local category = Menu.Categories[Menu.OpenedCategory]
        if category and category.hasTabs and category.tabs then
            local currentTab = category.tabs[Menu.CurrentTab]
            if currentTab and currentTab.items then
                local maxVisible = Menu.ItemsPerPage
                local totalItems = #currentTab.items
                local visibleItems = math.min(maxVisible, totalItems)
                itemsH = visibleItems * itemH
            end
        end
    else
        itemsY = startY + headerH + menuBarH + spacing
        
        local maxVisible = Menu.ItemsPerPage
        local totalCategories = #Menu.Categories - 1
        local visibleCategories = math.min(maxVisible, totalCategories)
        itemsH = visibleCategories * itemH
    end
    
    local itemsEndY = itemsY + itemsH
    
  
    local menuBarY = startY + headerH
    local menuBarEndY = menuBarY + menuBarH
    
    for i, seg in ipairs(segments) do
        if i == #segments then
            break
        end
        
        if seg.y >= itemsEndY then
            break
        end
        
       
      
        if seg.y < menuBarY then
          
            local offset = menuBarY - seg.y
            if offset >= seg.h then
                
            else
               
                seg = {y = menuBarY, h = seg.h - offset}
            end
        end
        
      
        if seg.y < menuBarY or seg.h <= 0 then
            
        else
        local segSteps = math.ceil(seg.h / 2)
        
        for i = 0, segSteps - 1 do
            local localY = i * 2
            local drawH = 2
            if localY + drawH > seg.h then drawH = seg.h - localY end
            
            local currentY = seg.y + localY
                
              
                if currentY < menuBarY then
                    
                    local adjust = menuBarY - currentY
                    if adjust >= drawH then
                       
                    else
                        currentY = menuBarY
                        drawH = drawH - adjust
                    end
                end
            
            
            if currentY >= menuBarEndY and currentY < itemsY then
               
            else
                if currentY >= itemsEndY then
                    break
                end
                if currentY + drawH > itemsEndY then
                    drawH = itemsEndY - currentY
                    if drawH <= 0 then
                        break
                    end
                end
                
               
                local isTabArea = false
                if currentY >= menuBarY and currentY < menuBarEndY then
                    isTabArea = true
                end
                
                
                local backgroundAlpha = 1.0
                
               
                if isTabArea then
                    backgroundAlpha = 1.0
                else
                   
                    local blackBackgroundItem = nil
                    if Menu.Categories then
                        for _, cat in ipairs(Menu.Categories) do
                            if cat.name == "Settings" and cat.tabs then
                                for _, tab in ipairs(cat.tabs) do
                                    if tab.name == "General" and tab.items then
                                        for _, item in ipairs(tab.items) do
                                            if item.name == "Black Background" then
                                                blackBackgroundItem = item
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    
                    if blackBackgroundItem and blackBackgroundItem.value == false then
                        backgroundAlpha = 0.2
                    else
                        backgroundAlpha = 1.0
                    end
                end

                if Susano and Susano.DrawRectFilled then
                    Susano.DrawRectFilled(x, currentY, width, drawH, 0.0, 0.0, 0.0, backgroundAlpha, 0)
                else
                    Menu.DrawRect(x, currentY, width, drawH, 0, 0, 0, math.floor(backgroundAlpha * 255))
                end
            end
        end
        end
    end

    if Menu.ShowSnowflakes or Menu.ShowBlossoms then
        ensureAmbientParticles()

        local dtScale = clampNumber(((GetFrameTime and GetFrameTime() or 0.016) * 60.0), 0.55, 1.85)
        local timeNow = (GetGameTimer and (GetGameTimer() / 1000.0)) or 0.0

        if Menu.ShowSnowflakes then
            drawSnowflakes(x, y, width, fullHeight, segments, dtScale, timeNow)
        end

        if Menu.ShowBlossoms then
            drawBlossoms(x, y, width, fullHeight, segments, dtScale, timeNow)
        end
    end
end


Menu.DisplayMenuLayout = {
    width = 940,
    height = 560,
    sidebarWidth = 210,
    headerHeight = 60,
    tabBarHeight = 44,
    itemHeight = 38,
    padding = 18,
    rowGap = 4,
    itemsPerPage = 11
}

local function DM_DrawRect(x, y, w, h, r, g, b, a)
    if not (Susano and (Susano.DrawRectFilled or Susano.DrawFilledRect)) then return end
    r = r or 1.0; g = g or 1.0; b = b or 1.0; a = a or 1.0
    if r > 1.0 then r = r / 255.0 end
    if g > 1.0 then g = g / 255.0 end
    if b > 1.0 then b = b / 255.0 end
    if a > 1.0 then a = a / 255.0 end
    if Susano.DrawRectFilled then
        Susano.DrawRectFilled(x, y, w, h, r, g, b, a, 0)
    else
        Susano.DrawFilledRect(x, y, w, h, r, g, b, a)
    end
end

local function DM_DrawTextSafe(x, y, text, size, r, g, b, a)
    if Menu.DrawText then
        Menu.DrawText(x, y, text, size, r, g, b, a)
    elseif Susano and Susano.DrawText then
        if r and r > 1.0 then r = r / 255.0 end
        if g and g > 1.0 then g = g / 255.0 end
        if b and b > 1.0 then b = b / 255.0 end
        if a and a > 1.0 then a = a / 255.0 end
        Susano.DrawText(x, y, tostring(text or ""), size or 16, r or 1, g or 1, b or 1, a or 1)
    end
end

local function DM_GetAccent()
    local base = (Menu and Menu.Colors and Menu.Colors.SelectedBg) or { r = 0, g = 221, b = 255 }
    return base.r or 0, base.g or 221, base.b or 255
end

local function DM_GetRect()
    local layout = Menu.DisplayMenuLayout
    local screenW, screenH = MenuGetScreenSize()
    local scale = Menu.Scale or 1.0
    local maxW = math.floor(screenW * 0.92)
    local maxH = math.floor(screenH * 0.88)
    local w = math.min(math.floor(layout.width * scale), maxW)
    local h = math.min(math.floor(layout.height * scale), maxH)
    local x = math.floor((screenW - w) / 2)
    local y = math.floor((screenH - h) / 2)
    return x, y, w, h, scale
end

local function DM_GetSidebarRowRect(panelX, panelY, scale, index)
    local layout = Menu.DisplayMenuLayout
    local sidebarW = layout.sidebarWidth * scale
    local headerH = layout.headerHeight * scale
    local rowH = (layout.itemHeight + 2) * scale
    local startY = panelY + headerH + (8 * scale)
    local rowX = panelX + (8 * scale)
    local rowY = startY + ((index - 1) * rowH)
    local rowW = sidebarW - (16 * scale)
    return rowX, rowY, rowW, rowH * 0.92
end

local function DM_GetTabRect(panelX, panelY, panelW, scale, index, totalTabs)
    local layout = Menu.DisplayMenuLayout
    local sidebarW = layout.sidebarWidth * scale
    local headerH = layout.headerHeight * scale
    local tabBarH = layout.tabBarHeight * scale
    local contentX = panelX + sidebarW
    local contentW = panelW - sidebarW
    local tabAreaPad = 16 * scale
    local availableW = contentW - (tabAreaPad * 2)
    local tabW = availableW / math.max(1, totalTabs)
    local tabX = contentX + tabAreaPad + ((index - 1) * tabW)
    local tabY = panelY + headerH
    return tabX, tabY, tabW, tabBarH
end

local function DM_GetItemAreaRect(panelX, panelY, panelW, panelH, scale)
    local layout = Menu.DisplayMenuLayout
    local sidebarW = layout.sidebarWidth * scale
    local headerH = layout.headerHeight * scale
    local tabBarH = layout.tabBarHeight * scale
    local pad = 14 * scale
    local x = panelX + sidebarW + pad
    local y = panelY + headerH + tabBarH + pad
    local w = panelW - sidebarW - (pad * 2)
    local h = panelH - headerH - tabBarH - (pad * 2)
    return x, y, w, h
end

local function DM_GetItemRowRect(itemAreaX, itemAreaY, itemAreaW, scale, displayIndex)
    local layout = Menu.DisplayMenuLayout
    local rowH = layout.itemHeight * scale
    local gap = layout.rowGap * scale
    local rowY = itemAreaY + ((displayIndex - 1) * (rowH + gap))
    return itemAreaX, rowY, itemAreaW, rowH
end

local function DM_CountVisibleItems(items)
    if not items then return 0 end
    return #items
end

function Menu.DrawDisplayMenu()
    if not Menu.Categories then return end
    if not (Susano and Susano.DrawRectFilled) and not (Susano and Susano.DrawFilledRect) then return end

    local panelX, panelY, panelW, panelH, scale = DM_GetRect()
    local layout = Menu.DisplayMenuLayout
    local sidebarW = layout.sidebarWidth * scale
    local headerH = layout.headerHeight * scale
    local tabBarH = layout.tabBarHeight * scale
    local accentR, accentG, accentB = DM_GetAccent()

    DM_DrawRect(panelX - 2, panelY - 2, panelW + 4, panelH + 4, 0, 0, 0, 200)
    DM_DrawRect(panelX, panelY, panelW, panelH, 18, 19, 26, 245)
    DM_DrawRect(panelX, panelY, sidebarW, panelH, 12, 13, 18, 255)
    DM_DrawRect(panelX, panelY, panelW, headerH, 22, 24, 32, 255)
    DM_DrawRect(panelX + sidebarW - 1, panelY, 1, panelH, 40, 42, 52, 220)
    DM_DrawRect(panelX, panelY + headerH - 1, panelW, 1, 40, 42, 52, 220)

    local titleY = panelY + math.floor(headerH / 2) - math.floor(11 * scale)
    DM_DrawTextSafe(panelX + math.floor(18 * scale), titleY, "ARCANE", math.floor(20 * scale), accentR, accentG, accentB, 1.0)
    DM_DrawTextSafe(panelX + math.floor(18 * scale) + Menu.GetTextWidth("ARCANE", math.floor(20 * scale)) + math.floor(6 * scale), titleY, "MENU", math.floor(20 * scale), 235, 235, 240, 1.0)

    local rightLabel = "F10 Keybind  |  Mouse Mode"
    local labelW = Menu.GetTextWidth(rightLabel, math.floor(13 * scale))
    DM_DrawTextSafe(panelX + panelW - labelW - math.floor(18 * scale), titleY + math.floor(4 * scale), rightLabel, math.floor(13 * scale), 160, 165, 175, 1.0)

    local totalCategories = (#Menu.Categories) - 1
    local hoverCat = Menu.DisplayMenuHoverCategory
    for displayIndex = 1, totalCategories do
        local categoryIndex = displayIndex + 1
        local category = Menu.Categories[categoryIndex]
        if category then
            local rx, ry, rw, rh = DM_GetSidebarRowRect(panelX, panelY, scale, displayIndex)
            local isSelected = (Menu.OpenedCategory == categoryIndex) or (Menu.CurrentCategory == categoryIndex and not Menu.OpenedCategory)
            local isHover = (hoverCat == displayIndex)

            if isSelected then
                DM_DrawRect(rx, ry, rw, rh, accentR, accentG, accentB, 38)
                DM_DrawRect(rx, ry, math.max(2, math.floor(3 * scale)), rh, accentR, accentG, accentB, 255)
            elseif isHover then
                DM_DrawRect(rx, ry, rw, rh, 255, 255, 255, 12)
            end

            local labelColor = isSelected and 255 or 200
            local catName = category.name or ""
            local textSize = math.floor(15 * scale)
            local textY = ry + math.floor(rh / 2) - math.floor(textSize / 2)
            local textX = rx + math.floor(14 * scale)
            DM_DrawTextSafe(textX, textY, catName, textSize, labelColor, labelColor, labelColor, 1.0)

            if category.hasTabs then
                local arrow = "›"
                local arrowSize = math.floor(16 * scale)
                local arrowW = Menu.GetTextWidth(arrow, arrowSize)
                DM_DrawTextSafe(rx + rw - arrowW - math.floor(12 * scale), ry + math.floor(rh / 2) - math.floor(arrowSize / 2), arrow, arrowSize, 140, 140, 150, 1.0)
            end
        end
    end

    local opened = Menu.OpenedCategory and Menu.Categories[Menu.OpenedCategory]
    if not opened or not opened.hasTabs or not opened.tabs then
        local emptyMsg = "Select a category"
        local size = math.floor(16 * scale)
        local w = Menu.GetTextWidth(emptyMsg, size)
        DM_DrawTextSafe(panelX + sidebarW + math.floor(((panelW - sidebarW) - w) / 2), panelY + math.floor(panelH / 2), emptyMsg, size, 130, 135, 145, 1.0)
        return
    end

    local hoverTab = Menu.DisplayMenuHoverTab
    local totalTabs = #opened.tabs
    for i, tab in ipairs(opened.tabs) do
        local tx, ty, tw, th = DM_GetTabRect(panelX, panelY, panelW, scale, i, totalTabs)
        local isActive = (i == Menu.CurrentTab)
        local isHover = (hoverTab == i)

        if isActive then
            local barH = math.max(2, math.floor(2 * scale))
            DM_DrawRect(tx, ty + th - barH, tw, barH, accentR, accentG, accentB, 255)
        elseif isHover then
            DM_DrawRect(tx, ty, tw, th, 255, 255, 255, 10)
        end

        local size = math.floor(14 * scale)
        local label = tab.name or ""
        local labelW = Menu.GetTextWidth(label, size)
        local lx = tx + math.floor((tw - labelW) / 2)
        local ly = ty + math.floor(th / 2) - math.floor(size / 2)
        local cR, cG, cB = (isActive and accentR or 200), (isActive and accentG or 200), (isActive and accentB or 200)
        DM_DrawTextSafe(lx, ly, label, size, cR, cG, cB, 1.0)
    end

    local currentTab = opened.tabs[Menu.CurrentTab]
    if not currentTab or not currentTab.items then return end

    local areaX, areaY, areaW, areaH = DM_GetItemAreaRect(panelX, panelY, panelW, panelH, scale)
    local rowH = layout.itemHeight * scale
    local gap = layout.rowGap * scale
    local maxVisible = math.max(1, math.floor((areaH + gap) / (rowH + gap)))
    if maxVisible > layout.itemsPerPage then maxVisible = layout.itemsPerPage end

    local totalItems = #currentTab.items
    local scrollOffset = Menu.DisplayMenuItemScrollOffset or 0
    if scrollOffset < 0 then scrollOffset = 0 end
    if scrollOffset > math.max(0, totalItems - maxVisible) then
        scrollOffset = math.max(0, totalItems - maxVisible)
    end
    Menu.DisplayMenuItemScrollOffset = scrollOffset

    local hoverItem = Menu.DisplayMenuHoverItem
    for displayIndex = 1, math.min(maxVisible, totalItems) do
        local itemIndex = displayIndex + scrollOffset
        local item = currentTab.items[itemIndex]
        if item then
            local rx, ry, rw, rh = DM_GetItemRowRect(areaX, areaY, areaW, scale, displayIndex)

            if item.isSeparator then
                local sepText = item.separatorText or ""
                local sepSize = math.floor(13 * scale)
                DM_DrawRect(rx, ry + math.floor(rh / 2), rw, math.max(1, math.floor(1 * scale)), 60, 62, 75, 220)
                if sepText ~= "" then
                    local tw = Menu.GetTextWidth(sepText, sepSize) + math.floor(12 * scale)
                    DM_DrawRect(rx + math.floor(8 * scale), ry + math.floor(rh / 2) - math.floor(sepSize / 2) - math.floor(2 * scale), tw, sepSize + math.floor(4 * scale), 18, 19, 26, 255)
                    DM_DrawTextSafe(rx + math.floor(14 * scale), ry + math.floor(rh / 2) - math.floor(sepSize / 2), sepText, sepSize, accentR, accentG, accentB, 1.0)
                end
            else
                local isHover = (hoverItem == displayIndex)
                local rowBgA = isHover and 22 or 14
                DM_DrawRect(rx, ry, rw, rh, 255, 255, 255, rowBgA)
                DM_DrawRect(rx, ry, math.max(1, math.floor(1 * scale)), rh, accentR, accentG, accentB, isHover and 255 or 90)

                local nameSize = math.floor(14 * scale)
                local nameY = ry + math.floor(rh / 2) - math.floor(nameSize / 2)
                local nameX = rx + math.floor(14 * scale)
                local labelText = item.name or ""
                if item.bindKey and item.bindKeyName then
                    labelText = labelText .. "  [" .. item.bindKeyName .. "]"
                end
                DM_DrawTextSafe(nameX, nameY, labelText, nameSize, 230, 230, 235, 1.0)

                if item.type == "toggle" then
                    local toggleW = math.floor(34 * scale)
                    local toggleH = math.floor(16 * scale)
                    local toggleX = rx + rw - toggleW - math.floor(14 * scale)
                    local toggleY = ry + math.floor(rh / 2) - math.floor(toggleH / 2)
                    local on = item.value == true
                    if on then
                        DM_DrawRect(toggleX, toggleY, toggleW, toggleH, accentR, accentG, accentB, 220)
                    else
                        DM_DrawRect(toggleX, toggleY, toggleW, toggleH, 60, 62, 75, 220)
                    end
                    local knobSize = toggleH - math.floor(4 * scale)
                    local knobX = on and (toggleX + toggleW - knobSize - math.floor(2 * scale)) or (toggleX + math.floor(2 * scale))
                    local knobY = toggleY + math.floor(2 * scale)
                    DM_DrawRect(knobX, knobY, knobSize, knobSize, 240, 240, 245, 255)

                    if item.hasSlider then
                        local sliderW = math.floor(110 * scale)
                        local sliderH = math.max(3, math.floor(4 * scale))
                        local sliderX = toggleX - sliderW - math.floor(14 * scale)
                        local sliderY = ry + math.floor(rh / 2) - math.floor(sliderH / 2)
                        local minV = item.sliderMin or 0.0
                        local maxV = item.sliderMax or 100.0
                        local cur = item.sliderValue or minV
                        local pct = 0
                        if maxV > minV then pct = (cur - minV) / (maxV - minV) end
                        pct = math.max(0, math.min(1, pct))
                        DM_DrawRect(sliderX, sliderY, sliderW, sliderH, 60, 62, 75, 220)
                        DM_DrawRect(sliderX, sliderY, math.floor(sliderW * pct), sliderH, accentR, accentG, accentB, 230)
                        local valSize = math.floor(12 * scale)
                        local valText = string.format("%g", cur)
                        DM_DrawTextSafe(sliderX + sliderW + math.floor(8 * scale) + 0, ry + math.floor(rh / 2) - math.floor(valSize / 2) - math.floor(8 * scale), valText, valSize, 180, 180, 190, 1.0)
                    end
                elseif item.type == "slider" then
                    local sliderW = math.floor(140 * scale)
                    local sliderH = math.max(3, math.floor(4 * scale))
                    local sliderX = rx + rw - sliderW - math.floor(60 * scale)
                    local sliderY = ry + math.floor(rh / 2) - math.floor(sliderH / 2)
                    local minV = item.min or 0.0
                    local maxV = item.max or 100.0
                    local cur = item.value or minV
                    local pct = 0
                    if maxV > minV then pct = (cur - minV) / (maxV - minV) end
                    pct = math.max(0, math.min(1, pct))
                    DM_DrawRect(sliderX, sliderY, sliderW, sliderH, 60, 62, 75, 220)
                    DM_DrawRect(sliderX, sliderY, math.floor(sliderW * pct), sliderH, accentR, accentG, accentB, 230)
                    local valSize = math.floor(13 * scale)
                    local valText = string.format("%g", cur)
                    local valW = Menu.GetTextWidth(valText, valSize)
                    DM_DrawTextSafe(rx + rw - valW - math.floor(14 * scale), ry + math.floor(rh / 2) - math.floor(valSize / 2), valText, valSize, 220, 220, 230, 1.0)
                elseif item.type == "selector" or item.type == "toggle_selector" then
                    local options = item.options or {}
                    local sel = item.selected or 1
                    local optText = options[sel] or tostring(sel)
                    local fullText = "< " .. optText .. " >"
                    local size = math.floor(13 * scale)
                    local fullW = Menu.GetTextWidth(fullText, size)
                    local boxX = rx + rw - fullW - math.floor(20 * scale)
                    local boxY = ry + math.floor(rh / 2) - math.floor(size / 2)
                    DM_DrawTextSafe(boxX, boxY, fullText, size, accentR, accentG, accentB, 1.0)

                    if item.type == "toggle_selector" then
                        local toggleW = math.floor(28 * scale)
                        local toggleH = math.floor(14 * scale)
                        local toggleX = rx + rw - toggleW - math.floor(4 * scale)
                        local toggleY = ry + math.floor(rh / 2) - math.floor(toggleH / 2)
                        local on = item.value == true
                        if on then
                            DM_DrawRect(toggleX, toggleY, toggleW, toggleH, accentR, accentG, accentB, 220)
                        else
                            DM_DrawRect(toggleX, toggleY, toggleW, toggleH, 60, 62, 75, 220)
                        end
                        local knobSize = toggleH - math.floor(4 * scale)
                        local knobX = on and (toggleX + toggleW - knobSize - math.floor(2 * scale)) or (toggleX + math.floor(2 * scale))
                        local knobY = toggleY + math.floor(2 * scale)
                        DM_DrawRect(knobX, knobY, knobSize, knobSize, 240, 240, 245, 255)
                    end
                elseif item.type == "action" then
                    local btnText = "Run"
                    local size = math.floor(12 * scale)
                    local btnW = Menu.GetTextWidth(btnText, size) + math.floor(20 * scale)
                    local btnH = math.floor(20 * scale)
                    local btnX = rx + rw - btnW - math.floor(14 * scale)
                    local btnY = ry + math.floor(rh / 2) - math.floor(btnH / 2)
                    DM_DrawRect(btnX, btnY, btnW, btnH, accentR, accentG, accentB, 200)
                    DM_DrawTextSafe(btnX + math.floor((btnW - Menu.GetTextWidth(btnText, size)) / 2), btnY + math.floor(btnH / 2) - math.floor(size / 2), btnText, size, 18, 19, 26, 1.0)
                end
            end
        end
    end

    if totalItems > maxVisible then
        local trackX = panelX + panelW - math.floor(6 * scale)
        local trackY = areaY
        local trackW = math.max(2, math.floor(3 * scale))
        local trackH = areaH
        DM_DrawRect(trackX, trackY, trackW, trackH, 60, 62, 75, 200)
        local thumbH = math.max(20 * scale, trackH * (maxVisible / totalItems))
        local maxOffset = totalItems - maxVisible
        local pct = (maxOffset > 0) and (scrollOffset / maxOffset) or 0
        local thumbY = trackY + (trackH - thumbH) * pct
        DM_DrawRect(trackX, thumbY, trackW, thumbH, accentR, accentG, accentB, 230)
    end

    local footerH = math.floor(24 * scale)
    local footerY = panelY + panelH - footerH
    DM_DrawRect(panelX, footerY, panelW, footerH, 12, 13, 18, 255)
    DM_DrawRect(panelX, footerY, panelW, 1, 40, 42, 52, 220)
    local footerText = "discord.gg/arcaneservices"
    local footerSize = math.floor(12 * scale)
    DM_DrawTextSafe(panelX + math.floor(14 * scale), footerY + math.floor(footerH / 2) - math.floor(footerSize / 2), footerText, footerSize, 160, 165, 175, 1.0)
    local pageText = string.format("%d/%d", math.min(scrollOffset + 1, math.max(1, totalItems)), math.max(1, totalItems))
    local pageW = Menu.GetTextWidth(pageText, footerSize)
    DM_DrawTextSafe(panelX + panelW - pageW - math.floor(14 * scale), footerY + math.floor(footerH / 2) - math.floor(footerSize / 2), pageText, footerSize, 160, 165, 175, 1.0)
end

function Menu.HandleDisplayMenuInput()
    if not Menu.Visible or not Menu.DisplayMenu then
        Menu.DisplayMenuHoverCategory = nil
        Menu.DisplayMenuHoverTab = nil
        Menu.DisplayMenuHoverItem = nil
        Menu.DisplayMenuActiveSlider = nil
        Menu.DisplayMenuLeftWasDown = false
        Menu.DisplayMenuRightWasDown = false
        return
    end

    local mouseX, mouseY, leftDown, leftPressed, rightDown, rightPressed = GetOverlayMouseState()
    if not mouseX then return end

    local leftClicked = leftPressed or (leftDown and not Menu.DisplayMenuLeftWasDown)
    local rightClicked = rightPressed or (rightDown and not Menu.DisplayMenuRightWasDown)

    if not leftDown then
        Menu.DisplayMenuActiveSlider = nil
    end

    Menu.DisplayMenuHoverCategory = nil
    Menu.DisplayMenuHoverTab = nil
    Menu.DisplayMenuHoverItem = nil

    local panelX, panelY, panelW, panelH, scale = DM_GetRect()
    local layout = Menu.DisplayMenuLayout
    local sidebarW = layout.sidebarWidth * scale
    local headerH = layout.headerHeight * scale
    local tabBarH = layout.tabBarHeight * scale
    local insidePanel = IsPointInRect(mouseX, mouseY, panelX, panelY, panelW, panelH)

    if rightClicked and insidePanel then
        if Menu.OpenedCategory then
            Menu.OpenedCategory = nil
            Menu.CurrentItem = 1
            Menu.CurrentTab = 1
            Menu.DisplayMenuItemScrollOffset = 0
        else
            Menu.Visible = false
        end
        Menu.DisplayMenuLeftWasDown = leftDown
        Menu.DisplayMenuRightWasDown = rightDown
        return
    end

    local totalCategories = (#Menu.Categories) - 1
    for displayIndex = 1, totalCategories do
        local categoryIndex = displayIndex + 1
        local category = Menu.Categories[categoryIndex]
        if category then
            local rx, ry, rw, rh = DM_GetSidebarRowRect(panelX, panelY, scale, displayIndex)
            if IsPointInRect(mouseX, mouseY, rx, ry, rw, rh) then
                Menu.DisplayMenuHoverCategory = displayIndex
                Menu.CurrentCategory = categoryIndex
                if leftClicked then
                    if category.hasTabs and category.tabs then
                        Menu.OpenedCategory = categoryIndex
                        Menu.CurrentTab = 1
                        if category.tabs[1] and category.tabs[1].items then
                            Menu.CurrentItem = findNextNonSeparator(category.tabs[1].items, 0, 1)
                        else
                            Menu.CurrentItem = 1
                        end
                        Menu.DisplayMenuItemScrollOffset = 0
                    end
                end
                break
            end
        end
    end

    local opened = Menu.OpenedCategory and Menu.Categories[Menu.OpenedCategory]
    if opened and opened.hasTabs and opened.tabs then
        local totalTabs = #opened.tabs
        for i, tab in ipairs(opened.tabs) do
            local tx, ty, tw, th = DM_GetTabRect(panelX, panelY, panelW, scale, i, totalTabs)
            if IsPointInRect(mouseX, mouseY, tx, ty, tw, th) then
                Menu.DisplayMenuHoverTab = i
                if leftClicked then
                    Menu.CurrentTab = i
                    local newTab = opened.tabs[i]
                    if newTab and newTab.items then
                        Menu.CurrentItem = findNextNonSeparator(newTab.items, 0, 1)
                    else
                        Menu.CurrentItem = 1
                    end
                    Menu.DisplayMenuItemScrollOffset = 0
                end
                break
            end
        end

        local currentTab = opened.tabs[Menu.CurrentTab]
        if currentTab and currentTab.items then
            local areaX, areaY, areaW, areaH = DM_GetItemAreaRect(panelX, panelY, panelW, panelH, scale)
            local rowH = layout.itemHeight * scale
            local gap = layout.rowGap * scale
            local maxVisible = math.max(1, math.floor((areaH + gap) / (rowH + gap)))
            if maxVisible > layout.itemsPerPage then maxVisible = layout.itemsPerPage end
            local totalItems = #currentTab.items
            local scrollOffset = Menu.DisplayMenuItemScrollOffset or 0

            local insideArea = IsPointInRect(mouseX, mouseY, areaX, areaY, areaW, areaH)
            if insideArea and Susano and Susano.GetAsyncKeyState then
                local upDown, upPressed = Susano.GetAsyncKeyState(0x26)
                local downDown, downPressed = Susano.GetAsyncKeyState(0x28)
                if upPressed == true then scrollOffset = math.max(0, scrollOffset - 1) end
                if downPressed == true then scrollOffset = math.min(math.max(0, totalItems - maxVisible), scrollOffset + 1) end
                Menu.DisplayMenuItemScrollOffset = scrollOffset
            end

            for displayIndex = 1, math.min(maxVisible, totalItems) do
                local itemIndex = displayIndex + scrollOffset
                local item = currentTab.items[itemIndex]
                if item and not item.isSeparator then
                    local rx, ry, rw, rh = DM_GetItemRowRect(areaX, areaY, areaW, scale, displayIndex)
                    if IsPointInRect(mouseX, mouseY, rx, ry, rw, rh) then
                        Menu.DisplayMenuHoverItem = displayIndex
                        Menu.CurrentItem = itemIndex

                        local handled = false

                        if item.type == "toggle" and item.hasSlider then
                            local sliderW = math.floor(110 * scale)
                            local sliderH = math.max(3, math.floor(4 * scale))
                            local toggleW = math.floor(34 * scale)
                            local sliderX = rx + rw - toggleW - math.floor(14 * scale) - sliderW - math.floor(14 * scale)
                            local sliderY = ry + math.floor(rh / 2) - math.floor(sliderH / 2)
                            if IsPointInRect(mouseX, mouseY, sliderX, sliderY - math.floor(8 * scale), sliderW, sliderH + math.floor(16 * scale)) then
                                local pct = (mouseX - sliderX) / sliderW
                                if leftDown or leftClicked then
                                    SetSliderItemFromPercent(item, pct, true)
                                    Menu.DisplayMenuActiveSlider = { item = item, kind = "toggle_slider", sliderX = sliderX, sliderWidth = sliderW }
                                end
                                handled = true
                            end
                        elseif item.type == "slider" then
                            local sliderW = math.floor(140 * scale)
                            local sliderH = math.max(3, math.floor(4 * scale))
                            local sliderX = rx + rw - sliderW - math.floor(60 * scale)
                            local sliderY = ry + math.floor(rh / 2) - math.floor(sliderH / 2)
                            if IsPointInRect(mouseX, mouseY, sliderX, sliderY - math.floor(8 * scale), sliderW, sliderH + math.floor(16 * scale)) then
                                local pct = (mouseX - sliderX) / sliderW
                                if leftDown or leftClicked then
                                    SetSliderItemFromPercent(item, pct, false)
                                    Menu.DisplayMenuActiveSlider = { item = item, kind = "slider", sliderX = sliderX, sliderWidth = sliderW }
                                end
                                handled = true
                            end
                        elseif item.type == "toggle_selector" and item.options then
                            local options = item.options
                            local sel = item.selected or 1
                            local optText = options[sel] or tostring(sel)
                            local fullText = "< " .. optText .. " >"
                            local size = math.floor(13 * scale)
                            local fullW = Menu.GetTextWidth(fullText, size)
                            local toggleW = math.floor(28 * scale)
                            local boxX = rx + rw - fullW - math.floor(20 * scale)
                            local toggleX = rx + rw - toggleW - math.floor(4 * scale)
                            local toggleY = ry + math.floor(rh / 2) - math.floor(14 * scale / 2)

                            if IsPointInRect(mouseX, mouseY, boxX, ry, fullW, rh) then
                                if leftClicked then
                                    if mouseX <= boxX + (fullW / 2) then
                                        AdjustSelectorItem(item, -1, true)
                                    else
                                        AdjustSelectorItem(item, 1, true)
                                    end
                                end
                                handled = true
                            elseif IsPointInRect(mouseX, mouseY, toggleX, toggleY, toggleW, math.floor(14 * scale)) then
                                if leftClicked then
                                    TriggerPrimaryItemAction(item)
                                end
                                handled = true
                            end
                        elseif item.type == "selector" and item.options then
                            local sel = item.selected or 1
                            local optText = item.options[sel] or tostring(sel)
                            local fullText = "< " .. optText .. " >"
                            local size = math.floor(13 * scale)
                            local fullW = Menu.GetTextWidth(fullText, size)
                            local boxX = rx + rw - fullW - math.floor(20 * scale)
                            if IsPointInRect(mouseX, mouseY, boxX, ry, fullW, rh) then
                                if leftClicked then
                                    if mouseX <= boxX + (fullW / 2) then
                                        AdjustSelectorItem(item, -1, true)
                                    else
                                        AdjustSelectorItem(item, 1, true)
                                    end
                                end
                                handled = true
                            end
                        end

                        if leftClicked and not handled then
                            TriggerPrimaryItemAction(item)
                        end

                        break
                    end
                end
            end
        end
    end

    if leftDown and Menu.DisplayMenuActiveSlider and Menu.DisplayMenuActiveSlider.item then
        local slider = Menu.DisplayMenuActiveSlider
        local pct = (mouseX - slider.sliderX) / slider.sliderWidth
        SetSliderItemFromPercent(slider.item, pct, slider.kind == "toggle_slider")
    end

    Menu.DisplayMenuLeftWasDown = leftDown
    Menu.DisplayMenuRightWasDown = rightDown
end


Menu.DisplayMenuLayout = {
    width = 980,
    height = 540,
    minHeight = 430,
    maxHeightRatio = 0.88,
    sidebarWidth = 214,
    brandHeight = 54,
    searchHeight = 34,
    headerHeight = 52,
    footerHeight = 28,
    padding = 14,
    categoryHeight = 32,
    categoryGap = 3,
    tabHeight = 34,
    tabGap = 8,
    sectionGap = 12,
    sectionHeaderHeight = 22,
    sectionPaddingX = 16,
    sectionPaddingY = 14,
    sectionRadius = 16,
    rowGap = 8,
    itemHeight = 30,
    sliderHeight = 6,
    controlWidth = 176,
    scrollStep = 36
}

local function SDM_Scale(value, scale)
    return math.floor(((value or 0) * (scale or 1.0)) + 0.5)
end

local function SDM_Clamp(value, minValue, maxValue)
    if value < minValue then return minValue end
    if value > maxValue then return maxValue end
    return value
end

local function SDM_Normalize(value)
    if value == nil then
        return 1.0
    end
    if value > 1.0 then
        return value / 255.0
    end
    return value
end

local function SDM_IsFiniteNumber(value)
    return type(value) == "number" and value == value and value > -math.huge and value < math.huge
end

local function SDM_SanitizeRect(x, y, w, h, rounding)
    if not SDM_IsFiniteNumber(x) or not SDM_IsFiniteNumber(y) or not SDM_IsFiniteNumber(w) or not SDM_IsFiniteNumber(h) then
        return nil
    end

    if w <= 0 or h <= 0 then
        return nil
    end

    local safeRounding = rounding
    if not SDM_IsFiniteNumber(safeRounding) then
        safeRounding = 0
    end

    safeRounding = SDM_Clamp(safeRounding, 0, math.min(w, h) * 0.5)
    return x, y, w, h, safeRounding
end

local function SDM_DrawLineSafe(x1, y1, x2, y2, r, g, b, a, thickness)
    if not (Susano and Susano.DrawLine) then
        return
    end

    if not SDM_IsFiniteNumber(x1) or not SDM_IsFiniteNumber(y1) or not SDM_IsFiniteNumber(x2) or not SDM_IsFiniteNumber(y2) then
        return
    end

    local safeThickness = thickness
    if not SDM_IsFiniteNumber(safeThickness) then
        safeThickness = 1.0
    end

    Susano.DrawLine(x1, y1, x2, y2, SDM_Normalize(r or 1.0), SDM_Normalize(g or 1.0), SDM_Normalize(b or 1.0), SDM_Normalize(a or 1.0), math.max(1.0, safeThickness))
end

local function SDM_DrawCircleSafe(x, y, radius, filled, r, g, b, a, thickness, segments)
    if not (Susano and Susano.DrawCircle) then
        return false
    end

    if not SDM_IsFiniteNumber(x) or not SDM_IsFiniteNumber(y) or not SDM_IsFiniteNumber(radius) or radius <= 0 then
        return false
    end

    local safeThickness = thickness
    if not SDM_IsFiniteNumber(safeThickness) then
        safeThickness = 1.0
    end

    local safeSegments = segments
    if not SDM_IsFiniteNumber(safeSegments) then
        safeSegments = 20
    end

    Susano.DrawCircle(x, y, radius, filled == true, SDM_Normalize(r or 1.0), SDM_Normalize(g or 1.0), SDM_Normalize(b or 1.0), SDM_Normalize(a or 1.0), math.max(1.0, safeThickness), math.max(8, math.floor(safeSegments + 0.5)))
    return true
end

local function SDM_DrawRect(x, y, w, h, r, g, b, a, rounding)
    if not (Susano and (Susano.DrawRectFilled or Susano.DrawFilledRect)) then
        return
    end

    x, y, w, h, rounding = SDM_SanitizeRect(x, y, w, h, rounding)
    if not x then
        return
    end

    if Susano.DrawRectFilled then
        Susano.DrawRectFilled(x, y, w, h, SDM_Normalize(r), SDM_Normalize(g), SDM_Normalize(b), SDM_Normalize(a or 1.0), rounding or 0)
    else
        Susano.DrawFilledRect(x, y, w, h, SDM_Normalize(r), SDM_Normalize(g), SDM_Normalize(b), SDM_Normalize(a or 1.0))
    end
end

local function SDM_DrawOutline(x, y, w, h, r, g, b, a, thickness)
    thickness = math.max(1, thickness or 1)
    x, y, w, h = SDM_SanitizeRect(x, y, w, h, 0)
    if not x then
        return
    end

    if Susano and Susano.DrawRect then
        Susano.DrawRect(x, y, w, h, SDM_Normalize(r), SDM_Normalize(g), SDM_Normalize(b), SDM_Normalize(a or 1.0), thickness)
        return
    end

    SDM_DrawRect(x, y, w, thickness, r, g, b, a)
    SDM_DrawRect(x, y + h - thickness, w, thickness, r, g, b, a)
    SDM_DrawRect(x, y, thickness, h, r, g, b, a)
    SDM_DrawRect(x + w - thickness, y, thickness, h, r, g, b, a)
end

local function SDM_DrawGradientBar(x, y, w, h, r, g, b, a, rounding)
    x, y, w, h, rounding = SDM_SanitizeRect(x, y, w, h, rounding)
    if not x then
        return
    end

    if Susano and Susano.DrawRectGradient then
        local nr = SDM_Normalize(r)
        local ng = SDM_Normalize(g)
        local nb = SDM_Normalize(b)
        local na = SDM_Normalize(a or 1.0)
        Susano.DrawRectGradient(x, y, w, h, nr, ng, nb, na, nr, ng, nb, 0.35 * na, nr, ng, nb, 0.20 * na, nr, ng, nb, 0.95 * na, rounding or 0)
        return
    end

    SDM_DrawRect(x, y, w, h, r, g, b, a, rounding)
end

local function SDM_DrawText(x, y, text, size, r, g, b, a)
    if Menu.DrawText then
        Menu.DrawText(x, y, text, size, r, g, b, a)
    elseif Susano and Susano.DrawText then
        Susano.DrawText(x, y, tostring(text or ""), size or 14, SDM_Normalize(r or 1), SDM_Normalize(g or 1), SDM_Normalize(b or 1), SDM_Normalize(a or 1))
    end
end

local function SDM_TextWidth(text, size)
    if Menu.GetTextWidth then
        return Menu.GetTextWidth(text, size)
    end
    return string.len(tostring(text or "")) * ((size or 14) * 0.58)
end

local function SDM_GetAccent()
    local color = (Menu and Menu.Colors and Menu.Colors.SelectedBg) or { r = 0, g = 221, b = 255 }
    return color.r or 0, color.g or 221, color.b or 255
end

local SDM_EnsureOpenedCategory
local SDM_ItemHeight
local SDM_BuildSections

local function SDM_GetSectionColumnCount(sections, areaW, scale)
    if not sections or #sections <= 2 then
        return 1
    end

    return areaW >= SDM_Scale(760, scale) and 2 or 1
end

local function SDM_MeasureSidebarHeight(scale)
    local layout = Menu.DisplayMenuLayout
    local categoryCount = Menu.Categories and math.max(0, #Menu.Categories - 1) or 0
    local total = (layout.brandHeight * scale)
        + SDM_Scale(10, scale)
        + (layout.searchHeight * scale)
        + math.floor(SDM_Scale(layout.padding, scale) * 1.45)
        + (categoryCount * layout.categoryHeight * scale)
        + SDM_Scale(layout.padding, scale)

    if categoryCount > 1 then
        total = total + ((categoryCount - 1) * layout.categoryGap * scale)
    end

    return math.floor(total + 0.5)
end

local function SDM_MeasureTabContentHeight(tab, areaW, scale)
    local layout = Menu.DisplayMenuLayout
    local sections = SDM_BuildSections(tab)
    if #sections == 0 then
        return SDM_Scale(180, scale)
    end

    local columnCount = SDM_GetSectionColumnCount(sections, areaW, scale)
    local sectionGap = SDM_Scale(layout.sectionGap, scale)
    local rowGap = SDM_Scale(layout.rowGap, scale)
    local sectionBaseHeight = SDM_Scale(layout.sectionHeaderHeight + (layout.sectionPaddingY * 2), scale)
    local columnHeights = {}

    for col = 1, columnCount do
        columnHeights[col] = 0
    end

    for _, section in ipairs(sections) do
        local shortest = 1
        for col = 2, columnCount do
            if columnHeights[col] < columnHeights[shortest] then
                shortest = col
            end
        end

        local sectionHeight = sectionBaseHeight
        for index, item in ipairs(section.items or {}) do
            sectionHeight = sectionHeight + SDM_ItemHeight(item, scale)
            if index < #(section.items or {}) then
                sectionHeight = sectionHeight + rowGap
            end
        end

        columnHeights[shortest] = columnHeights[shortest] + sectionHeight + sectionGap
    end

    local contentHeight = 0
    for col = 1, columnCount do
        contentHeight = math.max(contentHeight, math.max(0, columnHeights[col] - sectionGap))
    end

    return math.max(SDM_Scale(190, scale), contentHeight)
end

local function SDM_GetRect()
    local layout = Menu.DisplayMenuLayout
    local screenW, screenH = MenuGetScreenSize()
    local defaultScale = Menu.DefaultScaleMultiplier or 1.0
    local scale = (Menu.Scale or defaultScale) / math.max(0.01, defaultScale)
    scale = SDM_Clamp(scale, 0.84, 1.22)
    local width = math.min(math.floor(layout.width * scale), math.floor(screenW * 0.91))
    local sidebarW = math.floor(layout.sidebarWidth * scale)
    local padding = SDM_Scale(layout.padding, scale)
    local headerH = SDM_Scale(layout.headerHeight, scale)
    local footerH = SDM_Scale(layout.footerHeight, scale)
    local areaW = math.max(SDM_Scale(420, scale), width - sidebarW - (padding * 2))
    local opened = SDM_EnsureOpenedCategory and SDM_EnsureOpenedCategory() or nil
    local currentTab = opened and opened.tabs and opened.tabs[Menu.CurrentTab] or nil
    local contentDrivenHeight = headerH + footerH + (padding * 2) + SDM_MeasureTabContentHeight(currentTab, areaW, scale)
    local sidebarDrivenHeight = SDM_MeasureSidebarHeight(scale) + footerH + padding
    local targetHeight = math.max(SDM_Scale(layout.minHeight or layout.height, scale), contentDrivenHeight, sidebarDrivenHeight)
    local height = math.min(targetHeight, math.floor(screenH * (layout.maxHeightRatio or 0.88)))
    local x = math.floor((screenW - width) / 2)
    local y = math.floor((screenH - height) / 2)
    return x, y, width, height, scale
end

local function SDM_GetGlyph(category)
    if type(category.icon) == "string" and category.icon:match("^[%w]$") then
        return string.upper(category.icon)
    end
    local name = tostring(category.name or "?")
    local match = name:match("%a")
    return string.upper(match or string.sub(name, 1, 1))
end

local function SDM_GetMenuToggleLabel()
    if Menu.SelectedKeyName and Menu.SelectedKeyName ~= "" then
        return Menu.SelectedKeyName
    end
    return "Unassigned"
end

local function SDM_DrawCategoryIcon(category, x, y, size, selected, accentR, accentG, accentB)
    local lineR = selected and accentR or 214
    local lineG = selected and accentG or 218
    local lineB = selected and accentB or 228
    local bgR = selected and accentR or 34
    local bgG = selected and accentG or 36
    local bgB = selected and accentB or 46
    local radius = math.max(5, size * 0.28)

    SDM_DrawRect(x, y, size, size, bgR, bgG, bgB, selected and 0.22 or 0.12, radius)
    SDM_DrawOutline(x, y, size, size, 72, 74, 90, selected and 170 or 120, 1)

    local name = string.lower(tostring(category and category.name or ""))
    if not (Susano and Susano.DrawLine) then
        local glyph = SDM_GetGlyph(category)
        local glyphW = SDM_TextWidth(glyph, 12)
        SDM_DrawText(x + math.floor((size - glyphW) / 2), y + SDM_Scale(4, 1.0), glyph, 12, lineR, lineG, lineB, 1.0)
        return
    end

    local function L(x1, y1, x2, y2, thickness)
        SDM_DrawLineSafe(x1, y1, x2, y2, lineR, lineG, lineB, 1.0, thickness or 1.7)
    end

    local function C(cx, cy, r, filled, thickness)
        if not SDM_DrawCircleSafe(cx, cy, r, filled, lineR, lineG, lineB, 1.0, thickness or 1.6, 20) then
            SDM_DrawRect(cx - r, cy - r, r * 2, r * 2, lineR, lineG, lineB, 1.0, r)
        end
    end

    if name == "player" or name == "miguelin" then
        C(x + (size * 0.50), y + (size * 0.34), size * 0.16, false, 1.8)
        L(x + (size * 0.50), y + (size * 0.50), x + (size * 0.50), y + (size * 0.74), 1.8)
        L(x + (size * 0.34), y + (size * 0.59), x + (size * 0.66), y + (size * 0.59), 1.8)
        L(x + (size * 0.39), y + (size * 0.88), x + (size * 0.50), y + (size * 0.74), 1.8)
        L(x + (size * 0.61), y + (size * 0.88), x + (size * 0.50), y + (size * 0.74), 1.8)
    elseif name == "online" then
        C(x + (size * 0.38), y + (size * 0.36), size * 0.11, false, 1.7)
        C(x + (size * 0.62), y + (size * 0.36), size * 0.11, false, 1.7)
        C(x + (size * 0.50), y + (size * 0.58), size * 0.13, false, 1.7)
        L(x + (size * 0.28), y + (size * 0.70), x + (size * 0.72), y + (size * 0.70), 1.7)
    elseif name == "visual" then
        L(x + (size * 0.14), y + (size * 0.50), x + (size * 0.31), y + (size * 0.30), 1.7)
        L(x + (size * 0.31), y + (size * 0.30), x + (size * 0.69), y + (size * 0.30), 1.7)
        L(x + (size * 0.69), y + (size * 0.30), x + (size * 0.86), y + (size * 0.50), 1.7)
        L(x + (size * 0.86), y + (size * 0.50), x + (size * 0.69), y + (size * 0.70), 1.7)
        L(x + (size * 0.69), y + (size * 0.70), x + (size * 0.31), y + (size * 0.70), 1.7)
        L(x + (size * 0.31), y + (size * 0.70), x + (size * 0.14), y + (size * 0.50), 1.7)
        C(x + (size * 0.50), y + (size * 0.50), size * 0.10, true, 1.6)
    elseif name == "combat" then
        C(x + (size * 0.50), y + (size * 0.50), size * 0.13, false, 1.7)
        L(x + (size * 0.50), y + (size * 0.10), x + (size * 0.50), y + (size * 0.28), 1.7)
        L(x + (size * 0.50), y + (size * 0.72), x + (size * 0.50), y + (size * 0.90), 1.7)
        L(x + (size * 0.10), y + (size * 0.50), x + (size * 0.28), y + (size * 0.50), 1.7)
        L(x + (size * 0.72), y + (size * 0.50), x + (size * 0.90), y + (size * 0.50), 1.7)
    elseif name == "vehicle" then
        SDM_DrawRect(x + (size * 0.18), y + (size * 0.42), size * 0.64, size * 0.18, lineR, lineG, lineB, 0.10, 3)
        L(x + (size * 0.28), y + (size * 0.42), x + (size * 0.40), y + (size * 0.26), 1.7)
        L(x + (size * 0.40), y + (size * 0.26), x + (size * 0.66), y + (size * 0.26), 1.7)
        L(x + (size * 0.66), y + (size * 0.26), x + (size * 0.78), y + (size * 0.42), 1.7)
        C(x + (size * 0.33), y + (size * 0.66), size * 0.08, false, 1.7)
        C(x + (size * 0.67), y + (size * 0.66), size * 0.08, false, 1.7)
    elseif name == "settings" then
        C(x + (size * 0.50), y + (size * 0.50), size * 0.13, false, 1.7)
        C(x + (size * 0.50), y + (size * 0.50), size * 0.04, true, 1.5)
        L(x + (size * 0.50), y + (size * 0.10), x + (size * 0.50), y + (size * 0.24), 1.7)
        L(x + (size * 0.50), y + (size * 0.76), x + (size * 0.50), y + (size * 0.90), 1.7)
        L(x + (size * 0.10), y + (size * 0.50), x + (size * 0.24), y + (size * 0.50), 1.7)
        L(x + (size * 0.76), y + (size * 0.50), x + (size * 0.90), y + (size * 0.50), 1.7)
        L(x + (size * 0.22), y + (size * 0.22), x + (size * 0.31), y + (size * 0.31), 1.7)
        L(x + (size * 0.69), y + (size * 0.69), x + (size * 0.78), y + (size * 0.78), 1.7)
        L(x + (size * 0.22), y + (size * 0.78), x + (size * 0.31), y + (size * 0.69), 1.7)
        L(x + (size * 0.69), y + (size * 0.31), x + (size * 0.78), y + (size * 0.22), 1.7)
    elseif name == "miscellaneous" then
        L(x + (size * 0.18), y + (size * 0.28), x + (size * 0.82), y + (size * 0.28), 1.7)
        L(x + (size * 0.18), y + (size * 0.50), x + (size * 0.82), y + (size * 0.50), 1.7)
        L(x + (size * 0.18), y + (size * 0.72), x + (size * 0.82), y + (size * 0.72), 1.7)
        C(x + (size * 0.35), y + (size * 0.28), size * 0.06, true, 1.5)
        C(x + (size * 0.60), y + (size * 0.50), size * 0.06, true, 1.5)
        C(x + (size * 0.44), y + (size * 0.72), size * 0.06, true, 1.5)
    elseif name == "farmeo coca" then
        SDM_DrawOutline(x + (size * 0.22), y + (size * 0.24), size * 0.56, size * 0.56, lineR, lineG, lineB, 255, 1)
        L(x + (size * 0.22), y + (size * 0.24), x + (size * 0.78), y + (size * 0.80), 1.7)
        L(x + (size * 0.78), y + (size * 0.24), x + (size * 0.22), y + (size * 0.80), 1.7)
    else
        local glyph = SDM_GetGlyph(category)
        local glyphW = SDM_TextWidth(glyph, 12)
        SDM_DrawText(x + math.floor((size - glyphW) / 2), y + SDM_Scale(4, 1.0), glyph, 12, lineR, lineG, lineB, 1.0)
    end
end

local function SDM_FormatValue(value)
    if type(value) == "number" then
        local rounded = math.floor(value + 0.5)
        if math.abs(value - rounded) < 0.001 then
            return tostring(rounded)
        end
        return (string.format("%.2f", value):gsub("0+$", ""):gsub("%.$", ""))
    end
    return tostring(value or "")
end

local function SDM_DrawCheck(x, y, size, r, g, b, a)
    if Susano and Susano.DrawLine then
        SDM_DrawLineSafe(x + (size * 0.24), y + (size * 0.53), x + (size * 0.43), y + (size * 0.74), r, g, b, a or 1, 1.9)
        SDM_DrawLineSafe(x + (size * 0.43), y + (size * 0.74), x + (size * 0.78), y + (size * 0.28), r, g, b, a or 1, 1.9)
    else
        SDM_DrawText(x + (size * 0.18), y, "v", 11, r, g, b, a)
    end
end

local function SDM_DrawCheckbox(x, y, size, checked, accentR, accentG, accentB)
    local radius = math.max(4, size * 0.24)
    SDM_DrawRect(x, y, size, size, 33, 34, 44, 255, radius)
    SDM_DrawOutline(x, y, size, size, 70, 72, 88, 210, 1)
    if checked then
        SDM_DrawRect(x + 2, y + 2, size - 4, size - 4, accentR, accentG, accentB, 255, radius)
        SDM_DrawCheck(x, y, size, 245, 245, 248, 1.0)
    end
end

SDM_ItemHeight = function(item, scale)
    if item and (item.type == "slider" or (item.type == "toggle" and item.hasSlider)) then
        return SDM_Scale(44, scale)
    end
    return SDM_Scale(Menu.DisplayMenuLayout.itemHeight, scale)
end

SDM_BuildSections = function(tab)
    local sections = {}
    if not tab or not tab.items then
        return sections
    end

    local current = { title = tab.name or "Options", items = {} }
    local function push(force)
        if force or #current.items > 0 then
            sections[#sections + 1] = current
        end
    end

    for _, item in ipairs(tab.items) do
        if item and item.isSeparator then
            if #current.items > 0 then
                push(false)
            end
            current = { title = item.separatorText or tab.name or "Options", items = {} }
        elseif item then
            current.items[#current.items + 1] = item
        end
    end

    if #current.items > 0 or #sections == 0 then
        push(true)
    end

    return sections
end

SDM_EnsureOpenedCategory = function()
    if not Menu.Categories or #Menu.Categories <= 1 then
        return nil
    end

    local opened = Menu.OpenedCategory and Menu.Categories[Menu.OpenedCategory] or nil
    if opened and opened.hasTabs and opened.tabs and #opened.tabs > 0 then
        return opened
    end

    local fallback = nil
    if Menu.CurrentCategory and Menu.CurrentCategory > 1 then
        local current = Menu.Categories[Menu.CurrentCategory]
        if current and current.hasTabs and current.tabs and #current.tabs > 0 then
            fallback = Menu.CurrentCategory
        end
    end

    if not fallback then
        for index = 2, #Menu.Categories do
            local category = Menu.Categories[index]
            if category and category.hasTabs and category.tabs and #category.tabs > 0 then
                fallback = index
                break
            end
        end
    end

    if not fallback then
        return nil
    end

    Menu.OpenedCategory = fallback
    Menu.CurrentCategory = fallback
    Menu.CurrentTab = 1
    Menu.DisplayMenuItemScrollOffset = 0
    return Menu.Categories[fallback]
end

local function SDM_BuildMap(openedCategory, currentTab, panelX, panelY, panelW, panelH, scale)
    local layout = Menu.DisplayMenuLayout
    local padding = SDM_Scale(layout.padding, scale)
    local sidebarW = layout.sidebarWidth * scale
    local footerH = layout.footerHeight * scale
    local areaX = panelX + sidebarW + padding
    local areaY = panelY + (layout.headerHeight * scale) + padding
    local areaW = panelW - sidebarW - (padding * 2)
    local areaH = panelH - (layout.headerHeight * scale) - footerH - (padding * 2)
    local map = {
        panel = { x = panelX, y = panelY, w = panelW, h = panelH },
        contentArea = { x = areaX, y = areaY, w = areaW, h = areaH },
        searchRect = {
            x = panelX + padding,
            y = panelY + SDM_Scale(layout.brandHeight, scale) + SDM_Scale(10, scale),
            w = sidebarW - (padding * 2),
            h = SDM_Scale(layout.searchHeight, scale)
        },
        categoryButtons = {},
        tabButtons = {},
        sections = {},
        itemRows = {},
        totalItems = 0,
        scrollOffset = 0,
        scrollRange = 0
    }

    for displayIndex = 1, (#Menu.Categories - 1) do
        local categoryIndex = displayIndex + 1
        local category = Menu.Categories[categoryIndex]
        if category then
            local rowX = panelX + padding
            local rowY = panelY + (layout.brandHeight * scale) + (layout.searchHeight * scale) + math.floor(padding * 1.45) + ((displayIndex - 1) * (layout.categoryHeight * scale + layout.categoryGap * scale))
            map.categoryButtons[#map.categoryButtons + 1] = {
                categoryIndex = categoryIndex,
                category = category,
                x = rowX,
                y = rowY,
                w = sidebarW - (padding * 2),
                h = layout.categoryHeight * scale
            }
        end
    end

    local tabs = (openedCategory and openedCategory.tabs) or {}
    local tabGap = SDM_Scale(layout.tabGap, scale)
    local tabWidth = (areaW - (tabGap * math.max(0, #tabs - 1))) / math.max(1, #tabs)
    for index, tab in ipairs(tabs) do
        map.tabButtons[#map.tabButtons + 1] = {
            tabIndex = index,
            tab = tab,
            x = areaX + ((index - 1) * (tabWidth + tabGap)),
            y = panelY + SDM_Scale(12, scale),
            w = tabWidth,
            h = SDM_Scale(layout.tabHeight, scale)
        }
    end

    local itemIndices = {}
    for index, item in ipairs((currentTab and currentTab.items) or {}) do
        itemIndices[item] = index
    end

    local sections = SDM_BuildSections(currentTab)
    local columnCount = SDM_GetSectionColumnCount(sections, areaW, scale)
    local sectionGap = SDM_Scale(layout.sectionGap, scale)
    local sectionWidth = math.floor((areaW - (sectionGap * math.max(0, columnCount - 1))) / math.max(1, columnCount))
    local columnHeights = {}
    for col = 1, columnCount do columnHeights[col] = 0 end

    local placements = {}
    local rowGap = SDM_Scale(layout.rowGap, scale)
    for _, section in ipairs(sections) do
        local shortest = 1
        for col = 2, columnCount do
            if columnHeights[col] < columnHeights[shortest] then
                shortest = col
            end
        end

        local sectionHeight = SDM_Scale(layout.sectionHeaderHeight + (layout.sectionPaddingY * 2), scale)
        for index, item in ipairs(section.items or {}) do
            sectionHeight = sectionHeight + SDM_ItemHeight(item, scale)
            if index < #(section.items or {}) then
                sectionHeight = sectionHeight + rowGap
            end
        end

        placements[#placements + 1] = { col = shortest, top = columnHeights[shortest], height = sectionHeight, width = sectionWidth, section = section }
        columnHeights[shortest] = columnHeights[shortest] + sectionHeight + sectionGap
    end

    local contentHeight = 0
    for col = 1, columnCount do
        contentHeight = math.max(contentHeight, math.max(0, columnHeights[col] - sectionGap))
    end

    local scrollRange = math.max(0, contentHeight - areaH)
    local scrollOffset = SDM_Clamp(Menu.DisplayMenuItemScrollOffset or 0, 0, scrollRange)
    Menu.DisplayMenuItemScrollOffset = scrollOffset
    map.scrollOffset = scrollOffset
    map.scrollRange = scrollRange
    map.visualContentHeight = math.min(areaH, math.max(contentHeight + SDM_Scale(8, scale), SDM_Scale(210, scale)))

    local sectionPadX = SDM_Scale(layout.sectionPaddingX, scale)
    local sectionPadY = SDM_Scale(layout.sectionPaddingY, scale)
    local sectionHeaderH = SDM_Scale(layout.sectionHeaderHeight, scale)
    local checkboxSize = SDM_Scale(18, scale)
    local sliderHeight = math.max(4, SDM_Scale(layout.sliderHeight, scale))
    local controlWidth = SDM_Scale(layout.controlWidth, scale)

    for _, placement in ipairs(placements) do
        local sectionX = areaX + ((placement.col - 1) * (sectionWidth + sectionGap))
        local sectionY = areaY + placement.top - scrollOffset
        local sectionEntry = {
            title = placement.section.title or "Options",
            x = sectionX,
            y = sectionY,
            w = placement.width,
            h = placement.height,
            rows = {},
            visible = not (sectionY + placement.height < areaY or sectionY > (areaY + areaH))
        }

        local rowY = sectionY + sectionPadY + sectionHeaderH
        for _, item in ipairs(placement.section.items or {}) do
            local rowHeight = SDM_ItemHeight(item, scale)
            local rowRect = { x = sectionX + sectionPadX, y = rowY, w = placement.width - (sectionPadX * 2), h = rowHeight }
            local rowEntry = {
                item = item,
                itemIndex = itemIndices[item] or 1,
                displayOrder = map.totalItems + 1,
                rowRect = rowRect,
                visible = not (rowRect.y + rowRect.h < areaY or rowRect.y > (areaY + areaH))
            }

            local rightX = rowRect.x + rowRect.w
            local midY = rowRect.y + math.floor(rowRect.h / 2)

            if item.type == "toggle" then
                rowEntry.toggleRect = { x = rightX - checkboxSize, y = midY - math.floor(checkboxSize / 2), w = checkboxSize, h = checkboxSize }
                if item.hasSlider then
                    local valueW = SDM_TextWidth(SDM_FormatValue(item.sliderValue or item.sliderMin or 0), 12)
                    local sliderW = math.min(controlWidth, rowRect.w - SDM_Scale(170, scale))
                    local sliderX = rightX - checkboxSize - SDM_Scale(14, scale) - sliderW - valueW - SDM_Scale(10, scale)
                    rowEntry.sliderRect = { x = sliderX, y = rowRect.y + rowRect.h - sliderHeight - SDM_Scale(8, scale), w = sliderW, h = sliderHeight }
                    rowEntry.valueRect = { x = sliderX + sliderW + SDM_Scale(10, scale), y = rowEntry.sliderRect.y - SDM_Scale(9, scale), w = valueW, h = SDM_Scale(20, scale) }
                end
            elseif item.type == "slider" then
                local valueW = SDM_TextWidth(SDM_FormatValue(item.value or item.min or 0), 12)
                local sliderW = math.min(controlWidth + SDM_Scale(20, scale), rowRect.w - SDM_Scale(150, scale))
                local sliderX = rightX - sliderW - valueW - SDM_Scale(10, scale)
                rowEntry.sliderRect = { x = sliderX, y = rowRect.y + rowRect.h - sliderHeight - SDM_Scale(8, scale), w = sliderW, h = sliderHeight }
                rowEntry.valueRect = { x = sliderX + sliderW + SDM_Scale(10, scale), y = rowEntry.sliderRect.y - SDM_Scale(9, scale), w = valueW, h = SDM_Scale(20, scale) }
            elseif item.type == "selector" or item.type == "toggle_selector" then
                local optionText = ((item.options or {})[item.selected or 1]) or tostring(item.selected or 1)
                local selectorW = math.min(SDM_Scale(200, scale), math.max(SDM_Scale(112, scale), SDM_TextWidth("  < " .. tostring(optionText) .. " >  ", 12) + SDM_Scale(14, scale)))
                local selectorRight = rightX
                if item.type == "toggle_selector" then
                    rowEntry.toggleRect = { x = rightX - checkboxSize, y = midY - math.floor(checkboxSize / 2), w = checkboxSize, h = checkboxSize }
                    selectorRight = rowEntry.toggleRect.x - SDM_Scale(12, scale)
                end
                rowEntry.selectorRect = { x = selectorRight - selectorW, y = midY - math.floor(SDM_Scale(26, scale) / 2), w = selectorW, h = SDM_Scale(26, scale) }
            elseif item.type == "action" then
                local buttonW = SDM_TextWidth("Run", 12) + SDM_Scale(24, scale)
                rowEntry.buttonRect = { x = rightX - buttonW, y = midY - math.floor(SDM_Scale(24, scale) / 2), w = buttonW, h = SDM_Scale(24, scale) }
            end

            sectionEntry.rows[#sectionEntry.rows + 1] = rowEntry
            map.itemRows[#map.itemRows + 1] = rowEntry
            map.totalItems = map.totalItems + 1
            rowY = rowY + rowHeight + rowGap
        end

        map.sections[#map.sections + 1] = sectionEntry
    end

    if scrollRange > 0 then
        local trackW = SDM_Scale(4, scale)
        local thumbH = math.max(SDM_Scale(42, scale), areaH * (areaH / math.max(areaH, contentHeight)))
        local percent = scrollRange > 0 and (scrollOffset / scrollRange) or 0
        map.scrollbarTrack = { x = areaX + areaW - trackW, y = areaY, w = trackW, h = areaH }
        map.scrollbarThumb = { x = map.scrollbarTrack.x, y = areaY + ((areaH - thumbH) * percent), w = trackW, h = thumbH }
    end

    return map
end

Menu.DrawDisplayMenu = function()
    if not Menu.Categories then return end
    if not (Susano and (Susano.DrawRectFilled or Susano.DrawFilledRect)) then return end
    SetInteractiveOverlayState(true)

    local panelX, panelY, panelW, panelH, scale = SDM_GetRect()
    local opened = SDM_EnsureOpenedCategory()
    local currentTab = opened and opened.tabs and opened.tabs[Menu.CurrentTab] or nil
    if not opened or not currentTab then
        return
    end

    local layout = Menu.DisplayMenuLayout
    local accentR, accentG, accentB = SDM_GetAccent()
    local sidebarW = layout.sidebarWidth * scale
    local radius = SDM_Scale(layout.sectionRadius, scale)
    local footerH = SDM_Scale(layout.footerHeight, scale)
    local screenW, screenH = MenuGetScreenSize()
    local map = SDM_BuildMap(opened, currentTab, panelX, panelY, panelW, panelH, scale)
    Menu.DisplayMenuCurrentMap = map

    SDM_DrawRect(0, 0, screenW, screenH, 0, 0, 0, 96)
    SDM_DrawRect(panelX + SDM_Scale(8, scale), panelY + SDM_Scale(12, scale), panelW, panelH, 0, 0, 0, 72, radius + SDM_Scale(5, scale))
    SDM_DrawRect(panelX, panelY, panelW, panelH, 19, 20, 26, 252, radius)
    SDM_DrawOutline(panelX, panelY, panelW, panelH, 48, 50, 62, 210, 1)
    SDM_DrawRect(panelX, panelY, sidebarW, panelH, 23, 24, 31, 255, radius)
    SDM_DrawRect(panelX + sidebarW - SDM_Scale(1, scale), panelY + SDM_Scale(10, scale), SDM_Scale(1, scale), panelH - SDM_Scale(20, scale), 42, 43, 54, 210)
    SDM_DrawRect(panelX + sidebarW, panelY, panelW - sidebarW, SDM_Scale(layout.headerHeight, scale), 21, 22, 29, 255, radius)
    SDM_DrawRect(panelX, panelY + panelH - footerH, panelW, footerH, 16, 17, 23, 255, radius)
    SDM_DrawRect(panelX + sidebarW, panelY + SDM_Scale(layout.headerHeight, scale) - SDM_Scale(1, scale), panelW - sidebarW, SDM_Scale(1, scale), 40, 42, 54, 220)

    local badgeSize = SDM_Scale(18, scale)
    local badgeX = panelX + SDM_Scale(layout.padding, scale)
    local badgeY = panelY + SDM_Scale(18, scale)
    SDM_DrawRect(badgeX, badgeY, badgeSize, badgeSize, accentR, accentG, accentB, 255, math.max(4, badgeSize * 0.34))
    SDM_DrawRect(badgeX + SDM_Scale(4, scale), badgeY + SDM_Scale(4, scale), badgeSize - SDM_Scale(8, scale), badgeSize - SDM_Scale(8, scale), 18, 19, 24, 255, math.max(3, badgeSize * 0.24))
    SDM_DrawText(badgeX + badgeSize + SDM_Scale(10, scale), badgeY - SDM_Scale(2, scale), "arcane", 24, 245, 245, 248, 1.0)
    SDM_DrawText(badgeX + badgeSize + SDM_Scale(10, scale), badgeY + SDM_Scale(20, scale), "display menu", 11, 135, 140, 154, 1.0)

    SDM_DrawRect(map.searchRect.x, map.searchRect.y, map.searchRect.w, map.searchRect.h, 30, 31, 38, 255, SDM_Scale(9, scale))
    SDM_DrawOutline(map.searchRect.x, map.searchRect.y, map.searchRect.w, map.searchRect.h, 49, 51, 64, 210, 1)
    SDM_DrawText(map.searchRect.x + SDM_Scale(12, scale), map.searchRect.y + SDM_Scale(11, scale), "Search", 12, 110, 114, 127, 1.0)

    for _, button in ipairs(map.categoryButtons) do
        local isSelected = Menu.OpenedCategory == button.categoryIndex
        local isHover = Menu.DisplayMenuHoverCategory == button.categoryIndex
        if isSelected then
            SDM_DrawRect(button.x, button.y, button.w, button.h, 31, 32, 40, 255, SDM_Scale(9, scale))
            SDM_DrawGradientBar(button.x, button.y, SDM_Scale(3, scale), button.h, accentR, accentG, accentB, 255, SDM_Scale(2, scale))
        elseif isHover then
            SDM_DrawRect(button.x, button.y, button.w, button.h, 255, 255, 255, 10, SDM_Scale(9, scale))
        end

        local iconSize = SDM_Scale(24, scale)
        local iconX = button.x + SDM_Scale(12, scale)
        local iconY = button.y + math.floor((button.h - iconSize) / 2)
        SDM_DrawCategoryIcon(button.category, iconX, iconY, iconSize, isSelected, accentR, accentG, accentB)
        SDM_DrawText(iconX + iconSize + SDM_Scale(12, scale), button.y + SDM_Scale(13, scale), button.category.name or "", 14, isSelected and 245 or 176, isSelected and 245 or 180, isSelected and 248 or 191, 1.0)
    end

    local headerLabel = string.format("%s / %s", tostring(opened.name or "Category"), tostring(currentTab.name or "Tab"))
    local headerInfo = string.format("%s  |  Menu Key", SDM_GetMenuToggleLabel())
    local headerInfoW = SDM_TextWidth(headerInfo, 11)
    SDM_DrawText(panelX + sidebarW + SDM_Scale(layout.padding, scale), panelY + SDM_Scale(15, scale), headerLabel, 16, 242, 242, 246, 1.0)
    SDM_DrawText(panelX + panelW - headerInfoW - SDM_Scale(layout.padding, scale), panelY + SDM_Scale(18, scale), headerInfo, 11, 134, 138, 150, 1.0)
    SDM_DrawRect(map.contentArea.x, map.contentArea.y, map.contentArea.w, map.visualContentHeight or map.contentArea.h, 17, 18, 24, 110, SDM_Scale(12, scale))

    for _, tabButton in ipairs(map.tabButtons) do
        local isActive = tabButton.tabIndex == Menu.CurrentTab
        local isHover = Menu.DisplayMenuHoverTab == tabButton.tabIndex
        if isActive then
            SDM_DrawRect(tabButton.x, tabButton.y + SDM_Scale(6, scale), tabButton.w, tabButton.h - SDM_Scale(6, scale), 28, 29, 37, 255, SDM_Scale(9, scale))
            SDM_DrawGradientBar(tabButton.x, tabButton.y + tabButton.h - SDM_Scale(3, scale), tabButton.w, SDM_Scale(3, scale), accentR, accentG, accentB, 255, SDM_Scale(2, scale))
        elseif isHover then
            SDM_DrawRect(tabButton.x, tabButton.y + SDM_Scale(8, scale), tabButton.w, tabButton.h - SDM_Scale(8, scale), 255, 255, 255, 8, SDM_Scale(9, scale))
        end

        local label = tabButton.tab.name or ""
        local labelW = SDM_TextWidth(label, 13)
        SDM_DrawText(tabButton.x + math.floor((tabButton.w - labelW) / 2), tabButton.y + SDM_Scale(11, scale), label, 13, isActive and accentR or 177, isActive and accentG or 181, isActive and accentB or 192, 1.0)
    end

    for _, section in ipairs(map.sections) do
        if section.visible then
            SDM_DrawRect(section.x, section.y, section.w, section.h, 24, 25, 32, 255, radius)
            SDM_DrawOutline(section.x, section.y, section.w, section.h, 40, 42, 52, 210, 1)
            SDM_DrawGradientBar(section.x, section.y, SDM_Scale(3, scale), section.h, accentR, accentG, accentB, 255, SDM_Scale(2, scale))
            SDM_DrawText(section.x + SDM_Scale(layout.sectionPaddingX, scale), section.y + SDM_Scale(layout.sectionPaddingY, scale), section.title, 12, 137, 141, 155, 1.0)

            for _, row in ipairs(section.rows) do
                if row.visible then
                    local item = row.item
                    local rect = row.rowRect
                    local hover = Menu.DisplayMenuHoverItem == row.itemIndex
                    local selected = Menu.CurrentItem == row.itemIndex
                    if hover or selected then
                        SDM_DrawRect(rect.x, rect.y, rect.w, rect.h, 255, 255, 255, hover and 7 or 5, SDM_Scale(8, scale))
                    end

                    local labelY = rect.y + SDM_Scale((item.type == "slider" or (item.type == "toggle" and item.hasSlider)) and 4 or 8, scale)
                    SDM_DrawText(rect.x, labelY, item.name or "", 13, 229, 229, 233, 1.0)
                    if item.bindKeyName then
                        SDM_DrawText(rect.x + SDM_TextWidth(item.name or "", 13) + SDM_Scale(8, scale), labelY + SDM_Scale(1, scale), "[" .. tostring(item.bindKeyName) .. "]", 10, 118, 122, 135, 1.0)
                    end

                    if item.type == "toggle" then
                        if row.toggleRect then
                            SDM_DrawCheckbox(row.toggleRect.x, row.toggleRect.y, row.toggleRect.w, item.value == true, accentR, accentG, accentB)
                        end
                        if item.hasSlider and row.sliderRect then
                            local minV = item.sliderMin or 0.0
                            local maxV = item.sliderMax or 100.0
                            local curV = item.sliderValue or minV
                            local pct = maxV > minV and SDM_Clamp((curV - minV) / (maxV - minV), 0, 1) or 0
                            SDM_DrawRect(row.sliderRect.x, row.sliderRect.y, row.sliderRect.w, row.sliderRect.h, 60, 62, 76, 215, math.max(2, row.sliderRect.h / 2))
                            SDM_DrawGradientBar(row.sliderRect.x, row.sliderRect.y, row.sliderRect.w * pct, row.sliderRect.h, accentR, accentG, accentB, 255, math.max(2, row.sliderRect.h / 2))
                            SDM_DrawRect(row.sliderRect.x + (row.sliderRect.w * pct) - SDM_Scale(4, scale), row.sliderRect.y - SDM_Scale(3, scale), SDM_Scale(8, scale), SDM_Scale(8, scale), 245, 245, 248, 255, SDM_Scale(4, scale))
                            if row.valueRect then
                                SDM_DrawText(row.valueRect.x, row.valueRect.y, SDM_FormatValue(curV), 12, 167, 171, 182, 1.0)
                            end
                        end
                    elseif item.type == "slider" and row.sliderRect then
                        local minV = item.min or 0.0
                        local maxV = item.max or 100.0
                        local curV = item.value or minV
                        local pct = maxV > minV and SDM_Clamp((curV - minV) / (maxV - minV), 0, 1) or 0
                        SDM_DrawRect(row.sliderRect.x, row.sliderRect.y, row.sliderRect.w, row.sliderRect.h, 60, 62, 76, 215, math.max(2, row.sliderRect.h / 2))
                        SDM_DrawGradientBar(row.sliderRect.x, row.sliderRect.y, row.sliderRect.w * pct, row.sliderRect.h, accentR, accentG, accentB, 255, math.max(2, row.sliderRect.h / 2))
                        SDM_DrawRect(row.sliderRect.x + (row.sliderRect.w * pct) - SDM_Scale(4, scale), row.sliderRect.y - SDM_Scale(3, scale), SDM_Scale(8, scale), SDM_Scale(8, scale), 245, 245, 248, 255, SDM_Scale(4, scale))
                        if row.valueRect then
                            SDM_DrawText(row.valueRect.x, row.valueRect.y, SDM_FormatValue(curV), 12, 167, 171, 182, 1.0)
                        end
                    elseif (item.type == "selector" or item.type == "toggle_selector") and row.selectorRect then
                        local optionText = ((item.options or {})[item.selected or 1]) or tostring(item.selected or 1)
                        SDM_DrawRect(row.selectorRect.x, row.selectorRect.y, row.selectorRect.w, row.selectorRect.h, 31, 32, 40, 255, SDM_Scale(8, scale))
                        SDM_DrawOutline(row.selectorRect.x, row.selectorRect.y, row.selectorRect.w, row.selectorRect.h, 63, 65, 80, 220, 1)
                        SDM_DrawText(row.selectorRect.x + SDM_Scale(8, scale), row.selectorRect.y + SDM_Scale(6, scale), "< " .. tostring(optionText) .. " >", 12, accentR, accentG, accentB, 1.0)
                        if row.toggleRect then
                            SDM_DrawCheckbox(row.toggleRect.x, row.toggleRect.y, row.toggleRect.w, item.value == true, accentR, accentG, accentB)
                        end
                    elseif item.type == "action" and row.buttonRect then
                        SDM_DrawRect(row.buttonRect.x, row.buttonRect.y, row.buttonRect.w, row.buttonRect.h, accentR, accentG, accentB, 220, SDM_Scale(8, scale))
                        SDM_DrawText(row.buttonRect.x + math.floor((row.buttonRect.w - SDM_TextWidth("Run", 12)) / 2), row.buttonRect.y + SDM_Scale(6, scale), "Run", 12, 19, 19, 24, 1.0)
                    end
                end
            end
        end
    end

    if map.scrollbarTrack and map.scrollbarThumb then
        SDM_DrawRect(map.scrollbarTrack.x, map.scrollbarTrack.y, map.scrollbarTrack.w, map.scrollbarTrack.h, 44, 46, 58, 150, SDM_Scale(2, scale))
        SDM_DrawGradientBar(map.scrollbarThumb.x, map.scrollbarThumb.y, map.scrollbarThumb.w, map.scrollbarThumb.h, accentR, accentG, accentB, 255, SDM_Scale(2, scale))
    end

    local footerY = panelY + panelH - footerH
    local footerText = "discord.gg/arcaneservices"
    local footerInfo = string.format("%d options  |  right click = close", map.totalItems)
    local selectedDisplayIndex = 1
    for _, row in ipairs(map.itemRows or {}) do
        if row.itemIndex == Menu.CurrentItem then
            selectedDisplayIndex = row.displayOrder or selectedDisplayIndex
            break
        end
    end
    local footerRight = string.format("%d / %d", math.max(1, selectedDisplayIndex), math.max(1, map.totalItems))
    local footerRightW = SDM_TextWidth(footerRight, 11)
    local footerInfoW = SDM_TextWidth(footerInfo, 11)
    SDM_DrawText(panelX + SDM_Scale(14, scale), footerY + SDM_Scale(7, scale), footerText, 11, 130, 135, 147, 1.0)
    SDM_DrawText(panelX + panelW - footerRightW - SDM_Scale(14, scale), footerY + SDM_Scale(7, scale), footerRight, 11, 130, 135, 147, 1.0)
    SDM_DrawText(panelX + math.floor((panelW - footerInfoW) / 2), footerY + SDM_Scale(7, scale), footerInfo, 11, 103, 108, 120, 1.0)
end

Menu.HandleDisplayMenuInput = function()
    if not Menu.Visible or not Menu.DisplayMenu then
        Menu.DisplayMenuHoverCategory = nil
        Menu.DisplayMenuHoverTab = nil
        Menu.DisplayMenuHoverItem = nil
        Menu.DisplayMenuActiveSlider = nil
        Menu.DisplayMenuCurrentMap = nil
        Menu.DisplayMenuLeftWasDown = false
        Menu.DisplayMenuRightWasDown = false
        return
    end

    SetInteractiveOverlayState(true)

    local mouseX, mouseY, leftDown, leftPressed, rightDown, rightPressed = GetOverlayMouseState()
    if not mouseX then
        return
    end

    local leftClicked = leftPressed or (leftDown and not Menu.DisplayMenuLeftWasDown)
    local rightClicked = rightPressed or (rightDown and not Menu.DisplayMenuRightWasDown)
    if not leftDown then
        Menu.DisplayMenuActiveSlider = nil
    end

    local panelX, panelY, panelW, panelH, scale = SDM_GetRect()
    local opened = SDM_EnsureOpenedCategory()
    local currentTab = opened and opened.tabs and opened.tabs[Menu.CurrentTab] or nil
    if not opened or not currentTab then
        return
    end

    local map = Menu.DisplayMenuCurrentMap
    if not map or not map.panel then
        map = SDM_BuildMap(opened, currentTab, panelX, panelY, panelW, panelH, scale)
        Menu.DisplayMenuCurrentMap = map
    end

    Menu.DisplayMenuHoverCategory = nil
    Menu.DisplayMenuHoverTab = nil
    Menu.DisplayMenuHoverItem = nil

    local insidePanel = IsPointInRect(mouseX, mouseY, map.panel.x, map.panel.y, map.panel.w, map.panel.h)
    if rightClicked and insidePanel then
        Menu.Visible = false
        Menu.DisplayMenuCurrentMap = nil
        Menu.DisplayMenuLeftWasDown = leftDown
        Menu.DisplayMenuRightWasDown = rightDown
        return
    end

    for _, button in ipairs(map.categoryButtons or {}) do
        if IsPointInRect(mouseX, mouseY, button.x, button.y, button.w, button.h) then
            Menu.DisplayMenuHoverCategory = button.categoryIndex
            Menu.CurrentCategory = button.categoryIndex
            if leftClicked and button.category and button.category.hasTabs and button.category.tabs then
                Menu.OpenedCategory = button.categoryIndex
                Menu.CurrentTab = 1
                Menu.DisplayMenuItemScrollOffset = 0
                if button.category.tabs[1] and button.category.tabs[1].items then
                    Menu.CurrentItem = findNextNonSeparator(button.category.tabs[1].items, 0, 1)
                else
                    Menu.CurrentItem = 1
                end
                Menu.DisplayMenuCurrentMap = nil
            end
            break
        end
    end

    for _, tabButton in ipairs(map.tabButtons or {}) do
        if IsPointInRect(mouseX, mouseY, tabButton.x, tabButton.y, tabButton.w, tabButton.h) then
            Menu.DisplayMenuHoverTab = tabButton.tabIndex
            if leftClicked then
                Menu.CurrentTab = tabButton.tabIndex
                Menu.DisplayMenuItemScrollOffset = 0
                if opened.tabs[Menu.CurrentTab] and opened.tabs[Menu.CurrentTab].items then
                    Menu.CurrentItem = findNextNonSeparator(opened.tabs[Menu.CurrentTab].items, 0, 1)
                else
                    Menu.CurrentItem = 1
                end
                Menu.DisplayMenuCurrentMap = nil
            end
            break
        end
    end

    local contentArea = map.contentArea
    if contentArea and IsPointInRect(mouseX, mouseY, contentArea.x, contentArea.y, contentArea.w, contentArea.h) and Susano and Susano.GetAsyncKeyState then
        local _, upPressed = Susano.GetAsyncKeyState(0x26)
        local _, downPressed = Susano.GetAsyncKeyState(0x28)
        if upPressed == true then
            Menu.DisplayMenuItemScrollOffset = SDM_Clamp((Menu.DisplayMenuItemScrollOffset or 0) - SDM_Scale(Menu.DisplayMenuLayout.scrollStep, scale), 0, map.scrollRange or 0)
            Menu.DisplayMenuCurrentMap = nil
        end
        if downPressed == true then
            Menu.DisplayMenuItemScrollOffset = SDM_Clamp((Menu.DisplayMenuItemScrollOffset or 0) + SDM_Scale(Menu.DisplayMenuLayout.scrollStep, scale), 0, map.scrollRange or 0)
            Menu.DisplayMenuCurrentMap = nil
        end
    end

    if map.scrollbarTrack and leftClicked and IsPointInRect(mouseX, mouseY, map.scrollbarTrack.x - SDM_Scale(6, scale), map.scrollbarTrack.y, map.scrollbarTrack.w + SDM_Scale(12, scale), map.scrollbarTrack.h) then
        local percent = (mouseY - map.scrollbarTrack.y) / map.scrollbarTrack.h
        Menu.DisplayMenuItemScrollOffset = SDM_Clamp((map.scrollRange or 0) * percent, 0, map.scrollRange or 0)
        Menu.DisplayMenuCurrentMap = nil
    end

    for _, row in ipairs(map.itemRows or {}) do
        local rect = row.rowRect
        if row.visible and IsPointInRect(mouseX, mouseY, rect.x, rect.y, rect.w, rect.h) then
            local item = row.item
            local handled = false
            Menu.DisplayMenuHoverItem = row.itemIndex
            Menu.CurrentItem = row.itemIndex

            if row.sliderRect and IsPointInRect(mouseX, mouseY, row.sliderRect.x, row.sliderRect.y - SDM_Scale(8, scale), row.sliderRect.w, row.sliderRect.h + SDM_Scale(16, scale)) then
                if leftDown or leftClicked then
                    SetSliderItemFromPercent(item, (mouseX - row.sliderRect.x) / row.sliderRect.w, item.type == "toggle" and item.hasSlider)
                    Menu.DisplayMenuActiveSlider = { item = item, kind = (item.type == "toggle" and item.hasSlider) and "toggle_slider" or "slider", sliderX = row.sliderRect.x, sliderWidth = row.sliderRect.w }
                end
                handled = true
            elseif row.selectorRect and IsPointInRect(mouseX, mouseY, row.selectorRect.x, row.selectorRect.y, row.selectorRect.w, row.selectorRect.h) then
                if leftClicked then
                    AdjustSelectorItem(item, mouseX <= (row.selectorRect.x + (row.selectorRect.w / 2)) and -1 or 1, true)
                end
                handled = true
            elseif row.toggleRect and IsPointInRect(mouseX, mouseY, row.toggleRect.x, row.toggleRect.y, row.toggleRect.w, row.toggleRect.h) then
                if leftClicked then
                    TriggerPrimaryItemAction(item)
                end
                handled = true
            elseif row.buttonRect and IsPointInRect(mouseX, mouseY, row.buttonRect.x, row.buttonRect.y, row.buttonRect.w, row.buttonRect.h) then
                if leftClicked then
                    TriggerPrimaryItemAction(item)
                end
                handled = true
            end

            if leftClicked and not handled and (item.type == "toggle" or item.type == "toggle_selector" or item.type == "action") then
                TriggerPrimaryItemAction(item)
            end
            break
        end
    end

    if leftDown and Menu.DisplayMenuActiveSlider and Menu.DisplayMenuActiveSlider.item then
        local slider = Menu.DisplayMenuActiveSlider
        SetSliderItemFromPercent(slider.item, (mouseX - slider.sliderX) / slider.sliderWidth, slider.kind == "toggle_slider")
    end

    Menu.DisplayMenuLeftWasDown = leftDown
    Menu.DisplayMenuRightWasDown = rightDown
end

function Menu.Render()
    if Menu.TopLevelTabs and not Menu.Categories then
        Menu.UpdateCategoriesFromTopTab()
    end

    if not (Susano and Susano.BeginFrame) then
        return
    end

    local dt = 0.016
    if GetFrameTime then
        dt = GetFrameTime()
    end
    local animSpeed = 5.0 * dt

    if Menu.IsLoading then
        Menu.LoadingBarAlpha = math.min(1.0, Menu.LoadingBarAlpha + animSpeed)
    else
        Menu.LoadingBarAlpha = math.max(0.0, Menu.LoadingBarAlpha - animSpeed)
    end

    if Menu.SelectingKey or Menu.SelectingBind then
        Menu.KeySelectorAlpha = math.min(1.0, Menu.KeySelectorAlpha + animSpeed)
    else
        Menu.KeySelectorAlpha = math.max(0.0, Menu.KeySelectorAlpha - animSpeed)
    end

    if Menu.ShowKeybinds then
        Menu.KeybindsInterfaceAlpha = math.min(1.0, Menu.KeybindsInterfaceAlpha + animSpeed)
    else
        Menu.KeybindsInterfaceAlpha = math.max(0.0, Menu.KeybindsInterfaceAlpha - animSpeed)
    end

    if Menu.ShowSpectatorList then
        Menu.SpectatorListAlpha = math.min(1.0, Menu.SpectatorListAlpha + animSpeed)
    else
        Menu.SpectatorListAlpha = math.max(0.0, Menu.SpectatorListAlpha - animSpeed)
    end

    SetInteractiveOverlayState(IsInteractiveOverlayActive())

    Susano.BeginFrame()

    local overlayStackY = 20
    if Menu.KeybindsInterfaceAlpha > 0 then
        local _, keybindHeight = Menu.DrawKeybindsInterface(Menu.KeybindsInterfaceAlpha, overlayStackY)
        overlayStackY = overlayStackY + keybindHeight + 10
    end

    if Menu.SpectatorListAlpha > 0 then
        Menu.DrawSpectatorList(Menu.SpectatorListAlpha, overlayStackY)
    end

    Menu.BlockGameplayInput()
    local drawDisplayMenuLate = false

    if Menu.Visible then
        if Menu.DisplayMenu then
            drawDisplayMenuLate = true
        else
            Menu.DrawBackground()
            Menu.DrawHeader()
            Menu.DrawCategories()
            Menu.DrawFooter()
        end
    end

    if Menu.InputOpen then
        Menu.DrawInputWindow()
    end

    if Menu.LoadingBarAlpha > 0 then
        Menu.DrawLoadingBar(Menu.LoadingBarAlpha)
    end

    if Menu.KeySelectorAlpha > 0 then
        Menu.DrawKeySelector(Menu.KeySelectorAlpha)
    end

    if Menu.OnRender then
        local success, err = pcall(Menu.OnRender)
        if not success then
        end
    end

    if drawDisplayMenuLate then
        Menu.DrawDisplayMenu()
    end

    if Menu.HasNotifications() then
        Menu.DrawNotifications()
    end

    DrawClickableCursor()

    if Susano.SubmitFrame then
        Susano.SubmitFrame()
    end

    if not Menu.Visible and not Menu.ShowKeybinds and not Menu.ShowSpectatorList and Menu.LoadingBarAlpha <= 0 and Menu.KeySelectorAlpha <= 0 and Menu.SpectatorListAlpha <= 0 and not Menu.HasNotifications() then
        if Susano.ResetFrame then
            Susano.ResetFrame()
        end
    end
end

Menu.KeyStates = {}

function Menu.IsKeyJustPressed(keyCode)
    if not (Susano and Susano.GetAsyncKeyState) then
        return false
    end

    local down, pressed = Menu.GetKeyState(keyCode)
    local wasDown = Menu.KeyStates[keyCode] or false

    if down == true then
        Menu.KeyStates[keyCode] = true
    else
        Menu.KeyStates[keyCode] = false
    end

    if pressed == true then
        return true
    end

    if down == true and not wasDown then
        return true
    end

    return false
end


Menu.KeyNames = {
    [0x08] = "Backspace", [0x09] = "Tab", [0x0D] = "Enter", [0x10] = "Shift",
    [0x11] = "Ctrl", [0x12] = "Alt", [0x13] = "Pause", [0x14] = "Caps Lock",
    [0x1B] = "ESC", [0x20] = "Space", [0x21] = "Page Up", [0x22] = "Page Down",
    [0x23] = "End", [0x24] = "Home", [0x25] = "Left", [0x26] = "Up",
    [0x27] = "Right", [0x28] = "Down", [0x2D] = "Insert", [0x2E] = "Delete",
    [0x30] = "0", [0x31] = "1", [0x32] = "2", [0x33] = "3", [0x34] = "4",
    [0x35] = "5", [0x36] = "6", [0x37] = "7", [0x38] = "8", [0x39] = "9",
    [0x41] = "A", [0x42] = "B", [0x43] = "C", [0x44] = "D", [0x45] = "E",
    [0x46] = "F", [0x47] = "G", [0x48] = "H", [0x49] = "I", [0x4A] = "J",
    [0x4B] = "K", [0x4C] = "L", [0x4D] = "M", [0x4E] = "N", [0x4F] = "O",
    [0x50] = "P", [0x51] = "Q", [0x52] = "R", [0x53] = "S", [0x54] = "T",
    [0x55] = "U", [0x56] = "V", [0x57] = "W", [0x58] = "X", [0x59] = "Y",
    [0x5A] = "Z", [0x60] = "Numpad 0", [0x61] = "Numpad 1", [0x62] = "Numpad 2",
    [0x63] = "Numpad 3", [0x64] = "Numpad 4", [0x65] = "Numpad 5", [0x66] = "Numpad 6",
    [0x67] = "Numpad 7", [0x68] = "Numpad 8", [0x69] = "Numpad 9",
    [0x6A] = "Multiply", [0x6B] = "Add", [0x6D] = "Subtract", [0x6E] = "Decimal",
    [0x6F] = "Divide", [0x70] = "F1", [0x71] = "F2", [0x72] = "F3", [0x73] = "F4",
    [0x74] = "F5", [0x75] = "F6", [0x76] = "F7", [0x77] = "F8", [0x78] = "F9",
    [0x79] = "F10", [0x7A] = "F11", [0x7B] = "F12",
    [0x90] = "Num Lock", [0x91] = "Scroll Lock",
    [0xA0] = "Left Shift", [0xA1] = "Right Shift", [0xA2] = "Left Ctrl",
    [0xA3] = "Right Ctrl", [0xA4] = "Left Alt", [0xA5] = "Right Alt"
}

Menu.LinkedKeyGroups = {
    [0x10] = {0x10, 0xA0, 0xA1},
    [0x11] = {0x11, 0xA2, 0xA3},
    [0x12] = {0x12, 0xA4, 0xA5}
}

Menu.BindableKeys = {
    0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49, 0x4A, 0x4B, 0x4C, 0x4D,
    0x4E, 0x4F, 0x50, 0x51, 0x52, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58, 0x59, 0x5A,
    0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39,
    0x20, 0x1B, 0x08, 0x09, 0x10, 0x11, 0x12,
    0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x2D, 0x2E,
    0x70, 0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79, 0x7A, 0x7B
}

function Menu.GetKeyName(keyCode)
    return Menu.KeyNames[keyCode] or ("Key 0x" .. string.format("%02X", keyCode))
end

function Menu.GetKeyState(keyCode)
    if not (Susano and Susano.GetAsyncKeyState) then
        return false, false
    end

    local linkedKeys = Menu.LinkedKeyGroups[keyCode]
    if linkedKeys then
        local isDown = false
        local isPressed = false

        for _, linkedKeyCode in ipairs(linkedKeys) do
            local down, pressed = Susano.GetAsyncKeyState(linkedKeyCode)
            if down == true then
                isDown = true
            end
            if pressed == true then
                isPressed = true
            end
        end

        return isDown, isPressed
    end

    local down, pressed = Susano.GetAsyncKeyState(keyCode)
    return down == true, pressed == true
end

function Menu.CaptureBindableKey()
    for _, keyCode in ipairs(Menu.BindableKeys) do
        if keyCode ~= 0x0D then
            local down, pressed = Menu.GetKeyState(keyCode)
            local wasDown = Menu.KeyStates[keyCode] or false

            if Menu.SuppressCaptureUntilRelease == keyCode then
                if down == true then
                    Menu.KeyStates[keyCode] = true
                else
                    Menu.KeyStates[keyCode] = false
                    Menu.SuppressCaptureUntilRelease = nil
                end
            else

                if down == true then
                    Menu.KeyStates[keyCode] = true
                else
                    Menu.KeyStates[keyCode] = false
                end

                if pressed == true or (down == true and not wasDown) then
                    return keyCode
                end
            end
        end
    end

    return nil
end

local function IsModifierVirtualKey(keyCode)
    return keyCode == 0x10 or keyCode == 0x11 or keyCode == 0x12
        or keyCode == 0xA0 or keyCode == 0xA1
        or keyCode == 0xA2 or keyCode == 0xA3
        or keyCode == 0xA4 or keyCode == 0xA5
end

local function CaptureMenuToggleKey()
    for _, keyCode in ipairs(Menu.BindableKeys) do
        if keyCode ~= 0x0D and not IsModifierVirtualKey(keyCode) then
            local down, pressed = Menu.GetKeyState(keyCode)
            local wasDown = Menu.KeyStates[keyCode] or false

            if Menu.SuppressCaptureUntilRelease == keyCode then
                if down == true then
                    Menu.KeyStates[keyCode] = true
                else
                    Menu.KeyStates[keyCode] = false
                    Menu.SuppressCaptureUntilRelease = nil
                end
            else
                Menu.KeyStates[keyCode] = down == true
                if pressed == true or (down == true and not wasDown) then
                    return keyCode
                end
            end
        end
    end

    return nil
end

function Menu.ApplySpecialToggleState(item)
    if not item or (item.type ~= "toggle" and item.type ~= "toggle_selector") then
        return
    end

    if item.name == "Show Menu Keybinds" then
        Menu.ShowKeybinds = item.value == true
    elseif item.name == "Clickable Menu" then
        Menu.ClickableMenu = item.value == true
    elseif item.name == "Display Menu" then
        Menu.DisplayMenu = item.value == true
        Menu.DisplayMenuHoverCategory = nil
        Menu.DisplayMenuHoverTab = nil
        Menu.DisplayMenuHoverItem = nil
        Menu.DisplayMenuActiveSlider = nil
        Menu.DisplayMenuLeftWasDown = false
        Menu.DisplayMenuRightWasDown = false
        Menu.DisplayMenuItemScrollOffset = 0
        Menu.DisplayMenuCurrentMap = nil
    elseif item.name == "Editor Mode" then
        Menu.EditorMode = item.value == true
    elseif item.name == "Flakes" then
        Menu.ShowSnowflakes = item.value == true
    elseif item.name == "Blossoms" then
        Menu.ShowBlossoms = item.value == true
    elseif item.name == "Show Spectator List" then
        Menu.ShowSpectatorList = item.value == true
    end

    SetInteractiveOverlayState(IsInteractiveOverlayActive())
end

IsPointInRect = function(px, py, x, y, width, height)
    return px >= x and px <= (x + width) and py >= y and py <= (y + height)
end
if type(_G) == "table" then
    _G.IsPointInRect = IsPointInRect
end

ResolveOverlayCursorPosition = function()
    local cursorPos = nil
    local cursorPosY = nil
    local mouseX = nil
    local mouseY = nil
    local screenW, screenH = MenuGetScreenSize()

    if Susano and Susano.GetCursorPos then
        cursorPos, cursorPosY = Susano.GetCursorPos()
    end

    if cursorPos then
        if type(cursorPos) == "number" and type(cursorPosY) == "number" then
            mouseX = cursorPos
            mouseY = cursorPosY
        elseif type(cursorPos) == "table" then
            mouseX = cursorPos.x or cursorPos[1]
            mouseY = cursorPos.y or cursorPos[2]
        else
            local xOk, x = pcall(function() return cursorPos.x end)
            local yOk, y = pcall(function() return cursorPos.y end)
            if xOk and type(x) == "number" then mouseX = x end
            if yOk and type(y) == "number" then mouseY = y end

            if mouseX == nil or mouseY == nil then
                local iOk, ix = pcall(function() return cursorPos[1] end)
                local jOk, iy = pcall(function() return cursorPos[2] end)
                if mouseX == nil and iOk and type(ix) == "number" then mouseX = ix end
                if mouseY == nil and jOk and type(iy) == "number" then mouseY = iy end
            end
        end
    end

    if (type(mouseX) ~= "number" or type(mouseY) ~= "number") and GetNuiCursorPosition then
        local ok, nuiX, nuiY = pcall(GetNuiCursorPosition)
        if ok and type(nuiX) == "number" and type(nuiY) == "number" then
            mouseX = nuiX
            mouseY = nuiY
        end
    end

    if (type(mouseX) ~= "number" or type(mouseY) ~= "number") and screenW and screenH and screenW > 0 and screenH > 0 then
        local normX = nil
        local normY = nil

        if GetDisabledControlNormal then
            local okX, valueX = pcall(GetDisabledControlNormal, 0, 239)
            local okY, valueY = pcall(GetDisabledControlNormal, 0, 240)
            if okX and type(valueX) == "number" then normX = valueX end
            if okY and type(valueY) == "number" then normY = valueY end
        end

        if (type(normX) ~= "number" or type(normY) ~= "number") and GetControlNormal then
            local okX, valueX = pcall(GetControlNormal, 0, 239)
            local okY, valueY = pcall(GetControlNormal, 0, 240)
            if okX and type(valueX) == "number" then normX = valueX end
            if okY and type(valueY) == "number" then normY = valueY end
        end

        if type(normX) == "number" and type(normY) == "number" then
            if normX >= 0 and normY >= 0 and normX <= 1.0 and normY <= 1.0 then
                mouseX = normX * screenW
                mouseY = normY * screenH
            end
        end
    end

    if type(mouseX) ~= "number" or type(mouseY) ~= "number" then
        if type(Menu.LastOverlayMouseX) == "number" and type(Menu.LastOverlayMouseY) == "number" then
            return Menu.LastOverlayMouseX, Menu.LastOverlayMouseY
        end
        return nil
    end

    if screenW and screenH and screenW > 0 and screenH > 0 then
        if mouseX >= 0 and mouseY >= 0 and mouseX <= 1.0 and mouseY <= 1.0 then
            mouseX = mouseX * screenW
            mouseY = mouseY * screenH
        elseif mouseX >= 0 and mouseY >= 0 and mouseX <= 1.5 and mouseY <= 1.5 then
            mouseX = mouseX * screenW
            mouseY = mouseY * screenH
        end

        mouseX = math.max(0, math.min(screenW, mouseX))
        mouseY = math.max(0, math.min(screenH, mouseY))
    end

    Menu.LastOverlayMouseX = mouseX
    Menu.LastOverlayMouseY = mouseY
    return mouseX, mouseY
end
if type(_G) == "table" then
    _G.ResolveOverlayCursorPosition = ResolveOverlayCursorPosition
end

GetOverlayMouseState = function()
    local mouseX, mouseY = ResolveOverlayCursorPosition()
    if not mouseX or not mouseY then
        return nil
    end

    local leftDown = false
    local leftPressed = false
    local rightDown = false
    local rightPressed = false

    if Susano and Susano.GetAsyncKeyState then
        leftDown, leftPressed = Susano.GetAsyncKeyState(0x01)
        rightDown, rightPressed = Susano.GetAsyncKeyState(0x02)
    end

    if not leftDown and IsDisabledControlPressed then
        leftDown = IsDisabledControlPressed(0, 24)
    end
    if not rightDown and IsDisabledControlPressed then
        rightDown = IsDisabledControlPressed(0, 25)
    end
    if not leftDown and IsControlPressed then
        leftDown = IsControlPressed(0, 24)
    end
    if not rightDown and IsControlPressed then
        rightDown = IsControlPressed(0, 25)
    end

    if not leftPressed and IsDisabledControlJustPressed then
        leftPressed = IsDisabledControlJustPressed(0, 24)
    end
    if not rightPressed and IsDisabledControlJustPressed then
        rightPressed = IsDisabledControlJustPressed(0, 25)
    end
    if not leftPressed and IsControlJustPressed then
        leftPressed = IsControlJustPressed(0, 24)
    end
    if not rightPressed and IsControlJustPressed then
        rightPressed = IsControlJustPressed(0, 25)
    end

    return mouseX, mouseY,
        (leftDown == true or leftDown == 1), leftPressed == true,
        (rightDown == true or rightDown == 1), rightPressed == true
end
if type(_G) == "table" then
    _G.GetOverlayMouseState = GetOverlayMouseState
end

local function GetClickableCursorAccentColor()
    local base = (Menu and Menu.Colors and Menu.Colors.SelectedBg) or { r = 0, g = 221, b = 255 }
    local r = tonumber(base.r) or 0
    local g = tonumber(base.g) or 0
    local b = tonumber(base.b) or 0

    if r > 1.0 then r = r / 255.0 end
    if g > 1.0 then g = g / 255.0 end
    if b > 1.0 then b = b / 255.0 end

    return math.max(0.0, math.min(1.0, r)),
        math.max(0.0, math.min(1.0, g)),
        math.max(0.0, math.min(1.0, b))
end

local function DrawClickableCursorLine(x1, y1, x2, y2, r, g, b, a, thickness)
    if not SDM_IsFiniteNumber(x1) or not SDM_IsFiniteNumber(y1) or not SDM_IsFiniteNumber(x2) or not SDM_IsFiniteNumber(y2) then
        return
    end

    if Susano and Susano.DrawLine then
        Susano.DrawLine(x1, y1, x2, y2, r, g, b, a, thickness)
    elseif Susano and Susano.DrawRectFilled then
        local minX = math.min(x1, x2)
        local minY = math.min(y1, y2)
        local width = math.max(1, math.abs(x2 - x1))
        local height = math.max(1, math.abs(y2 - y1))
        Susano.DrawRectFilled(minX, minY, width, height, r, g, b, a, 1)
    end
end

local function DrawPointerCursor(mouseX, mouseY, pressed)
    local accentR, accentG, accentB = GetClickableCursorAccentColor()
    local offsetX = pressed and -0.5 or 0.0
    local offsetY = pressed and 0.5 or 0.0
    local cursorScale = (Menu.DisplayMenu and Menu.Visible) and 1.35 or 1.0
    local function PX(value)
        return value * cursorScale
    end

    local points = {
        { x = mouseX + offsetX,      y = mouseY + offsetY },
        { x = mouseX + offsetX,      y = mouseY + PX(18) + offsetY },
        { x = mouseX + PX(4) + offsetX,  y = mouseY + PX(14) + offsetY },
        { x = mouseX + PX(8) + offsetX,  y = mouseY + PX(24) + offsetY },
        { x = mouseX + PX(12) + offsetX, y = mouseY + PX(22) + offsetY },
        { x = mouseX + PX(8) + offsetX,  y = mouseY + PX(12) + offsetY },
        { x = mouseX + PX(15) + offsetX, y = mouseY + PX(12) + offsetY }
    }

    for i = 1, #points do
        local current = points[i]
        local nextPoint = points[(i % #points) + 1]
        DrawClickableCursorLine(current.x + 1.5, current.y + 1.5, nextPoint.x + 1.5, nextPoint.y + 1.5, 0.0, 0.0, 0.0, 0.45, 4.0)
    end

    for i = 1, #points do
        local current = points[i]
        local nextPoint = points[(i % #points) + 1]
        DrawClickableCursorLine(current.x, current.y, nextPoint.x, nextPoint.y, 0.0, 0.0, 0.0, 1.0, 3.4)
    end

    for i = 1, #points do
        local current = points[i]
        local nextPoint = points[(i % #points) + 1]
        DrawClickableCursorLine(current.x, current.y, nextPoint.x, nextPoint.y, 1.0, 1.0, 1.0, 1.0, 2.0)
    end

    DrawClickableCursorLine(mouseX + PX(4) + offsetX, mouseY + PX(14) + offsetY, mouseX + PX(9) + offsetX, mouseY + PX(22) + offsetY, accentR, accentG, accentB, 1.0, 2.1)
    DrawClickableCursorLine(mouseX + PX(1) + offsetX, mouseY + PX(1) + offsetY, mouseX + PX(4) + offsetX, mouseY + PX(4) + offsetY, accentR, accentG, accentB, 0.90, 1.6)

    SDM_DrawCircleSafe(mouseX + PX(2), mouseY + PX(2), PX(7), false, accentR, accentG, accentB, 0.18, 1.0, 18)

    if not SDM_DrawCircleSafe(mouseX + offsetX, mouseY + offsetY, (pressed and 2.5 or 2.0) * cursorScale, true, accentR, accentG, accentB, pressed and 0.95 or 0.75, 1.0, 18) then
        if Susano and Susano.DrawRectFilled then
            Susano.DrawRectFilled(mouseX - 1 + offsetX, mouseY - 1 + offsetY, PX(3), PX(3), accentR, accentG, accentB, pressed and 0.95 or 0.75, 1)
        end
    elseif Susano and Susano.DrawRectFilled then
        Susano.DrawRectFilled(mouseX - 1 + offsetX, mouseY - 1 + offsetY, PX(3), PX(3), accentR, accentG, accentB, pressed and 0.95 or 0.75, 1)
    end
end

DrawClickableCursor = function()
    if not Susano or not IsInteractiveOverlayActive() then
        return
    end

    if not Menu.Visible and not Menu.InputOpen and not Menu.SelectingBind and not Menu.SelectingKey then
        return
    end

    local mouseX, mouseY, leftDown = GetOverlayMouseState()
    if not mouseX or not mouseY then
        return
    end

    if Susano.DrawLine or Susano.DrawCircle then
        DrawPointerCursor(mouseX, mouseY, leftDown == true)
    elseif Susano.DrawRectFilled then
        local accentR, accentG, accentB = GetClickableCursorAccentColor()
        Susano.DrawRectFilled(mouseX + 1, mouseY + 2, 10, 16, 0.0, 0.0, 0.0, 0.40, 1)
        Susano.DrawRectFilled(mouseX, mouseY, 2, 18, 1.0, 1.0, 1.0, 1.0, 1)
        Susano.DrawRectFilled(mouseX + 2, mouseY + 4, 2, 14, 1.0, 1.0, 1.0, 1.0, 1)
        Susano.DrawRectFilled(mouseX + 4, mouseY + 8, 2, 12, 1.0, 1.0, 1.0, 1.0, 1)
        Susano.DrawRectFilled(mouseX + 6, mouseY + 11, 2, 10, 1.0, 1.0, 1.0, 1.0, 1)
        Susano.DrawRectFilled(mouseX + 8, mouseY + 11, 7, 2, 1.0, 1.0, 1.0, 1.0, 1)
        Susano.DrawRectFilled(mouseX + 5, mouseY + 14, 5, 2, accentR, accentG, accentB, 0.95, 1)
    end
end

local function IsWardrobeSelectorItem(item)
    if not item then
        return false
    end

    local wardrobeItemNames = {
        Hat = true,
        Mask = true,
        Glasses = true,
        Torso = true,
        Tshirt = true,
        Pants = true,
        Shoes = true
    }

    return wardrobeItemNames[item.name] == true
end

local function ApplySelectorSpecialCases(item, currentIndex)
    if not item then
        return
    end

    if item.name == "Menu Theme" and item.options then
        local theme = item.options[currentIndex]
        Menu.ApplyTheme(theme)
    elseif item.name == "Gradient" and item.options then
        local gradientVal = item.options[currentIndex]
        Menu.GradientType = tonumber(gradientVal) or 1
    elseif item.name == "Scroll Bar Position" and item.options then
        local pos = item.options[currentIndex]
        if pos == "Left" then
            Menu.ScrollbarPosition = 1
        elseif pos == "Right" then
            Menu.ScrollbarPosition = 2
        end
    end
end

local function AdjustSelectorItem(item, direction, invokeCallback)
    if not item then
        return
    end

    if item.type == "toggle_selector" then
        local currentIndex = item.selected or 1
        if item.options and #item.options > 0 then
            currentIndex = currentIndex + direction
            if currentIndex < 1 then
                currentIndex = #item.options
            elseif currentIndex > #item.options then
                currentIndex = 1
            end
        end

        item.selected = currentIndex
        local optionValue = (item.options and item.options[currentIndex]) or currentIndex
        if invokeCallback and item.onClick then
            local success, error = Menu.ExecuteCallbackSafely(item.onClick, item.value, optionValue)
            if not success and Menu.NotifyError then
                Menu.NotifyError(item.name or "Selector", error)
            end
        end
        return
    end

    if item.type ~= "selector" then
        return
    end

    local currentIndex = item.selected or 1
    if IsWardrobeSelectorItem(item) then
        currentIndex = math.max(1, currentIndex + direction)
    elseif item.options and #item.options > 0 then
        currentIndex = currentIndex + direction
        if currentIndex < 1 then
            currentIndex = #item.options
        elseif currentIndex > #item.options then
            currentIndex = 1
        end
    end

    item.selected = currentIndex
    ApplySelectorSpecialCases(item, currentIndex)

    if invokeCallback and item.onClick then
        local optionValue = (item.options and item.options[currentIndex]) or currentIndex
        local success, error = Menu.ExecuteCallbackSafely(item.onClick, currentIndex, optionValue)
        if not success and Menu.NotifyError then
            Menu.NotifyError(item.name or "Selector", error)
        end
    end
end
if type(_G) == "table" then
    _G.AdjustSelectorItem = AdjustSelectorItem
end

local function ApplySliderSpecialCases(item)
    if not item then
        return
    end

    if item.name == "Smooth Menu" then
        Menu.SmoothFactor = (item.value or 0) / 100.0
    elseif item.name == "Menu Size" then
        Menu.Scale = ((item.value or 100.0) / 100.0) * (Menu.DefaultScaleMultiplier or 1.0)
    end
end

local function SetSliderItemFromPercent(item, percent, isToggleSlider)
    if not item then
        return
    end

    percent = math.max(0.0, math.min(1.0, percent or 0.0))

    if isToggleSlider then
        local minValue = item.sliderMin or 0.0
        local maxValue = item.sliderMax or 100.0
        local step = item.sliderStep or 0.1
        local rawValue = minValue + ((maxValue - minValue) * percent)
        local snapped = minValue + (math.floor((((rawValue - minValue) / step) + 0.5)) * step)
        snapped = math.max(minValue, math.min(maxValue, snapped))

        if item.sliderValue ~= snapped then
            item.sliderValue = snapped
            if item.onSliderChange then
                local success, error = Menu.ExecuteCallbackSafely(item.onSliderChange, item.sliderValue)
                if not success and Menu.NotifyError then
                    Menu.NotifyError(item.name or "Slider", error)
                end
            end
        end
        return
    end

    local minValue = item.min or 0.0
    local maxValue = item.max or 100.0
    local step = item.step or 1.0
    local rawValue = minValue + ((maxValue - minValue) * percent)
    local snapped = minValue + (math.floor((((rawValue - minValue) / step) + 0.5)) * step)
    snapped = math.max(minValue, math.min(maxValue, snapped))

    if item.value ~= snapped then
        item.value = snapped
        ApplySliderSpecialCases(item)
        if item.onClick then
            local success, error = Menu.ExecuteCallbackSafely(item.onClick, item.value)
            if not success and Menu.NotifyError then
                Menu.NotifyError(item.name or "Slider", error)
            end
        end
    end
end
if type(_G) == "table" then
    _G.SetSliderItemFromPercent = SetSliderItemFromPercent
end

local function TriggerPrimaryItemAction(item)
    if not item or item.isSeparator then
        return
    end

    if item.type == "toggle" or item.type == "toggle_selector" then
        item.value = not item.value
        Menu.ApplySpecialToggleState(item)
        if item.onClick then
            local success, error
            if item.type == "toggle_selector" then
                local option = (item.options and item.options[item.selected or 1]) or nil
                success, error = Menu.ExecuteCallbackSafely(item.onClick, item.value, option)
            else
                success, error = Menu.ExecuteCallbackSafely(item.onClick, item.value)
            end

            if not success and Menu.NotifyError then
                Menu.NotifyError(item.name or "Toggle", error)
            else
                Menu.NotifyInteraction(item, "toggle", item.value)
            end
        else
            Menu.NotifyInteraction(item, "toggle", item.value)
        end
    elseif item.type == "action" then
        if item.name == "Change Menu Keybind" then
            Menu.SelectingKey = true
            Menu.SelectedKey = Menu.SelectedKey
            Menu.SelectedKeyName = Menu.SelectedKeyName
            Menu.SuppressCaptureUntilRelease = Menu.SelectedKey
        end

        if item.onClick then
            local success, error = Menu.ExecuteCallbackSafely(item.onClick)
            if not success and Menu.NotifyError then
                Menu.NotifyError(item.name or "Action", error)
            else
                Menu.NotifyInteraction(item, "action")
            end
        else
            Menu.NotifyInteraction(item, "action")
        end
    elseif item.type == "selector" then
        AdjustSelectorItem(item, 1, true)
    end
end
if type(_G) == "table" then
    _G.TriggerPrimaryItemAction = TriggerPrimaryItemAction
end

local function GetMenuBoundsForMouse()
    local scaledPos = Menu.GetScaledPosition()
    local scale = Menu.Scale or 1.0
    local headerVisualHeight = Menu.Banner.enabled and (Menu.Banner.height * scale) or scaledPos.headerHeight
    local rowCount = 0

    if Menu.OpenedCategory then
        local category = Menu.Categories[Menu.OpenedCategory]
        local currentTab = category and category.tabs and category.tabs[Menu.CurrentTab]
        local totalItems = currentTab and currentTab.items and #currentTab.items or 0
        rowCount = math.min(Menu.ItemsPerPage, totalItems)
    else
        rowCount = math.min(Menu.ItemsPerPage, math.max(0, #Menu.Categories - 1))
    end

    local totalHeight = headerVisualHeight + scaledPos.mainMenuHeight + scaledPos.mainMenuSpacing + (rowCount * scaledPos.itemHeight) + scaledPos.footerSpacing + scaledPos.footerHeight
    return scaledPos.x, scaledPos.y, scaledPos.width, totalHeight
end

local function HandleClickableMenuInput()
    if not Menu.Visible or not Menu.ClickableMenu or Menu.EditorMode then
        Menu.ActiveMouseSlider = nil
        Menu.MouseLeftWasDown = false
        Menu.MouseRightWasDown = false
        return
    end

    local mouseX, mouseY, leftDown, leftPressed, rightDown, rightPressed = GetOverlayMouseState()
    if not mouseX then
        return
    end

    local leftClicked = leftPressed or (leftDown and not Menu.MouseLeftWasDown)
    local rightClicked = rightPressed or (rightDown and not Menu.MouseRightWasDown)

    if not leftDown then
        Menu.ActiveMouseSlider = nil
    end

    local menuX, menuY, menuWidth, menuHeight = GetMenuBoundsForMouse()
    local insideMenu = IsPointInRect(mouseX, mouseY, menuX, menuY, menuWidth, menuHeight)

    if rightClicked and insideMenu then
        if Menu.OpenedCategory then
            Menu.OpenedCategory = nil
            Menu.CurrentItem = 1
            Menu.CurrentTab = 1
            Menu.ItemScrollOffset = 0
        else
            Menu.Visible = false
        end

        Menu.MouseLeftWasDown = leftDown
        Menu.MouseRightWasDown = rightDown
        return
    end

    local scaledPos = Menu.GetScaledPosition()
    local scale = Menu.Scale or 1.0

    if Menu.OpenedCategory then
        local category = Menu.Categories[Menu.OpenedCategory]
        local x = scaledPos.x
        local startY = scaledPos.y + scaledPos.headerHeight
        local width = scaledPos.width
        local itemHeight = scaledPos.itemHeight
        local mainMenuHeight = scaledPos.mainMenuHeight
        local mainMenuSpacing = scaledPos.mainMenuSpacing

        if category and category.hasTabs and category.tabs then
            local numTabs = #category.tabs
            local tabWidth = width / math.max(1, numTabs)
            local currentX = x

            for i, tab in ipairs(category.tabs) do
                local tabX = currentX
                local currentTabWidth = (i == numTabs) and ((x + width) - currentX) or (tabWidth + (0.5 * scale))
                if IsPointInRect(mouseX, mouseY, tabX, startY, currentTabWidth, mainMenuHeight) then
                    if leftClicked then
                        Menu.CurrentTab = i
                        local newTab = category.tabs[Menu.CurrentTab]
                        if newTab and newTab.items then
                            Menu.CurrentItem = findNextNonSeparator(newTab.items, 0, 1)
                        else
                            Menu.CurrentItem = 1
                        end
                        Menu.ItemScrollOffset = 0
                        Menu.TabSelectorX = tabX
                    end
                    break
                end
                currentX = currentX + tabWidth
            end

            local currentTab = category.tabs[Menu.CurrentTab]
            if currentTab and currentTab.items then
                local totalItems = #currentTab.items
                local maxVisible = Menu.ItemsPerPage
                local itemY = startY + mainMenuHeight + mainMenuSpacing

                for displayIndex = 1, math.min(maxVisible, totalItems) do
                    local itemIndex = displayIndex + Menu.ItemScrollOffset
                    local item = currentTab.items[itemIndex]
                    local rowY = itemY + ((displayIndex - 1) * itemHeight)

                    if item and IsPointInRect(mouseX, mouseY, x, rowY, width, itemHeight) then
                        if not item.isSeparator then
                            Menu.CurrentItem = itemIndex
                        end

                        if item and not item.isSeparator then
                            local handled = false

                            if item.type == "toggle" and item.hasSlider then
                                local sliderWidth = 85 * scale
                                local sliderHeight = 6 * scale
                                local sliderX = x + width - sliderWidth - (95 * scale)
                                local sliderY = rowY + (itemHeight / 2) - (sliderHeight / 2)
                                if IsPointInRect(mouseX, mouseY, sliderX, sliderY - (6 * scale), sliderWidth, sliderHeight + (12 * scale)) then
                                    local percent = (mouseX - sliderX) / sliderWidth
                                    if leftDown or leftClicked then
                                        SetSliderItemFromPercent(item, percent, true)
                                        Menu.ActiveMouseSlider = { item = item, kind = "toggle_slider", sliderX = sliderX, sliderWidth = sliderWidth }
                                    end
                                    handled = true
                                end
                            elseif item.type == "slider" then
                                local sliderWidth = 100 * scale
                                local sliderHeight = 7 * scale
                                local sliderX = x + width - sliderWidth - (60 * scale)
                                local sliderY = rowY + (itemHeight / 2) - (sliderHeight / 2)
                                if IsPointInRect(mouseX, mouseY, sliderX, sliderY - (6 * scale), sliderWidth, sliderHeight + (12 * scale)) then
                                    local percent = (mouseX - sliderX) / sliderWidth
                                    if leftDown or leftClicked then
                                        SetSliderItemFromPercent(item, percent, false)
                                        Menu.ActiveMouseSlider = { item = item, kind = "slider", sliderX = sliderX, sliderWidth = sliderWidth }
                                    end
                                    handled = true
                                end
                            elseif item.type == "toggle_selector" and item.options then
                                local toggleWidth = 32 * scale
                                local toggleHeight = 14 * scale
                                local toggleX = x + width - toggleWidth - (15 * scale)
                                local toggleY = rowY + (itemHeight / 2) - (toggleHeight / 2)
                                local selectedOption = item.options[item.selected or 1] or ""
                                local fullText = "< " .. selectedOption .. " >"
                                local selectorWidth = Menu.GetTextWidth(fullText, 16)
                                local selectorX = toggleX - selectorWidth - (15 * scale)
                                local leftArrowWidth = Menu.GetTextWidth("< ", 16)
                                local optionWidth = Menu.GetTextWidth(selectedOption, 16)

                                if IsPointInRect(mouseX, mouseY, selectorX, rowY, selectorWidth, itemHeight) then
                                    if leftClicked then
                                        if mouseX <= (selectorX + leftArrowWidth + optionWidth * 0.35) then
                                            AdjustSelectorItem(item, -1, true)
                                        else
                                            AdjustSelectorItem(item, 1, true)
                                        end
                                    end
                                    handled = true
                                elseif IsPointInRect(mouseX, mouseY, toggleX, toggleY, toggleWidth, toggleHeight) then
                                    if leftClicked then
                                        TriggerPrimaryItemAction(item)
                                    end
                                    handled = true
                                end
                            elseif item.type == "selector" and item.options then
                                if IsWardrobeSelectorItem(item) then
                                    local selectorText = "- " .. tostring(item.selected or 1) .. " -"
                                    local selectorWidth = Menu.GetTextWidth(selectorText, 17)
                                    local selectorX = x + width - selectorWidth - (16 * scale)
                                    if IsPointInRect(mouseX, mouseY, selectorX, rowY, selectorWidth, itemHeight) then
                                        if leftClicked then
                                            if mouseX <= selectorX + (selectorWidth / 2) then
                                                AdjustSelectorItem(item, -1, true)
                                            else
                                                AdjustSelectorItem(item, 1, true)
                                            end
                                        end
                                        handled = true
                                    end
                                else
                                    local selectedOption = item.options[item.selected or 1] or ""
                                    local fullText = "< " .. selectedOption .. " >"
                                    local selectorWidth = Menu.GetTextWidth(fullText, 17)
                                    local selectorX = x + width - selectorWidth - (16 * scale)
                                    local leftArrowWidth = Menu.GetTextWidth("< ", 17)
                                    local optionWidth = Menu.GetTextWidth(selectedOption, 17)

                                    if IsPointInRect(mouseX, mouseY, selectorX, rowY, selectorWidth, itemHeight) then
                                        if leftClicked then
                                            if mouseX <= (selectorX + leftArrowWidth + optionWidth * 0.35) then
                                                AdjustSelectorItem(item, -1, true)
                                            else
                                                AdjustSelectorItem(item, 1, true)
                                            end
                                        end
                                        handled = true
                                    end
                                end
                            end

                            if leftClicked and not handled then
                                TriggerPrimaryItemAction(item)
                            end
                        end

                        break
                    end
                end
            end
        end
    else
        local x = scaledPos.x
        local width = scaledPos.width
        local bannerHeight = Menu.Banner.enabled and (Menu.Banner.height * scale) or scaledPos.headerHeight
        local startY = scaledPos.y + bannerHeight
        local itemHeight = scaledPos.itemHeight
        local mainMenuHeight = scaledPos.mainMenuHeight
        local mainMenuSpacing = scaledPos.mainMenuSpacing

        if Menu.TopLevelTabs then
            local tabCount = #Menu.TopLevelTabs
            local tabWidth = width / math.max(1, tabCount)
            for i, tab in ipairs(Menu.TopLevelTabs) do
                local tabX = x + ((i - 1) * tabWidth)
                if IsPointInRect(mouseX, mouseY, tabX, startY, tabWidth, mainMenuHeight) then
                    if leftClicked then
                        Menu.CurrentTopTab = i
                        Menu.UpdateCategoriesFromTopTab()
                    end
                    break
                end
            end
        end

        local totalCategories = #Menu.Categories - 1
        local maxVisible = Menu.ItemsPerPage
        for displayIndex = 1, math.min(maxVisible, totalCategories) do
            local categoryIndex = displayIndex + Menu.CategoryScrollOffset + 1
            local category = Menu.Categories[categoryIndex]
            local rowY = startY + mainMenuHeight + mainMenuSpacing + ((displayIndex - 1) * itemHeight)

            if category and IsPointInRect(mouseX, mouseY, x, rowY, width, itemHeight) then
                Menu.CurrentCategory = categoryIndex
                if leftClicked and category.hasTabs and category.tabs then
                    Menu.OpenedCategory = categoryIndex
                    Menu.CurrentTab = 1
                    if category.tabs[1] and category.tabs[1].items then
                        Menu.CurrentItem = findNextNonSeparator(category.tabs[1].items, 0, 1)
                    else
                        Menu.CurrentItem = 1
                    end
                    Menu.ItemScrollOffset = 0
                end
                break
            end
        end
    end

    if leftDown and Menu.ActiveMouseSlider and Menu.ActiveMouseSlider.item then
        local slider = Menu.ActiveMouseSlider
        local percent = (mouseX - slider.sliderX) / slider.sliderWidth
        SetSliderItemFromPercent(slider.item, percent, slider.kind == "toggle_slider")
    end

    Menu.MouseLeftWasDown = leftDown
    Menu.MouseRightWasDown = rightDown
end

function Menu.HandleInput()
    if Menu.IsLoading or not Menu.LoadingComplete then
        return
    end

    if Menu.InputOpen then
        return
    end

    if Menu.SelectingBind then
        if not (Susano and Susano.GetAsyncKeyState) then
            return
        end

        if Menu.IsKeyJustPressed(0x1B) then
            Menu.SelectingBind = false
            Menu.BindingItem = nil
            Menu.BindingKey = nil
            Menu.BindingKeyName = nil
            SetInteractiveOverlayState(IsInteractiveOverlayActive())
            return
        end

        if Menu.IsKeyJustPressed(0x0D) then
            if Menu.BindingKey and Menu.BindingItem then
                Menu.BindingItem.bindKey = Menu.BindingKey
                Menu.BindingItem.bindKeyName = Menu.BindingKeyName
                local itemName = Menu.BindingItem.name or "option"
                local savedKeyName = Menu.BindingKeyName
                Menu.SelectingBind = false
                Menu.BindingItem = nil
                Menu.BindingKey = nil
                Menu.BindingKeyName = nil
                print("Bind set for " .. itemName .. ": " .. tostring(savedKeyName))
                Menu.NotifyInteraction({ name = itemName }, "bind", savedKeyName)
            end
            return
        end

        local keyCode = Menu.CaptureBindableKey()
        if keyCode then
            Menu.BindingKey = keyCode
            Menu.BindingKeyName = Menu.GetKeyName(keyCode)
            if Menu.BindingItem then
                local itemName = Menu.BindingItem.name or "option"
                local savedKeyName = Menu.BindingKeyName
                Menu.BindingItem.bindKey = Menu.BindingKey
                Menu.BindingItem.bindKeyName = Menu.BindingKeyName
                Menu.SelectingBind = false
                Menu.BindingItem = nil
                Menu.BindingKey = nil
                Menu.BindingKeyName = nil
                Menu.NotifyInteraction({ name = itemName }, "bind", savedKeyName)
                SetInteractiveOverlayState(IsInteractiveOverlayActive())
            end
        end
        return
    end

    if Menu.SelectingKey then
        if not (Susano and Susano.GetAsyncKeyState) then
            return
        end

        if Menu.IsKeyJustPressed(0x0D) then
            if Menu.SelectedKey then
                Menu.SelectingKey = false
                Menu.NotifyInteraction({ name = "Tecla del menu" }, "bind", Menu.SelectedKeyName or Menu.GetKeyName(Menu.SelectedKey))
                SetInteractiveOverlayState(IsInteractiveOverlayActive())
            end
            return
        end

        local keyCode = CaptureMenuToggleKey()
        if keyCode then
            Menu.SelectedKey = keyCode
            Menu.SelectedKeyName = Menu.GetKeyName(keyCode)
        end
        return
    end

    if Susano and Susano.GetAsyncKeyState then
        if Menu.Categories then
            for _, category in ipairs(Menu.Categories) do
                if category and category.hasTabs and category.tabs then
                    for _, tab in ipairs(category.tabs) do
                        if tab and tab.items then
                            for _, item in ipairs(tab.items) do
                                if item and item.bindKey and (item.type == "toggle" or item.type == "action") then
                                    local down, pressed = Menu.GetKeyState(item.bindKey)
                                    local wasDown = Menu.KeyStates[item.bindKey] or false

                                    if down == true then
                                        Menu.KeyStates[item.bindKey] = true
                                    else
                                        Menu.KeyStates[item.bindKey] = false
                                    end

                                    if (pressed == true) or (down == true and not wasDown) then
                                        if item.type == "toggle" then
                                            item.value = not item.value
                                            Menu.ApplySpecialToggleState(item)
                                            if item.onClick then
                                                local success, error = Menu.ExecuteCallbackSafely(item.onClick, item.value)
                                                if not success and Menu.NotifyError then
                                                    Menu.NotifyError(item.name or "Toggle", error)
                                                elseif Menu.NotifySuccess then
                                                    Menu.NotifySuccess(item.name or "Toggle", "Set to " .. tostring(item.value))
                                                end
                                            else
                                                Menu.NotifyInteraction(item, "toggle", item.value)
                                            end
                                            print("Toggled " .. (item.name or "option") .. " to " .. tostring(item.value))
                                        elseif item.type == "action" then
                                            if item.onClick then
                                                local success, error = Menu.ExecuteCallbackSafely(item.onClick)
                                                if not success and Menu.NotifyError then
                                                    Menu.NotifyError(item.name or "Action", error)
                                                elseif Menu.NotifySuccess then
                                                    Menu.NotifySuccess(item.name or "Action", "Executed successfully")
                                                end
                                            else
                                                Menu.NotifyInteraction(item, "action")
                                            end
                                            print("Executed action: " .. (item.name or "option"))
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    local toggleKeyCode = Menu.SelectedKey
    if toggleKeyCode and Susano and Susano.GetAsyncKeyState then
        local down, pressed = Menu.GetKeyState(toggleKeyCode)

        local wasDown = Menu.KeyStates[toggleKeyCode] or false
        local keyPressed = false

        if pressed == true then
            keyPressed = true
        elseif down == true and not wasDown then
            keyPressed = true
        end

        if down == true then
            Menu.KeyStates[toggleKeyCode] = true
        else
            Menu.KeyStates[toggleKeyCode] = false
        end

        if keyPressed then
            local wasVisible = Menu.Visible
            Menu.Visible = not Menu.Visible
            Menu.DisplayMenuCurrentMap = nil
            SetInteractiveOverlayState(IsInteractiveOverlayActive())

            if wasVisible and not Menu.Visible and not Menu.ShowKeybinds and not Menu.ShowSpectatorList then
                if Susano and Susano.ResetFrame then
                    Susano.ResetFrame()
                end
            end
        end
    end

    if not Menu.Visible then
        return
    end

    if Menu.DisplayMenu then
        Menu.HandleDisplayMenuInput()
        return
    end

    if Menu.EditorMode then
        local moveSpeed = 8.0
        local screenW = 1920
        local screenH = 1080
        if Susano and Susano.GetScreenWidth and Susano.GetScreenHeight then
            screenW = Susano.GetScreenWidth()
            screenH = Susano.GetScreenHeight()
        end

        if Susano and Susano.GetCursorPos and Susano.GetAsyncKeyState then
            local mouseX, mouseY = GetOverlayMouseState()
            mouseX = mouseX or 0
            mouseY = mouseY or 0
            
            local leftMouseDown = false
            if Susano.GetAsyncKeyState then
                local lmbDown, lmbPressed = Susano.GetAsyncKeyState(0x01)
                if lmbDown == true or lmbDown == 1 then
                    leftMouseDown = true
                end
            end
            
            if not leftMouseDown and (IsControlPressed or IsDisabledControlPressed) then
                if IsDisabledControlPressed and IsDisabledControlPressed(0, 24) then
                    leftMouseDown = true
                elseif IsControlPressed and IsControlPressed(0, 24) then
                    leftMouseDown = true
                end
            end
            
            local menuX = Menu.Position.x
            local menuY = Menu.Position.y
            local menuWidth = Menu.Position.width
            
            local totalHeight = Menu.Position.headerHeight
            if Menu.OpenedCategory then
                local category = Menu.Categories[Menu.OpenedCategory]
                if category and category.hasTabs and category.tabs then
                    local currentTab = category.tabs[Menu.CurrentTab]
                    if currentTab and currentTab.items then
                        local maxVisible = Menu.ItemsPerPage
                        local totalItems = #currentTab.items
                        local visibleItems = math.min(maxVisible, totalItems)
                        totalHeight = totalHeight + Menu.Position.mainMenuHeight + Menu.Position.mainMenuSpacing + (visibleItems * Menu.Position.itemHeight)
                    else
                        totalHeight = totalHeight + Menu.Position.mainMenuHeight + Menu.Position.mainMenuSpacing
                    end
                else
                    totalHeight = totalHeight + Menu.Position.mainMenuHeight + Menu.Position.mainMenuSpacing
                end
            else
                local maxVisible = Menu.ItemsPerPage
                local totalCategories = #Menu.Categories - 1
                local visibleCategories = math.min(maxVisible, totalCategories)
                totalHeight = totalHeight + Menu.Position.mainMenuHeight + Menu.Position.mainMenuSpacing + (visibleCategories * Menu.Position.itemHeight)
            end
            totalHeight = totalHeight + Menu.Position.footerSpacing + Menu.Position.footerHeight
            
            local isOverMenu = (mouseX >= menuX and mouseX <= menuX + menuWidth and 
                               mouseY >= menuY and mouseY <= menuY + totalHeight)
            
            local wasMouseDown = Menu.KeyStates[0x01] or false
            
            if leftMouseDown then
                if not wasMouseDown and isOverMenu then
                    Menu.EditorDragging = true
                    Menu.EditorDragOffsetX = mouseX - menuX
                    Menu.EditorDragOffsetY = mouseY - menuY
                    print("Started dragging menu")
                end
                
                if Menu.EditorDragging then
                    local newX = mouseX - Menu.EditorDragOffsetX
                    local newY = mouseY - Menu.EditorDragOffsetY
                    
                    local maxX = math.max(0, screenW - menuWidth)
                    local maxY = math.max(0, screenH - totalHeight)
                    
                    Menu.Position.x = math.max(0, math.min(maxX, newX))
                    Menu.Position.y = math.max(0, math.min(maxY, newY))
                end
                
                Menu.KeyStates[0x01] = true
            else
                Menu.EditorDragging = false
                Menu.KeyStates[0x01] = false
            end
        end

        if Susano and Susano.GetAsyncKeyState then
            local upDown = Susano.GetAsyncKeyState(0x26)
            local downDown = Susano.GetAsyncKeyState(0x28)
            local leftDown = Susano.GetAsyncKeyState(0x25)
            local rightDown = Susano.GetAsyncKeyState(0x27)

            if upDown == true then
                Menu.Position.y = math.max(0, Menu.Position.y - moveSpeed)
            end
            if downDown == true then
                Menu.Position.y = math.min(screenH - 200, Menu.Position.y + moveSpeed)
            end
            if leftDown == true then
                Menu.Position.x = math.max(0, Menu.Position.x - moveSpeed)
            end
            if rightDown == true then
                Menu.Position.x = math.min(screenW - Menu.Position.width, Menu.Position.x + moveSpeed)
            end

            if Menu.IsKeyJustPressed(0x0D) then
                local currentTab = nil
                if Menu.OpenedCategory then
                    local category = Menu.Categories[Menu.OpenedCategory]
                    if category and category.hasTabs and category.tabs then
                        currentTab = category.tabs[Menu.CurrentTab]
                    end
                end
                if currentTab and currentTab.items then
                    for _, item in ipairs(currentTab.items) do
                        if item.name == "Editor Mode" and item.type == "toggle" then
                            item.value = not item.value
                            Menu.EditorMode = item.value
                            break
                        end
                    end
                end
            end
        end
        return
    end

    HandleClickableMenuInput()

    if Menu.OpenedCategory then
        local category = Menu.Categories[Menu.OpenedCategory]
        if not category or not category.hasTabs or not category.tabs then
            Menu.OpenedCategory = nil
            return
        end

        local currentTab = category.tabs[Menu.CurrentTab]
        if currentTab and currentTab.items then
            if Susano and Susano.GetAsyncKeyState then
                local upDown, upPressed = Susano.GetAsyncKeyState(0x26)
                local downDown, downPressed = Susano.GetAsyncKeyState(0x28)
                local qDown, qPressed = Susano.GetAsyncKeyState(0x51)
                local eDown, ePressed = Susano.GetAsyncKeyState(0x45)
                local backDown, backPressed = Susano.GetAsyncKeyState(0x08)
                local leftDown, leftPressed = Susano.GetAsyncKeyState(0x25)
                local rightDown, rightPressed = Susano.GetAsyncKeyState(0x27)
                local bindShortcutCode = Menu.BindShortcutKey or 0x79
                local bindDown, bindPressed = Susano.GetAsyncKeyState(bindShortcutCode)

                local upWasDown = Menu.KeyStates[0x26] or false
                local downWasDown = Menu.KeyStates[0x28] or false
                local qWasDown = Menu.KeyStates[0x51] or false
                local eWasDown = Menu.KeyStates[0x45] or false
                local backWasDown = Menu.KeyStates[0x08] or false
                local leftWasDown = Menu.KeyStates[0x25] or false
                local rightWasDown = Menu.KeyStates[0x27] or false
                local bindWasDown = Menu.KeyStates[bindShortcutCode] or false

                if upDown == true then Menu.KeyStates[0x26] = true else Menu.KeyStates[0x26] = false end
                if downDown == true then Menu.KeyStates[0x28] = true else Menu.KeyStates[0x28] = false end
                if qDown == true then Menu.KeyStates[0x51] = true else Menu.KeyStates[0x51] = false end
                if eDown == true then Menu.KeyStates[0x45] = true else Menu.KeyStates[0x45] = false end
                if backDown == true then Menu.KeyStates[0x08] = true else Menu.KeyStates[0x08] = false end
                if leftDown == true then Menu.KeyStates[0x25] = true else Menu.KeyStates[0x25] = false end
                if rightDown == true then Menu.KeyStates[0x27] = true else Menu.KeyStates[0x27] = false end
                if bindDown == true then Menu.KeyStates[bindShortcutCode] = true else Menu.KeyStates[bindShortcutCode] = false end

                if (bindPressed == true) or (bindDown == true and not bindWasDown) then
                    if Menu.CurrentItem > 0 and Menu.CurrentItem <= #currentTab.items then
                        local selectedItem = currentTab.items[Menu.CurrentItem]
                        if selectedItem and not selectedItem.isSeparator then
                            Menu.SelectingBind = true
                            Menu.BindingItem = selectedItem
                            Menu.BindingKey = nil
                            Menu.BindingKeyName = nil
                            Menu.SuppressCaptureUntilRelease = bindShortcutCode
                            if not selectedItem.bindKey then
                                selectedItem.bindKey = nil
                                selectedItem.bindKeyName = nil
                            else
                                Menu.BindingKey = selectedItem.bindKey
                                Menu.BindingKeyName = selectedItem.bindKeyName
                            end
                        end
                    end
                end

                if (upPressed == true) or (upDown == true and not upWasDown) then
                    Menu.CurrentItem = findNextNonSeparator(currentTab.items, Menu.CurrentItem, -1)
                elseif (downPressed == true) or (downDown == true and not downWasDown) then
                    Menu.CurrentItem = findNextNonSeparator(currentTab.items, Menu.CurrentItem, 1)
                elseif (qPressed == true) or (qDown == true and not qWasDown) then
                    if Menu.CurrentTab > 1 then
                        Menu.CurrentTab = Menu.CurrentTab - 1
                        local newTab = category.tabs[Menu.CurrentTab]
                        if newTab and newTab.items then
                            Menu.CurrentItem = findNextNonSeparator(newTab.items, 0, 1)
                        else
                            Menu.CurrentItem = 1
                        end
                        Menu.ItemScrollOffset = 0
                    elseif Menu.TopLevelTabs then
                        Menu.CurrentTopTab = Menu.CurrentTopTab - 1
                        if Menu.CurrentTopTab < 1 then Menu.CurrentTopTab = #Menu.TopLevelTabs end
                        Menu.UpdateCategoriesFromTopTab()
                    end
                elseif (ePressed == true) or (eDown == true and not eWasDown) then
                    if Menu.CurrentTab < #category.tabs then
                        Menu.CurrentTab = Menu.CurrentTab + 1
                        local newTab = category.tabs[Menu.CurrentTab]
                        if newTab and newTab.items then
                            Menu.CurrentItem = findNextNonSeparator(newTab.items, 0, 1)
                        else
                            Menu.CurrentItem = 1
                        end
                        Menu.ItemScrollOffset = 0
                    elseif Menu.TopLevelTabs then
                         Menu.CurrentTopTab = Menu.CurrentTopTab + 1
                         if Menu.CurrentTopTab > #Menu.TopLevelTabs then Menu.CurrentTopTab = 1 end
                         Menu.UpdateCategoriesFromTopTab()
                    end
                elseif (backPressed == true) or (backDown == true and not backWasDown) then
                    if Menu.TopLevelTabs and Menu.TopLevelTabs[Menu.CurrentTopTab].autoOpen then
                         if Menu.CurrentTopTab > 1 then
                             Menu.CurrentTopTab = 1
                             Menu.UpdateCategoriesFromTopTab()
                         else
                             Menu.Visible = false
                         end
                    else
                        Menu.OpenedCategory = nil
                        Menu.CurrentItem = 1
                        Menu.CurrentTab = 1
                        Menu.ItemScrollOffset = 0
                    end
                elseif (leftPressed == true) or (leftDown == true and not leftWasDown) then
                    if Menu.CurrentItem > 0 and Menu.CurrentItem <= #currentTab.items then
                        local selectedItem = currentTab.items[Menu.CurrentItem]
                        if selectedItem then
                            if selectedItem.type == "slider" then
                                local step = 1.0
                                if selectedItem.step then
                                    step = selectedItem.step
                                end
                                selectedItem.value = math.max(selectedItem.min or 0.0, (selectedItem.value or selectedItem.min or 0.0) - step)
                                if selectedItem.name == "Smooth Menu" then
                                    Menu.SmoothFactor = selectedItem.value / 100.0
                                elseif selectedItem.name == "Menu Size" then
                                    Menu.Scale = (selectedItem.value / 100.0) * (Menu.DefaultScaleMultiplier or 1.0)
                                end
                                if selectedItem.onClick then
                                    local success, error = Menu.ExecuteCallbackSafely(selectedItem.onClick, selectedItem.value)
                                    if not success and Menu.NotifyError then
                                        Menu.NotifyError(selectedItem.name or "Slider", error)
                                    else
                                        Menu.NotifyInteraction(selectedItem, "slider", selectedItem.value)
                                    end
                                else
                                    Menu.NotifyInteraction(selectedItem, "slider", selectedItem.value)
                                end
                            elseif selectedItem.type == "toggle" and selectedItem.hasSlider then
                                local step = selectedItem.sliderStep or 0.1
                                selectedItem.sliderValue = math.max(selectedItem.sliderMin or 0.0, (selectedItem.sliderValue or selectedItem.sliderMin or 0.0) - step)
                                if selectedItem.onSliderChange then
                                    local success, error = Menu.ExecuteCallbackSafely(selectedItem.onSliderChange, selectedItem.sliderValue)
                                    if not success and Menu.NotifyError then
                                        Menu.NotifyError(selectedItem.name or "Slider", error)
                                    else
                                        Menu.NotifyInteraction(selectedItem, "toggle_slider", selectedItem.sliderValue)
                                    end
                                else
                                    Menu.NotifyInteraction(selectedItem, "toggle_slider", selectedItem.sliderValue)
                                end
                            elseif selectedItem.type == "toggle_selector" then
                                local currentIndex = selectedItem.selected or 1
                                if selectedItem.options and #selectedItem.options > 0 then
                                    currentIndex = currentIndex - 1
                                    if currentIndex < 1 then
                                        currentIndex = #selectedItem.options
                                    end
                                end
                                selectedItem.selected = currentIndex
                                local optionValue = (selectedItem.options and selectedItem.options[currentIndex]) or currentIndex
                                Menu.NotifyInteraction(selectedItem, "selector", optionValue)
                            elseif selectedItem.type == "selector" then
                                local currentIndex = selectedItem.selected or 1

                                local isWardrobeSelector = false
                                local wardrobeItemNames = {"Hat", "Mask", "Glasses", "Torso", "Tshirt", "Pants", "Shoes"}
                                for _, name in ipairs(wardrobeItemNames) do
                                    if selectedItem.name == name then
                                        isWardrobeSelector = true
                                        break
                                    end
                                end

                                if isWardrobeSelector then
                                    currentIndex = math.max(1, currentIndex - 1)
                                else
                                    if selectedItem.options and #selectedItem.options > 0 then
                                        currentIndex = currentIndex - 1
                                        if currentIndex < 1 then
                                            currentIndex = #selectedItem.options
                                        end
                                    end
                                end
                                selectedItem.selected = currentIndex

                                local notifySelectorChange = false
                                if selectedItem.name == "Menu Theme" and selectedItem.options then
                                    local theme = selectedItem.options[currentIndex]
                                    Menu.ApplyTheme(theme)
                                    notifySelectorChange = true
                                elseif selectedItem.name == "Gradient" and selectedItem.options then
                                    local gradientVal = selectedItem.options[currentIndex]
                                    Menu.GradientType = tonumber(gradientVal) or 1
                                    notifySelectorChange = true
                                elseif selectedItem.name == "Scroll Bar Position" and selectedItem.options then
                                    local pos = selectedItem.options[currentIndex]
                                    if pos == "Left" then
                                        Menu.ScrollbarPosition = 1
                                    elseif pos == "Right" then
                                        Menu.ScrollbarPosition = 2
                                    end
                                    notifySelectorChange = true
                                end

                                if notifySelectorChange then
                                    local optionValue = (selectedItem.options and selectedItem.options[currentIndex]) or currentIndex
                                    Menu.NotifyInteraction(selectedItem, "selector", optionValue)
                                end

                            end
                        end
                    end
                elseif (rightPressed == true) or (rightDown == true and not rightWasDown) then
                    if Menu.CurrentItem > 0 and Menu.CurrentItem <= #currentTab.items then
                        local selectedItem = currentTab.items[Menu.CurrentItem]
                        if selectedItem then
                            if selectedItem.type == "slider" then
                                local step = 1.0
                                if selectedItem.step then
                                    step = selectedItem.step
                                end
                                selectedItem.value = math.min(selectedItem.max or 100.0, (selectedItem.value or selectedItem.min or 0.0) + step)
                                if selectedItem.name == "Smooth Menu" then
                                    Menu.SmoothFactor = selectedItem.value / 100.0
                                elseif selectedItem.name == "Menu Size" then
                                    Menu.Scale = (selectedItem.value / 100.0) * (Menu.DefaultScaleMultiplier or 1.0)
                                end
                                if selectedItem.onClick then
                                    local success, error = Menu.ExecuteCallbackSafely(selectedItem.onClick, selectedItem.value)
                                    if not success and Menu.NotifyError then
                                        Menu.NotifyError(selectedItem.name or "Slider", error)
                                    else
                                        Menu.NotifyInteraction(selectedItem, "slider", selectedItem.value)
                                    end
                                else
                                    Menu.NotifyInteraction(selectedItem, "slider", selectedItem.value)
                                end
                            elseif selectedItem.type == "toggle" and selectedItem.hasSlider then
                                local step = selectedItem.sliderStep or 0.1
                                selectedItem.sliderValue = math.min(selectedItem.sliderMax or 100.0, (selectedItem.sliderValue or selectedItem.sliderMin or 0.0) + step)
                                if selectedItem.onSliderChange then
                                    local success, error = Menu.ExecuteCallbackSafely(selectedItem.onSliderChange, selectedItem.sliderValue)
                                    if not success and Menu.NotifyError then
                                        Menu.NotifyError(selectedItem.name or "Slider", error)
                                    else
                                        Menu.NotifyInteraction(selectedItem, "toggle_slider", selectedItem.sliderValue)
                                    end
                                else
                                    Menu.NotifyInteraction(selectedItem, "toggle_slider", selectedItem.sliderValue)
                                end
                            elseif selectedItem.type == "toggle_selector" then
                                local currentIndex = selectedItem.selected or 1
                                if selectedItem.options and #selectedItem.options > 0 then
                                    currentIndex = currentIndex + 1
                                    if currentIndex > #selectedItem.options then
                                        currentIndex = 1
                                    end
                                end
                                selectedItem.selected = currentIndex
                                local optionValue = (selectedItem.options and selectedItem.options[currentIndex]) or currentIndex
                                Menu.NotifyInteraction(selectedItem, "selector", optionValue)
                            elseif selectedItem.type == "selector" then
                                local currentIndex = selectedItem.selected or 1

                                local isWardrobeSelector = false
                                local wardrobeItemNames = {"Hat", "Mask", "Glasses", "Torso", "Tshirt", "Pants", "Shoes"}
                                for _, name in ipairs(wardrobeItemNames) do
                                    if selectedItem.name == name then
                                        isWardrobeSelector = true
                                        break
                                    end
                                end

                                if isWardrobeSelector then
                                    currentIndex = currentIndex + 1
                                else
                                    if selectedItem.options and #selectedItem.options > 0 then
                                        currentIndex = currentIndex + 1
                                        if currentIndex > #selectedItem.options then
                                            currentIndex = 1
                                        end
                                    end
                                end
                                selectedItem.selected = currentIndex

                                local notifySelectorChange = false
                                if selectedItem.name == "Menu Theme" and selectedItem.options then
                                    local theme = selectedItem.options[currentIndex]
                                    Menu.ApplyTheme(theme)
                                    notifySelectorChange = true
                                elseif selectedItem.name == "Gradient" and selectedItem.options then
                                    local gradientVal = selectedItem.options[currentIndex]
                                    Menu.GradientType = tonumber(gradientVal) or 1
                                    notifySelectorChange = true
                                elseif selectedItem.name == "Scroll Bar Position" and selectedItem.options then
                                    local pos = selectedItem.options[currentIndex]
                                    if pos == "Left" then
                                        Menu.ScrollbarPosition = 1
                                    elseif pos == "Right" then
                                        Menu.ScrollbarPosition = 2
                                    end
                                    notifySelectorChange = true
                                end

                                if notifySelectorChange then
                                    local optionValue = (selectedItem.options and selectedItem.options[currentIndex]) or currentIndex
                                    Menu.NotifyInteraction(selectedItem, "selector", optionValue)
                                end

                            end
                        end
                    end
                end
            end

            if Menu.IsKeyJustPressed(0x0D) then
                local item = currentTab.items[Menu.CurrentItem]
                if item and not item.isSeparator then
                    if item.type == "toggle" or item.type == "toggle_selector" then
                        item.value = not item.value
                        Menu.ApplySpecialToggleState(item)
                        if item.onClick then item.onClick(item.value) end
                        Menu.NotifyInteraction(item, "toggle", item.value)
                    elseif item.type == "action" then
                        if item.name == "Change Menu Keybind" then
                            Menu.SelectingKey = true
                            Menu.SelectedKey = Menu.SelectedKey
                            Menu.SelectedKeyName = Menu.SelectedKeyName
                            Menu.SuppressCaptureUntilRelease = Menu.SelectedKey
                            print("Changing menu keybind...")
                        end
                        if item.onClick then
                            local success, error = Menu.ExecuteCallbackSafely(item.onClick)
                            if not success and Menu.NotifyError then
                                Menu.NotifyError(item.name or "Action", error)
                            else
                                Menu.NotifyInteraction(item, "action")
                            end
                        else
                            Menu.NotifyInteraction(item, "action")
                        end
                    elseif item.type == "selector" then
                        if item.onClick then
                             local option = (item.options and item.options[item.selected]) or nil
                             local success, error = Menu.ExecuteCallbackSafely(item.onClick, item.selected, option)
                             if not success and Menu.NotifyError then
                                Menu.NotifyError(item.name or "Selector", error)
                             else
                                Menu.NotifyInteraction(item, "selector", option)
                             end
                        end
                    end
                end
            end
        end
    else
        if Susano and Susano.GetAsyncKeyState then
            local upDown, upPressed = Susano.GetAsyncKeyState(0x26)
            local downDown, downPressed = Susano.GetAsyncKeyState(0x28)
            local qDown, qPressed = Susano.GetAsyncKeyState(0x51)
            local eDown, ePressed = Susano.GetAsyncKeyState(0x45)
            local backDown, backPressed = Susano.GetAsyncKeyState(0x08)

            local upWasDown = Menu.KeyStates[0x26] or false
            local downWasDown = Menu.KeyStates[0x28] or false
            local qWasDown = Menu.KeyStates[0x51] or false
            local eWasDown = Menu.KeyStates[0x45] or false
            local backWasDown = Menu.KeyStates[0x08] or false

            if upDown == true then Menu.KeyStates[0x26] = true else Menu.KeyStates[0x26] = false end
            if downDown == true then Menu.KeyStates[0x28] = true else Menu.KeyStates[0x28] = false end
            if qDown == true then Menu.KeyStates[0x51] = true else Menu.KeyStates[0x51] = false end
            if eDown == true then Menu.KeyStates[0x45] = true else Menu.KeyStates[0x45] = false end
            if backDown == true then Menu.KeyStates[0x08] = true else Menu.KeyStates[0x08] = false end

            if (upPressed == true) or (upDown == true and not upWasDown) then
                Menu.CurrentCategory = Menu.CurrentCategory - 1
                if Menu.CurrentCategory < 2 then
                    Menu.CurrentCategory = #Menu.Categories
                end
            elseif (downPressed == true) or (downDown == true and not downWasDown) then
                Menu.CurrentCategory = Menu.CurrentCategory + 1
                if Menu.CurrentCategory > #Menu.Categories then
                    Menu.CurrentCategory = 2
                end
            elseif (qPressed == true) or (qDown == true and not qWasDown) then
                if Menu.TopLevelTabs then
                    Menu.CurrentTopTab = Menu.CurrentTopTab - 1
                    if Menu.CurrentTopTab < 1 then Menu.CurrentTopTab = #Menu.TopLevelTabs end
                    Menu.UpdateCategoriesFromTopTab()
                end
            elseif (ePressed == true) or (eDown == true and not eWasDown) then
                if Menu.TopLevelTabs then
                    Menu.CurrentTopTab = Menu.CurrentTopTab + 1
                    if Menu.CurrentTopTab > #Menu.TopLevelTabs then Menu.CurrentTopTab = 1 end
                    Menu.UpdateCategoriesFromTopTab()
                end
            elseif (backPressed == true) or (backDown == true and not backWasDown) then
                Menu.Visible = false
            end
        end

        if Menu.IsKeyJustPressed(0x0D) then
            local category = Menu.Categories[Menu.CurrentCategory]
            if category and category.hasTabs and category.tabs then
                Menu.OpenedCategory = Menu.CurrentCategory
                Menu.CurrentTab = 1
                if category.tabs[1] and category.tabs[1].items then
                    Menu.CurrentItem = findNextNonSeparator(category.tabs[1].items, 0, 1)
                else
                    Menu.CurrentItem = 1
                end
                Menu.ItemScrollOffset = 0
            end
        end
    end
end


CreateThread(function()
    Menu.LoadingStartTime = GetGameTimer() or 0

    while Menu.IsLoading do
        local currentTime = GetGameTimer() or Menu.LoadingStartTime
        local elapsedTime = currentTime - Menu.LoadingStartTime

        Menu.LoadingProgress = (elapsedTime / Menu.LoadingDuration) * 100.0

        if Menu.LoadingProgress >= 100.0 then
            Menu.LoadingProgress = 100.0
            Menu.IsLoading = false
            Menu.LoadingComplete = true
            Menu.SelectingKey = true
            break
        end

        Wait(0)
    end
end)

CreateThread(function()
    while true do
        local renderOk, renderErr = pcall(Menu.Render)
        if not renderOk then
            print("Arcane Menu render error: " .. tostring(renderErr))
        end

        if Menu.LoadingComplete then
            local inputOk, inputErr = pcall(Menu.HandleInput)
            if not inputOk then
                print("Arcane Menu input error: " .. tostring(inputErr))
            end
        end

        Wait(0)
    end
end)


function Menu.OpenInput(title, subtitle, callback)
    if type(subtitle) == "function" then
        callback = subtitle
        subtitle = "Enter text below"
    end
    Menu.InputTitle = title
    Menu.InputSubtitle = subtitle
    Menu.InputText = ""
    Menu.InputCallback = callback
    Menu.InputOpen = true
    Menu.SelectingKey = false
    Menu.SelectingBind = false
end

function Menu.DrawInputWindow()
    if not Menu.InputOpen then return end
    
    local screenWidth = 1920
    local screenHeight = 1080
    if Susano and Susano.GetScreenWidth and Susano.GetScreenHeight then
        screenWidth = Susano.GetScreenWidth()
        screenHeight = Susano.GetScreenHeight()
    end
    
    if Susano and Susano.DrawRectFilled then
        Susano.DrawRectFilled(0, 0, screenWidth, screenHeight, 0, 0, 0, 0.6, 0)
    else
        Menu.DrawRect(0, 0, screenWidth, screenHeight, 0, 0, 0, 150)
    end
    
    local width = 350
    local height = 130
    local x = (screenWidth / 2) - (width / 2)
    local y = (screenHeight / 2) - (height / 2)
    
    if Susano and Susano.DrawRectFilled then
        Susano.DrawRectFilled(x, y, width, height, 0.08, 0.08, 0.08, 1.0, 6)
    else
        Menu.DrawRect(x, y, width, height, 20, 20, 20, 255)
    end
    
    local r = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.r) and (Menu.Colors.SelectedBg.r / 255.0) or 1.0
    local g = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.g) and (Menu.Colors.SelectedBg.g / 255.0) or 0.0
    local b = (Menu.Colors.SelectedBg and Menu.Colors.SelectedBg.b) and (Menu.Colors.SelectedBg.b / 255.0) or 1.0
    
    if Susano and Susano.DrawRectFilled then
        Susano.DrawRectFilled(x, y, width, 2, r, g, b, 1.0, 0)
    else
        Menu.DrawRect(x, y, width, 2, math.floor(r*255), math.floor(g*255), math.floor(b*255), 255)
    end
    
    local titleText = Menu.InputTitle or "Input"
    local titleSize = 20
    local titleWidth = Menu.GetTextWidth(titleText, titleSize)
    local titleX = x + (width / 2) - (titleWidth / 2)
    Menu.DrawText(titleX, y + 15, titleText, titleSize, 1.0, 1.0, 1.0, 1.0)
    
    local subText = Menu.InputSubtitle or "Enter text below:"
    Menu.DrawText(x + 20, y + 45, subText, 14, 0.7, 0.7, 0.7, 1.0)
    
    local boxW = width - 40
    local boxH = 30
    local boxX = x + 20
    local boxY = y + 70
    
    if Susano and Susano.DrawRectFilled then
        Susano.DrawRectFilled(boxX - 1, boxY - 1, boxW + 2, boxH + 2, 1.0, 1.0, 1.0, 0.8, 4)
        Susano.DrawRectFilled(boxX, boxY, boxW, boxH, 0.15, 0.15, 0.15, 1.0, 4)
    else
        Menu.DrawRect(boxX, boxY, boxW, boxH, 40, 40, 40, 255)
    end
    
    local displayText = Menu.InputText or ""
    if math.floor(GetGameTimer() / 500) % 2 == 0 then
        displayText = displayText .. "|"
    end
    
    local maxDisplayChars = 30
    if string.len(displayText) > maxDisplayChars then
        displayText = "..." .. string.sub(displayText, -maxDisplayChars)
    end
    
    Menu.DrawText(boxX + 10, boxY + 5, displayText, 16, 1.0, 1.0, 1.0, 1.0)
    
    if Susano and Susano.GetAsyncKeyState then
         if Menu.IsKeyJustPressed(0x0D) then
             Menu.InputOpen = false
             if Menu.InputCallback then
                 Menu.InputCallback(Menu.InputText)
             end
         end
         
         if Menu.IsKeyJustPressed(0x08) then
             if string.len(Menu.InputText) > 0 then
                 Menu.InputText = string.sub(Menu.InputText, 1, -2)
             end
         end
         
         if Menu.IsKeyJustPressed(0x1B) then
             Menu.InputOpen = false
         end
         
         local shiftPressed = false
         if Susano.GetAsyncKeyState(0x10) or Susano.GetAsyncKeyState(0xA0) or Susano.GetAsyncKeyState(0xA1) then
             shiftPressed = true
         end
         
         for i = 0x41, 0x5A do
             if Menu.IsKeyJustPressed(i) then
                 local char = string.char(i)
                 if not shiftPressed then
                     char = string.lower(char)
                 end
                 Menu.InputText = Menu.InputText .. char
             end
         end
         for i = 0x30, 0x39 do
             if Menu.IsKeyJustPressed(i) then
                 Menu.InputText = Menu.InputText .. string.char(i)
             end
         end
         if Menu.IsKeyJustPressed(0x20) then
             Menu.InputText = Menu.InputText .. " "
         end
         if Menu.IsKeyJustPressed(0xBD) then
             if shiftPressed then Menu.InputText = Menu.InputText .. "_" else Menu.InputText = Menu.InputText .. "-" end
         end
    end
end

if Menu.Banner.enabled and Menu.Banner.imageUrl then
    Menu.LoadBannerTexture(Menu.Banner.imageUrl)
end


return Menu
