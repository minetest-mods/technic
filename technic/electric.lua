power_tools ={}

registered_power_tools_count=1

function register_power_tool (string1,max_charge)
power_tools[registered_power_tools_count]={}
power_tools[registered_power_tools_count].tool_name=string1
power_tools[registered_power_tools_count].max_charge=max_charge
registered_power_tools_count=registered_power_tools_count+1
end

register_power_tool ("technic:mining_drill",60000)
register_power_tool ("technic:laser_mk1",40000)
register_power_tool ("technic:battery",10000)

minetest.register_alias("battery", "technic:battery")
minetest.register_alias("battery_box", "technic:battery_box")
minetest.register_alias("electric_furnace", "technic:electric_furnace")


minetest.register_craft({
	output = 'technic:battery 1',
	recipe = {
		{'default:wood', 'default:copper_ingot', 'default:wood'},
		{'default:wood', 'moreores:tin_ingot', 'default:wood'},
		{'default:wood', 'default:copper_ingot', 'default:wood'},
	}
}) 

minetest.register_craft({
	output = 'technic:battery_box 1',
	recipe = {
		{'technic:battery', 'default:wood', 'technic:battery'},
		{'technic:battery', 'default:copper_ingot', 'technic:battery'},
		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
	}
}) 

minetest.register_craft({
	output = 'technic:electric_furnace',
	recipe = {
		{'default:brick', 'default:brick', 'default:brick'},
		{'default:brick', '', 'default:brick'},
		{'default:steel_ingot', 'default:copper_ingot', 'default:steel_ingot'},
	}
})


minetest.register_tool("technic:battery",
{description = "RE Battery",
inventory_image = "technic_battery.png",
energy_charge = 0,
tool_capabilities = {max_drop_level=0, groupcaps={fleshy={times={}, uses=10000, maxlevel=0}}}}) 

minetest.register_craftitem("technic:battery_box", {
	description = "Battery box",
	stack_max = 99,
}) 



battery_box_formspec =
	"invsize[8,9;]"..
	"image[1,1;1,2;technic_power_meter_bg.png]"..
	"list[current_name;src;3,1;1,1;]"..
	"image[4,1;1,1;technic_battery_reload.png]"..
	"list[current_name;dst;5,1;1,1;]"..
	"label[0,0;Battery box]"..
	"label[3,0;Charge]"..
	"label[5,0;Discharge]"..
	"label[1,3;Power level]"..
	"list[current_player;main;0,5;8,4;]"

minetest.register_node("technic:battery_box", {
	description = "Battery box",
	tiles = {"technic_battery_box_top.png", "technic_battery_box_bottom.png", "technic_battery_box_side.png",
		"technic_battery_box_side.png", "technic_battery_box_side.png", "technic_battery_box_side.png"},
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
	sounds = default.node_sound_wood_defaults(),
	technic_power_machine=1,
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("infotext", "Battery box")
		meta:set_float("technic_power_machine", 1)
		meta:set_string("formspec", battery_box_formspec)
		local inv = meta:get_inventory()
		inv:set_size("src", 1)
		inv:set_size("dst", 1)
		battery_charge = 0
		max_charge = 60000
		end,	
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("dst") then
			return false
		elseif not inv:is_empty("src") then
			return false
		end
		return true
	end,
})

electric_furnace_formspec =
	"invsize[8,9;]"..
	"image[1,1;1,2;technic_power_meter_bg.png]"..
	"list[current_name;src;3,1;1,1;]"..
	"list[current_name;dst;5,1;2,2;]"..
	"list[current_player;main;0,5;8,4;]"..
	"label[0,0;Electric Furnace]"..
	"label[1,3;Power level]"
	
minetest.register_node("technic:electric_furnace", {
	description = "Electric furnace",
	tiles = {"technic_electric_furnace_top.png", "technic_electric_furnace_bottom.png", "technic_electric_furnace_side.png",
		"technic_electric_furnace_side.png", "technic_electric_furnace_side.png", "technic_electric_furnace_front.png"},
	paramtype2 = "facedir",
	groups = {cracky=2},
	legacy_facedir_simple = true,
	sounds = default.node_sound_stone_defaults(),
	technic_power_machine=1,
	internal_EU_buffer=0;
	interal_EU_buffer_size=2000;
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_float("technic_power_machine", 1)
		meta:set_string("formspec", electric_furnace_formspec)
		meta:set_string("infotext", "Electric furnace")
		local inv = meta:get_inventory()
		inv:set_size("src", 1)
		inv:set_size("dst", 4)
		local EU_used  = 0
		local furnace_is_cookin = 0
		local cooked = nil
		meta:set_float("internal_EU_buffer",0)
		meta:set_float("internal_EU_buffer_size",2000)

	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("dst") then
			return false
		elseif not inv:is_empty("src") then
			return false
		end
		return true
	end,
})

