-- 1 Affix = Red, 2 Affixes = Orange, 3 Affixes = Green

local filter = {}

filter.helm_affix_filter = {
    { sno_id = 1829596, affix_name = "Lucky Hit Chance" },
    { sno_id = 1829592, affix_name = "Max. Life" },
    { sno_id = 1829556, affix_name = "Attack Speed" },
}

filter.chest_affix_filter = {
    { sno_id = 1829562, affix_name = "Dexterity" },
    { sno_id = 1873229, affix_name = "Ranks To Dark Shroud", required = true },
    { sno_id = 1829592, affix_name = "Max. Life" },
}

filter.gloves_affix_filter = {
    { sno_id = 1829596, affix_name = "Lucky Hit Chance" },
    { sno_id = 1829582, affix_name = "Critical Strike Chance" },
    { sno_id = 1829556, affix_name = "Attack Speed" },
}

filter.pants_affix_filter = {
    { sno_id = 1829562, affix_name = "Dexterity" },
    { sno_id = 1829592, affix_name = "Max. Life" },
    { sno_id = 1873199, affix_name = "Ranks to Heartseeker", required = true },
}

filter.boots_affix_filter = {
    { sno_id = 1829598, affix_name = "Movement Speed" },
    { sno_id = 1829592, affix_name = "Max. Life" },
    { sno_id = 1829554, affix_name = "Armor" },
}

filter.two_hand_weapons_affix_filter = {
    { sno_id = 1829562, affix_name = "Dexterity" },
    { sno_id = 1834112, affix_name = "Vulnerable" },
    { sno_id = 1829592, affix_name = "Max. Life" },
}

filter.one_hand_weapons_affix_filter = {
    { sno_id = 1829562, affix_name = "Dexterity" },
    { sno_id = 1834112, affix_name = "Vulnerable" },
    { sno_id = 1829592, affix_name = "Max. Life" },
}

filter.amulet_affix_filter = {
    { sno_id = 1829596, affix_name = "Lucky Hit Chance" },
    { sno_id = 1927657, affix_name = "Ranks To Frigid Finesse" },
    { sno_id = 1927487, affix_name = "Ranks To Exploit" },
    { sno_id = 1927557, affix_name = "Ranks To Malice" },
    { sno_id = 1829582, affix_name = "Critical Strike Chance" },
}

filter.ring_affix_filter = {
    { sno_id = 1829675, affix_name = "Lucky Hit Chance" },
    { sno_id = 1829556, affix_name = "Attack Speed" },
    { sno_id = 1829562, affix_name = "Dexterity" },
    { sno_id = 1829584, affix_name = "Critical Strike Chance" },
}

-- Weapon filters (Direct)
filter.focus_weapons_affix_filter = {
    { sno_id = 1829566, affix_name = "Intelligence" },
    { sno_id = 1829560, affix_name = "Cooldown Reduction"}
}

filter.dagger_weapons_affix_filter = {
    
}

filter.shield_weapons_affix_filter = {
    
}


return filter