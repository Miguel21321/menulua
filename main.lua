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
Menu.ShowSnowflakes = false
Menu.SelectorY = 0
Menu.CategorySelectorY = 0
Menu.TabSelectorX = 0
Menu.TabSelectorWidth = 0
Menu.SmoothFactor = 0.2
Menu.GradientType = 1
Menu.ScrollbarPosition = 2

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
    height = 94
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
    width = 364,
    itemHeight = 38,
    mainMenuHeight = 30,
    headerHeight = 94,
    footerHeight = 54,
    footerSpacing = 6,
    mainMenuSpacing = 6,
    footerRadius = 10,
    itemRadius = 7,
    scrollbarWidth = 6,
    scrollbarPadding = 6,
    headerRadius = 10
}
Menu.DefaultScaleMultiplier = 1.16
Menu.Scale = Menu.DefaultScaleMultiplier
Menu.TextRenderer = "susano"
Menu.TextFont = 0
Menu.TextNativeScaleDivisor = 50.0
Menu.TextNativeUseOutline = false
Menu.TextShadowEnabled = true
Menu.Fonts = {
    loaded = false,
    failed = false,
    handles = {},
    definitions = {
        body = { path = "C:/Windows/Fonts/segoeui.ttf", size = 16 },
        strong = { path = "C:/Windows/Fonts/seguisb.ttf", size = 17 },
        display = { path = "C:/Windows/Fonts/bahnschrift.ttf", size = 22 },
        mono = { path = "C:/Windows/Fonts/consola.ttf", size = 14 }
    }
}
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

function Menu.EnsureFontsLoaded()
    if not Menu.Fonts or Menu.Fonts.loaded or Menu.Fonts.failed then
        return
    end

    if not (Susano and Susano.LoadFont) then
        Menu.Fonts.failed = true
        return
    end

    for role, definition in pairs(Menu.Fonts.definitions or {}) do
        if definition and definition.path and definition.size then
            local ok, fontId = pcall(Susano.LoadFont, definition.path, definition.size)
            if ok and fontId and fontId ~= 0 then
                Menu.Fonts.handles[role] = fontId
            end
        end
    end

    Menu.Fonts.loaded = true
end

local function PushFontRole(role)
    if not role or not (Susano and Susano.PushFont) then
        return false
    end

    Menu.EnsureFontsLoaded()

    local handle = Menu.Fonts and Menu.Fonts.handles and Menu.Fonts.handles[role]
    if not handle then
        return false
    end

    Susano.PushFont(handle)
    return true
end

local function PopFontRole(pushed)
    if pushed and Susano and Susano.PopFont then
        Susano.PopFont()
    end
end

local function NormalizeColorComponent(value)
    local component = tonumber(value) or 0
    if component > 1.0 then
        component = component / 255.0
    end
    if component < 0.0 then
        component = 0.0
    elseif component > 1.0 then
        component = 1.0
    end
    return component
end

local function GetThemeAccentColor(multiplier)
    local factor = multiplier or 1.0
    local base = Menu.Colors.SelectedBg or { r = 0, g = 221, b = 255 }
    return math.min(1.0, NormalizeColorComponent(base.r) * factor),
        math.min(1.0, NormalizeColorComponent(base.g) * factor),
        math.min(1.0, NormalizeColorComponent(base.b) * factor)
end

local function GetMenuChromeColors()
    local accentR, accentG, accentB = GetThemeAccentColor(1.0)
    return {
        accentR = accentR,
        accentG = accentG,
        accentB = accentB,
        bodyTopR = 0.08, bodyTopG = 0.10, bodyTopB = 0.14,
        bodyBottomR = 0.03, bodyBottomG = 0.05, bodyBottomB = 0.08,
        rowTopR = 0.11, rowTopG = 0.14, rowTopB = 0.19,
        rowBottomR = 0.06, rowBottomG = 0.08, rowBottomB = 0.12,
        rowIdleTopR = 0.07, rowIdleTopG = 0.09, rowIdleTopB = 0.13,
        rowIdleBottomR = 0.04, rowIdleBottomG = 0.06, rowIdleBottomB = 0.09,
        textDimR = 0.69, textDimG = 0.77, textDimB = 0.84
    }
end

local function DrawAccentRule(x, y, width, height, alpha, rounding)
    local accentR, accentG, accentB = GetThemeAccentColor(1.0)
    local softR = accentR * 0.38
    local softG = accentG * 0.38
    local softB = accentB * 0.38

    if Susano and Susano.DrawRectGradient then
        Susano.DrawRectGradient(x, y, width, height,
            softR, softG, softB, 0.24 * alpha,
            accentR, accentG, accentB, 0.98 * alpha,
            accentR, accentG, accentB, 0.98 * alpha,
            softR, softG, softB, 0.24 * alpha,
            rounding or 0)
    elseif Susano and Susano.DrawRectFilled then
        Susano.DrawRectFilled(x, y, width, height, accentR, accentG, accentB, 0.95 * alpha, rounding or 0)
    else
        Menu.DrawRoundedRect(x, y, width, height,
            math.floor(accentR * 255), math.floor(accentG * 255), math.floor(accentB * 255), math.floor(242 * alpha), rounding or 0)
    end
end

local function DrawPanelSurface(x, y, width, height, radius, alpha, options)
    options = options or {}
    local chrome = GetMenuChromeColors()
    local bgAlpha = options.bgAlpha or (0.95 * alpha)
    local borderAlpha = options.borderAlpha or (0.52 * alpha)
    local shadowAlpha = options.shadowAlpha or (0.18 * alpha)

    if Susano and Susano.DrawRectFilled then
        Susano.DrawRectFilled(x + 4, y + 6, width, height, 0.0, 0.0, 0.0, shadowAlpha, radius)

        if Susano and Susano.DrawRectGradient then
            Susano.DrawRectGradient(x, y, width, height,
                chrome.bodyTopR, chrome.bodyTopG, chrome.bodyTopB, bgAlpha,
                chrome.bodyBottomR, chrome.bodyBottomG, chrome.bodyBottomB, bgAlpha,
                chrome.bodyBottomR, chrome.bodyBottomG, chrome.bodyBottomB, bgAlpha,
                chrome.bodyTopR, chrome.bodyTopG, chrome.bodyTopB, bgAlpha,
                radius)
        else
            Susano.DrawRectFilled(x, y, width, height, chrome.bodyTopR, chrome.bodyTopG, chrome.bodyTopB, bgAlpha, radius)
        end

        Susano.DrawRectFilled(x + 1, y + 1, math.max(0, width - 2), 1, 1.0, 1.0, 1.0, 0.06 * alpha, 0)
        Susano.DrawRectFilled(x + 1, y + 1, math.max(0, width - 2), math.max(1, 18 * (Menu.Scale or 1.0)),
            1.0, 1.0, 1.0, 0.02 * alpha, radius)
        if options.accentLine ~= false then
            DrawAccentRule(x + 1, y + 1, math.max(0, width - 2), math.max(2, 3 * (Menu.Scale or 1.0)), alpha, radius)
        end
        if Susano and Susano.DrawRect then
            Susano.DrawRect(x, y, width, height, chrome.accentR, chrome.accentG, chrome.accentB, borderAlpha, 1.0)
        end
    else
        Menu.DrawRoundedRect(x + 4, y + 6, width, height, 0, 0, 0, math.floor(46 * alpha), radius)
        Menu.DrawRoundedRect(x, y, width, height, 16, 20, 28, math.floor(bgAlpha * 255), radius)
        if options.accentLine ~= false then
            DrawAccentRule(x, y, width, math.max(2, 3 * (Menu.Scale or 1.0)), alpha, radius)
        end
    end
