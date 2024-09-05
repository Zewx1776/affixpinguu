menu = require("menu")
filter = require("filter")
dump = require("dump")
selling = require("selling")

local filter_lookup = {
    ["Amulet"] = filter.amulet_affix_filter,
    ["Ring"] = filter.ring_affix_filter,
    ["2H"] = filter.two_hand_weapons_affix_filter,
    ["1H"] = filter.one_hand_weapons_affix_filter,
    ["Boots"] = filter.boots_affix_filter,
    ["Pants"] = filter.pants_affix_filter,
    ["Gloves"] = filter.gloves_affix_filter,
    ["Chest"] = filter.chest_affix_filter,
    ["Helm"] = filter.helm_affix_filter
}

local function get_filter(skin_name)
    -- Check for specific weapon types first
    if #filter.focus_weapons_affix_filter > 0 and skin_name:match("Focus") then       
        return filter.focus_weapons_affix_filter
    end

    if #filter.dagger_weapons_affix_filter > 0 and skin_name:match("Dagger") then
        return filter.dagger_weapons_affix_filter
    end

    if #filter.shield_weapons_affix_filter > 0 and skin_name:match("Shield") then
        return filter.shield_weapons_affix_filter
    end

    -- Check the broader categories
    for pattern, filter in pairs(filter_lookup) do
        if skin_name:match(pattern) then
            return filter
        end
    end
    return nil
end

local function is_sno_id_in_table(filter_entry, sno_id) 
    for _, filter_entry in pairs(filter_table) do
        if filter_entry.sno_id == sno_id then
            return true
        end
    end

    return false
end

local uber_table = {
    { name = "Tyrael's Might", sno = 1901484 },
    { name = "The Grandfather", sno = 223271 },
    { name = "Andariel's Visage", sno = 241930 },
    { name = "Ahavarion, Spear of Lycander", sno = 359165 },
    { name = "Doombringer", sno = 221017 },
    { name = "Harlequin Crest", sno = 609820 },
    { name = "Melted Heart of Selig", sno = 1275935 },
    { name = "‍Ring of Starless Skies", sno = 1306338 }
}

function is_uber_item(sno_to_check)
    for _, entry in ipairs(uber_table) do
        if entry.sno == sno_to_check then
            return true
        end
    end
    return false
end

local function get_affix_screen_position(item) -- (credits QQT)
    local row, col = item:get_inventory_row(), item:get_inventory_column()
    local screen_width, screen_height = get_screen_width(), get_screen_height()

    local inventory_start_x = screen_width * 0.747
    local inventory_start_y = screen_height * 0.670
    local slot_width = menu.menu_elements.slot_offset_x_slider:get()
    local slot_height = menu.menu_elements.slot_offset_y_slider:get()
    local space_between_items_x = menu.menu_elements.box_space_slider:get()
    local space_between_items_y = 6.2

    local adjusted_slot_width = slot_width + space_between_items_x
    local adjusted_slot_height = slot_height + space_between_items_y
    local margin_x = space_between_items_x / 2
    local margin_y = space_between_items_y / 2
    local box_width = menu.menu_elements.box_width_slider:get()
    local box_height = menu.menu_elements.box_height_slider:get()

    local x = inventory_start_x + col * adjusted_slot_width + margin_x
    local y = inventory_start_y + row * adjusted_slot_height + margin_y

    return x, y, box_width, box_height
end

-- Add this new local variable to store our cache
local item_cache = {}

-- Function to update the cache
local function update_item_cache()
    local local_player = get_local_player()
    if not local_player then
        return
    end

    item_cache = {}  -- Clear the existing cache

    local inventory_items = local_player:get_inventory_items()
    for _, inventory_item in pairs(inventory_items) do
        if inventory_item then
            local skin_name = inventory_item:get_name()
            local display_name = inventory_item:get_display_name()
            local filter_table = get_filter(skin_name)

            if filter_table then
                local item_affixes = inventory_item:get_affixes()
                if #item_affixes > 1 then
                    local found_required_affixes = 0
                    local found_optional_affixes = 0
                    local required_count = 0

                    -- Count required affixes in filter
                    for _, filter_entry in pairs(filter_table) do
                        if filter_entry.required then
                            required_count = required_count + 1
                        end
                    end

                    for _, affix in pairs(item_affixes) do
                        if affix then                                 
                            for _, filter_entry in pairs(filter_table) do
                                if filter_entry.sno_id == affix.affix_name_hash then
                                    if filter_entry.required then
                                        found_required_affixes = found_required_affixes + 1
                                    else
                                        found_optional_affixes = found_optional_affixes + 1
                                    end
                                end
                            end
                        end
                    end

                    local total_found = found_required_affixes + found_optional_affixes
                    local has_greater_affix = string.find(display_name, "GreaterAffix") ~= nil
                    local is_uber = is_uber_item(inventory_item:get_sno_id())

                    -- Store the calculated values in the cache
                    item_cache[inventory_item] = {
                        x = nil,  -- We'll calculate these in render
                        y = nil,
                        box_width = nil,
                        box_height = nil,
                        total_found = total_found,
                        found_required_affixes = found_required_affixes,
                        found_optional_affixes = found_optional_affixes,
                        required_count = required_count,
                        has_greater_affix = has_greater_affix,
                        is_uber = is_uber
                    }
                end
            end
        end
    end
