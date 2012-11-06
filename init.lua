-- Minetest 0.4.3 : technic

minetest.register_alias("rebar", "technic:rebar")
minetest.register_alias("concrete", "technic:concrete")
minetest.register_alias("concrete_post", "technic:concrete_post")
minetest.register_alias("iron_chest", "technic:iron_chest")
minetest.register_alias("iron_locked_chest", "technic:iron_locked_chest")
minetest.register_alias("copper_chest", "technic:copper_chest")
minetest.register_alias("copper_locked_chest", "technic:copper_locked_chest")
minetest.register_alias("silver_chest", "technic:silver_chest")
minetest.register_alias("silver_locked_chest", "technic:silver_locked_chest")
minetest.register_alias("gold_chest", "technic:gold_chest")
minetest.register_alias("gold_locked_chest", "technic:gold_locked_chest")
minetest.register_alias("mithril_chest", "technic:mithril_chest")
minetest.register_alias("mithril_locked_chest", "technic:mithril_locked_chest")


modpath=minetest.get_modpath("technic")

--Read technic config file
dofile(modpath.."/config.lua")

dofile(modpath.."/concrete.lua")
dofile(modpath.."/iron_chest.lua")
dofile(modpath.."/copper_chest.lua")
dofile(modpath.."/silver_chest.lua")
dofile(modpath.."/gold_chest.lua")
dofile(modpath.."/mithril_chest.lua")
dofile(modpath.."/electric_furnace.lua")
dofile(modpath.."/battery_box.lua")
dofile(modpath.."/wires.lua")
dofile(modpath.."/wires_mv.lua")
dofile(modpath.."/ores.lua")
dofile(modpath.."/tool_workshop.lua")
dofile(modpath.."/music_player.lua")
dofile(modpath.."/grinder.lua")
dofile(modpath.."/mining_laser_mk1.lua")
dofile(modpath.."/injector.lua")
dofile(modpath.."/generator.lua")
dofile(modpath.."/solar_panel.lua")
dofile(modpath.."/geothermal.lua")
dofile(modpath.."/water_mill.lua")
dofile(modpath.."/alloy_furnace.lua")
dofile(modpath.."/items.lua")
dofile(modpath.."/mining_drill.lua")
dofile(modpath.."/screwdriver.lua")
dofile(modpath.."/sonic_screwdriver.lua")
dofile(modpath.."/node_breaker.lua")
dofile(modpath.."/deployer.lua")
dofile(modpath.."/constructor.lua")
dofile(modpath.."/tree_tap.lua")
dofile(modpath.."/flashlight.lua")
dofile(modpath.."/cans.lua")
dofile(modpath.."/chainsaw.lua")
dofile(modpath.."/nuclear_reactor.lua")

if enable_item_drop	then dofile(modpath.."/item_drop.lua") end
if enable_item_pickup   then dofile(modpath.."/item_pickup.lua") end

--MV machines
dofile(modpath.."/solar_panel_mv.lua")
dofile(modpath.."/battery_box_mv.lua")


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