-- namespace: technic
-- (c) 2012-2013 by RealBadAngel <mk@realbadangel.pl>

-- Mineclone2 Support
stone_sounds = nil
if minetest.get_modpath("mcl_sounds") then
	stone_sounds = mcl_sounds.node_sound_stone_defaults()
else
	stone_sounds = default.node_sound_stone_defaults()
end

mt_light_max = nil
if minetest.get_modpath("mcl_core") then
	mt_light_max = mcl_core.LIGHT_MAX
else
	mt_light_max = default.LIGHT_MAX
end

copper_ingrediant = nil
if minetest.get_modpath("mcl_core") then
	copper_ingrediant = "mcl_copper:copper_ingot"
else
	copper_ingrediant = 'default:copper_ingot'
end

iron_ingrediant = nil
if minetest.get_modpath("mcl_core") then
	iron_ingrediant = "mcl_core:iron_ingot"
else
	iron_ingrediant = 'default:steel_ingot'
end

mese_crystal_ingrediant = nil
if minetest.get_modpath("mcl_core") then
	mese_crystal_ingrediant = "mesecons:wire_00000000_off"
else
	mese_crystal_ingrediant = 'default:mese_crystal'
end

diamond_ingrediant = nil
if minetest.get_modpath("mcl_core") then
	diamond_ingrediant = "mcl_core:diamond"
else
	diamond_ingrediant = 'default:diamond'
end

glass_ingrediant = nil
if minetest.get_modpath("mcl_core") then
	glass_ingrediant = "mcl_core:glass"
else
	glass_ingrediant = 'default:glass'
end

brick_block_ingrediant = nil
if minetest.get_modpath("mcl_core") then
	brick_block_ingrediant = "mcl_core:brick_block"
else
	brick_block_ingrediant = 'default:brick'
end

mese_block_ingrediant = nil
if minetest.get_modpath("mcl_core") then
	mese_block_ingrediant = "mesecons_torch:redstoneblock"
else
	mese_block_ingrediant = "default:mese"
end


paper_ingrediant = nil
if minetest.get_modpath("mcl_core") then
	paper_ingrediant = "mcl_core:paper"
else
	paper_ingrediant = 'default:paper'
end


obsidian_glass_ingrediant = nil
if minetest.get_modpath("mcl_core") then
	obsidian_glass_ingrediant = "mcl_core:obsidian"
else
	obsidian_glass_ingrediant = 'default:obsidian_glass'
end

obsidian_ingrediant = nil
if minetest.get_modpath("mcl_core") then
	obsidian_ingrediant = "mcl_core:obsidian"
else
	obsidian_ingrediant = 'default:obsidian'
end

green_dye_ingrediant = nil
if minetest.get_modpath("mcl_core") then
	green_dye_ingrediant = "mcl_dye:green"
else
	green_dye_ingrediant = 'dye:green'
end

blue_dye_ingrediant = nil
if minetest.get_modpath("mcl_core") then
	blue_dye_ingrediant = "mcl_dye:blue"
else
	blue_dye_ingrediant = 'dye:blue'
end

red_dye_ingrediant = nil
if minetest.get_modpath("mcl_core") then
	red_dye_ingrediant = "mcl_dye:red"
else
	red_dye_ingrediant = 'dye:red'
end

white_dye_ingrediant = nil
if minetest.get_modpath("mcl_core") then
	white_dye_ingrediant = "mcl_dye:white"
else
	white_dye_ingrediant = 'dye:white'
end

gold_ingot_ingrediant = nil
if minetest.get_modpath("mcl_core") then
	gold_ingot_ingrediant = "mcl_core:gold_ingot"
else
	gold_ingot_ingrediant = 'default:gold_ingot'
end

chest_ingrediant = nil
if minetest.get_modpath("mcl_core") then
	chest_ingrediant = "mcl_chests:chest"
else
	chest_ingrediant = "default:chest"
end

stone_ingrediant = nil
if minetest.get_modpath("mcl_core") then
	stone_ingrediant = "mcl_core:stone"
else
	stone_ingrediant = "default:stone"
end

wood_fence_ingrediant = nil
if minetest.get_modpath("mcl_core") then
	wood_fence_ingrediant = "group:fence_wood"
else
	wood_fence_ingrediant = "default:fence_wood"
end


diamond_ingrediant = nil
if minetest.get_modpath("mcl_core") then
	diamond_ingrediant = "mcl_core:diamond"
else
	diamond_ingrediant = "default:diamond"
end

bronze_ingrediant = nil
if minetest.get_modpath("mcl_core") then
	bronze_ingrediant = "mcl_copper:copper_ingot"
else
	bronze_ingrediant = 'default:bronze_ingot'
end