end

local function DrawMenuRowSurface(x, y, width, height, isSelected)
    local chrome = GetMenuChromeColors()
    local scale = Menu.Scale or 1.0
    local radius = math.max(2, (Menu.Position.itemRadius or 4) * scale)

    if Susano and Susano.DrawRectFilled then
        if isSelected then
            local accentR = math.min(1.0, chrome.accentR * 0.62 + 0.06)
            local accentG = math.min(1.0, chrome.accentG * 0.62 + 0.08)
            local accentB = math.min(1.0, chrome.accentB * 0.62 + 0.10)
            local stripWidth = math.max(2, 3 * scale)

            if Susano and Susano.DrawRectGradient then
                Susano.DrawRectGradient(x, y, width, height,
                    accentR, accentG, accentB, 0.34,
                    chrome.bodyTopR, chrome.bodyTopG, chrome.bodyTopB, 0.96,
                    chrome.bodyBottomR, chrome.bodyBottomG, chrome.bodyBottomB, 0.96,
                    accentR, accentG, accentB, 0.24,
                    radius)
            else
                Susano.DrawRectFilled(x, y, width, height, chrome.bodyTopR, chrome.bodyTopG, chrome.bodyTopB, 0.96, radius)
            end
            Susano.DrawRectFilled(x + 2, y + 2, math.max(0, width - 4), 1, 1.0, 1.0, 1.0, 0.16, 0)
            Susano.DrawRectFilled(x + (7 * scale), y + (4 * scale), stripWidth, math.max(4, height - (8 * scale)),
                chrome.accentR, chrome.accentG, chrome.accentB, 1.0, stripWidth / 2)
            if Susano and Susano.DrawRect then
                Susano.DrawRect(x, y, width, height, chrome.accentR, chrome.accentG, chrome.accentB, 0.28, 1.0)
            end
        else
            if Susano and Susano.DrawRectGradient then
                Susano.DrawRectGradient(x, y, width, height,
                    chrome.rowIdleTopR, chrome.rowIdleTopG, chrome.rowIdleTopB, 0.76,
                    chrome.bodyTopR, chrome.bodyTopG, chrome.bodyTopB, 0.70,
                    chrome.bodyBottomR, chrome.bodyBottomG, chrome.bodyBottomB, 0.70,
                    chrome.rowIdleBottomR, chrome.rowIdleBottomG, chrome.rowIdleBottomB, 0.76,
                    radius)
            else
                Susano.DrawRectFilled(x, y, width, height, 0.03, 0.03, 0.03, 0.58, radius)
            end
            Susano.DrawRectFilled(x, y + height - 1, width, 1, 1.0, 1.0, 1.0, 0.06, 0)
            if Susano and Susano.DrawRect then
                Susano.DrawRect(x, y, width, height, 1.0, 1.0, 1.0, 0.04, 1.0)
            end
        end
    else
        if isSelected then
            Menu.DrawRoundedRect(x, y, width, height,
                math.floor(chrome.accentR * 255), math.floor(chrome.accentG * 255), math.floor(chrome.accentB * 255), 220, radius)
        else
            Menu.DrawRoundedRect(x, y, width, height, 8, 8, 8, 148, radius)
        end
    end
end

local function DrawKeyBadge(text, anchorX, centerY, alignRight, active, alpha, size)
    local label = string.upper(tostring(text or ""))
    local badgeSize = size or 11
    local scale = Menu.Scale or 1.0
    local resolvedBadgeSize = math.max(1, badgeSize * scale)
    local badgeHeight = math.max(18, 18 * scale)
    local badgeWidth = math.max(badgeHeight + 6, Menu.GetTextWidth(label, badgeSize, "mono") + (16 * scale))
    local badgeX = alignRight and (anchorX - badgeWidth) or anchorX
    local badgeY = centerY - (badgeHeight / 2)
    local chrome = GetMenuChromeColors()

    local bgR = active and (chrome.accentR * 0.56) or chrome.bodyTopR
    local bgG = active and (chrome.accentG * 0.56) or chrome.bodyTopG
    local bgB = active and (chrome.accentB * 0.56) or chrome.bodyTopB
    local bgAlpha = active and (0.94 * (alpha or 1.0)) or (0.76 * (alpha or 1.0))

    if Susano and Susano.DrawRectFilled then
        if active and Susano.DrawRectGradient then
            Susano.DrawRectGradient(badgeX, badgeY, badgeWidth, badgeHeight,
                bgR, bgG, bgB, bgAlpha,
                chrome.bodyTopR, chrome.bodyTopG, chrome.bodyTopB, 0.96 * (alpha or 1.0),
                chrome.bodyBottomR, chrome.bodyBottomG, chrome.bodyBottomB, 0.96 * (alpha or 1.0),
                bgR, bgG, bgB, math.max(0.24, bgAlpha * 0.74),
                badgeHeight / 2)
        else
            Susano.DrawRectFilled(badgeX, badgeY, badgeWidth, badgeHeight, bgR, bgG, bgB, bgAlpha, badgeHeight / 2)
        end
        if Susano and Susano.DrawRect then
            Susano.DrawRect(badgeX, badgeY, badgeWidth, badgeHeight, chrome.accentR, chrome.accentG, chrome.accentB, 0.28 * (alpha or 1.0), 1.0)
        end
    else
        Menu.DrawRoundedRect(badgeX, badgeY, badgeWidth, badgeHeight,
            math.floor(bgR * 255), math.floor(bgG * 255), math.floor(bgB * 255), math.floor(bgAlpha * 255), badgeHeight / 2)
    end

    local labelWidth = Menu.GetTextWidth(label, badgeSize, "mono")
    local labelX = badgeX + (badgeWidth / 2) - (labelWidth / 2)
    local labelY = badgeY + (badgeHeight / 2) - (resolvedBadgeSize / 2)
    Menu.DrawText(labelX, labelY, label, badgeSize, 1.0, 1.0, 1.0, alpha or 1.0, "mono")

    return badgeWidth, badgeHeight, badgeX, badgeY
end

