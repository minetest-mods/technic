-- LV Alloy furnace
minetest.register_craft({
	output = 'technic:coal_alloy_furnace',
	recipe = {
		{'default:brick', 'default:brick', 'default:brick'},
		{'default:brick', '',              'default:brick'},
		{'default:brick', 'default:brick', 'default:brick'},
	}
})

-- FIXME: kpoppel: I'd like to introduce an induction heating element here...
minetest.register_craft({
	output = 'technic:alloy_furnace',
	recipe = {
		{'default:brick', 'default:brick', 'default:brick'},
		{'default:brick', '', 'default:brick'},
		{'default:steel_ingot', 'technic:lv_cable', 'default:steel_ingot'},
	}
})

local alloy_furnace_formspec =
   "invsize[8,9;]"..
   "list[current_name;src;3,1;1,1;]"..
   "list[current_name;src2;3,2;1,1;]"..
   "list[current_name;dst;5,1;2,2;]"..
   "list[current_player;main;0,5;8,4;]"..
   "label[0,0;Electric Alloy Furnace]"

minetest.register_node(
   "technic:alloy_furnace",
   {
      description = "Electric alloy furnace",
      tiles = {"technic_alloy_furnace_top.png", "technic_machine_bottom.png", "technic_alloy_furnace_side.png",
	       "technic_alloy_furnace_side.png", "technic_alloy_furnace_side.png", "technic_alloy_furnace_front.png"},
      paramtype2 = "facedir",
      groups = {cracky=2},
      legacy_facedir_simple = true,
      sounds = default.node_sound_stone_defaults(),
      on_construct = function(pos)
			local meta = minetest.env:get_meta(pos)
			meta:set_string("infotext", "Electric Alloy furnace")
			meta:set_float("technic_power_machine", 1)
			meta:set_string("formspec", alloy_furnace_formspec)
			local inv = meta:get_inventory()
			inv:set_size("src", 1)
			inv:set_size("src2", 1)
			inv:set_size("dst", 4)
		     end,
      can_dig = function(pos,player)
		   local meta = minetest.env:get_meta(pos);
		   local inv = meta:get_inventory()
		   if not inv:is_empty("src") or not inv:is_empty("src2") or not inv:is_empty("dst") then
		      minetest.chat_send_player(player:get_player_name(), "Machine cannot be removed because it is not empty");
		      return false
		   else
		      return true
		   end
		end,
})

minetest.register_node(
   "technic:alloy_furnace_active",
   {
      description = "Alloy Furnace",
      tiles = {"technic_alloy_furnace_top.png", "technic_machine_bottom.png", "technic_alloy_furnace_side.png",
	       "technic_alloy_furnace_side.png", "technic_alloy_furnace_side.png", "technic_alloy_furnace_front_active.png"},
      paramtype2 = "facedir",
      light_source = 8,
      drop = "technic:alloy_furnace",
      groups = {cracky=2,not_in_creative_inventory=1},
      legacy_facedir_simple = true,
      sounds = default.node_sound_stone_defaults(),
      can_dig = function(pos,player)
		   local meta = minetest.env:get_meta(pos);
		   local inv = meta:get_inventory()
		   if not inv:is_empty("src") or not inv:is_empty("src2") or not inv:is_empty("dst") then
		      minetest.chat_send_player(player:get_player_name(), "Machine cannot be removed because it is not empty");
		      return false
		   else
		      return true
		   end
		end,
   })

