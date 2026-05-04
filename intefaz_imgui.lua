local Menu = {}
Menu.Visible = false
Menu.SelectedKey = 0x31 -- Tecla 1 (Por defecto para abrir/cerrar)
Menu.KeyStates = {}

-- Notificaciones adaptadas para no romper compatibilidad
function Menu.PushNotification(text, kind, replaceKey, duration)
    if Susano and Susano.ShowNotification then
        local prefix = kind == "success" and "~g~" or (kind == "danger" and "~r~" or "~b~")
        Susano.ShowNotification(prefix .. tostring(text))
    else
        print("[Arcane Menu] " .. tostring(text))
    end
end
function Menu.NotifyError(itemName, errorMsg) Menu.PushNotification("Error: " .. tostring(errorMsg), "danger") end
function Menu.ExecuteCallbackSafely(cb, ...)
    if type(cb) == "function" then
        local ok, err = pcall(cb, ...)
        return ok, err
    end
    return true, nil
end

-- Ciclo de renderizado ImGui
function Menu.OnRender()
    if not Menu.Visible then return end
    
    -- Asegurarnos que la API de ImGui existe en Susano
    if not Susano or not Susano.ImGui then return end

    -- Iniciar ventana
    local isOpen, visible = Susano.ImGui.Begin("Arcane Menu", Menu.Visible)
    Menu.Visible = isOpen -- Permite cerrar desde la 'X' nativa de ImGui
    
    if visible then
        -- Crear las Pestañas Superiores (Categorías)
        if Susano.ImGui.BeginTabBar("MenuCategories") then
            for _, cat in ipairs(Menu.Categories or {}) do
                if Susano.ImGui.BeginTabItem(cat.name) then
                    
                    -- Si la categoría tiene SubPestañas
                    if cat.hasTabs and cat.tabs then
                        if Susano.ImGui.BeginTabBar("SubTabs_" .. cat.name) then
                            for _, tab in ipairs(cat.tabs) do
                                if Susano.ImGui.BeginTabItem(tab.name) then
                                    Menu.RenderItems(tab.items)
                                    Susano.ImGui.EndTabItem()
                                end
                            end
                            Susano.ImGui.EndTabBar()
                        end
                    -- Si la categoría tiene items directamente
                    elseif cat.items then
                        Menu.RenderItems(cat.items)
                    end
                    
                    Susano.ImGui.EndTabItem()
                end
            end
            Susano.ImGui.EndTabBar()
        end
    end
    
    Susano.ImGui.End()
end

-- Renderizador de items que traduce tu configuración actual a ImGui
function Menu.RenderItems(items)
    for _, item in ipairs(items or {}) do
        if item.isSeparator then
            Susano.ImGui.Spacing()
            Susano.ImGui.Separator()
            if item.separatorText and item.separatorText ~= "" then
                Susano.ImGui.Text(item.separatorText)
                Susano.ImGui.Separator()
            end
            Susano.ImGui.Spacing()
        else
            if item.type == "toggle" or item.type == "toggle_selector" then
                local changed, newVal = Susano.ImGui.Checkbox(item.name, item.value or false)
                if changed then
                    item.value = newVal
                    if item.onClick then Menu.ExecuteCallbackSafely(item.onClick, newVal) end
                end
                
                if item.hasSlider then
                    Susano.ImGui.SameLine()
                    local sChanged, sVal = Susano.ImGui.SliderFloat("##slider_"..item.name, item.sliderValue or item.sliderMin or 0.0, item.sliderMin or 0.0, item.sliderMax or 100.0)
                    if sChanged then
                        item.sliderValue = sVal
                        if item.onSliderChange then Menu.ExecuteCallbackSafely(item.onSliderChange, sVal) end
                    end
                end
                
            elseif item.type == "action" then
                if Susano.ImGui.Button(item.name) then
                    if item.onClick then Menu.ExecuteCallbackSafely(item.onClick) end
                end
                
            elseif item.type == "slider" then
                local changed, newVal = Susano.ImGui.SliderFloat(item.name, item.value or item.min or 0.0, item.min or 0.0, item.max or 100.0)
                if changed then
                    item.value = newVal
                    if item.onClick then Menu.ExecuteCallbackSafely(item.onClick, newVal) end
                end
                
            elseif item.type == "selector" and item.options then
                local currentIdx = (item.selected or 1) - 1 -- ImGui suele usar index 0
                local changed, newIdx = Susano.ImGui.Combo(item.name, currentIdx, item.options)
                if changed then
                    item.selected = newIdx + 1
                    if item.onClick then Menu.ExecuteCallbackSafely(item.onClick, item.selected, item.options[item.selected]) end
                end
            end
        end
    end
end

return Menu
