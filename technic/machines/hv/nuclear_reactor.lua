-- The enriched uranium rod driven EU generator.
-- A very large and advanced machine providing vast amounts of power.
-- Very efficient but also expensive to run as it needs uranium. (10000EU 86400 ticks (24h))
-- Provides HV EUs that can be down converted as needed.
--
-- The nuclear reactor core needs water and a protective shield to work.
-- This is checked now and then and if the machine is tampered with... BOOM!
local burn_ticks   =     1                      -- [minutes]. How many minutes does the power plant burn per serving?
local power_supply = 10000                      -- [HV] EUs
local fuel_type    = "technic:enriched_uranium" -- This reactor burns this stuff

-- FIXME: recipe must make more sense like a rod recepticle, steam chamber, HV generator?
minetest.register_craft({
	output = 'technic:hv_nuclear_reactor_core',
	recipe = {
		{'technic:stainless_steel_ingot', 'technic:stainless_steel_ingot', 'technic:stainless_steel_ingot'},
		{'technic:stainless_steel_ingot', '', 'technic:stainless_steel_ingot'},
		{'technic:stainless_steel_ingot', 'technic:hv_cable', 'technic:stainless_steel_ingot'},
	}
})

minetest.register_craftitem("technic:hv_nuclear_reactor_core", {
	description = "Uranium Rod Driven HV Reactor",
	stack_max = 1,
}) 

local generator_formspec =
	"invsize[8,9;]"..
--	"image[0,0;5,5;technic_generator_menu.png]"..
	"label[0,0;Nuclear Reactor Rod Compartment]"..
	"list[current_name;src;2,1;3,2;]"..
	"list[current_player;main;0,5;8,4;]"

-- "Boxy sphere"
local nodebox = {{ -0.353, -0.353, -0.353, 0.353, 0.353, 0.353 }, -- Box
		 { -0.495, -0.064, -0.064, 0.495, 0.064, 0.064 }, -- Circle +-x
		 { -0.483, -0.128, -0.128, 0.483, 0.128, 0.128 },
		 { -0.462, -0.191, -0.191, 0.462, 0.191, 0.191 },
		 { -0.433, -0.249, -0.249, 0.433, 0.249, 0.249 },
		 { -0.397, -0.303, -0.303, 0.397, 0.303, 0.303 },
		 { -0.305, -0.396, -0.305, 0.305, 0.396, 0.305 }, -- Circle +-y
		 { -0.250, -0.432, -0.250, 0.250, 0.432, 0.250 },
		 { -0.191, -0.461, -0.191, 0.191, 0.461, 0.191 },
		 { -0.130, -0.482, -0.130, 0.130, 0.482, 0.130 },
		 { -0.066, -0.495, -0.066, 0.066, 0.495, 0.066 },
		 { -0.064, -0.064, -0.495, 0.064, 0.064, 0.495 }, -- Circle +-z
		 { -0.128, -0.128, -0.483, 0.128, 0.128, 0.483 },
		 { -0.191, -0.191, -0.462, 0.191, 0.191, 0.462 },
		 { -0.249, -0.249, -0.433, 0.249, 0.249, 0.433 },
		 { -0.303, -0.303, -0.397, 0.303, 0.303, 0.397 },
		 }

