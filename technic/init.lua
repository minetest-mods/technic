-- Minetest 0.4.6 mod: technic
-- namespace: technic
-- (c) 2012-2013 by RealBadAngel <mk@realbadangel.pl>

technic = {}

technic.dprint = function(string)
		    if technic.DBG == 1 then
		       print(string)
		    end
		 end

local modpath=minetest.get_modpath("technic")

--Read technic config file
dofile(modpath.."/config.lua")
--helper functions
dofile(modpath.."/helpers.lua")

--items 
dofile(modpath.."/items.lua")

-- Register functions
dofile(modpath.."/register_machine_and_tool.lua")
dofile(modpath.."/alloy_furnaces_commons.lua") -- Idea: Let the LV, MV, HV version of the furnace support different alloys

-- Switching station LV,MV,HV
dofile(modpath.."/switching_station.lua")
dofile(modpath.."/supply_converter.lua")

--LV machines
dofile(modpath.."/wires.lua")
dofile(modpath.."/battery_box.lua")
dofile(modpath.."/alloy_furnace.lua")
dofile(modpath.."/solar_panel.lua")
dofile(modpath.."/solar_array_lv.lua")
dofile(modpath.."/geothermal.lua")
dofile(modpath.."/water_mill.lua")
dofile(modpath.."/generator.lua")
dofile(modpath.."/electric_furnace.lua")
dofile(modpath.."/tool_workshop.lua")
dofile(modpath.."/music_player.lua")
dofile(modpath.."/grinder.lua")
dofile(modpath.."/cnc.lua")
dofile(modpath.."/cnc_api.lua")
dofile(modpath.."/cnc_nodes.lua")

--MV machines
dofile(modpath.."/wires_mv.lua")
dofile(modpath.."/battery_box_mv.lua")
dofile(modpath.."/solar_array_mv.lua")
dofile(modpath.."/electric_furnace_mv.lua")
dofile(modpath.."/alloy_furnace_mv.lua")
dofile(modpath.."/forcefield.lua")
---- The power radiator supplies appliances with inductive coupled power:
---- lighting and associated textures is taken directly from VanessaE's homedecor and made electric.
dofile(modpath.."/power_radiator.lua")
dofile(modpath.."/lighting.lua")
--
----HV machines
dofile(modpath.."/wires_hv.lua")
dofile(modpath.."/battery_box_hv.lua")
dofile(modpath.."/solar_array_hv.lua")

--Tools
if technic.config:getBool("enable_mining_drill") then dofile(modpath.."/mining_drill.lua") end
if technic.config:getBool("enable_mining_laser") then dofile(modpath.."/mining_laser_mk1.lua") end
if technic.config:getBool("enable_flashlight") then dofile(modpath.."/flashlight.lua") end
dofile(modpath.."/cans.lua")
dofile(modpath.."/chainsaw.lua")
dofile(modpath.."/tree_tap.lua")
dofile(modpath.."/sonic_screwdriver.lua")
--
---- mesecons and tubes related
dofile(modpath.."/injector.lua")
dofile(modpath.."/node_breaker.lua")
dofile(modpath.."/deployer.lua")
dofile(modpath.."/constructor.lua")
dofile(modpath.."/frames.lua")

function has_locked_chest_privilege(meta, player)
   if player:get_player_name() ~= meta:get_string("owner") then
      return false
   end
   return true
end


-- Swap nodes out. Return the node name.
function hacky_swap_node(pos,name)
   local node = minetest.env:get_node(pos)
   if node.name ~= name then
      local meta = minetest.env:get_meta(pos)
      local meta0 = meta:to_table()
      node.name = name
      minetest.env:set_node(pos,node)
      meta = minetest.env:get_meta(pos)
      meta:from_table(meta0)
   end
   return node.name
end
