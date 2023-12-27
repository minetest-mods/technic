local default = minetest.get_modpath("default") and default or {}
local mcl = minetest.get_modpath("mcl_core")

-- Compatibility table
technic.compat = {}

-- Helper function to set compatibility variables
local function set_compat(mcl_value, default_value)
    return mcl and mcl_value or default_value
end

-- Mineclone2 Support
technic.compat.stone_sounds = mcl and mcl_sounds.node_sound_stone_defaults() or default.node_sound_stone_defaults()
technic.compat.mt_light_max = mcl and mcl_core.LIGHT_MAX or default.LIGHT_MAX
technic.compat.copper_ingredient = mcl and "mcl_copper:copper_ingot" or 'default:copper_ingot'
technic.compat.iron_ingredient = mcl and "mcl_core:iron_ingot" or 'default:steel_ingot'
technic.compat.iron_lump_ingredient = mcl and "mcl_raw_ores:raw_iron" or 'default:iron_lump'
technic.compat.gold_lump_ingredient = mcl and "mcl_raw_ores:raw_gold" or 'default:gold_lump'
technic.compat.copper_lump_ingredient = mcl and "mcl_copper:raw_copper" or 'default:copper_lump'
technic.compat.mese_crystal_ingredient = mcl and "mesecons:wire_00000000_off" or 'default:mese_crystal'
technic.compat.diamond_ingredient = mcl and "mcl_core:diamond" or 'default:diamond'
technic.compat.glass_ingredient = mcl and "mcl_core:glass" or 'default:glass'
technic.compat.brick_block_ingredient = mcl and "mcl_core:brick_block" or 'default:brick'
technic.compat.mese_block_ingredient = mcl and "mesecons_torch:redstoneblock" or "default:mese"
technic.compat.paper_ingredient = mcl and "mcl_core:paper" or 'default:paper'
technic.compat.obsidian_glass_ingredient = mcl and "mcl_core:obsidian" or 'default:obsidian_glass'
technic.compat.obsidian_ingredient = mcl and "mcl_core:obsidian" or 'default:obsidian'
technic.compat.green_dye_ingredient = mcl and "mcl_dye:green" or 'dye:green'
technic.compat.blue_dye_ingredient = mcl and "mcl_dye:blue" or 'dye:blue'
technic.compat.red_dye_ingredient = mcl and "mcl_dye:red" or 'dye:red'
technic.compat.white_dye_ingredient = mcl and "mcl_dye:white" or 'dye:white'
technic.compat.gold_ingot_ingredient = mcl and "mcl_core:gold_ingot" or 'default:gold_ingot'
technic.compat.chest_ingredient = mcl and "mcl_chests:chest" or "default:chest"
technic.compat.stone_ingredient = mcl and "mcl_core:stone" or "default:stone"
technic.compat.wood_fence_ingredient = mcl and "group:fence_wood" or "default:fence_wood"
technic.compat.diamond_ingredient = mcl and "mcl_core:diamond" or "default:diamond"
technic.compat.bronze_ingredient = mcl and "mcl_copper:copper_ingot" or 'default:bronze_ingot'
technic.compat.tin_ingredient = mcl and "moreores:tin_ingot" or 'default:tin_ingot'
technic.compat.sandstone_ingredient = mcl and "mcl_core:sandstone" or 'default:desert_stone'
technic.compat.sand_ingredient = mcl and "mcl_core:sand" or 'default:sand'
technic.compat.gravel_ingredient = mcl and "mcl_core:gravel" or 'default:gravel'
technic.compat.desert_stone_ingredient = mcl and "mcl_core:redsandstone" or 'default:desert_stone'
technic.compat.desert_sand_ingredient = mcl and "mcl_core:redsand" or 'default:desert_sand'
technic.compat.furnace_ingredient = mcl and "mcl_furnaces:furnace" or 'default:furnace'
technic.compat.mossy_cobble_ingredient = mcl and "mcl_core:mossycobble" or 'default:mossycobble'
technic.compat.cobble_ingredient = mcl and "mcl_core:cobble" or 'default:cobble'
technic.compat.snow_block_ingredient = mcl and "mcl_core:snowblock" or 'default:snowblock'
technic.compat.ice_block_ingredient = mcl and "mcl_core:ice" or 'default:ice'
technic.compat.granite_ingredient = mcl and "mcl_core:granite" or 'technic:granite'
technic.compat.granite_bricks_ingredient = mcl and "mcl_core:granite_smooth" or 'technic:granite_bricks'
technic.compat.coal_ingredient = mcl and "group:coal" or "default:coal_lump"
technic.compat.dirt_ingredient = mcl and "mcl_core:dirt" or "default:dirt"
technic.compat.mesecons_fiber_ingredient = mcl and "mesecons:wire_00000000_off" or "mesecons_materials:fiber"
technic.compat.stick_ingredient = mcl and "mcl_core:stick" or "default:stick"
technic.compat.emtpy_bucket_ingredient = mcl and "mcl_buckets:bucket_empty" or "bucket:bucket_empty"
technic.compat.water_bucket_ingredient = mcl and "mcl_buckets:bucket_water" or "bucket:bucket_water"

