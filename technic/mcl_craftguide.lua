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

mcl_craftguide.register_craft_type("alloy_furnace", {
    description = "Alloy Furnace",
    icon = "technic_coal_alloy_furnace_front_active.png",
})


centrifuge_recipes = {
	{ "technic:bronze_dust 8",             "technic:copper_dust 7",       "technic:tin_dust"      },
	{ "technic:stainless_steel_dust 5",    "technic:wrought_iron_dust 4", "technic:chromium_dust" },
	{ "technic:brass_dust 3",              "technic:copper_dust 2",       "technic:zinc_dust"     },
	{ "technic:chernobylite_dust",         sand_ingredient,                "technic:uranium3_dust" },
	{ dirt_ingredient.." 4",                    sand_ingredient,                gravel_ingredient,       "default:clay_lump 2"     },
}

compressor_recipes = {
	{snow_block_ingredient,          ice_block_ingredient},
	{sand_ingredient.." 2",             sandstone_ingredient},
	{desert_sand_ingredient.." 2",      desert_stone_ingredient},
	{desert_sand_ingredient,        desert_stone_ingredient},
	{"technic:mixed_metal_ingot",  "technic:composite_plate"},
	{copper_ingredient.." 5",     "technic:copper_plate"},
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
	{water_bucket_ingredient, { ice_block_ingredient, emtpy_bucket_ingredient } },
	{bucket_river_water_ingredient, { ice_block_ingredient, emtpy_bucket_ingredient } },
	{dirt_ingredient , dirt_with_snow_ingredient },
	{bucket_lava_ingredient, { obsidian_ingredient, emtpy_bucket_ingredient } }
}

grinder_recipes = {
    -- Dusts
    {coal_ingredient,              "technic:coal_dust 2"},
    {copper_lump_ingredient,            "technic:copper_dust 2"},
    {desert_stone_ingredient,      desert_sand_ingredient},
    {gold_lump_ingredient,        "technic:gold_dust 2"},
    {iron_lump_ingredient,              "technic:wrought_iron_dust 2"},
    {"moreores:tin_lump",               "technic:tin_dust 2"},
    {"technic:chromium_lump",      "technic:chromium_dust 2"},
    {"technic:uranium_lump",       "technic:uranium_dust 2"},
    {"technic:zinc_lump",          "technic:zinc_dust 2"},
    {"technic:lead_lump",          "technic:lead_dust 2"},
    {"technic:sulfur_lump",        "technic:sulfur_dust 2"},
    {stone_ingredient,             "technic:stone_dust"},
    {sand_ingredient,              "technic:stone_dust"},
    {desert_sand_ingredient,       "technic:stone_dust"},

    -- Other
    {cobble_ingredient,             gravel_ingredient},
    {gravel_ingredient,             sand_ingredient},
    {sandstone_ingredient,         sand_ingredient.." 2"}, -- reverse recipe can be found in the compressor
    {desert_stone_ingredient,   desert_sand_ingredient.." 2"}, -- reverse recipe can be found in the compressor
    {ice_block_ingredient,         snow_block_ingredient},
}

alloy_recipes = {
	{"technic:copper_dust 7",         "technic:tin_dust",           "technic:bronze_dust 8", 12},
	{copper_ingredient.." 7",        tin_ingredient,          bronze_ingredient.." 8", 12},
	{"technic:wrought_iron_dust 2",   "technic:coal_dust",          "technic:carbon_steel_dust 2", 6},
	{"technic:wrought_iron_ingot 2",  "technic:coal_dust",          "technic:carbon_steel_ingot 2", 6},
	{"technic:carbon_steel_dust 2",   "technic:coal_dust",          "technic:cast_iron_dust 2", 6},
	{"technic:carbon_steel_ingot 2",  "technic:coal_dust",          "technic:cast_iron_ingot 2", 6},
	{"technic:carbon_steel_dust 4",   "technic:chromium_dust",      "technic:stainless_steel_dust 5", 7.5},
	{"technic:carbon_steel_ingot 4",  "technic:chromium_ingot",     "technic:stainless_steel_ingot 5", 7.5},
	{"technic:copper_dust 2",         "technic:zinc_dust",          "technic:brass_dust 3"},
	{copper_ingredient.." 2",        "technic:zinc_ingot",         "basic_materials:brass_ingot 3"},
	{sand_ingredient.." 2",                "technic:coal_dust 2",        "technic:silicon_wafer"},
	{"technic:silicon_wafer",         "technic:gold_dust",          "technic:doped_silicon_wafer"},
	-- from https://en.wikipedia.org/wiki/Carbon_black
	-- The highest volume use of carbon black is as a reinforcing filler in rubber products, especially tires.
	-- "[Compounding a] pure gum vulcanizate … with 50% of its weight of carbon black improves its tensile strength and wear resistance …"
	{"technic:raw_latex 4",           "technic:coal_dust 2",        "technic:rubber 6", 2},
	{ice_block_ingredient, 		  emtpy_bucket_ingredient,        water_bucket_ingredient, 1 },
}

for _, data in pairs(alloy_recipes) do
	mcl_craftguide.register_craft({
        type = "alloy_furnace",
        width = 1,
        output = data[3],
        items = {data[1], data[2]},
    })
end

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

