local filter = {}

filter.helm_affix_filter = {
    -- Helm affixes not shown in the image
}

filter.chest_affix_filter = {
    -- Chest affixes not shown in the image
}

filter.gloves_affix_filter = {
    -- Gloves affixes not shown in the image
}

filter.pants_affix_filter = {
    { sno_id = 1829554, affix_name = "Armor" },  -- Armor
    { sno_id = 1829592, affix_name = "Maximum Life" },  -- Max Life
    { sno_id = 1829574, affix_name = "Willpower" },  -- Willpower
}

filter.boots_affix_filter = {
    -- Boots affixes not shown in the image
}

filter.two_hand_weapons_affix_filter = {
    -- Two-hand weapon affixes not shown in the image
}

filter.one_hand_weapons_affix_filter = {
    { sno_id = 1829574, affix_name = "Willpower" },  -- Willpower
    { sno_id = 1829586, affix_name = "Critical Strike Damage" },  -- Critical Strike Damage
    { sno_id = 1829592, affix_name = "Maximum Life" },  -- Max Life
}

filter.amulet_affix_filter = {
    { sno_id = 1928710, affix_name = "Ranks to Nature's Reach" },  -- Ranks to Nature's Reach
    { sno_id = 1928728, affix_name = "Ranks to Quickshift" },  -- Ranks to Quickshift
    { sno_id = 1928718, affix_name = "Ranks to Envenom" },  -- Ranks to Envenom
}

filter.ring_affix_filter = {
}

-- Weapon filters (Direct)
filter.focus_weapons_affix_filter = {
    { sno_id = 1829582, affix_name = "Critical Strike Chance" },  -- Critical Strike Chance (Offhand)
    { sno_id = 1829592, affix_name = "Maximum Life" },  -- Max Life (Offhand)
    { sno_id = 1829574, affix_name = "Willpower" },  -- Willpower (Offhand)
}

filter.dagger_weapons_affix_filter = {
    { sno_id = 1829582, affix_name = "Critical Strike Chance" },  -- Critical Strike Chance (Offhand)
    { sno_id = 1829592, affix_name = "Maximum Life" },  -- Max Life (Offhand)
    { sno_id = 1829574, affix_name = "Willpower" },  -- Willpower (Offhand)
}

filter.shield_weapons_affix_filter = {
    { sno_id = 1829582, affix_name = "Critical Strike Chance" },  -- Critical Strike Chance (Offhand)
    { sno_id = 1829592, affix_name = "Maximum Life" },  -- Max Life (Offhand)
    { sno_id = 1829574, affix_name = "Willpower" },  -- Willpower (Offhand)
}

return filter