local function GetCategoryToken(categoryName)
    local map = {
        ["Miguelin"] = "MG",
        ["Farmeo Coca"] = "FC",
        ["Player"] = "PL",
        ["Online"] = "ON",
        ["Visual"] = "VS",
        ["Combat"] = "CB",
        ["Vehicle"] = "VH",
        ["Miscellaneous"] = "MS",
        ["Settings"] = "ST"
    }

    local token = map[tostring(categoryName or "")]
    if token then
        return token
    end

    local fallback = tostring(categoryName or "?")
    fallback = string.gsub(fallback, "%s+", "")
    return string.upper(string.sub(fallback, 1, math.min(2, #fallback)))
end

local function GetCategoryIconText(category)
    local name = category and tostring(category.name or "") or ""
    local fallbackMap = {
        ["Miguelin"] = "A",
        ["Farmeo Coca"] = "C",
        ["Player"] = "P",
        ["Online"] = "O",
        ["Visual"] = "V",
        ["Combat"] = "+",
        ["Vehicle"] = "V",
        ["Miscellaneous"] = "M",
        ["Settings"] = "S"
    }

    local icon = category and category.icon or nil
    if type(icon) == "string" and icon ~= "" then
        local lower = string.lower(icon)
        if string.find(lower, "ð") or string.find(lower, "â") then
            icon = nil
        end
    end

    if type(icon) == "string" and icon ~= "" then
        return icon
    end

    return fallbackMap[name] or GetCategoryToken(name)
end

local function GetFooterIdentityText()
    if GetPlayerName and PlayerId then
        local ok, playerName = pcall(function()
            return GetPlayerName(PlayerId())
        end)
        if ok and type(playerName) == "string" and playerName ~= "" then
            return playerName
        end
    end

    return "Arcane"
end

local function GetCurrentMenuTitle()
    if Menu.OpenedCategory and Menu.Categories then
        local category = Menu.Categories[Menu.OpenedCategory]
        if category and category.name and category.name ~= "" then
            return tostring(category.name)
        end
    end

    if Menu.Categories and Menu.Categories[1] and Menu.Categories[1].name then
        return tostring(Menu.Categories[1].name)
    end

    return "Main Menu"
end

local function GetCurrentMenuContext()
    if Menu.OpenedCategory and Menu.Categories then
        local category = Menu.Categories[Menu.OpenedCategory]
        local currentTab = category and category.tabs and category.tabs[Menu.CurrentTab]
        if currentTab and currentTab.name and currentTab.name ~= "" then
            return tostring(currentTab.name)
        end

        if category and category.name and category.name ~= "" then
            return tostring(category.name)
        end
    end

    if Menu.TopLevelTabs and Menu.TopLevelTabs[Menu.CurrentTopTab] and Menu.TopLevelTabs[Menu.CurrentTopTab].name then
        return tostring(Menu.TopLevelTabs[Menu.CurrentTopTab].name)
    end

    return "Navigation"
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

function Menu.GetTextWidth(text, size_px, fontRole)
    local resolvedText = tostring(text or "")
    local resolvedSize = ResolveTextSize(size_px)
    local pushed = PushFontRole(fontRole)

    if Susano and Susano.GetTextWidth then
        local width = Susano.GetTextWidth(resolvedText, resolvedSize)
        PopFontRole(pushed)
        return width
    end

    PopFontRole(pushed)
    return string.len(resolvedText) * (resolvedSize * 0.58)
end

function Menu.DrawText(x, y, text, size_px, r, g, b, a, fontRole)
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
        local pushed = PushFontRole(fontRole)
        Susano.DrawText(x, y, tostring(text or ""), resolvedSize, r, g, b, a)
        PopFontRole(pushed)
    end
end

function Menu.DrawTextEmphasis(x, y, text, size_px, r, g, b, a, fontRole)
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

    local pushed = PushFontRole(fontRole)
    local shadowOffset = resolvedSize >= 20 and 1 or 1
    local shadowAlpha = math.min(a * 0.38, 0.42)

    Susano.DrawText(x, y + shadowOffset, tostring(text or ""), resolvedSize, 0.0, 0.0, 0.0, shadowAlpha)
    Susano.DrawText(x, y, tostring(text or ""), resolvedSize, r, g, b, a)
    PopFontRole(pushed)
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

    Menu.InteractiveOverlayEnabled = desiredState

    if Susano and Susano.EnableOverlay then
        Susano.EnableOverlay(desiredState)
    end
end

local DrawClickableCursor

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
    local shouldBlock = ((Menu.Visible and Menu.BlockInputWhileOpen) or Menu.SelectingBind or Menu.SelectingKey or Menu.InputOpen)
    if not shouldBlock then
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
    local height = Menu.Banner.enabled and (Menu.Banner.height * scale) or scaledPos.headerHeight
    local chrome = GetMenuChromeColors()
    local headerRadius = math.max(8, (scaledPos.headerRadius or 0) + (2 * scale))
    local iconSize = 44 * scale
    local iconX = x + (16 * scale)
    local iconY = y + (18 * scale)
    local brandX = iconX + iconSize + (16 * scale)
    local titleY = y + (18 * scale)
    local subtitleY = y + (47 * scale)
    local previewWidth = 118 * scale
    local previewHeight = height - (28 * scale)
    local previewX = x + width - previewWidth - (14 * scale)
    local previewY = y + (14 * scale)
    local chipLabel = Menu.OpenedCategory and "ACTIVE MODULE" or "MAIN MENU"
    local chipPadding = 12 * scale
    local chipWidth = Menu.GetTextWidth(chipLabel, 10, "mono") + (chipPadding * 2)
    local chipX = previewX + previewWidth - chipWidth - (10 * scale)
    local chipY = previewY + (8 * scale)
    local previewTitle = string.upper(GetCurrentMenuContext())

    DrawPanelSurface(x, y, width, height, headerRadius, 1.0, {
        bgAlpha = 0.98,
        borderAlpha = 0.48,
        shadowAlpha = 0.20,
        accentLine = false
    })

    if Susano and Susano.DrawRectGradient then
        Susano.DrawRectGradient(x + 1, y + 1, width - 2, height - 2,
            chrome.rowTopR, chrome.rowTopG, chrome.rowTopB, 0.22,
            chrome.bodyTopR, chrome.bodyTopG, chrome.bodyTopB, 0.06,
            chrome.bodyBottomR, chrome.bodyBottomG, chrome.bodyBottomB, 0.02,
            chrome.accentR * 0.32, chrome.accentG * 0.32, chrome.accentB * 0.32, 0.18,
            headerRadius)
    end

    if Susano and Susano.DrawCircle then
        Susano.DrawCircle(x + width - (44 * scale), y + (18 * scale), 46 * scale, true,
            chrome.accentR, chrome.accentG, chrome.accentB, 0.08, 1.0, 32)
        Susano.DrawCircle(x + width - (26 * scale), y + height - (18 * scale), 34 * scale, true,
            chrome.accentR, chrome.accentG, chrome.accentB, 0.05, 1.0, 28)
    end

    if Susano and Susano.DrawRectGradient then
        Susano.DrawRectGradient(iconX, iconY, iconSize, iconSize,
            chrome.accentR, chrome.accentG, chrome.accentB, 0.98,
            chrome.accentR * 0.78, chrome.accentG * 0.78, chrome.accentB * 0.78, 0.98,
            chrome.accentR * 0.58, chrome.accentG * 0.58, chrome.accentB * 0.58, 0.98,
            chrome.accentR, chrome.accentG, chrome.accentB, 0.98,
            8 * scale)
    elseif Susano and Susano.DrawRectFilled then
        Susano.DrawRectFilled(iconX, iconY, iconSize, iconSize, chrome.accentR, chrome.accentG, chrome.accentB, 0.96, 8 * scale)
    else
        Menu.DrawRoundedRect(iconX, iconY, iconSize, iconSize,
            math.floor(chrome.accentR * 255), math.floor(chrome.accentG * 255), math.floor(chrome.accentB * 255), 246, 8 * scale)
    end

    local iconLetter = "A"
    local iconLetterWidth = Menu.GetTextWidth(iconLetter, 22, "display")
    Menu.DrawTextEmphasis(iconX + (iconSize / 2) - (iconLetterWidth / 2), iconY + (10 * scale), iconLetter, 22, 0.06, 0.09, 0.12, 1.0, "display")
    Menu.DrawTextEmphasis(brandX, titleY, "Arcane", 24, 1.0, 1.0, 1.0, 1.0, "display")
    Menu.DrawText(brandX, subtitleY, "CONTROL SUITE", 11, chrome.textDimR, chrome.textDimG, chrome.textDimB, 0.92, "strong")

    DrawPanelSurface(previewX, previewY, previewWidth, previewHeight, 9 * scale, 1.0, {
        bgAlpha = 0.72,
        borderAlpha = 0.24,
        shadowAlpha = 0.12,
        accentLine = false
    })

    if Menu.Banner.enabled and Menu.bannerTexture and Menu.bannerTexture > 0 and Susano and Susano.DrawImage then
        Susano.DrawImage(Menu.bannerTexture, previewX + 1, previewY + 1, previewWidth - 2, previewHeight - 2, 1.0, 1.0, 1.0, 0.18, 9 * scale)
    end

    if Susano and Susano.DrawRectGradient then
        Susano.DrawRectGradient(previewX + 1, previewY + 1, previewWidth - 2, previewHeight - 2,
            chrome.bodyTopR, chrome.bodyTopG, chrome.bodyTopB, 0.78,
            chrome.bodyBottomR, chrome.bodyBottomG, chrome.bodyBottomB, 0.46,
            chrome.bodyBottomR, chrome.bodyBottomG, chrome.bodyBottomB, 0.74,
            chrome.bodyTopR, chrome.bodyTopG, chrome.bodyTopB, 0.92,
            9 * scale)
    end

    DrawKeyBadge(chipLabel, chipX + chipWidth, chipY + (9 * scale), true, true, 0.94, 10)
    local previewBadgeX = previewX + (14 * scale)
    local previewBadgeY = previewY + previewHeight - (29 * scale)
    local previewWordmark = Menu.OpenedCategory and string.upper(GetCurrentMenuTitle()) or "ARCANE MENU"
    if #previewWordmark > 13 then
        previewWordmark = string.sub(previewWordmark, 1, 11) .. ".."
    end
    if #previewTitle > 16 then
        previewTitle = string.sub(previewTitle, 1, 14) .. ".."
    end
    Menu.DrawTextEmphasis(previewBadgeX, previewY + (15 * scale), "AS", 22, 0.42, 0.64, 0.78, 0.94, "display")
    Menu.DrawText(previewBadgeX + (34 * scale), previewY + (20 * scale), previewWordmark, 10, chrome.textDimR, chrome.textDimG, chrome.textDimB, 0.88, "mono")
    Menu.DrawText(previewBadgeX, previewBadgeY, previewTitle, 10, 1.0, 1.0, 1.0, 0.92, "mono")

    DrawAccentRule(x, y, width, math.max(2, 2 * scale), 1.0, 0)
    DrawAccentRule(x, y + height - (3 * scale), width, math.max(2, 3 * scale), 0.94, 0)
end

function Menu.DrawScrollbar(x, startY, visibleHeight, selectedIndex, totalItems, isMainMenu, menuWidth)
    if totalItems < 1 then
        return
    end

    local scaledPos = Menu.GetScaledPosition()
    local scrollbarWidth = scaledPos.scrollbarWidth
    local scrollbarPadding = scaledPos.scrollbarPadding
    local scale = Menu.Scale or 1.0
    local width = menuWidth or scaledPos.width

    local scrollbarX
    if Menu.ScrollbarPosition == 2 then
        scrollbarX = x + width - scrollbarWidth - scrollbarPadding
    else
        scrollbarX = x + scrollbarPadding
    end

    local scrollbarY = startY
    local scrollbarHeight = visibleHeight

    local adjustedIndex = selectedIndex
    if isMainMenu then
        adjustedIndex = selectedIndex - 1
    end


    local visibleSlots = math.min(Menu.ItemsPerPage, math.max(1, totalItems))
    local thumbHeight = scrollbarHeight
    if totalItems > visibleSlots then
        thumbHeight = math.max(28 * scale, scrollbarHeight * (visibleSlots / totalItems))
    end
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

    local chrome = GetMenuChromeColors()
    local thumbPadding = 1

    if Susano and Susano.DrawRectFilled then
        local trackX = scrollbarX + (scrollbarWidth / 2) - 1
        Susano.DrawRectFilled(scrollbarX, scrollbarY, scrollbarWidth, scrollbarHeight, 0.03, 0.05, 0.07, 0.62, scrollbarWidth / 2)
        Susano.DrawRectFilled(trackX, scrollbarY + (3 * scale), 2, math.max(0, scrollbarHeight - (6 * scale)), 1.0, 1.0, 1.0, 0.06, 1)
        Susano.DrawRectFilled(scrollbarX, Menu.scrollbarY, scrollbarWidth, Menu.scrollbarHeight,
            0.04, 0.06, 0.09, 0.88,
            scrollbarWidth / 2)
        Susano.DrawRectFilled(scrollbarX + thumbPadding, Menu.scrollbarY + thumbPadding,
            math.max(1, scrollbarWidth - (thumbPadding * 2)), math.max(1, Menu.scrollbarHeight - (thumbPadding * 2)),
            chrome.accentR, chrome.accentG, chrome.accentB, 0.96,
            math.max(1, (scrollbarWidth - (thumbPadding * 2)) / 2))
        if Susano and Susano.DrawRect then
            Susano.DrawRect(scrollbarX, Menu.scrollbarY, scrollbarWidth, Menu.scrollbarHeight,
                chrome.accentR, chrome.accentG, chrome.accentB, 0.36, 1.0)
        end
    else
        Menu.DrawRoundedRect(scrollbarX + thumbPadding, Menu.scrollbarY + thumbPadding,
            math.max(1, scrollbarWidth - (thumbPadding * 2)), math.max(1, Menu.scrollbarHeight - (thumbPadding * 2)),
            math.floor(chrome.accentR * 255), math.floor(chrome.accentG * 255), math.floor(chrome.accentB * 255), 255,
            math.max(1, (scrollbarWidth - (thumbPadding * 2)) / 2))
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
    local chrome = GetMenuChromeColors()

    if Susano and Susano.DrawRectFilled then
        if Susano and Susano.DrawRectGradient then
            Susano.DrawRectGradient(x, startY, width, tabHeight,
                chrome.rowTopR, chrome.rowTopG, chrome.rowTopB, 0.90,
                chrome.bodyTopR, chrome.bodyTopG, chrome.bodyTopB, 0.94,
                chrome.bodyBottomR, chrome.bodyBottomG, chrome.bodyBottomB, 0.94,
                chrome.rowBottomR, chrome.rowBottomG, chrome.rowBottomB, 0.90,
                8 * scale)
        else
            Susano.DrawRectFilled(x, startY, width, tabHeight, 0.03, 0.04, 0.06, 0.92, 7 * scale)
        end
    else
        Menu.DrawRoundedRect(x, startY, width, tabHeight, 8, 10, 14, 234, 7 * scale)
    end

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
            if Susano and Susano.DrawRectGradient then
                Susano.DrawRectGradient(drawX, startY, drawWidth, tabHeight,
                    chrome.accentR, chrome.accentG, chrome.accentB, 0.42,
                    chrome.bodyTopR, chrome.bodyTopG, chrome.bodyTopB, 0.98,
                    chrome.bodyBottomR, chrome.bodyBottomG, chrome.bodyBottomB, 0.98,
                    chrome.accentR, chrome.accentG, chrome.accentB, 0.32,
                    7 * scale)
            elseif Susano and Susano.DrawRectFilled then
                Susano.DrawRectFilled(drawX, startY, drawWidth, tabHeight, chrome.bodyTopR, chrome.bodyTopG, chrome.bodyTopB, 0.96, 7 * scale)
            else
                Menu.DrawRoundedRect(drawX, startY, drawWidth, tabHeight, 22, 28, 36, 246, 7 * scale)
            end

            DrawAccentRule(drawX + 1, startY + tabHeight - (3 * scale), math.max(0, drawWidth - 2), math.max(2, 2 * scale), 1.0, 0)
        end

        local textSize = 16
        local scaledTextSize = ResolveTextSize(textSize)
        local textY = startY + tabHeight / 2 - (scaledTextSize / 2) + (1 * scale)
        local textWidth = Menu.GetTextWidth(tab.name, textSize)
        local textX = tabX + (currentTabWidth / 2) - (textWidth / 2)
        if isSelected then
            Menu.DrawTextEmphasis(textX, textY, tab.name, textSize, 1.0, 1.0, 1.0, 0.98)
        else
            Menu.DrawText(textX, textY, tab.name, textSize, chrome.textDimR, chrome.textDimG, chrome.textDimB, 0.86)
        end

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
    local chrome = GetMenuChromeColors()
    
    if item.isSeparator then
        if Susano and Susano.DrawRectFilled then
            Susano.DrawRectFilled(x, itemY, width, itemHeight, 0.03, 0.04, 0.06, 0.78, math.max(5, Menu.Position.itemRadius * scale * 0.60))
        else
            Menu.DrawRoundedRect(x, itemY, width, itemHeight, 8, 10, 14, 198, math.max(5, Menu.Position.itemRadius * scale * 0.60))
        end

        if item.separatorText then
            local textY = itemY + itemHeight / 2 - (7 * scale)
            local textWidth = Menu.GetTextWidth(item.separatorText, 14)

            local textX = x + (width / 2) - (textWidth / 2)

            Menu.DrawText(textX, textY, item.separatorText, 14, chrome.textDimR, chrome.textDimG, chrome.textDimB, 0.94)

            local barY = itemY + (itemHeight / 2)
            local barSpacing = 10 * scale
            local barMaxLength = 72 * scale
            local barHeight = math.max(1, 1 * scale)
            local barRadius = 0.5 * scale

            local leftBarX = textX - barSpacing - barMaxLength
            local leftBarWidth = math.min(barMaxLength, textX - leftBarX - barSpacing)
            if leftBarWidth > 0 and leftBarX >= x + 15 then
                if Susano and Susano.DrawRectFilled then
                    Susano.DrawRectFilled(leftBarX, math.floor(barY), leftBarWidth, barHeight,
                        chrome.accentR, chrome.accentG, chrome.accentB, 0.24,
                        barRadius)
                else
                    Menu.DrawRect(leftBarX, math.floor(barY), leftBarWidth, barHeight,
                        math.floor(chrome.accentR * 255), math.floor(chrome.accentG * 255), math.floor(chrome.accentB * 255), 62)
                end
            end

            local rightBarX = textX + textWidth + barSpacing
            local rightBarWidth = math.min(barMaxLength, (x + width - 15) - rightBarX)
            if rightBarWidth > 0 and rightBarX + rightBarWidth <= x + width - 15 then
                if Susano and Susano.DrawRectFilled then
                    Susano.DrawRectFilled(rightBarX, math.floor(barY), rightBarWidth, barHeight,
                        chrome.accentR, chrome.accentG, chrome.accentB, 0.24,
                        barRadius)
                else
                    Menu.DrawRect(rightBarX, math.floor(barY), rightBarWidth, barHeight,
                        math.floor(chrome.accentR * 255), math.floor(chrome.accentG * 255), math.floor(chrome.accentB * 255), 62)
                end
            end
        end
        return
    end

    DrawMenuRowSurface(x, itemY, width, itemHeight, false)

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
        DrawMenuRowSurface(x, drawY, width, itemHeight, true)
    end

    local textX = x + (18 * scale)
    local textY = itemY + itemHeight / 2 - (8 * scale)
    local textSize = 17 * scale
    if isSelected then
        Menu.DrawTextEmphasis(textX, textY, item.name, 17, 1.0, 1.0, 1.0, 1.0, "strong")
    else
        Menu.DrawText(textX, textY, item.name, 17, 1.0, 1.0, 1.0, 0.98, "body")
    end

    local actionBadgeWidth = 0
    if item.type == "action" and item.bindKeyName then
        actionBadgeWidth = DrawKeyBadge(item.bindKeyName, x + width - (36 * scale), itemY + (itemHeight / 2), true, false, 0.94, 10)
    end

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
                    0.10, 0.12, 0.15, 0.95,
                    toggleRadius)
            else
                Menu.DrawRoundedRect(toggleX, toggleY, toggleWidth, toggleHeight,
                    25, 31, 38, 242,
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

        local circleR, circleG, circleB = 1.0, 1.0, 1.0

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
                Susano.DrawRectFilled(toggleX, toggleY, toggleWidth, toggleHeight, 0.10, 0.12, 0.15, 0.95, toggleRadius)
            else
                Menu.DrawRoundedRect(toggleX, toggleY, toggleWidth, toggleHeight, 25, 31, 38, 242, toggleRadius)
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

        local circleR, circleG, circleB = 1.0, 1.0, 1.0

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
    elseif item.type == "action" then
        local chevronX = x + width - (26 * scale)
        if actionBadgeWidth > 0 then
            chevronX = chevronX - actionBadgeWidth - (10 * scale)
        end
        Menu.DrawText(chevronX, textY, ">", 17, isSelected and 1.0 or chrome.textDimR, isSelected and 1.0 or chrome.textDimG, isSelected and 1.0 or chrome.textDimB, 0.94, "strong")
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
    local chrome = GetMenuChromeColors()

    if Susano and Susano.DrawRectFilled then
        Susano.DrawRectFilled(x, itemY, width, mainMenuHeight, 0.03, 0.04, 0.06, 0.94, 8 * scale)
    else
        Menu.DrawRoundedRect(x, itemY, width, mainMenuHeight, 8, 10, 14, 240, 8 * scale)
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

                if Susano and Susano.DrawRectGradient then
                    Susano.DrawRectGradient(drawX, itemY, drawWidth, mainMenuHeight,
                        chrome.accentR, chrome.accentG, chrome.accentB, 0.82,
                        chrome.bodyTopR, chrome.bodyTopG, chrome.bodyTopB, 0.96,
                        chrome.bodyTopR, chrome.bodyTopG, chrome.bodyTopB, 0.96,
                        chrome.accentR, chrome.accentG, chrome.accentB, 0.74,
                        8 * scale)
                elseif Susano and Susano.DrawRectFilled then
                    Susano.DrawRectFilled(drawX, itemY, drawWidth, mainMenuHeight, chrome.bodyTopR, chrome.bodyTopG, chrome.bodyTopB, 0.96, 8 * scale)
                else
                    Menu.DrawRoundedRect(drawX, itemY, drawWidth, mainMenuHeight, 22, 28, 36, 246, 8 * scale)
                end

                DrawAccentRule(drawX + 1, itemY + mainMenuHeight - (3 * scale), math.max(0, drawWidth - 2), math.max(2, 2 * scale), 1.0, 0)
            end
            
            local text = tab.name
            local textSize = 16
            local textWidth = Menu.GetTextWidth(text, textSize, isSelected and "strong" or "body")
            
            local textX = tabX + (tabWidth / 2) - (textWidth / 2)
            local textY = itemY + mainMenuHeight / 2 - 7
            
            if isSelected then
                Menu.DrawTextEmphasis(textX, textY, text, textSize, 1.0, 1.0, 1.0, 0.98, "strong")
            else
                Menu.DrawText(textX, textY, text, textSize, chrome.textDimR, chrome.textDimG, chrome.textDimB, 0.84, "body")
            end
        end
    else
        local labelText = Menu.Categories[1] and Menu.Categories[1].name or "Main Menu"
        local textY = itemY + mainMenuHeight / 2 - 7
        local textX = x + (16 * scale)
        Menu.DrawTextEmphasis(textX, textY, labelText, 16, 1.0, 1.0, 1.0, 0.98, "strong")
        local helperText = "Navigation"
        local helperWidth = Menu.GetTextWidth(helperText, 11, "mono")
        local helperX = x + width - helperWidth - (14 * scale)
        Menu.DrawText(helperX, itemY + (mainMenuHeight / 2) - (5 * scale), helperText, 11, chrome.textDimR, chrome.textDimG, chrome.textDimB, 0.84, "mono")
    end

    local actualVisibleCount = 0
    for displayIndex = 1, math.min(maxVisible, totalCategories) do
        local categoryIndex = displayIndex + Menu.CategoryScrollOffset + 1
        if categoryIndex <= #Menu.Categories then
            actualVisibleCount = actualVisibleCount + 1
            local category = Menu.Categories[categoryIndex]
            local isSelected = (categoryIndex == Menu.CurrentCategory)

            local itemY = startY + mainMenuHeight + mainMenuSpacing + (displayIndex - 1) * itemHeight
            DrawMenuRowSurface(x, itemY, width, itemHeight, false)

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
                DrawMenuRowSurface(x, drawY, width, itemHeight, true)
            end

            local token = GetCategoryToken(category.name)
            local tokenWidth = DrawKeyBadge(token, x + (16 * scale), itemY + (itemHeight / 2), false, isSelected, 0.96, 10)
            local textX = x + (16 * scale) + tokenWidth + (10 * scale)
            local textY = itemY + itemHeight / 2 - (8 * scale)
            if isSelected then
                Menu.DrawTextEmphasis(textX, textY, category.name, 17, 1.0, 1.0, 1.0, 1.0, "strong")
            else
                Menu.DrawText(textX, textY, category.name, 17, 1.0, 1.0, 1.0, 0.98, "body")
            end

            local chevronX = x + width - (26 * scale)
            Menu.DrawText(chevronX, textY, ">", 17, isSelected and 1.0 or chrome.textDimR, isSelected and 1.0 or chrome.textDimG, isSelected and 1.0 or chrome.textDimB, 0.94, "strong")
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

local function GetCurrentBindableMenuItem()
    if not Menu.OpenedCategory or not Menu.Categories then
        return nil
    end

    local category = Menu.Categories[Menu.OpenedCategory]
    local currentTab = category and category.tabs and category.tabs[Menu.CurrentTab]
    local item = currentTab and currentTab.items and currentTab.items[Menu.CurrentItem]
    if item and not item.isSeparator and (item.type == "toggle" or item.type == "action") then
        return item
    end

    return nil
end

local function GetBindHintText()
    local bindItem = GetCurrentBindableMenuItem()
    if bindItem and bindItem.name and bindItem.name ~= "" then
        local itemName = tostring(bindItem.name)
        if #itemName > 22 then
            itemName = string.sub(itemName, 1, 19) .. "..."
        end
        return "to bind " .. itemName
    end

    return "to set a keybind"
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
    local chrome = GetMenuChromeColors()

    DrawPanelSurface(x, footerY, footerWidth, footerHeight, footerRounding, 1.0, {
        bgAlpha = 0.96,
        borderAlpha = 0.42,
        shadowAlpha = 0.14
    })

    local footerPadding = 14 * scale
    local footerLabel = string.lower(GetFooterIdentityText()) .. " | " .. string.lower(GetCurrentMenuContext())
    local footerLabelY = footerY + (7 * scale)
    Menu.DrawText(x + footerPadding, footerLabelY, footerLabel, 10, chrome.textDimR, chrome.textDimG, chrome.textDimB, 0.92, "mono")

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
    DrawKeyBadge(posText, x + footerWidth - footerPadding, footerY + (11 * scale), true, true, 0.98, 11)

    local hintY = footerY + footerHeight - (18 * scale)
    local prefix = "Press"
    local prefixWidth = Menu.GetTextWidth(prefix, 12, "strong")
    local prefixX = x + footerPadding
    Menu.DrawText(prefixX, hintY, prefix, 12, 1.0, 1.0, 1.0, 0.96, "strong")

    local bindKeyLabel = Menu.BindShortcutLabel or Menu.GetKeyName(Menu.BindShortcutKey or 0x79)
    local badgeAnchorX = prefixX + prefixWidth + (10 * scale)
    local badgeWidth = DrawKeyBadge(bindKeyLabel, badgeAnchorX, hintY + (8 * scale), false, true, 0.98, 11)

    local suffixText = GetBindHintText()
    local suffixX = badgeAnchorX + badgeWidth + (10 * scale)
    Menu.DrawText(suffixX, hintY, suffixText, 12, chrome.textDimR, chrome.textDimG, chrome.textDimB, 0.94, "body")
end

function Menu.DrawKeySelector(alpha)
    if alpha <= 0 then return end

    local screenWidth = 1920
    local screenHeight = 1080
    if Susano and Susano.GetScreenWidth and Susano.GetScreenHeight then
        screenWidth = Susano.GetScreenWidth()
        screenHeight = Susano.GetScreenHeight()
    end

    local scale = Menu.Scale or 1.0
    local padding = 18 * scale
    local cornerRadius = 12 * scale
    local barHeight = 3 * scale
    local textSize = 13
    local headerHeight = 44 * scale

    local width = 430 * scale
    local startX = math.floor((screenWidth - width) / 2)
    local startY = math.floor(screenHeight - (194 * scale))

    local itemName = Menu.BindingItem and (Menu.BindingItem.name or "Option") or "Menu Toggle"
    local keyName = Menu.BindingItem and Menu.BindingKeyName or Menu.SelectedKeyName
    if not keyName then keyName = "..." end
    local totalHeight = (146 * scale)
    local chrome = GetMenuChromeColors()
    local cardX = startX + padding
    local cardY = startY + headerHeight + (10 * scale)
    local cardWidth = width - (padding * 2)
    local cardHeight = 44 * scale

    DrawPanelSurface(startX, startY, width, totalHeight, cornerRadius, alpha, {
        bgAlpha = 0.98 * alpha,
        borderAlpha = 0.66 * alpha
    })

    if Susano and Susano.DrawRectGradient then
        Susano.DrawRectGradient(startX + 1, startY + 1, width - 2, headerHeight,
            chrome.rowTopR, chrome.rowTopG, chrome.rowTopB, 0.92 * alpha,
            chrome.bodyTopR, chrome.bodyTopG, chrome.bodyTopB, 0.82 * alpha,
            chrome.bodyTopR, chrome.bodyTopG, chrome.bodyTopB, 0.76 * alpha,
            chrome.accentR * 0.34, chrome.accentG * 0.34, chrome.accentB * 0.34, 0.18 * alpha,
            cornerRadius)
    end

    local title = "KEYBIND CAPTURE"
    local titleX = startX + padding
    local titleY = startY + (13 * scale)
    Menu.DrawTextEmphasis(titleX, titleY, title, textSize, 1.0, 1.0, 1.0, 1.0 * alpha, "mono")

    local stepText = "PRESS A KEY AND CONFIRM WITH ENTER"
    local stepTextSize = 10
    local stepTextWidth = Menu.GetTextWidth(stepText, stepTextSize, "mono")
    Menu.DrawText(startX + width - stepTextWidth - padding, titleY + (1 * scale), stepText, stepTextSize, chrome.textDimR, chrome.textDimG, chrome.textDimB, 0.92 * alpha, "mono")

    local barY = startY + headerHeight
    DrawAccentRule(startX + padding, barY, width - (padding * 2), barHeight, alpha, 0)

    DrawPanelSurface(cardX, cardY, cardWidth, cardHeight, 9 * scale, alpha, {
        bgAlpha = 0.62 * alpha,
        borderAlpha = 0.22 * alpha,
        shadowAlpha = 0.08 * alpha,
        accentLine = false
    })

    local iconBoxSize = 26 * scale
    local iconBoxX = cardX + (10 * scale)
    local iconBoxY = cardY + (cardHeight / 2) - (iconBoxSize / 2)
    if Susano and Susano.DrawRectGradient then
        Susano.DrawRectGradient(iconBoxX, iconBoxY, iconBoxSize, iconBoxSize,
            chrome.accentR, chrome.accentG, chrome.accentB, 0.96 * alpha,
            chrome.accentR * 0.72, chrome.accentG * 0.72, chrome.accentB * 0.72, 0.96 * alpha,
            chrome.accentR * 0.52, chrome.accentG * 0.52, chrome.accentB * 0.52, 0.96 * alpha,
            chrome.accentR, chrome.accentG, chrome.accentB, 0.96 * alpha,
            6 * scale)
    elseif Susano and Susano.DrawRectFilled then
        Susano.DrawRectFilled(iconBoxX, iconBoxY, iconBoxSize, iconBoxSize, chrome.accentR, chrome.accentG, chrome.accentB, 0.94 * alpha, 6 * scale)
    end

    local iconText = ">"
    local iconTextWidth = Menu.GetTextWidth(iconText, 14, "strong")
    Menu.DrawTextEmphasis(iconBoxX + (iconBoxSize / 2) - (iconTextWidth / 2), iconBoxY + (4 * scale), iconText, 14, 0.06, 0.08, 0.12, 1.0 * alpha, "strong")

    local labelY = cardY + (8 * scale)
    Menu.DrawTextEmphasis(cardX + (iconBoxSize + 22 * scale), labelY, itemName, 14, 1.0, 1.0, 1.0, 1.0 * alpha, "strong")
    Menu.DrawText(cardX + (iconBoxSize + 22 * scale), labelY + (17 * scale), "Selected key", 11, chrome.textDimR, chrome.textDimG, chrome.textDimB, 0.94 * alpha, "body")

    local keyBadgeCenterY = cardY + (cardHeight / 2)
    DrawKeyBadge(keyName, startX + width - padding - 8, keyBadgeCenterY, true, true, alpha, 14)

    local helperY = startY + totalHeight - (28 * scale)
    local helperText = "ESC, BACKSPACE AND FUNCTION KEYS CAN STILL BE ASSIGNED."
    Menu.DrawText(startX + padding, helperY, helperText, 10, chrome.textDimR, chrome.textDimG, chrome.textDimB, 0.84 * alpha, "mono")
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

    return width, height
end

local function buildKeybindRows()
    local rows = {}
    local menuKeyCode = Menu.SelectedKey or 0x31
    local menuKeyName = Menu.SelectedKeyName or Menu.GetKeyName(menuKeyCode)

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
        return 0, 0
    end

    local rows = buildKeybindRows()
    local screenWidth = getOverlayScreenSize()
    local panelX = (screenWidth - 20) + (tonumber(Menu.KeybindsPanelOffsetX) or 0)
    local panelY = (startY or 20) + (tonumber(Menu.KeybindsPanelOffsetY) or 0)
    return Menu.DrawOverlayPanel("Keybinds", rows, panelX, panelY, alpha, {
        alignRight = true,
        minWidth = 230,
        clampToScreen = true
    })
end

function Menu.DrawSpectatorList(alpha, startY)
    if alpha <= 0 then
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
    return Menu.DrawOverlayPanel("Spectators", rows, panelX, panelY, alpha, {
        alignRight = true,
        minWidth = 210,
        clampToScreen = true
    })
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
    local startY = scaledPos.y
    local scale = Menu.Scale or 1.0
    local bannerHeight = Menu.Banner.enabled and (Menu.Banner.height * scale) or scaledPos.headerHeight
    local headerH = bannerHeight
    local footerSegment = segments[#segments]
    local contentY = startY + headerH
    local contentEndY = footerSegment and (footerSegment.y + footerSegment.h) or (startY + fullHeight)
    local contentHeight = math.max(0, contentEndY - contentY)
    local totalMenuHeight = math.max(0, contentEndY - y)

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
                    if blackBackgroundItem then break end
                end
            end
            if blackBackgroundItem then break end
        end
    end

    if totalMenuHeight > 0 and Susano and Susano.DrawRectFilled then
        Susano.DrawRectFilled(x + (8 * scale), y + (10 * scale), width, totalMenuHeight, 0.0, 0.0, 0.0, 0.18, 14 * scale)
        Susano.DrawRectFilled(x + (3 * scale), y + (4 * scale), width, totalMenuHeight, 0.0, 0.0, 0.0, 0.10, 14 * scale)
    end

    local bgAlpha = (blackBackgroundItem and blackBackgroundItem.value == false) and 0.68 or 0.92
    if contentHeight > 0 then
        DrawPanelSurface(x, contentY, width, contentHeight, scaledPos.footerRadius + (2 * scale), 1.0, {
            bgAlpha = bgAlpha,
            borderAlpha = 0.26,
            shadowAlpha = 0.14,
            accentLine = false
        })
        DrawAccentRule(x, contentY, width, math.max(2, 2 * scale), 0.72, 0)
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


function Menu.Render()
    if Menu.TopLevelTabs and not Menu.Categories then
        Menu.UpdateCategoriesFromTopTab()
    end

    if not (Susano and Susano.BeginFrame) then
        return
    end

    Menu.EnsureFontsLoaded()

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

    local useInteractiveOverlay = (Menu.Visible and Menu.ClickableMenu) or Menu.EditorMode or Menu.SelectingBind or Menu.SelectingKey or Menu.InputOpen
    SetInteractiveOverlayState(useInteractiveOverlay == true)

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

    if Menu.Visible then
        Menu.DrawBackground()
        Menu.DrawHeader()
        Menu.DrawCategories()
        Menu.DrawFooter()
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
    0x20, 0x1B, 0x08, 0x09, 0x11, 0x12,
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
    local suppressedKey = Menu.SuppressCaptureUntilRelease

    for _, keyCode in ipairs(Menu.BindableKeys) do
        if keyCode ~= 0x0D then
            local down, pressed = Menu.GetKeyState(keyCode)
            local wasDown = Menu.KeyStates[keyCode] or false

            if down == true then
                Menu.KeyStates[keyCode] = true
            else
                Menu.KeyStates[keyCode] = false
            end

            if suppressedKey and keyCode == suppressedKey then
                if down ~= true then
                    Menu.SuppressCaptureUntilRelease = nil
                    suppressedKey = nil
                end
            elseif pressed == true or (down == true and not wasDown) then
                return keyCode
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
    elseif item.name == "Editor Mode" then
        Menu.EditorMode = item.value == true
    elseif item.name == "Flakes" then
        Menu.ShowSnowflakes = item.value == true
    elseif item.name == "Blossoms" then
        Menu.ShowBlossoms = item.value == true
    elseif item.name == "Show Spectator List" then
        Menu.ShowSpectatorList = item.value == true
    end

    SetInteractiveOverlayState((Menu.Visible and Menu.ClickableMenu) or Menu.EditorMode)
end

local function IsPointInRect(px, py, x, y, width, height)
    return px >= x and px <= (x + width) and py >= y and py <= (y + height)
end

local function ResolveOverlayCursorPosition()
    if not (Susano and Susano.GetCursorPos) then
        return nil
    end

    local cursorPos, cursorPosY = Susano.GetCursorPos()
    local mouseX = nil
    local mouseY = nil

    if type(cursorPos) == "number" and type(cursorPosY) == "number" then
        mouseX = cursorPos
        mouseY = cursorPosY
    elseif cursorPos then
        if type(cursorPos) == "table" then
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

    if type(mouseX) ~= "number" or type(mouseY) ~= "number" then
        return nil
    end

    local screenW, screenH = MenuGetScreenSize()
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

    return mouseX, mouseY
end

local function GetOverlayMouseState()
    if not (Susano and Susano.GetCursorPos) then
        return nil
    end

    local mouseX, mouseY = ResolveOverlayCursorPosition()
    if not mouseX or not mouseY then
        return nil
    end

    local leftDown = false
    local leftPressed = false
    local rightDown = false
    local rightPressed = false

    if Susano.GetAsyncKeyState then
        leftDown, leftPressed = Susano.GetAsyncKeyState(0x01)
        rightDown, rightPressed = Susano.GetAsyncKeyState(0x02)
    end

    return mouseX, mouseY,
        (leftDown == true or leftDown == 1), leftPressed == true,
        (rightDown == true or rightDown == 1), rightPressed == true
end

DrawClickableCursor = function()
    if not Menu.Visible or not (Menu.ClickableMenu or Menu.EditorMode) or not Susano or not Susano.GetCursorPos then
        return
    end

    local mouseX, mouseY = GetOverlayMouseState()
    if not mouseX or not mouseY then
        return
    end

    local outer = 11
    local inner = 7
    local dot = 3

    if Susano.DrawCircle then
        Susano.DrawCircle(mouseX, mouseY, outer, false, 0.0, 0.0, 0.0, 0.95, 2.0, 26)
        Susano.DrawCircle(mouseX, mouseY, inner, false, 1.0, 1.0, 1.0, 1.0, 1.0, 24)
        Susano.DrawCircle(mouseX, mouseY, dot, true, 1.0, 0.25, 0.25, 1.0, 1.0, 18)
    elseif Susano.DrawRectFilled then
        Susano.DrawRectFilled(mouseX - 6, mouseY - 1, 12, 2, 0.0, 0.0, 0.0, 1.0, 1)
        Susano.DrawRectFilled(mouseX - 1, mouseY - 6, 2, 12, 0.0, 0.0, 0.0, 1.0, 1)
        Susano.DrawRectFilled(mouseX - 5, mouseY, 10, 1, 1.0, 1.0, 1.0, 1.0, 0)
        Susano.DrawRectFilled(mouseX, mouseY - 5, 1, 10, 1.0, 1.0, 1.0, 1.0, 0)
        Susano.DrawRectFilled(mouseX - 1, mouseY - 1, 2, 2, 1.0, 0.25, 0.25, 1.0, 1)
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

local function BeginBindingForItem(item, activationKeyCode)
    if not item or item.isSeparator then
        return false
    end

    if item.type ~= "toggle" and item.type ~= "action" then
        return false
    end

    Menu.SelectingBind = true
    Menu.BindingItem = item
    Menu.BindingKey = item.bindKey or nil
    Menu.BindingKeyName = item.bindKeyName or nil
    Menu.SuppressCaptureUntilRelease = activationKeyCode or nil
    return true
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

        if Menu.IsKeyJustPressed(0x0D) then
            if Menu.BindingKey and Menu.BindingItem then
                Menu.BindingItem.bindKey = Menu.BindingKey
                Menu.BindingItem.bindKeyName = Menu.BindingKeyName
                local itemName = Menu.BindingItem.name or "option"
                local savedKeyName = Menu.BindingKeyName
                Menu.SelectingBind = false
                Menu.SuppressCaptureUntilRelease = nil
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
                Menu.SuppressCaptureUntilRelease = nil
                Menu.NotifyInteraction({ name = "Tecla del menu" }, "bind", Menu.SelectedKeyName or Menu.GetKeyName(Menu.SelectedKey))
            end
            return
        end

        local keyCode = Menu.CaptureBindableKey()
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
                                    local bindShortcutCode = Menu.BindShortcutKey or 0x79
                                    if Menu.Visible and item.bindKey == bindShortcutCode then
                                        local down = Menu.GetKeyState(item.bindKey)
                                        Menu.KeyStates[item.bindKey] = (down == true)
                                    else
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
    end

    local toggleKeyCode = Menu.SelectedKey or 0x31
    if toggleKeyCode == 0x10 or toggleKeyCode == 0xA0 or toggleKeyCode == 0xA1 then
        toggleKeyCode = 0x31
        Menu.SelectedKey = toggleKeyCode
        Menu.SelectedKeyName = Menu.GetKeyName(toggleKeyCode)
    end

    if Susano and Susano.GetAsyncKeyState then
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
                        BeginBindingForItem(selectedItem, bindShortcutCode)
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
        Menu.Render()

        if Menu.LoadingComplete then
            Menu.HandleInput()
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
