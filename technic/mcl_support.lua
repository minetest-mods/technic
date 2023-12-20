local default = minetest.get_modpath("default") and default or {}
-- Mineclone2 Support
stone_sounds = minetest.get_modpath("mcl_sounds") and mcl_sounds.node_sound_stone_defaults() or default.node_sound_stone_defaults()
mt_light_max = minetest.get_modpath("mcl_core") and mcl_core.LIGHT_MAX or default.LIGHT_MAX
copper_ingrediant = minetest.get_modpath("mcl_core") and "mcl_copper:copper_ingot" or 'default:copper_ingot'
iron_ingrediant = minetest.get_modpath("mcl_core") and "mcl_core:iron_ingot" or 'default:steel_ingot'
iron_lump_ingrediant = minetest.get_modpath("mcl_core") and "mcl_raw_ores:raw_iron" or 'default:iron_lump'
gold_lump_ingrediant = minetest.get_modpath("mcl_core") and "mcl_raw_ores:raw_gold" or 'default:gold_lump'
copper_lump_ingrediant = minetest.get_modpath("mcl_core") and "mcl_raw_ores:raw_copper" or 'default:copper_lump'
mese_crystal_ingrediant = minetest.get_modpath("mcl_core") and "mesecons:wire_00000000_off" or 'default:mese_crystal'
diamond_ingrediant = minetest.get_modpath("mcl_core") and "mcl_core:diamond" or 'default:diamond'
glass_ingrediant = minetest.get_modpath("mcl_core") and "mcl_core:glass" or 'default:glass'
brick_block_ingrediant = minetest.get_modpath("mcl_core") and "mcl_core:brick_block" or 'default:brick'
mese_block_ingrediant = minetest.get_modpath("mcl_core") and "mesecons_torch:redstoneblock" or "default:mese"
paper_ingrediant = minetest.get_modpath("mcl_core") and "mcl_core:paper" or 'default:paper'
obsidian_glass_ingrediant = minetest.get_modpath("mcl_core") and "mcl_core:obsidian" or 'default:obsidian_glass'
obsidian_ingrediant = minetest.get_modpath("mcl_core") and "mcl_core:obsidian" or 'default:obsidian'
green_dye_ingrediant = minetest.get_modpath("mcl_core") and "mcl_dye:green" or 'dye:green'
blue_dye_ingrediant = minetest.get_modpath("mcl_core") and "mcl_dye:blue" or 'dye:blue'
red_dye_ingrediant = minetest.get_modpath("mcl_core") and "mcl_dye:red" or 'dye:red'
white_dye_ingrediant = minetest.get_modpath("mcl_core") and "mcl_dye:white" or 'dye:white'
gold_ingot_ingrediant = minetest.get_modpath("mcl_core") and "mcl_core:gold_ingot" or 'default:gold_ingot'
chest_ingrediant = minetest.get_modpath("mcl_core") and "mcl_chests:chest" or "default:chest"
stone_ingrediant = minetest.get_modpath("mcl_core") and "mcl_core:stone" or "default:stone"
wood_fence_ingrediant = minetest.get_modpath("mcl_core") and "group:fence_wood" or "default:fence_wood"
diamond_ingrediant = minetest.get_modpath("mcl_core") and "mcl_core:diamond" or "default:diamond"
bronze_ingrediant = minetest.get_modpath("mcl_core") and "mcl_copper:copper_ingot" or 'default:bronze_ingot'
tin_ingrediant = minetest.get_modpath("mcl_core") and "moreores:tin_ingot" or 'default:tin_ingot'
sandstone_ingrediant = minetest.get_modpath("mcl_core") and "mcl_core:sandstone" or 'default:desert_stone'
sand_ingrediant = minetest.get_modpath("mcl_core") and "mcl_core:sand" or 'default:sand'
gravel_ingrediant = minetest.get_modpath("mcl_core") and "mcl_core:gravel" or 'default:gravel'
desert_stone_ingrediant = minetest.get_modpath("mcl_core") and "mcl_core:redsandstone" or 'default:desert_stone'
desert_sand_ingrediant = minetest.get_modpath("mcl_core") and "mcl_core:redsand" or 'default:desert_sand'
furnace_ingrediant = minetest.get_modpath("mcl_core") and "mcl_furnaces:furnace" or 'default:furnace'
mossy_cobble_ingrediant = minetest.get_modpath("mcl_core") and "mcl_core:mossycobble" or 'default:mossycobble'
cobble_ingrediant = minetest.get_modpath("mcl_core") and "mcl_core:cobble" or 'default:cobble'
snow_block_ingrediant = minetest.get_modpath("mcl_core") and "mcl_core:snowblock" or 'default:snowblock'
ice_block_ingrediant = minetest.get_modpath("mcl_core") and "mcl_core:ice" or 'default:ice'
granite_ingrediant = minetest.get_modpath("mcl_core") and "mcl_core:granite" or 'technic:granite'
granite_bricks_ingrediant = minetest.get_modpath("mcl_core") and "mcl_core:granite_smooth" or 'technic:granite_bricks'
coal_ingrediant = minetest.get_modpath("mcl_core") and "group:coal" or "default:coal_lump"
dirt_ingrediant = minetest.get_modpath("mcl_core") and "mcl_core:dirt" or "default:dirt"
mesecons_fiber_ingrediant = minetest.get_modpath("mcl_core") and "mesecons:wire_00000000_off" or "mesecons_materials:fiber"
stick_ingrediant = minetest.get_modpath("mcl_core") and "mcl_core:stick" or "default:stick"
emtpy_bucket_ingrediant = minetest.get_modpath("mcl_core") and "mcl_buckets:bucket_empty" or "bucket:bucket_empty"
water_bucket_ingrediant = minetest.get_modpath("mcl_core") and "mcl_buckets:bucket_water" or "bucket:bucket_water"

