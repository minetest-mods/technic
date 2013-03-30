-- Minetest 0.4.6 : technic

modpath=minetest.get_modpath("technic")

--Read technic config file
dofile(modpath.."/config.lua")
--helper functions
dofile(modpath.."/helpers.lua")

-- chests
dofile(modpath.."/chest_commons.lua")
dofile(modpath.."/iron_chest.lua")
dofile(modpath.."/copper_chest.lua")
dofile(modpath.."/silver_chest.lua")
dofile(modpath.."/gold_chest.lua")
dofile(modpath.."/mithril_chest.lua")

--items 
dofile(modpath.."/concrete.lua")
dofile(modpath.."/items.lua")

--LV machines
dofile(modpath.."/wires.lua")
dofile(modpath.."/battery_box.lua")
dofile(modpath.."/alloy_furnaces_commons.lua")
dofile(modpath.."/alloy_furnace.lua")
dofile(modpath.."/solar_panel.lua")
dofile(modpath.."/geothermal.lua")
dofile(modpath.."/water_mill.lua")
dofile(modpath.."/electric_furnace.lua")
dofile(modpath.."/tool_workshop.lua")
dofile(modpath.."/music_player.lua")
dofile(modpath.."/generator.lua")
dofile(modpath.."/grinder.lua")

--MV machines
dofile(modpath.."/wires_mv.lua")
dofile(modpath.."/battery_box_mv.lua")
dofile(modpath.."/solar_panel_mv.lua")
dofile(modpath.."/electric_furnace_mv.lua")
dofile(modpath.."/alloy_furnace_mv.lua")
dofile(modpath.."/forcefield.lua")

--Tools
if enable_mining_drill==true then dofile(modpath.."/mining_drill.lua") end
if enable_mining_laser==true then dofile(modpath.."/mining_laser_mk1.lua") end
if enable_flashlight==true then dofile(modpath.."/flashlight.lua") end
dofile(modpath.."/cans.lua")
dofile(modpath.."/chainsaw.lua")
dofile(modpath.."/tree_tap.lua")
dofile(modpath.."/sonic_screwdriver.lua")

-- mesecons and tubes related
dofile(modpath.."/injector.lua")
dofile(modpath.."/node_breaker.lua")
dofile(modpath.."/deployer.lua")
dofile(modpath.."/constructor.lua")
dofile(modpath.."/frames.lua")


if enable_item_drop	then dofile(modpath.."/item_drop.lua") end
if enable_item_pickup   then dofile(modpath.."/item_pickup.lua") end

function has_locked_chest_privilege(meta, player)
	if player:get_player_name() ~= meta:get_string("owner") then
		return false
	end
	return true
end


function hacky_swap_node(pos,name)
	local node = minetest.env:get_node(pos)
	local meta = minetest.env:get_meta(pos)
	local meta0 = meta:to_table()
	if node.name == name then
		return nil
	end
	node.name = name
	local meta0 = meta:to_table()
	minetest.env:set_node(pos,node)
	meta = minetest.env:get_meta(pos)
	meta:from_table(meta0)
	return 1
end
