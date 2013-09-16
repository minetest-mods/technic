technic.grinder_recipes ={}

technic.register_grinder_recipe = function(src, dst)
				   technic.grinder_recipes[src] = dst
				   if unified_inventory then
				      unified_inventory.register_craft(
					 {
					    type = "grinding",
					    output = dst,
					    items = {src},
					    width = 0,
					 })
				   end
				end

-- Receive an ItemStack of result by an ItemStack input
technic.get_grinder_recipe = function(itemstack)
				local src_item  = itemstack:to_table()
				if src_item == nil then
				   return nil
				end
				local item_name = src_item["name"]
				if technic.grinder_recipes[item_name] then
				   return ItemStack(technic.grinder_recipes[item_name])
				else
				   return nil
				end
			     end


technic.register_grinder_recipe("default:stone","default:sand")
technic.register_grinder_recipe("default:cobble","default:gravel")
technic.register_grinder_recipe("default:gravel","default:dirt")
technic.register_grinder_recipe("default:desert_stone","default:desert_sand")
technic.register_grinder_recipe("default:iron_lump","technic:iron_dust 2")
technic.register_grinder_recipe("default:steel_ingot","technic:iron_dust 1")
technic.register_grinder_recipe("default:coal_lump","technic:coal_dust 2")
technic.register_grinder_recipe("default:copper_lump","technic:copper_dust 2")
technic.register_grinder_recipe("default:copper_ingot","technic:copper_dust 1")
technic.register_grinder_recipe("default:gold_lump","technic:gold_dust 2")
technic.register_grinder_recipe("default:gold_ingot","technic:gold_dust 1")
--technic.register_grinder_recipe("default:bronze_ingot","technic:bronze_dust 1")  -- Dust does not exist yet
--technic.register_grinder_recipe("home_decor:brass_ingot","technic:brass_dust 1") -- needs check for the mod
technic.register_grinder_recipe("moreores:tin_lump","technic:tin_dust 2")
technic.register_grinder_recipe("moreores:tin_ingot","technic:tin_dust 1")
technic.register_grinder_recipe("moreores:silver_lump","technic:silver_dust 2")
technic.register_grinder_recipe("moreores:silver_ingot","technic:silver_dust 1")
technic.register_grinder_recipe("moreores:mithril_lump","technic:mithril_dust 2")
technic.register_grinder_recipe("moreores:mithril_ingot","technic:mithril_dust 1")
technic.register_grinder_recipe("technic:chromium_lump","technic:chromium_dust 2")
technic.register_grinder_recipe("technic:chromium_ingot","technic:chromium_dust 1")
technic.register_grinder_recipe("technic:stainless_steel_ingot","stainless_steel_dust 1")
technic.register_grinder_recipe("technic:brass_ingot","technic:brass_dust 1")
technic.register_grinder_recipe("technic:zinc_lump","technic:zinc_dust 2")
technic.register_grinder_recipe("technic:zinc_ingot","technic:zinc_dust 1")

minetest.register_craftitem( "technic:coal_dust", {
				description = "Coal Dust",
				inventory_image = "technic_coal_dust.png",
				on_place_on_ground = minetest.craftitem_place_item,
			     })

minetest.register_craftitem( "technic:iron_dust", {
				description = "Iron Dust",
				inventory_image = "technic_iron_dust.png",
				on_place_on_ground = minetest.craftitem_place_item,
			     })

minetest.register_craft({
			   type = "cooking",
			   output = "default:steel_ingot",
			   recipe = "technic:iron_dust",
			})

minetest.register_craftitem( "technic:copper_dust", {
				description = "Copper Dust",
				inventory_image = "technic_copper_dust.png",
				on_place_on_ground = minetest.craftitem_place_item,
			     })
minetest.register_craft({
			   type = "cooking",
			   output = "moreores:copper_ingot",
			   recipe = "technic:copper_dust",
			})

minetest.register_craftitem( "technic:tin_dust", {
				description = "Tin Dust",
				inventory_image = "technic_tin_dust.png",
				on_place_on_ground = minetest.craftitem_place_item,
			     })
minetest.register_craft({
			   type = "cooking",
			   output = "moreores:tin_ingot",
			   recipe = "technic:tin_dust",
			})

minetest.register_craftitem( "technic:silver_dust", {
				description = "Silver Dust",
				inventory_image = "technic_silver_dust.png",
				on_place_on_ground = minetest.craftitem_place_item,
			     })