-- Ingredient Variables
if minetest.get_modpath("mcl_core") then
    blueberries_ingredient = "mcl_farming:blueberries"
    grass_ingredient = "mcl_core:grass"
    dry_shrub_ingredient = "mcl_core:deadbush"
    junglegrass_ingredient = "mcl_core:tallgrass"
    cactus_ingredient = "mcl_core:cactus"
    geranium_ingredient = "mcl_flowers:blue_orchid"
    dandelion_white_ingredient = "mcl_flowers:oxeye_daisy"
    dandelion_yellow_ingredient = "mcl_flowers:dandelion"
    tulip_ingredient = "mcl_flowers:orange_tulip"
    rose_ingredient = "mcl_flowers:poppy"
    viola_ingredient = "mcl_flowers:allium"
else
    blueberries_ingredient = "default:blueberries"
    grass_ingredient = "default:grass_1"
    dry_shrub_ingredient = "default:dry_shrub"
    junglegrass_ingredient = "default:junglegrass"
    cactus_ingredient = "default:cactus"
    geranium_ingredient = "flowers:geranium"
    dandelion_white_ingredient = "flowers:dandelion_white"
    dandelion_yellow_ingredient = "flowers:dandelion_yellow"
    tulip_ingredient = "flowers:tulip"
    rose_ingredient = "flowers:rose"
    viola_ingredient = "flowers:viola"
end

-- Dye Output Variables
if minetest.get_modpath("mcl_core") then
    dye_black = "mcl_dye:black"
    dye_violet = "mcl_dye:violet"
    dye_green = "mcl_dye:green"
    dye_brown = "mcl_dye:brown"
    dye_blue = "mcl_dye:blue"
    dye_white = "mcl_dye:white"
    dye_yellow = "mcl_dye:yellow"
    dye_orange = "mcl_dye:orange"
    dye_red = "mcl_dye:red"
else
    dye_black = "dye:black"
    dye_violet = "dye:violet"
    dye_green = "dye:green"
    dye_brown = "dye:brown"
    dye_blue = "dye:blue"
    dye_white = "dye:white"
    dye_yellow = "dye:yellow"
    dye_orange = "dye:orange"
    dye_red = "dye:red"
end

dirt_with_snow_ingrediant = minetest.get_modpath("mcl_core") and "mcl_core:dirt_with_grass_snow" or "default:dirt_with_snow"
bucket_lava_ingrediant = minetest.get_modpath("mcl_core") and "mcl_buckets:bucket_lava" or "bucket:bucket_lava"
bucket_river_water_ingrediant = minetest.get_modpath("mcl_core") and "mcl_buckets:bucket_river_water" or "bucket:bucket_river_water"
