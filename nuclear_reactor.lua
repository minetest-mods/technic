


minetest.register_craft({
	output = 'technic:generator',
	recipe = {
		{'default:stone', 'default:stone', 'default:stone'},
		{'default:stone', 'default:stone', 'default:stone'},
		{'default:stone', 'moreores:copper_ingot', 'default:stone'},
	}
})

minetest.register_craftitem("technic:reactor", {
	description = "Nuclear Reactor",
	stack_max = 99,
}) 

generator_formspec =
	"invsize[8,9;]"..
	"image[0,0;5,5;technic_generator_menu.png]"..
	"image[1,1;1,2;technic_power_meter_bg.png]"..
--	"label[0,0;Generator]"..
	"label[1,3;Power level]"..
	"list[current_name;src;3,1;1,1;]"..
	"image[4,1;1,1;default_furnace_fire_bg.png]"..
	"list[current_player;main;0,5;8,4;]"
	

minetest.register_node("technic:reactor", {
	description = "Nuclear Reactor",
	tiles = {"technic_generator_top.png", "technic_machine_bottom.png", "technic_generator_side.png",
		"technic_generator_side.png", "technic_generator_side.png", "technic_generator_front.png"},
	paramtype2 = "facedir",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	technic_power_machine=1,
	internal_EU_buffer=0;
	internal_EU_buffer_size=5000;
	burn_time=0;
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("infotext", "Generator")
		meta:set_float("technic_power_machine", 1)
		meta:set_float("internal_EU_buffer", 0)
		meta:set_float("internal_EU_buffer_size", 5000)
		meta:set_string("formspec", generator_formspec)
		meta:set_float("burn_time", 0)
		
		local inv = meta:get_inventory()
		inv:set_size("src", 1)
		
		end,	
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("src") then
			return false
		end
		return true
		end,

})

minetest.register_node("technic:reactor_active", {
	description = "Nuclear Reactor",
	tiles = {"technic_generator_top.png", "technic_machine_bottom.png", "technic_generator_side.png",
		"technic_generator_side.png", "technic_generator_side.png", "technic_generator_front_active.png"},
	paramtype2 = "facedir",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2,not_in_creative_inventory=1},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	drop="technic:generator",
	technic_power_machine=1,
	internal_EU_buffer=0;
	internal_EU_buffer_size=0;
	burn_time=0;
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("src") then
			return false
		end
		return true
		end,

})
minetest.register_abm({
	nodenames = {"technic:reactor","technic:reactor_active"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)

	local meta = minetest.env:get_meta(pos)
	local burn_time= meta:get_float("burn_time")
	local charge= meta:get_float("internal_EU_buffer")
	local max_charge= meta:get_float("internal_EU_buffer_size")
	local burn_charge=200

	if burn_time>0 then
		if charge+burn_charge>max_charge then
		burn_charge=max_charge-charge
		end
		if burn_charge>0 then 
		burn_time=burn_time-1
		meta:set_float("burn_time",burn_time)
		charge=charge+burn_charge
		meta:set_float("internal_EU_buffer",charge)
		end
		
	end
	if burn_time==0 then
		local inv = meta:get_inventory()
		if inv:is_empty("src")==false  then 
		local srcstack = inv:get_stack("src", 1)
		src_item=srcstack:to_table()
		if src_item["name"]== "technic:uranium" then
		srcstack:take_item()
		inv:set_stack("src", 1, srcstack)
		burn_time=10000
		meta:set_float("burn_time",burn_time)
		hacky_swap_node (pos,"technic:reactor_active") 
		end
		end
	end

	local load = math.floor((charge/max_charge)*100)
	local percent = math.floor((burn_time/10000)*100)
	meta:set_string("formspec",
				"invsize[8,9;]"..
				"image[1,1;1,2;technic_power_meter_bg.png^[lowpart:"..
						(load)..":technic_power_meter_fg.png]"..
				"label[0,0;Nuclear Reactor]"..
				"label[1,3;Power level]"..
				"list[current_name;src;3,1;1,1;]"..
				"image[4,1;1,1;default_furnace_fire_bg.png^[lowpart:"..
						(percent)..":default_furnace_fire_fg.png]"..
				"list[current_player;main;0,5;8,4;]"
				)
				
	if burn_time==0 then
		hacky_swap_node (pos,"technic:reactor")
	end
		

	end
}) 

