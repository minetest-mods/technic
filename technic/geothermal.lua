-- A geothermal EU generator
-- Using hot lava and water this device can create energy from steam
-- The machine is only producing LV EUs and can thus not drive more advanced equipment
-- The output is a little more than the coal burning generator (max 300EUs)
minetest.register_alias("geothermal", "technic:geothermal")

minetest.register_craft({
	output = 'technic:geothermal',
	recipe = {
		{'default:stone', 'default:stone', 'default:stone'},
		{'default:copper_ingot', 'default:diamond', 'default:copper_ingot'},
		{'default:stone', 'default:copper_ingot', 'default:stone'},
	}
})

minetest.register_craftitem("technic:geothermal", {
	description = "Geothermal Generator",
	stack_max = 99,
}) 

local geothermal_formspec =
	"invsize[8,4;]"..
	"image[1,1;1,2;technic_power_meter_bg.png]"..
	"label[0,0;Geothermal Generator]"..
	"label[1,3;Power level]"..
	"list[current_player;main;0,5;8,4;]"
	

minetest.register_node(
   "technic:geothermal",
   {
      description = "Geothermal Generator",
      tiles = {"technic_geothermal_top.png", "technic_machine_bottom.png", "technic_geothermal_side.png",
	       "technic_geothermal_side.png", "technic_geothermal_side.png", "technic_geothermal_side.png"},
      paramtype2 = "facedir",
      groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
      legacy_facedir_simple = true,
      sounds = default.node_sound_wood_defaults(),
      on_construct = function(pos)
			local meta = minetest.env:get_meta(pos)
			meta:set_string("infotext", "Geothermal Generator")
			meta:set_float("technic_power_machine", 1)
			meta:set_int("LV_EU_supply", 0)
			meta:set_string("formspec", geothermal_formspec)	
		     end,	
   })

minetest.register_node(
   "technic:geothermal_active",
   {
      description = "Geothermal Generator",
      tiles = {"technic_geothermal_top_active.png", "technic_machine_bottom.png", "technic_geothermal_side.png",
	       "technic_geothermal_side.png", "technic_geothermal_side.png", "technic_geothermal_side.png"},
      paramtype2 = "facedir",
      groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2,not_in_creative_inventory=1},
      legacy_facedir_simple = true,
      sounds = default.node_sound_wood_defaults(),
      drop="technic:geothermal",
   })

local check_node_around = function(pos)
			     local node=minetest.env:get_node(pos)
			     if node.name=="default:water_source" or node.name=="default:water_flowing" then return 1 end
			     if node.name=="default:lava_source" or node.name=="default:lava_flowing" then return 2 end	
			     return 0
			  end

minetest.register_abm(
   {
      nodenames = {"technic:geothermal","technic:geothermal_active"},
      interval = 1,
      chance   = 1,
      action = function(pos, node, active_object_count, active_object_count_wider)
		  local meta             = minetest.env:get_meta(pos)
		  local water_nodes      = 0
		  local lava_nodes       = 0
		  local production_level = 0
		  local eu_supply        = 0

		  -- Correct positioning is water on one side and lava on the other.
		  -- The two cannot be adjacent because the lava the turns into obsidian or rock.
		  -- To get to 100% production stack the water and lava one extra block down as well:
		  --    WGL (W=Water, L=Lava, G=the generator, |=an LV cable)
                  --    W|L
		  pos.x=pos.x+1
		  local check=check_node_around(pos)
		  if check==1 then water_nodes=water_nodes+1 end
		  if check==2 then lava_nodes=lava_nodes+1 end
		  pos.y=pos.y-1
		  local check=check_node_around(pos)
		  if check==1 then water_nodes=water_nodes+1 end
		  if check==2 then lava_nodes=lava_nodes+1 end

		  pos.x=pos.x-2
		  check=check_node_around(pos)
		  if check==1 then water_nodes=water_nodes+1 end
		  if check==2 then lava_nodes=lava_nodes+1 end
		  pos.y=pos.y+1
		  check=check_node_around(pos)
		  if check==1 then water_nodes=water_nodes+1 end
		  if check==2 then lava_nodes=lava_nodes+1 end

		  pos.x=pos.x+1
		  pos.z=pos.z+1
		  check=check_node_around(pos)
		  if check==1 then water_nodes=water_nodes+1 end
		  if check==2 then lava_nodes=lava_nodes+1 end
		  pos.y=pos.y-1
		  check=check_node_around(pos)
		  if check==1 then water_nodes=water_nodes+1 end
		  if check==2 then lava_nodes=lava_nodes+1 end

		  pos.z=pos.z-2
		  check=check_node_around(pos)
		  if check==1 then water_nodes=water_nodes+1 end
		  if check==2 then lava_nodes=lava_nodes+1 end
		  pos.y=pos.y+1
		  check=check_node_around(pos)
		  if check==1 then water_nodes=water_nodes+1 end
		  if check==2 then lava_nodes=lava_nodes+1 end

		  -- Back to (0,0,0)
		  pos.z=pos.z+1
	
		  if water_nodes==1 and lava_nodes==1 then production_level =  25; eu_supply = 50 end
		  if water_nodes==2 and lava_nodes==1 then production_level =  50; eu_supply = 100 end
		  if water_nodes==1 and lava_nodes==2 then production_level =  75; eu_supply = 200 end
		  if water_nodes==2 and lava_nodes==2 then production_level = 100; eu_supply = 300 end

		  if production_level>0 then
		     meta:set_int("LV_EU_supply", eu_supply)
		  end

		  local load = 1 -- math.floor((charge/max_charge)*100)
		  meta:set_string("formspec",
				  "invsize[8,4;]"..
				     "image[1,1;1,2;technic_power_meter_bg.png^[lowpart:"..
				     (load)..":technic_power_meter_fg.png]"..
				  "label[0,0;Geothermal Generator]"..
				  "label[1,3;Power level]"..
				  "label[4,0;Production at "..tostring(production_level).."%]"
			    )
				
		  if production_level>0 and minetest.env:get_node(pos).name=="technic:geothermal" then
		     hacky_swap_node (pos,"technic:geothermal_active")
		     return
		  end
		  if production_level==0 then
		     hacky_swap_node (pos,"technic:geothermal")
		     meta:set_int("LV_EU_supply", 0)
		  end
	       end
   }) 

technic.register_LV_machine ("technic:geothermal","PR")
technic.register_LV_machine ("technic:geothermal_active","PR")