-- Ingredient Variables
if mcl then
    technic.compat.blueberries_ingredient = "mcl_farming:blueberries"
    technic.compat.grass_ingredient = "mcl_core:grass"
    technic.compat.dry_shrub_ingredient = "mcl_core:deadbush"
    technic.compat.junglegrass_ingredient = "mcl_core:tallgrass"
    technic.compat.cactus_ingredient = "mcl_core:cactus"
    technic.compat.geranium_ingredient = "mcl_flowers:blue_orchid"
    technic.compat.dandelion_white_ingredient = "mcl_flowers:oxeye_daisy"
    technic.compat.dandelion_yellow_ingredient = "mcl_flowers:dandelion"
    technic.compat.tulip_ingredient = "mcl_flowers:orange_tulip"
    technic.compat.rose_ingredient = "mcl_flowers:poppy"
    technic.compat.viola_ingredient = "mcl_flowers:allium"
else
    technic.compat.blueberries_ingredient = "default:blueberries"
    technic.compat.grass_ingredient = "default:grass_1"
    technic.compat.dry_shrub_ingredient = "default:dry_shrub"
    technic.compat.junglegrass_ingredient = "default:junglegrass"
    technic.compat.cactus_ingredient = "default:cactus"
    technic.compat.geranium_ingredient = "flowers:geranium"
    technic.compat.dandelion_white_ingredient = "flowers:dandelion_white"
    technic.compat.dandelion_yellow_ingredient = "flowers:dandelion_yellow"
    technic.compat.tulip_ingredient = "flowers:tulip"
    technic.compat.rose_ingredient = "flowers:rose"
    technic.compat.viola_ingredient = "flowers:viola"
end

-- Dye Output Variables
if mcl then
    technic.compat.dye_black = "mcl_dye:black"
    technic.compat.dye_violet = "mcl_dye:violet"
    technic.compat.dye_green = "mcl_dye:green"
    technic.compat.dye_brown = "mcl_dye:brown"
    technic.compat.dye_blue = "mcl_dye:blue"
    technic.compat.dye_white = "mcl_dye:white"
    technic.compat.dye_yellow = "mcl_dye:yellow"
    technic.compat.dye_orange = "mcl_dye:orange"
    technic.compat.dye_red = "mcl_dye:red"
else
    technic.compat.dye_black = "dye:black"
    technic.compat.dye_violet = "dye:violet"
    technic.compat.dye_green = "dye:green"
    technic.compat.dye_brown = "dye:brown"
    technic.compat.dye_blue = "dye:blue"
    technic.compat.dye_white = "dye:white"
    technic.compat.dye_yellow = "dye:yellow"
    technic.compat.dye_orange = "dye:orange"
    technic.compat.dye_red = "dye:red"
end

technic.compat.dirt_with_snow_ingredient = mcl and "mcl_core:dirt_with_grass_snow" or "default:dirt_with_snow"
technic.compat.bucket_lava_ingredient = mcl and "mcl_buckets:bucket_lava" or "bucket:bucket_lava"
technic.compat.bucket_river_water_ingredient = mcl and "mcl_buckets:bucket_river_water" or "bucket:bucket_river_water"
