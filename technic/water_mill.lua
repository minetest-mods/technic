-- A water mill produces LV EUs by exploiting flowing water across it
-- It is a LV EU supplyer and fairly low yield (max 120EUs)
-- It is a little under half as good as the thermal generator.
minetest.register_alias("water_mill", "technic:water_mill")

minetest.register_craft({
	output = 'technic:water_mill',
	recipe = {
		{'default:stone', 'default:stone', 'default:stone'},
		{'default:wood', 'default:diamond', 'default:wood'},
		{'default:stone', 'default:copper_ingot', 'default:stone'},
	}
})

minetest.register_craftitem("technic:water_mill", {
	description = "Water Mill",
	stack_max = 99,
}) 

local water_mill_formspec =
	"invsize[8,4;]"..
	"image[1,1;1,2;technic_power_meter_bg.png]"..
	"label[0,0;Water Mill]"..
	"label[1,3;Power level]"..
	"list[current_player;main;0,5;8,4;]"
	

minetest.register_node(
   "technic:water_mill",
   {
      description = "Water Mill",
      tiles = {"technic_water_mill_top.png", "technic_machine_bottom.png", "technic_water_mill_side.png",
	       "technic_water_mill_side.png", "technic_water_mill_side.png", "technic_water_mill_side.png"},
      paramtype2 = "facedir",
      groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
      legacy_facedir_simple = true,
      sounds = default.node_sound_wood_defaults(),
      on_construct = function(pos)
			local meta = minetest.env:get_meta(pos)
			meta:set_string("infotext", "Water Mill")
			meta:set_float("technic_power_machine", 1)
			meta:set_int("LV_EU_supply", 0)
			meta:set_string("formspec", water_mill_formspec)	
		     end,	
   })

minetest.register_node(
   "technic:water_mill_active",
   {
      description = "Water Mill",
      tiles = {"technic_water_mill_top_active.png", "technic_machine_bottom.png", "technic_water_mill_side.png",
	       "technic_water_mill_side.png", "technic_water_mill_side.png", "technic_water_mill_side.png"},
      paramtype2 = "facedir",
      groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2,not_in_creative_inventory=1},
      legacy_facedir_simple = true,
      sounds = default.node_sound_wood_defaults(),
      drop="technic:water_mill",
})

local check_node_around_mill = function(pos)
				  local node=minetest.env:get_node(pos)
				  if node.name=="default:water_flowing" then return 1 end
				  return 0
			       end

minetest.register_abm(
   {
      nodenames = {"technic:water_mill","technic:water_mill_active"},
      interval = 1,
      chance   = 1,
      action = function(pos, node, active_object_count, active_object_count_wider)
		  local meta             = minetest.env:get_meta(pos)
		  local water_nodes      = 0
		  local lava_nodes       = 0
		  local production_level = 0
		  local eu_supply        = 0

		  pos.x=pos.x+1
		  local check=check_node_around_mill (pos)
		  if check==1 then water_nodes=water_nodes+1 end
		  pos.x=pos.x-2
		  check=check_node_around_mill (pos)
		  if check==1 then water_nodes=water_nodes+1 end
		  pos.x=pos.x+1
		  pos.z=pos.z+1
		  check=check_node_around_mill (pos)
		  if check==1 then water_nodes=water_nodes+1 end
		  pos.z=pos.z-2
		  check=check_node_around_mill (pos)
		  if check==1 then water_nodes=water_nodes+1 end
		  pos.z=pos.z+1
	
		  if water_nodes==1 then production_level =  25; eu_supply =  30 end
		  if water_nodes==2 then production_level =  50; eu_supply =  60 end
		  if water_nodes==3 then production_level =  75; eu_supply =  90 end
		  if water_nodes==4 then production_level = 100; eu_supply = 120 end

		  if production_level>0 then
		     meta:set_int("LV_EU_supply", eu_supply)
		  end

		  local load = 1 -- math.floor((charge/max_charge)*100)
		  meta:set_string("formspec",
				  "invsize[8,4;]"..
				     "image[1,1;1,2;technic_power_meter_bg.png^[lowpart:"..
				     (load)..":technic_power_meter_fg.png]"..
				  "label[0,0;Water Mill]"..
				  "label[1,3;Power level]"..
				  "label[4,0;Production at "..tostring(production_level).."%]"
			    )
				
		  if production_level>0 and minetest.env:get_node(pos).name=="technic:water_mill" then
		     hacky_swap_node (pos,"technic:water_mill_active")
		     meta:set_int("LV_EU_supply", 0)
		     return
		  end
		  if production_level==0 then hacky_swap_node (pos,"technic:water_mill") end
	       end
   }) 

technic.register_LV_machine ("technic:water_mill","PR")
technic.register_LV_machine ("technic:water_mill_active","PR")