minetest.register_abm(
   { nodenames = {"technic:alloy_furnace","technic:alloy_furnace_active"},
     interval = 1,
     chance   = 1,
     action = function(pos, node, active_object_count, active_object_count_wider)
		 local meta         = minetest.env:get_meta(pos)
		 local eu_input     = meta:get_int("LV_EU_input")
		 local state        = meta:get_int("state")
		 local next_state   = state

		 -- Machine information
		 local machine_name         = "Electric Alloy Furnace"
		 local machine_node         = "technic:alloy_furnace"
		 local machine_state_demand = { 50, 600 }

		 -- Setup meta data if it does not exist. state is used as an indicator of this
		 if state == 0 then
		    meta:set_int("state", 1)
		    meta:set_int("LV_EU_demand", machine_state_demand[1])
		    meta:set_int("LV_EU_input", 0)
		    meta:set_int("tube_time", 0)
		    return
		 end
			 
		 -- Power off automatically if no longer connected to a switching station
		 technic.switching_station_timeout_count(pos, "LV")
			 
		 -- State machine
		 if eu_input == 0 then
		    -- Unpowered - go idle
		    hacky_swap_node(pos, machine_node)
		    meta:set_string("infotext", machine_name.." Unpowered")
		    next_state = 1
		 elseif eu_input == machine_state_demand[state] then
		    -- Powered - do the state specific actions
			    
		    -- Execute always if powered logic
		    local inv    = meta:get_inventory()
		    local empty  = 1
		    local recipe = nil
		    local result = nil

		    -- Get what to cook if anything
		    local srcstack  = inv:get_stack("src", 1)
		    local src2stack = inv:get_stack("src2", 1)
		    local src_item1 = nil
		    local src_item2 = nil
		    if srcstack and src2stack then
		       src_item1 = srcstack:to_table()
		       src_item2 = src2stack:to_table()
		       empty     = 0
		    end
	       
		    if src_item1 and src_item2 then
		       recipe = technic.get_alloy_recipe(src_item1,src_item2)
		    end
		    if recipe then
		       result = { name=recipe.dst_name, count=recipe.dst_count}
		    end

		    if recipe then
		       print("recipe "..recipe.dst_name.." : result "..result.name.." : empty "..empty.." : src_item1 "..src_item1.name.." : src_item2 "..src_item2.name)
		    end

		    if state == 1 then
		       hacky_swap_node(pos, machine_node)
		       meta:set_string("infotext", machine_name.." Idle")
		       
		       if empty == 0 and recipe and inv:room_for_item("dst", result) then
			  meta:set_string("infotext", machine_name.." Active")
			  meta:set_string("src_time", 0)
			  next_state = 2
		       end

		    elseif state == 2 then
		       hacky_swap_node(pos, machine_node.."_active")
		       meta:set_int("src_time", meta:get_int("src_time") + 1)
		       if meta:get_int("src_time") == 4 then -- 4 ticks per output
			  meta:set_string("src_time", 0)
			  -- check if there's room for output in "dst" list and that we have the materials
			  if recipe and inv:room_for_item("dst", result) then
			     -- Take stuff from "src" list
			     srcstack:take_item(recipe.src1_count)
			     inv:set_stack("src", 1, srcstack)
			     src2stack:take_item(recipe.src2_count)
			     inv:set_stack("src2", 1, src2stack)
			   -- Put result in "dst" list
			     inv:add_item("dst",result)
			  else
			     next_state = 1
			  end
		       end
		    end
		    -- Change state?
		    if next_state ~= state then
		       meta:set_int("LV_EU_demand", machine_state_demand[next_state])
		       meta:set_int("state", next_state)
		    end
		 end
	      end,
  })

technic.register_LV_machine ("technic:alloy_furnace","RE")
technic.register_LV_machine ("technic:alloy_furnace_active","RE")

--------------------------------------------------
-- coal driven alloy furnace. This uses no EUs:
--------------------------------------------------
coal_alloy_furnace_formspec =
	"size[8,9]"..
	"label[0,0;Alloy Furnace]"..
	"image[2,2;1,1;default_furnace_fire_bg.png]"..
	"list[current_name;fuel;2,3;1,1;]"..
	"list[current_name;src;2,1;1,1;]"..
	"list[current_name;src2;3,1;1,1;]"..
	"list[current_name;dst;5,1;2,2;]"..
	"list[current_player;main;0,5;8,4;]"

minetest.register_node("technic:coal_alloy_furnace", {
	description = "Alloy Furnace",
	tiles = {"technic_coal_alloy_furnace_top.png", "technic_coal_alloy_furnace_bottom.png", "technic_coal_alloy_furnace_side.png",
		"technic_coal_alloy_furnace_side.png", "technic_coal_alloy_furnace_side.png", "technic_coal_alloy_furnace_front.png"},
	paramtype2 = "facedir",
	groups = {cracky=2},
	legacy_facedir_simple = true,
	sounds = default.node_sound_stone_defaults(),
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec", coal_alloy_furnace_formspec)
		meta:set_string("infotext", "Alloy Furnace")
		local inv = meta:get_inventory()
		inv:set_size("fuel", 1)
		inv:set_size("src", 1)
		inv:set_size("src2", 1)
		inv:set_size("dst", 4)
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		if not (inv:is_empty("fuel") or inv:is_empty("dst") or inv:is_empty("src") or inv:is_empty("src2") )then
			return false
			end
		return true
	end,
})

minetest.register_node("technic:coal_alloy_furnace_active", {
	description = "Alloy Furnace",
	tiles = {"technic_coal_alloy_furnace_top.png", "technic_coal_alloy_furnace_bottom.png", "technic_coal_alloy_furnace_side.png",
		"technic_coal_alloy_furnace_side.png", "technic_coal_alloy_furnace_side.png", "technic_coal_alloy_furnace_front_active.png"},
	paramtype2 = "facedir",
	light_source = 8,
	drop = "technic:coal_alloy_furnace",
	groups = {cracky=2, not_in_creative_inventory=1},
	legacy_facedir_simple = true,
	sounds = default.node_sound_stone_defaults(),
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		if not (inv:is_empty("fuel") or inv:is_empty("dst") or inv:is_empty("src") or inv:is_empty("src2") )then
			return false
			end
		return true
	end,
})

