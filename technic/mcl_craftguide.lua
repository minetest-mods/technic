-- Register craft types for each machine
mcl_craftguide.register_craft_type("centrifuge", {
    description = "Centrifuge",
    icon = "technic_mv_centrifuge_front_active.png",
})

mcl_craftguide.register_craft_type("compressor", {
    description = "Compressor",
    icon = "technic_lv_compressor_front_active.png", 
})

mcl_craftguide.register_craft_type("extractor", {
    description = "Extractor",
    icon = "technic_lv_extractor_front_active.png", 
})

mcl_craftguide.register_craft_type("freezer", {
    description = "Freezer",
    icon = "technic_mv_freezer_front_active.png",
})

mcl_craftguide.register_craft_type("grinder", {
    description = "Grinder",
    icon = "technic_lv_grinder_front_active.png", 
})


centrifuge_recipes = {
	{ "technic:bronze_dust 8",             "technic:copper_dust 7",       "technic:tin_dust"      },
	{ "technic:stainless_steel_dust 5",    "technic:wrought_iron_dust 4", "technic:chromium_dust" },
	{ "technic:brass_dust 3",              "technic:copper_dust 2",       "technic:zinc_dust"     },
	{ "technic:chernobylite_dust",         sand_ingrediant,                "technic:uranium3_dust" },
	{ dirt_ingrediant.." 4",                    sand_ingrediant,                gravel_ingrediant,       "default:clay_lump 2"     },
}

compressor_recipes = {
	{snow_block_ingrediant,          ice_block_ingrediant},
	{sand_ingrediant.." 2",             sandstone_ingrediant},
	{desert_sand_ingrediant.." 2",      desert_stone_ingrediant},
	{desert_sand_ingrediant,        desert_stone_ingrediant},
	{"technic:mixed_metal_ingot",  "technic:composite_plate"},
	{copper_ingrediant.." 5",     "technic:copper_plate"},
	{"technic:coal_dust 4",        "technic:graphite"},
	{"technic:carbon_cloth",       "technic:carbon_plate"},
	{"technic:uranium35_ingot 5",  "technic:uranium_fuel"},
}

extractor_recipes = {
    {"technic:coal_dust",                dye_black .. " 2"},
    {blueberries_ingredient,              dye_violet .. " 2"},
    {grass_ingredient,                    dye_green .. " 1"},
    {dry_shrub_ingredient,                dye_brown .. " 1"},
    {junglegrass_ingredient,              dye_green .. " 2"},
    {cactus_ingredient,                   dye_green .. " 4"},
    {geranium_ingredient,                 dye_blue .. " 4"},
    {dandelion_white_ingredient,          dye_white .. " 4"},
    {dandelion_yellow_ingredient,         dye_yellow .. " 4"},
    {tulip_ingredient,                    dye_orange .. " 4"},
    {rose_ingredient,                     dye_red .. " 4"},
    {viola_ingredient,                    dye_violet .. " 4"},
    {blackberry_ingredient,               unifieddyes and "unifieddyes:magenta_s50 4" or dye_violet .. " 4"},
    {blueberry_ingredient,                unifieddyes and "unifieddyes:magenta_s50 4" or ""},
}

freezer_recipes = {
	{water_bucket_ingrediant, { ice_block_ingrediant, emtpy_bucket_ingrediant } },
	{bucket_river_water_ingrediant, { ice_block_ingrediant, emtpy_bucket_ingrediant } },
	{dirt_ingrediant , dirt_with_snow_ingrediant },
	{bucket_lava_ingrediant, { obsidian_ingrediant, emtpy_bucket_ingrediant } }
}

grinder_recipes = {
    -- Dusts
    {coal_ingrediant,              "technic:coal_dust 2"},
    {copper_lump_ingrediant,            "technic:copper_dust 2"},
    {desert_stone_ingrediant,      desert_sand_ingrediant},
    {gold_lump_ingrediant,        "technic:gold_dust 2"},
    {iron_lump_ingrediant,              "technic:wrought_iron_dust 2"},
    {"moreores:tin_lump",               "technic:tin_dust 2"},
    {"technic:chromium_lump",      "technic:chromium_dust 2"},
    {"technic:uranium_lump",       "technic:uranium_dust 2"},
    {"technic:zinc_lump",          "technic:zinc_dust 2"},
    {"technic:lead_lump",          "technic:lead_dust 2"},
    {"technic:sulfur_lump",        "technic:sulfur_dust 2"},
    {stone_ingrediant,             "technic:stone_dust"},
    {sand_ingrediant,              "technic:stone_dust"},
    {desert_sand_ingrediant,       "technic:stone_dust"},

    -- Other
    {cobble_ingrediant,             gravel_ingrediant},
    {gravel_ingrediant,             sand_ingrediant},
    {sandstone_ingrediant,         sand_ingrediant.." 2"}, -- reverse recipe can be found in the compressor
    {desert_stone_ingrediant,   desert_sand_ingrediant.." 2"}, -- reverse recipe can be found in the compressor
    {ice_block_ingrediant,         snow_block_ingrediant},
}

-- Register Centrifuge Recipes
for _, data in pairs(centrifuge_recipes) do
    mcl_craftguide.register_craft({
        type = "centrifuge",
        width = 1,
        output = table.concat({data[2], data[3], data[4]}, " "),
        items = {data[1]},
    })
end

-- Register Compressor Recipes
for _, data in pairs(compressor_recipes) do
    mcl_craftguide.register_craft({
        type = "compressor",
        width = 1,
        output = data[2],
        items = {data[1]},
    })
end

-- Register Extractor Recipes
for _, data in ipairs(extractor_recipes) do
    mcl_craftguide.register_craft({
        type = "extractor",
        width = 1,
        output = data[2],
        items = {data[1]},
    })
end

-- Register Freezer Recipes
for _, data in pairs(freezer_recipes) do
    local output_string
    if type(data[2]) == "table" then
        output_string = table.concat(data[2], ", ")
    else
        output_string = data[2]
    end

    mcl_craftguide.register_craft({
        type = "freezer",
        width = 1,
        output = output_string,
        items = {data[1]},
    })
end


-- Register Grinder Recipes
for _, data in pairs(grinder_recipes) do
    mcl_craftguide.register_craft({
        type = "grinder",
        width = 1,
        output = data[2],
        items = {data[1]},
    })
end