end

on_render_menu(function ()
    menu.render_menu()

    if menu.menu_elements.dumping_button:get() then
        dump.retrieve_inventory_items()
    end
end)

on_key_release(function(key)
    if key == 88 then 
        local local_player = get_local_player()
        if not local_player then
            return
        end

        local nearest_vendor = selling.get_nearest_vendor()
        if nearest_vendor and get_open_inventory_bag() == 0 then    
            local inventory_items = local_player:get_inventory_items()
            for _, inventory_item in pairs(inventory_items) do
                if inventory_item then
                    -- Check if the item is locked
                    if inventory_item:is_locked() then
                        goto continue -- Skip to the next item if it's locked
                    end

                    local skin_name = inventory_item:get_name()
                    local display_name = inventory_item:get_display_name()  -- Added get_display_name for GreaterAffix check
                    local filter_table = get_filter(skin_name)
                
                    if filter_table then
                        local item_affixes = inventory_item:get_affixes()

                        if #item_affixes > 2 then
                            local found_affixes = 0
                            local has_required_affix = false
                            local has_greater_affix = string.find(display_name, "GreaterAffix") ~= nil

                            for _, affix in pairs(item_affixes) do
                                if affix then
                                    for _, filter_entry in pairs(filter_table) do
                                        if filter_entry.sno_id == affix.affix_name_hash then
                                            found_affixes = found_affixes + 1
                                            if filter_entry.required then
                                                has_required_affix = true
                                            end
                                            break
                                        end
                                    end
                                end
                            end

                            -- Check if the item should be ignored based on the new checkbox
                            if menu.menu_elements.ignore_greater_or_required_checkbox:get() then
                                if has_greater_affix or has_required_affix then
                                    goto continue -- Skip to next item
                                end
                            end

                            -- Get the slider value for the number of affixes
                            local affix_sell_count = menu.menu_elements.affix_sell_slider:get()
        
                            -- Check if the item should be sold based on the slider value
                            if found_affixes <= affix_sell_count then
                                if not is_uber_item(inventory_item:get_sno_id()) then
                                    loot_manager.salvage_specific_item(inventory_item)
                                end
                            end
                        else
                            loot_manager.salvage_specific_item(inventory_item)
                        end
                    end
                end
                ::continue::
            end
        end       
    end   
end)

-- ... (keep all the previous code up to the on_render function)

local was_inventory_open = false

