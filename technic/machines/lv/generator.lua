-- The coal driven EU generator.
-- A simple device to get started on the electric machines.
-- Inefficient and expensive in coal (200EU 16 ticks)
-- Also only allows for LV machinery to run.
minetest.register_alias("generator", "technic:generator")
minetest.register_alias("generator", "technic:generator_active")

minetest.register_craft({
	output = 'technic:generator',
	recipe = {
		{'default:stone', 'default:stone', 'default:stone'},
		{'default:stone', '', 'default:stone'},
		{'default:stone', 'default:copper_ingot', 'default:stone'},
	}
})

minetest.register_craftitem("technic:generator", {
	description = "Coal Driven Generator",
	stack_max = 99,
}) 

local generator_formspec =
	"invsize[8,9;]"..
	"image[0,0;5,5;technic_generator_menu.png]"..
	"image[1,1;1,2;technic_power_meter_bg.png]"..
--	"label[0,0;Generator]"..
	"label[1,3;Power level]"..
	"list[current_name;src;3,1;1,1;]"..
	"image[4,1;1,1;default_furnace_fire_bg.png]"..
	"list[current_player;main;0,5;8,4;]"
	

minetest.register_node(
   "technic:generator",
   {
      description = "Coal Driven Generator",
      tiles = {"technic_generator_top.png", "technic_machine_bottom.png", "technic_generator_side.png",
	       "technic_generator_side.png", "technic_generator_side.png", "technic_generator_front.png"},
      paramtype2 = "facedir",
      groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
      legacy_facedir_simple = true,
      sounds = default.node_sound_wood_defaults(),
      on_construct = function(pos)
			local meta = minetest.env:get_meta(pos)
			meta:set_string("infotext", "Coal Electric Generator")
			meta:set_float("technic_power_machine", 1)
			meta:set_int("LV_EU_supply", 0)
			meta:set_int("LV_EU_from_fuel", 1) -- Signal to the switching station that this device burns some sort of fuel and needs special handling
			meta:set_int("burn_time", 0)
			meta:set_string("formspec", generator_formspec)
			local inv = meta:get_inventory()
			inv:set_size("src", 1)
		end,	
      can_dig = function(pos,player)
		   local meta = minetest.env:get_meta(pos);
		   local inv = meta:get_inventory()
		   if not inv:is_empty("src") then
		      minetest.chat_send_player(player:get_player_name(), "Machine cannot be removed because it is not empty");
		      return false
		   else
		      return true
		   end
		end,
   })

minetest.register_node(
   "technic:generator_active",
   {
      description = "Coal Driven Generator",
      tiles = {"technic_generator_top.png", "technic_machine_bottom.png", "technic_generator_side.png",
	       "technic_generator_side.png", "technic_generator_side.png", "technic_generator_front_active.png"},
      paramtype2 = "facedir",
      groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2,not_in_creative_inventory=1},
      legacy_facedir_simple = true,
      sounds = default.node_sound_wood_defaults(),
      drop="technic:generator",
      can_dig = function(pos,player)
		   local meta = minetest.env:get_meta(pos);
		   local inv = meta:get_inventory()
		   if not inv:is_empty("src") then
		      minetest.chat_send_player(player:get_player_name(), "Machine cannot be removed because it is not empty");
		      return false
		   else
		      return true
		   end
		end,
   })

minetest.register_abm(
   {
      nodenames = {"technic:generator","technic:generator_active"},
      interval = 1,
      chance   = 1,
      action = function(pos, node, active_object_count, active_object_count_wider)
		  local meta = minetest.env:get_meta(pos)
		  local burn_time= meta:get_int("burn_time")

		  -- If more to burn and the energy produced was used: produce some more
		  if burn_time>0 then
		     if meta:get_int("LV_EU_supply") == 0 then
			-- We did not use the power
			meta:set_int("LV_EU_supply", 200) -- Give 200EUs
		     else
			burn_time = burn_time - 1
			meta:set_int("burn_time",burn_time)
			meta:set_string("infotext", "Coal Electric Generator ("..math.floor(burn_time/16*100).."%)")
		     end
		  end

		  -- Burn another piece of coal
		  if burn_time==0 then
		     local inv = meta:get_inventory()
		     if inv:is_empty("src") == false  then 
			local srcstack = inv:get_stack("src", 1)
			src_item=srcstack:to_table()
			if src_item["name"] == "default:coal_lump" then
			   srcstack:take_item()
			   inv:set_stack("src", 1, srcstack)
			   burn_time=16
			   meta:set_int("burn_time",burn_time)
			   hacky_swap_node (pos,"technic:generator_active") 
			   meta:set_int("LV_EU_supply", 200) -- Give 200EUs
			else
			   meta:set_int("LV_EU_supply", 0)
			end
		     else
			   meta:set_int("LV_EU_supply", 0)
		     end
		  end

		  local load = 8 -- math.floor((charge/max_charge)*100)
		  local percent = math.floor((burn_time/16)*100)
		  meta:set_string("formspec",
				  "invsize[8,9;]"..
				     "image[1,1;1,2;technic_power_meter_bg.png^[lowpart:"..
				     (load)..":technic_power_meter_fg.png]"..
				  "label[0,0;Generator]"..
				  "label[1,3;Power level]"..
				  "list[current_name;src;3,1;1,1;]"..
				  "image[4,1;1,1;default_furnace_fire_bg.png^[lowpart:"..
				  (percent)..":default_furnace_fire_fg.png]"..
			       "list[current_player;main;0,5;8,4;]"
			 )

		  if burn_time==0 then
		     hacky_swap_node (pos,"technic:generator")
		  end
	       end
   })

technic.register_LV_machine ("technic:generator","PR")
technic.register_LV_machine ("technic:generator_active","PR")