minetest.register_craft({
			   type = "cooking",
			   output = "moreores:silver_ingot",
			   recipe = "technic:silver_dust",
			})

minetest.register_craftitem( "technic:gold_dust", {
				description = "Gold Dust",
				inventory_image = "technic_gold_dust.png",
				on_place_on_ground = minetest.craftitem_place_item,
			     })
minetest.register_craft({
			   type = "cooking",
			   output = "default:gold_ingot",
			   recipe = "technic:gold_dust",
			})

minetest.register_craftitem( "technic:mithril_dust", {
				description = "Mithril Dust",
				inventory_image = "technic_mithril_dust.png",
				on_place_on_ground = minetest.craftitem_place_item,
			     })
minetest.register_craft({
			   type = "cooking",
			   output = "moreores:mithril_ingot",
			   recipe = "technic:mithril_dust",
			})

minetest.register_craftitem( "technic:chromium_dust", {
				description = "Chromium Dust",
				inventory_image = "technic_chromium_dust.png",
				on_place_on_ground = minetest.craftitem_place_item,
			     })
minetest.register_craft({
			   type = "cooking",
			   output = "technic:chromium_ingot",
			   recipe = "technic:chromium_dust",
			})

minetest.register_craftitem( "technic:bronze_dust", {
				description = "Bronze Dust",
				inventory_image = "technic_bronze_dust.png",
				on_place_on_ground = minetest.craftitem_place_item,
			     })
minetest.register_craft({
			   type = "cooking",
			   output = "default:bronze_ingot",
			   recipe = "technic:bronze_dust",
			})

minetest.register_craftitem( "technic:brass_dust", {
				description = "Brass Dust",
				inventory_image = "technic_brass_dust.png",
				on_place_on_ground = minetest.craftitem_place_item,
			     })
minetest.register_craft({
			   type = "cooking",
			   output = "technic:brass_ingot",
			   recipe = "technic:brass_dust",
			})

minetest.register_craftitem( "technic:stainless_steel_dust", {
				description = "Stainless Steel Dust",
				inventory_image = "technic_stainless_steel_dust.png",
			     })

minetest.register_craft({
			   type = "cooking",
			   output = "technic:stainless_steel_ingot",
			   recipe = "technic:stainless_steel_dust",
			})

minetest.register_craftitem( "technic:zinc_dust", {
				description = "Zinc Dust",
				inventory_image = "technic_zinc_dust.png",
			     })

minetest.register_craft({
			   type = "cooking",
			   output = "technic:zinc_ingot",
			   recipe = "technic:zinc_dust",
			})

minetest.register_alias("grinder", "technic:grinder")
minetest.register_craft({
			   output = 'technic:grinder',
			   recipe = {
			      {'default:desert_stone', 'default:desert_stone', 'default:desert_stone'},
			      {'default:desert_stone', 'default:diamond', 'default:desert_stone'},
			      {'default:steel_ingot', 'technic:lv_cable', 'default:steel_ingot'},
			   }
			})

minetest.register_craftitem("technic:grinder", {
			       description = "Grinder",
			       stack_max = 99,
			    })

local grinder_formspec =
   "invsize[8,9;]"..
   "label[0,0;Grinder]"..
   "list[current_name;src;3,1;1,1;]"..
   "list[current_name;dst;5,1;2,2;]"..
   "list[current_player;main;0,5;8,4;]"

minetest.register_node(
   "technic:grinder",
   {
      description = "Grinder",
      tiles = {"technic_lv_grinder_top.png", "technic_lv_grinder_bottom.png", "technic_lv_grinder_side.png",
	       "technic_lv_grinder_side.png", "technic_lv_grinder_side.png", "technic_lv_grinder_front.png"},
      paramtype2 = "facedir",
      groups = {cracky=2},
      legacy_facedir_simple = true,
      sounds = default.node_sound_wood_defaults(),
      on_construct = function(pos)
			local meta = minetest.env:get_meta(pos)
			meta:set_string("infotext", "Grinder")
			meta:set_float("technic_power_machine", 1)
			meta:set_string("formspec", grinder_formspec)
			local inv = meta:get_inventory()
			inv:set_size("src", 1)
			inv:set_size("dst", 4)
		     end,
      can_dig = function(pos,player)
		   local meta = minetest.env:get_meta(pos);
		   local inv = meta:get_inventory()
		   if not inv:is_empty("src") or not inv:is_empty("dst") then
		      minetest.chat_send_player(player:get_player_name(), "Machine cannot be removed because it is not empty");
		      return false
		   else
		      return true
		   end
		end,
   })