on_render(function()
    if not menu.menu_elements.main_boolean:get() then
        return
    end

    local is_open = is_inventory_open()

    -- Check if the inventory state has changed
    if is_open ~= was_inventory_open then
        if is_open then
            update_item_cache()
        else
            item_cache = {}  -- Clear the cache when inventory is closed
        end
        was_inventory_open = is_open
    end

    if not is_open then
        return
    end

    -- Render from the cache
    for inventory_item, cache_data in pairs(item_cache) do
        local x, y, box_width, box_height = get_affix_screen_position(inventory_item)
        cache_data.x, cache_data.y = x, y
        cache_data.box_width, cache_data.box_height = box_width, box_height

        if cache_data.is_uber then
            graphics.text_2d(tostring(cache_data.total_found), vec2:new(x + box_width - 15, y + box_height - 25), 20, color_white(255))
            graphics.rect(vec2:new(x, y), vec2:new(x + box_width, y + box_height), color_purple(255), 1, 3)
        end

        local greater_affix_colored = false

        -- Check if item has GreaterAffix and at least one optional affix while considering the filter for required affixes
        if cache_data.has_greater_affix and cache_data.found_required_affixes >= cache_data.required_count and cache_data.found_optional_affixes > 0 then
            local effective_optional_affixes = math.min(cache_data.found_optional_affixes, 3)

            if effective_optional_affixes == 1 then
                graphics.text_2d(tostring(cache_data.total_found), vec2:new(x + box_width - 15, y + box_height - 25), 20, color_white(255))
                graphics.rect(vec2:new(x, y), vec2:new(x + box_width, y + box_height), color_cyan_pale(100), 1, 3)  -- Pale for silver
            elseif effective_optional_affixes == 2 then
                graphics.text_2d(tostring(cache_data.total_found), vec2:new(x + box_width - 15, y + box_height - 25), 20, color_white(255))
                graphics.rect(vec2:new(x, y), vec2:new(x + box_width, y + box_height), color_cyan_pale(175), 1, 3)  -- Stronger for gold
            elseif effective_optional_affixes == 3 then
                graphics.text_2d(tostring(cache_data.total_found), vec2:new(x + box_width - 15, y + box_height - 25), 20, color_white(255))
                graphics.rect(vec2:new(x, y), vec2:new(x + box_width, y + box_height), color_cyan(255), 1, 3)  -- Cyan for the highest
            end
            greater_affix_colored = true
        end

        -- If item doesn't have a greater affix, check for optional affixes while considering the filter for required affixes
        if not greater_affix_colored then
            -- Check if the filter to only color items with GreaterAffix is enabled
            if menu.menu_elements.only_greater_affix_checkbox:get() then
                -- Check if the keep required affix coloring checkbox is enabled
                if menu.menu_elements.keep_required_affix_coloring_checkbox:get() then
                    local has_required_condition = cache_data.required_count > 0

                    if has_required_condition and cache_data.found_required_affixes >= cache_data.required_count then
                        local effective_optional_affixes = math.min(cache_data.found_optional_affixes, 3)

                        -- Ensure the required affix is treated as one of the optional affixes
                        effective_optional_affixes = effective_optional_affixes + 1

                        if effective_optional_affixes == 1 then
                            graphics.text_2d(tostring(cache_data.total_found) .. "R", vec2:new(x + box_width - 15, y + box_height - 25), 20, color_white(255))
                            graphics.rect(vec2:new(x, y), vec2:new(x + box_width, y + box_height), color_red(255), 1, 3)
                        elseif effective_optional_affixes == 2 then
                            graphics.text_2d(tostring(cache_data.total_found) .. "R", vec2:new(x + box_width - 25, y + box_height - 25), 20, color_white(255))
                            graphics.rect(vec2:new(x, y), vec2:new(x + box_width, y + box_height), color_orange(255), 1, 3)
                        elseif effective_optional_affixes >= 3 then
                            graphics.text_2d(tostring(cache_data.total_found) .. "R", vec2:new(x + box_width - 25, y + box_height - 25), 20, color_white(255))
                            graphics.rect(vec2:new(x, y), vec2:new(x + box_width, y + box_height), color_green(255), 1, 3)
                        end
                        goto continue
                    end
                end
                goto continue -- Skip to next item
            end

            local has_required_condition = cache_data.required_count > 0

            -- Check if the filter has a required condition
            if has_required_condition then
                if cache_data.found_required_affixes >= cache_data.required_count then
                    local effective_optional_affixes = math.min(cache_data.found_optional_affixes, 3)

                    -- Ensure the required affix is treated as one of the optional affixes
                    effective_optional_affixes = effective_optional_affixes + 1

                    if effective_optional_affixes == 1 then
                        graphics.text_2d(tostring(cache_data.total_found) .. "R", vec2:new(x + box_width - 15, y + box_height - 25), 20, color_white(255))
                        graphics.rect(vec2:new(x, y), vec2:new(x + box_width, y + box_height), color_red(255), 1, 3)
                    elseif effective_optional_affixes == 2 then
                        graphics.text_2d(tostring(cache_data.total_found) .. "R", vec2:new(x + box_width - 25, y + box_height - 25), 20, color_white(255))
                        graphics.rect(vec2:new(x, y), vec2:new(x + box_width, y + box_height), color_orange(255), 1, 3)
                    elseif effective_optional_affixes >= 3 then
                        graphics.text_2d(tostring(cache_data.total_found) .. "R", vec2:new(x + box_width - 25, y + box_height - 25), 20, color_white(255))
                        graphics.rect(vec2:new(x, y), vec2:new(x + box_width, y + box_height), color_green(255), 1, 3)
                    end
                end
            else
                -- If no required condition in the filter, handle the optional conditions separately if needed
                local effective_optional_affixes = math.min(cache_data.found_optional_affixes, 3)

                if effective_optional_affixes == 1 then
                    graphics.text_2d(tostring(cache_data.total_found), vec2:new(x + box_width - 15, y + box_height - 25), 20, color_white(255))
                    graphics.rect(vec2:new(x, y), vec2:new(x + box_width, y + box_height), color_red(255), 1, 3)
                elseif effective_optional_affixes == 2 then
                    graphics.text_2d(tostring(cache_data.total_found), vec2:new(x + box_width - 15, y + box_height - 25), 20, color_white(255))
                    graphics.rect(vec2:new(x, y), vec2:new(x + box_width, y + box_height), color_orange(255), 1, 3)
                elseif effective_optional_affixes == 3 then
                    graphics.text_2d(tostring(cache_data.total_found), vec2:new(x + box_width - 15, y + box_height - 25), 20, color_white(255))
                    graphics.rect(vec2:new(x, y), vec2:new(x + box_width, y + box_height), color_green(255), 1, 3)
                end
            end
        end
        ::continue::
    end
end)
          
