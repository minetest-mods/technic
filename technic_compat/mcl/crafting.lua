-- Helper function to set compatibility variables
local function set_compat(mcl_value, default_value)
    return technic_compat.mcl and mcl_value or default_value
end

-- Mineclone2 Support
technic_compat.copper_ingredient = technic_compat.mcl and "mcl_copper:copper_ingot" or 'default:copper_ingot'
technic_compat.iron_ingredient = technic_compat.mcl and "mcl_core:iron_ingot" or 'default:steel_ingot'
technic_compat.iron_lump_ingredient = technic_compat.mcl and "mcl_raw_ores:raw_iron" or 'default:iron_lump'
technic_compat.gold_lump_ingredient = technic_compat.mcl and "mcl_raw_ores:raw_gold" or 'default:gold_lump'
technic_compat.copper_lump_ingredient = technic_compat.mcl and "mcl_copper:raw_copper" or 'default:copper_lump'
technic_compat.mese_crystal_ingredient = technic_compat.mcl and "mesecons:wire_00000000_off" or 'default:mese_crystal'
technic_compat.diamond_ingredient = technic_compat.mcl and "mcl_core:diamond" or 'default:diamond'
technic_compat.glass_ingredient = technic_compat.mcl and "mcl_core:glass" or 'default:glass'
technic_compat.brick_block_ingredient = technic_compat.mcl and "mcl_core:brick_block" or 'default:brick'
technic_compat.mese_block_ingredient = technic_compat.mcl and "mesecons_torch:redstoneblock" or "default:mese"
technic_compat.paper_ingredient = technic_compat.mcl and "mcl_core:paper" or 'default:paper'
technic_compat.obsidian_glass_ingredient = technic_compat.mcl and "mcl_core:obsidian" or 'default:obsidian_glass'
technic_compat.obsidian_ingredient = technic_compat.mcl and "mcl_core:obsidian" or 'default:obsidian'
technic_compat.green_dye_ingredient = technic_compat.mcl and "mcl_dye:green" or 'dye:green'
technic_compat.blue_dye_ingredient = technic_compat.mcl and "mcl_dye:blue" or 'dye:blue'
technic_compat.red_dye_ingredient = technic_compat.mcl and "mcl_dye:red" or 'dye:red'
technic_compat.white_dye_ingredient = technic_compat.mcl and "mcl_dye:white" or 'dye:white'
technic_compat.gold_ingot_ingredient = technic_compat.mcl and "mcl_core:gold_ingot" or 'default:gold_ingot'
technic_compat.chest_ingredient = technic_compat.mcl and "mcl_chests:chest" or "default:chest"
technic_compat.stone_ingredient = technic_compat.mcl and "mcl_core:stone" or "default:stone"
technic_compat.wood_fence_ingredient = technic_compat.mcl and "group:fence_wood" or "default:fence_wood"
technic_compat.diamond_ingredient = technic_compat.mcl and "mcl_core:diamond" or "default:diamond"
technic_compat.bronze_ingredient = technic_compat.mcl and "mcl_copper:copper_ingot" or 'default:bronze_ingot'
technic_compat.tin_ingredient = technic_compat.mcl and "moreores:tin_ingot" or 'default:tin_ingot'
technic_compat.sandstone_ingredient = technic_compat.mcl and "mcl_core:sandstone" or 'default:desert_stone'
technic_compat.sand_ingredient = technic_compat.mcl and "mcl_core:sand" or 'default:sand'
technic_compat.gravel_ingredient = technic_compat.mcl and "mcl_core:gravel" or 'default:gravel'
technic_compat.desert_stone_ingredient = technic_compat.mcl and "mcl_core:redsandstone" or 'default:desert_stone'
technic_compat.desert_sand_ingredient = technic_compat.mcl and "mcl_core:redsand" or 'default:desert_sand'
technic_compat.furnace_ingredient = technic_compat.mcl and "mcl_furnaces:furnace" or 'default:furnace'
technic_compat.mossy_cobble_ingredient = technic_compat.mcl and "mcl_core:mossycobble" or 'default:mossycobble'
technic_compat.cobble_ingredient = technic_compat.mcl and "mcl_core:cobble" or 'default:cobble'
technic_compat.snow_block_ingredient = technic_compat.mcl and "mcl_core:snowblock" or 'default:snowblock'
technic_compat.ice_block_ingredient = technic_compat.mcl and "mcl_core:ice" or 'default:ice'
technic_compat.granite_ingredient = technic_compat.mcl and "mcl_core:granite" or 'technic:granite'
technic_compat.granite_bricks_ingredient = technic_compat.mcl and "mcl_core:granite_smooth" or 'technic:granite_bricks'
technic_compat.coal_ingredient = technic_compat.mcl and "group:coal" or "default:coal_lump"
technic_compat.dirt_ingredient = technic_compat.mcl and "mcl_core:dirt" or "default:dirt"
technic_compat.mesecons_fiber_ingredient = technic_compat.mcl and "mesecons:wire_00000000_off" or "mesecons_materials:fiber"
technic_compat.stick_ingredient = technic_compat.mcl and "mcl_core:stick" or "default:stick"
technic_compat.emtpy_bucket_ingredient = technic_compat.mcl and "mcl_buckets:bucket_empty" or "bucket:bucket_empty"
technic_compat.water_bucket_ingredient = technic_compat.mcl and "mcl_buckets:bucket_water" or "bucket:bucket_water"

