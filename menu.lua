local plugin_label = "AFFIX_PINGUU_FILTER_PLUGIN_"
local menu = {}

menu.menu_elements = {
    main_tree = tree_node:new(0),
    main_boolean = checkbox:new(true, get_hash(plugin_label .. "main_boolean")),

    -- Drawings
    position_submenu = tree_node:new(1),
    slot_offset_x_slider = slider_int:new(0, 150, 49, get_hash(plugin_label .. "slot_offset_x")),
    slot_offset_y_slider = slider_int:new(0, 150, 76, get_hash(plugin_label .. "slot_offset_y")),
    box_space_slider = slider_float:new(0, 1.0, 0.1, get_hash(plugin_label .. "box_space_slider")),
    box_height_slider = slider_int:new(0, 100, 76, get_hash(plugin_label .. "box_height_slider")),
    box_width_slider = slider_int:new(0, 100, 50, get_hash(plugin_label .. "box_width_slider")),

    -- Filtering
    only_greater_affix_checkbox = checkbox:new(false, get_hash(plugin_label .. "only_greater_affix")),
    keep_required_affix_coloring_checkbox = checkbox:new(false, get_hash(plugin_label .. "keep_required_affix_coloring")),
    affix_sell_slider = slider_int:new(1, 3, 1, get_hash(plugin_label .. "affix_sell_slider")),
    ignore_greater_or_required_checkbox = checkbox:new(false, get_hash(plugin_label .. "ignore_greater_or_required")),

    -- d
    dumping_button = button:new(get_hash(plugin_label .. "dumping_button"))
}

function menu.render_menu()
    if not menu.menu_elements.main_tree:push("Affix Filter (Pinguu)") then
        return
    end

    menu.menu_elements.main_boolean:render("Enable Affix Filter", "")
    if not menu.menu_elements.main_boolean:get() then
        menu.menu_elements.main_tree:pop()
        return
    end

    menu.menu_elements.only_greater_affix_checkbox:render("Only Greater Affix", "Enable to only color items with a Greater Affix")
    if menu.menu_elements.only_greater_affix_checkbox:get() then
        menu.menu_elements.keep_required_affix_coloring_checkbox:render("Keep Required Affix Coloring", "Enable to keep coloring items with required affixes")
    end

    menu.menu_elements.affix_sell_slider:render("Affix Sell Slider", "Select the number of affixes for selling logic")
    menu.menu_elements.ignore_greater_or_required_checkbox:render("Don't sell GA or Required Affix", "Ignore items with a Greater Affix or required affixes")

    if menu.menu_elements.main_tree:push("Drawing Position Adjustment") then
        menu.menu_elements.box_space_slider:render("Box Spacing", "", 1)
        menu.menu_elements.slot_offset_x_slider:render("Slot Offset X", "Adjust slot offset X")
        menu.menu_elements.slot_offset_y_slider:render("Slot Offset Y", "Adjust slot offset Y")
        menu.menu_elements.box_height_slider:render("Box Height Slider", "Adjust box height")
        menu.menu_elements.box_width_slider:render("Box Width Slider", "Adjust box width")
        menu.menu_elements.dumping_button:render("Dump Items", "Press to dump all items in inventory", 0)
        menu.menu_elements.main_tree:pop()
    end
    menu.menu_elements.main_tree:pop()
end

return menu