minetest.register_node(
   "technic:grinder_active",
   {
      description = "Grinder",
      tiles = {"technic_lv_grinder_top.png", "technic_lv_grinder_bottom.png", "technic_lv_grinder_side.png",
	       "technic_lv_grinder_side.png", "technic_lv_grinder_side.png", "technic_lv_grinder_front_active.png"},
      paramtype2 = "facedir",
      groups = {cracky=2,not_in_creative_inventory=1},
      legacy_facedir_simple = true,
      sounds = default.node_sound_wood_defaults(),
      can_dig = function(pos,player)
		   local meta = minetest.env:get_meta(pos);
		   local inv = meta:get_inventory()
		   if not inv:is_empty("src") or not inv:is_empty("dst") then
		      minetest.chat_send_player(player:get_player_name(), "Machine cannot be removed because it is not empty");
		      return false
		   else
		      return true
		   end
		end,
   })

minetest.register_abm(
   { nodenames = {"technic:grinder","technic:grinder_active"},
     interval = 1,
     chance   = 1,
     action = function(pos, node, active_object_count, active_object_count_wider)
		 -- Run a machine through its states. Takes the same arguments as the ABM action
		 -- and adds the machine's states and any extra data which is needed by the machine.
		 -- A machine is characterized by running through a set number of states (usually 2:
		 -- Idle and active) in some order. A state decides when to move to the next one
		 -- and the machine only changes state if it is powered correctly.
		 -- The machine will automatically shut down if disconnected from power in some fashion.
		 local meta         = minetest.env:get_meta(pos)
		 local eu_input     = meta:get_int("LV_EU_input")
		 local state        = meta:get_int("state")
		 local next_state   = state

		 -- Machine information
		 local machine_name         = "Grinder"
		 local machine_node         = "technic:grinder"
		 local machine_state_demand = { 50, 300 }
			 
		 -- Setup meta data if it does not exist. state is used as an indicator of this
		 if state == 0 then
		    meta:set_int("state", 1)
		    meta:set_int("LV_EU_demand", machine_state_demand[1])
		    meta:set_int("LV_EU_input", 0)
		    return
		 end
			 
		 -- Power off automatically if no longer connected to a switching station
		 technic.switching_station_timeout_count(pos, "LV")
			 
		 -- State machine
		 if eu_input == 0 then
		    -- unpowered - go idle
		    hacky_swap_node(pos, machine_node)
		    meta:set_string("infotext", machine_name.." Unpowered")
		    next_state = 1
		 elseif eu_input == machine_state_demand[state] then
		    -- Powered - do the state specific actions
			    
		    local inv    = meta:get_inventory()
		    local empty  = inv:is_empty("src")

		    if state == 1 then
		       hacky_swap_node(pos, machine_node)
		       meta:set_string("infotext", machine_name.." Idle")

		       local result = technic.get_grinder_recipe(inv:get_stack("src", 1))
		       if not empty and result and inv:room_for_item("dst",result) then
			  meta:set_int("src_time", 0)
			  next_state = 2
		       end

		    elseif state == 2 then
		       hacky_swap_node(pos, machine_node.."_active")
		       meta:set_string("infotext", machine_name.." Active")

		       if empty then
			  next_state = 1
		       else
			  meta:set_int("src_time", meta:get_int("src_time") + 1)
			  if meta:get_int("src_time") == 4 then -- 4 ticks per output
			     -- check if there's room for output in "dst" list
			     local result = technic.get_grinder_recipe(inv:get_stack("src", 1))

			     meta:set_int("src_time", 0)
			     if inv:room_for_item("dst",result) then
				-- take stuff from "src" list
				srcstack = inv:get_stack("src", 1)
				srcstack:take_item()
				inv:set_stack("src", 1, srcstack)
				-- Put result in "dst" list
				inv:add_item("dst", result)
			     else
				-- all full: go idle
				next_state = 1
			     end
			  end
		       end
		    end
		 end
		 -- Change state?
		 if next_state ~= state then
		    meta:set_int("LV_EU_demand", machine_state_demand[next_state])
		    meta:set_int("state", next_state)
		 end
	      end
  })

technic.register_LV_machine ("technic:grinder","RE")
technic.register_LV_machine ("technic:grinder_active","RE")

