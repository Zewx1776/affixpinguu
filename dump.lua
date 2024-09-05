local dump = {}

function dump.retrieve_inventory_items()
    local local_player = get_local_player()

    local inventory_items = local_player:get_inventory_items()
    if not inventory_items then
        console.print("No inventory items found.")
        return
    end

    for _, item in ipairs(inventory_items) do
        console.print("Display Name: " .. item:get_display_name())
        console.print("Item: " .. item:get_name())
        console.print("Affixes:")

        local affixes = item:get_affixes()
        for _, affix in ipairs(affixes) do
            console.print("  - " .. affix:get_name() .. " (".. affix.affix_name_hash ..")")
        end

	 -- Check if the item has GreaterAffix in its skin name
        local skin_name = item:get_display_name()
        if string.find(skin_name, "GreaterAffix") then
            console.print("GreaterAffix: Yes")
        end

        console.print("--------------------------------")
        
       
    end
end

return dump