minetest.register_node("technic:electric_furnace_active", {
	description = "Electric Furnace",
	tiles = {"technic_electric_furnace_top.png", "technic_electric_furnace_bottom.png", "technic_electric_furnace_side.png",
		"technic_electric_furnace_side.png", "technic_electric_furnace_side.png", "technic_electric_furnace_front_active.png"},
	paramtype2 = "facedir",
	light_source = 8,
	drop = "technic:electric_furnace",
	groups = {cracky=2, not_in_creative_inventory=1},
	legacy_facedir_simple = true,
	sounds = default.node_sound_stone_defaults(),
	internal_EU_buffer=0;
	interal_EU_buffer_size=2000;
	technic_power_machine=1,
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_float("technic_power_machine", 1)
		meta:set_string("formspec", electric_furnace_formspec)
		meta:set_string("infotext", "Electric furnace");
		local inv = meta:get_inventory()
		inv:set_size("src", 1)
		inv:set_size("dst", 4)
		local EU_used  = 0
		local furnace_is_cookin = 0
		local cooked = nil
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("dst") then
			return false
		elseif not inv:is_empty("src") then
			return false
		end
		return true
	end,
})

minetest.register_abm({
	nodenames = {"technic:electric_furnace","technic:electric_furnace_active"},
	interval = 1,
	chance = 1,
	
	action = function(pos, node, active_object_count, active_object_count_wider)

		local meta = minetest.env:get_meta(pos)
		internal_EU_buffer=meta:get_float("internal_EU_buffer")
		internal_EU_buffer_size=meta:get_float("internal_EU_buffer")
		local load = math.floor(internal_EU_buffer/2000 * 100)
		meta:set_string("formspec",
				"invsize[8,9;]"..
				"image[1,1;1,2;technic_power_meter_bg.png^[lowpart:"..
						(load)..":technic_power_meter_fg.png]"..
				"list[current_name;src;3,1;1,1;]"..
				"list[current_name;dst;5,1;2,2;]"..
				"list[current_player;main;0,5;8,4;]"..
				"label[0,0;Electric Furnace]"..
				"label[1,3;Power level]")

		local inv = meta:get_inventory()
		
		local furnace_is_cookin = meta:get_float("furnace_is_cookin")
		
		
		local srclist = inv:get_list("src")
		local cooked=nil 

		if srclist then
		 cooked = minetest.get_craft_result({method = "cooking", width = 1, items = srclist})
		end
		
		
		if (furnace_is_cookin == 1) then
			if internal_EU_buffer>=150 then
			internal_EU_buffer=internal_EU_buffer-150;
			meta:set_float("internal_EU_buffer",internal_EU_buffer)
			meta:set_float("src_time", meta:get_float("src_time") + 3)
			if cooked and cooked.item and meta:get_float("src_time") >= cooked.time then
				-- check if there's room for output in "dst" list
				if inv:room_for_item("dst",cooked.item) then
					-- Put result in "dst" list
					inv:add_item("dst", cooked.item)
					-- take stuff from "src" list
					srcstack = inv:get_stack("src", 1)
					srcstack:take_item()
					inv:set_stack("src", 1, srcstack)
				else
					print("Furnace inventory full!")
				end
				meta:set_string("src_time", 0)
			end
			end		
		end
		
		

		
		if srclist then
			cooked = minetest.get_craft_result({method = "cooking", width = 1, items = srclist})
			if cooked.time>0 then 
			hacky_swap_node(pos,"technic:electric_furnace_active")
			meta:set_string("infotext","Furnace active")
			meta:set_string("furnace_is_cookin",1)
		--	meta:set_string("formspec", electric_furnace_formspec)
			meta:set_string("src_time", 0)
			return
			end

		end
	
				hacky_swap_node(pos,"technic:electric_furnace")
				meta:set_string("infotext","Furnace inactive")
				meta:set_string("furnace_is_cookin",0)
		--		meta:set_string("formspec", electric_furnace_formspec)
				meta:set_string("src_time", 0)
		
	
end,		
})