tin_ingrediant = nil
if minetest.get_modpath("mcl_core") then
	tin_ingrediant = "moreores:tin_ingot"
else
	tin_ingrediant = 'default:tin_ingot'
end

sandstone_ingrediant = nil
if minetest.get_modpath("mcl_core") then
	sandstone_ingrediant = "mcl_core:sandstone"
else
	sandstone_ingrediant = 'default:desert_stone'
end

sand_ingrediant = nil
if minetest.get_modpath("mcl_core") then
	sand_ingrediant = "mcl_core:sand"
else
	sand_ingrediant = 'default:sand'
end

desert_stone_ingrediant = nil
if minetest.get_modpath("mcl_core") then
	desert_stone_ingrediant = "mcl_core:redsandstone"
else
	desert_stone_ingrediant = 'default:desert_stone'
end

desert_sand_ingrediant = nil
if minetest.get_modpath("mcl_core") then
	desert_sand_ingrediant = "mcl_core:redsand"
else
	desert_sand_ingrediant = 'default:desert_sand'
end



furnace_ingrediant = nil
if minetest.get_modpath("mcl_core") then
	furnace_ingrediant = "mcl_furnaces:furnace"
else
	furnace_ingrediant = 'default:furnace'
end

mossy_cobble_ingrediant = nil
if minetest.get_modpath("mcl_core") then
	mossy_cobble_ingrediant = "mcl_core:mossycobble"
else
	mossy_cobble_ingrediant = 'default:mossycobble'
end

snow_block_ingrediant = nil
if minetest.get_modpath("mcl_core") then
	snow_block_ingrediant = "mcl_core:snowblock"
else
	snow_block_ingrediant = 'default:snowblock'
end

ice_block_ingrediant = nil
if minetest.get_modpath("mcl_core") then
	ice_block_ingrediant = "mcl_core:ice"
else
	ice_block_ingrediant = 'default:ice'
end

granite_ingrediant = nil
if minetest.get_modpath("mcl_core") then
	granite_ingrediant = "mcl_core:granite"
else
	granite_ingrediant = 'technic:granite'
end

granite_bricks_ingrediant = nil
if minetest.get_modpath("mcl_core") then
	granite_bricks_ingrediant = "mcl_core:granite_smooth"
else
	granite_bricks_ingrediant = 'technic:granite_bricks'
end

coal_ingrediant = nil
if minetest.get_modpath("mcl_core") then
	coal_ingrediant = "group:coal"
else
	coal_ingrediant = "default:coal_lump"
end

dirt_ingrediant = nil
if minetest.get_modpath("mcl_core") then
	dirt_ingrediant = "mcl_core:dirt"
else
	dirt_ingrediant = "default:dirt"
end

mesecons_fiber_ingrediant = nil

if minetest.get_modpath("mcl_core") then
	mesecons_fiber_ingrediant = "mesecons:wire_00000000_off"
else
	mesecons_fiber_ingrediant = "mesecons_materials:fiber"
end

stick_ingrediant = nil

if minetest.get_modpath("mcl_core") then
	stick_ingrediant = "mcl_core:stick"
else
	stick_ingrediant = "default:stick"
end

if not minetest.get_translator then
	error("[technic] Your Minetest version is no longer supported."
		.. " (version < 5.0.0)")
end



local load_start = os.clock()

technic = rawget(_G, "technic") or {}
technic.creative_mode = minetest.settings:get_bool("creative_mode")


local modpath = minetest.get_modpath("technic")
technic.modpath = modpath


-- Boilerplate to support intllib
if rawget(_G, "intllib") then
	technic.getter = intllib.Getter()
else
	-- Intllib copypasta: TODO replace with the client-side translation API
	technic.getter = function(s,a,...)
		if a==nil then return s end
		a={a,...}
		return s:gsub("(@?)@(%(?)(%d+)(%)?)", function(e,o,n,c)
			if e==""then
				return a[tonumber(n)]..(o==""and c or"")
			end
			return "@"..o..n..c
		end)
	end
end
local S = technic.getter

-- Read configuration file
dofile(modpath.."/config.lua")

-- Helper functions
dofile(modpath.."/helpers.lua")

-- Items
dofile(modpath.."/items.lua")

-- Craft recipes for items
dofile(modpath.."/crafts.lua")

-- Register functions
dofile(modpath.."/register.lua")

-- Radiation
dofile(modpath.."/radiation.lua")

-- Machines
dofile(modpath.."/machines/init.lua")

-- Tools
dofile(modpath.."/tools/init.lua")

-- Aliases for legacy node/item names
dofile(modpath.."/legacy.lua")

if minetest.settings:get_bool("log_mods") then
	print(S("[Technic] Loaded in %f seconds"):format(os.clock() - load_start))
end