minetest.register_abm({
	nodenames = {"technic:coal_alloy_furnace","technic:coal_alloy_furnace_active"},
	interval = 1,
	chance = 1,

	action = function(pos, node, active_object_count, active_object_count_wider)
		local meta = minetest.env:get_meta(pos)
		for i, name in pairs({
				"fuel_totaltime",
				"fuel_time",
				"src_totaltime",
				"src_time"
		}) do
			if meta:get_string(name) == "" then
				meta:set_float(name, 0.0)
			end
		end

		local inv    = meta:get_inventory()
		local recipe = nil

		-- Get what to cook if anything
		local srcstack = inv:get_stack("src", 1)
		if srcstack then src_item1=srcstack:to_table() end
		
		local src2stack = inv:get_stack("src2", 1)
		if src2stack then src_item2=src2stack:to_table() end
		
		if src_item1 and src_item2 then
		   recipe = technic.get_alloy_recipe(src_item1,src_item2)
		end

		local was_active = false

		if meta:get_float("fuel_time") < meta:get_float("fuel_totaltime") then
		   was_active = true
		   meta:set_float("fuel_time", meta:get_float("fuel_time") + 1)
		   meta:set_float("src_time", meta:get_float("src_time") + 1)
		   if recipe and meta:get_float("src_time") == 6 then
		      -- check if there's room for output in "dst" list
		      local dst_stack = { name=recipe.dst_name, count=recipe.dst_count}
		      if inv:room_for_item("dst",dst_stack) then
			 -- Take stuff from "src" list
			 srcstack:take_item(recipe.src1_count)
			 inv:set_stack("src", 1, srcstack)
			 src2stack:take_item(recipe.src2_count)
			 inv:set_stack("src2", 1, src2stack)
			 -- Put result in "dst" list
			 inv:add_item("dst",dst_stack)
		      else
			 print("Furnace inventory full!") -- Silly code...
		      end
		      meta:set_string("src_time", 0)
		   end
		end
		
		if meta:get_float("fuel_time") < meta:get_float("fuel_totaltime") then
		   local percent = math.floor(meta:get_float("fuel_time") /
					   meta:get_float("fuel_totaltime") * 100)
		   meta:set_string("infotext","Furnace active: "..percent.."%")
		   hacky_swap_node(pos,"technic:coal_alloy_furnace_active")
		   meta:set_string("formspec",
				   "size[8,9]"..
				      "label[0,0;Electric Alloy Furnace]"..
				      "image[2,2;1,1;default_furnace_fire_bg.png^[lowpart:"..
				      (100-percent)..":default_furnace_fire_fg.png]"..
				   "list[current_name;fuel;2,3;1,1;]"..
				   "list[current_name;src;2,1;1,1;]"..
				   "list[current_name;src2;3,1;1,1;]"..
				   "list[current_name;dst;5,1;2,2;]"..
				   "list[current_player;main;0,5;8,4;]")
		   return
		end

		-- FIXME: Make this look more like the electrical version.
		-- This code refetches the recipe to see if it can be done again after the iteration
		srcstack = inv:get_stack("src", 1)
		if srcstack then src_item1=srcstack:to_table() end
		srcstack = inv:get_stack("src2", 1)
		if srcstack then src_item2=srcstack:to_table() end
		if src_item1 and src_item2 then
		   recipe = technic.get_alloy_recipe(src_item1,src_item2)
		end

		if recipe==nil then
		   if was_active then
		      meta:set_string("infotext","Furnace is empty")
		      hacky_swap_node(pos,"technic:coal_alloy_furnace")
		      meta:set_string("formspec", coal_alloy_furnace_formspec)
		   end
		   return
		end

		-- Next take a hard look at the fuel situation
		local fuel = nil
		local fuellist = inv:get_list("fuel")

		if fuellist then
		   fuel = minetest.get_craft_result({method = "fuel", width = 1, items = fuellist})
		end

		if fuel.time <= 0 then
		   meta:set_string("infotext","Furnace out of fuel")
		   hacky_swap_node(pos,"technic:coal_alloy_furnace")
		   meta:set_string("formspec", coal_alloy_furnace_formspec)
		   return
		end

		meta:set_string("fuel_totaltime", fuel.time)
		meta:set_string("fuel_time", 0)

		local stack = inv:get_stack("fuel", 1)
		stack:take_item()
		inv:set_stack("fuel", 1, stack)
	     end,
     })