-- Ingredient Variables
if technic_compat.mcl then
    technic_compat.blueberries_ingredient = "mcl_farming:blueberries"
    technic_compat.grass_ingredient = "mcl_core:grass"
    technic_compat.dry_shrub_ingredient = "mcl_core:deadbush"
    technic_compat.junglegrass_ingredient = "mcl_core:tallgrass"
    technic_compat.cactus_ingredient = "mcl_core:cactus"
    technic_compat.geranium_ingredient = "mcl_flowers:blue_orchid"
    technic_compat.dandelion_white_ingredient = "mcl_flowers:oxeye_daisy"
    technic_compat.dandelion_yellow_ingredient = "mcl_flowers:dandelion"
    technic_compat.tulip_ingredient = "mcl_flowers:orange_tulip"
    technic_compat.rose_ingredient = "mcl_flowers:poppy"
    technic_compat.viola_ingredient = "mcl_flowers:allium"
else
    technic_compat.blueberries_ingredient = "default:blueberries"
    technic_compat.grass_ingredient = "default:grass_1"
    technic_compat.dry_shrub_ingredient = "default:dry_shrub"
    technic_compat.junglegrass_ingredient = "default:junglegrass"
    technic_compat.cactus_ingredient = "default:cactus"
    technic_compat.geranium_ingredient = "flowers:geranium"
    technic_compat.dandelion_white_ingredient = "flowers:dandelion_white"
    technic_compat.dandelion_yellow_ingredient = "flowers:dandelion_yellow"
    technic_compat.tulip_ingredient = "flowers:tulip"
    technic_compat.rose_ingredient = "flowers:rose"
    technic_compat.viola_ingredient = "flowers:viola"
end

-- Dye Output Variables
if technic_compat.mcl then
    technic_compat.dye_black = "mcl_dye:black"
    technic_compat.dye_violet = "mcl_dye:violet"
    technic_compat.dye_green = "mcl_dye:green"
    technic_compat.dye_brown = "mcl_dye:brown"
    technic_compat.dye_blue = "mcl_dye:blue"
    technic_compat.dye_white = "mcl_dye:white"
    technic_compat.dye_yellow = "mcl_dye:yellow"
    technic_compat.dye_orange = "mcl_dye:orange"
    technic_compat.dye_red = "mcl_dye:red"
else
    technic_compat.dye_black = "dye:black"
    technic_compat.dye_violet = "dye:violet"
    technic_compat.dye_green = "dye:green"
    technic_compat.dye_brown = "dye:brown"
    technic_compat.dye_blue = "dye:blue"
    technic_compat.dye_white = "dye:white"
    technic_compat.dye_yellow = "dye:yellow"
    technic_compat.dye_orange = "dye:orange"
    technic_compat.dye_red = "dye:red"
end

technic_compat.dirt_with_snow_ingredient = technic_compat.mcl and "mcl_core:dirt_with_grass_snow" or "default:dirt_with_snow"
technic_compat.bucket_lava_ingredient = technic_compat.mcl and "mcl_buckets:bucket_lava" or "bucket:bucket_lava"
technic_compat.bucket_river_water_ingredient = technic_compat.mcl and "mcl_buckets:bucket_river_water" or "bucket:bucket_river_water"