minetest.register_node(
   "technic:hv_nuclear_reactor_core",
   {
      description = "Nuclear Reactor",
      tiles = {"technic_hv_nuclear_reactor_core.png", "technic_hv_nuclear_reactor_core.png", "technic_hv_nuclear_reactor_core.png",
	       "technic_hv_nuclear_reactor_core.png", "technic_hv_nuclear_reactor_core.png", "technic_hv_nuclear_reactor_core.png"},
--      paramtype2 = "facedir",
      groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
      legacy_facedir_simple = true,
      sounds = default.node_sound_wood_defaults(),
      drawtype="nodebox",
      paramtype = "light",
      node_box = {
	 type = "fixed",
	 fixed = nodebox
      },
      on_construct = function(pos)
			local meta = minetest.env:get_meta(pos)
			meta:set_string("infotext", "Nuclear Reactor Core")
			meta:set_float("technic_hv_power_machine", 1)
			meta:set_int("HV_EU_supply", 0)
			meta:set_int("HV_EU_from_fuel", 1) -- Signal to the switching station that this device burns some sort of fuel and needs special handling
			meta:set_int("burn_time", 0)
			meta:set_string("formspec", generator_formspec)
			local inv = meta:get_inventory()
			inv:set_size("src", 6)
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
   "technic:hv_nuclear_reactor_core_active",
   {
      description = "Coal Driven Generator",
      tiles = {"technic_hv_nuclear_reactor_core.png", "technic_hv_nuclear_reactor_core.png", "technic_hv_nuclear_reactor_core.png",
	       "technic_hv_nuclear_reactor_core.png", "technic_hv_nuclear_reactor_core.png", "technic_hv_nuclear_reactor_core.png"},
--      paramtype2 = "facedir",
      groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2,not_in_creative_inventory=1},
      legacy_facedir_simple = true,
      sounds = default.node_sound_wood_defaults(),
      drop="technic:generator",
      drawtype="nodebox",
      light_source = 15,
      paramtype = "light",
      node_box = {
	 type = "fixed",
	 fixed = nodebox
      },
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

local check_reactor_structure = function(pos)
				   -- The reactor consists of an 11x11x11 cube structure
				   -- A cross section through the middle:
				   --  CCCCC CCCCC
				   --  CCCCC CCCCC
				   --  CCSSS SSSCC
				   --  CCSCC CCSCC
				   --  CCSCWWWCSCC
				   --  CCSCW#WCSCC
				   --  CCSCW|WCSCC
				   --  CCSCC|CCSCC
				   --  CCSSS|SSSCC
				   --  CCCCC|CCCCC
				   --  C = Concrete, S = Stainless Steel, W = water node (not floating), #=reactor core, |=HV cable
				   --  The man-hole and the HV cable is only in the middle.
				   local water_nodes = minetest.find_nodes_in_area({x=pos.x-1, y=pos.y-1, z=pos.z-1},
									     {x=pos.x+1, y=pos.y+1, z=pos.z+1}, "default:water_source")
				   --print("Water      (  25):"..#water_nodes)
				   if #water_nodes ~= 25 then
				      --print("Water supply defect")
				      return 0
				   end
				   local inner_shield_nodes = minetest.find_nodes_in_area({x=pos.x-2, y=pos.y-2, z=pos.z-2},
											  {x=pos.x+2, y=pos.y+2, z=pos.z+2}, "technic:concrete")

				   --print("Concrete 1 (  96):"..#inner_shield_nodes)
				   if #inner_shield_nodes ~= 96 then
				      --print("Inner shield defect")
				      return 0
				   end
				   local steel_shield_nodes = minetest.find_nodes_in_area({x=pos.x-3, y=pos.y-3, z=pos.z-3},
											  {x=pos.x+3, y=pos.y+3, z=pos.z+3}, "default:steelblock")

				   --print("Steel      ( 216):"..#steel_shield_nodes)
				   if #steel_shield_nodes ~= 216 then
				      --print("Steel shield defect")
				      return 0
				   end
				   local outer_shield_nodes = minetest.find_nodes_in_area({x=pos.x-5, y=pos.y-5, z=pos.z-5},
											  {x=pos.x+5, y=pos.y+5, z=pos.z+5}, "technic:concrete")
				   --print("Concrete 2 (1080):"..#outer_shield_nodes)
				   if #outer_shield_nodes ~= (984+#inner_shield_nodes) then
				      --print("Outer shield defect")
				      return 0
				   end
				   return 1
				end

local explode_reactor = function(pos)
			   print("BOOM A reactor exploded!")
			end

minetest.register_abm(
   {
      nodenames = {"technic:hv_nuclear_reactor_core","technic:hv_nuclear_reactor_core_active"},
      interval = 1,
      chance   = 1,
      action = function(pos, node, active_object_count, active_object_count_wider)
		  local meta = minetest.env:get_meta(pos)
		  local burn_time= meta:get_int("burn_time")

		  -- If more to burn and the energy produced was used: produce some more
		  if burn_time>0 then
		     if meta:get_int("HV_EU_supply") == 0 then
			-- We did not use the power
			meta:set_int("HV_EU_supply", power_sypply)
		     else
			burn_time = burn_time - 1
			meta:set_int("burn_time",burn_time)
			meta:set_string("infotext", "Nuclear Reactor Core ("..math.floor(burn_time/(burn_ticks*60)*100).."%)")
		     end
		  end

		  -- Burn another piece of coal
		  if burn_time==0 then
		     local inv = meta:get_inventory()
		     local correct_fuel_count = 0
		     if inv:is_empty("src") == false  then 
			local srclist= inv:get_list("src")
			for _, srcstack in pairs(srclist) do
			   if srcstack then
			      local src_item=srcstack:to_table()
			      if src_item and src_item["name"] == fuel_type then
				 correct_fuel_count = correct_fuel_count + 1
			      end
			   end
			end
			-- Check that the reactor is complete as well as the correct number of correct fuel
			if correct_fuel_count == 6 then
			   if check_reactor_structure(pos) == 1 then
			      burn_time=burn_ticks*60
			      meta:set_int("burn_time",burn_time)
			      hacky_swap_node (pos,"technic:hv_nuclear_reactor_core_active") 
			      meta:set_int("HV_EU_supply", power_supply)
			      for idx, srcstack in pairs(srclist) do
				 srcstack:take_item()
				 inv:set_stack("src", idx, srcstack)
			      end
			   else
			      -- BOOM!!! (the reactor was compromised and it should explode after some time) TNT mod inspired??
			      explode_reactor(pos)
			   end
			else
			   meta:set_int("HV_EU_supply", 0)
			end
		     end
		  end

		  -- Nothing left to burn
		  if burn_time==0 then
		     meta:set_string("infotext", "Nuclear Reactor Core (idle)")
		     hacky_swap_node (pos,"technic:hv_nuclear_reactor_core")
		  end
	       end
   })

technic.register_HV_machine ("technic:hv_nuclear_reactor_core","PR")
technic.register_HV_machine ("technic:hv_nuclear_reactor_core_active","PR")
