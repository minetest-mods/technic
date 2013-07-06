minetest.register_craft({
	output = 'technic:electric_furnace',
	recipe = {
		{'default:cobble', 'default:cobble', 'default:cobble'},
		{'default:cobble', '', 'default:cobble'},
		{'default:steel_ingot', 'moreores:copper_ingot', 'default:steel_ingot'},
	}
})


electric_furnace_formspec =
	"invsize[8,9;]"..
	"image[1,1;1,2;technic_power_meter_bg.png]"..
	"list[current_name;src;3,1;1,1;]"..
	"list[current_name;dst;5,1;2,2;]"..
	"list[current_player;main;0,5;8,4;]"..
	"label[0,0;LV Electric Furnace]"..
	"label[1,3;Power level]"..
	"background[-0.19,-0.25;8.4,9.75;ui_form_bg.png]"..
	"background[0,0;8,4;ui_lv_electric_furnace.png]"..
	"background[0,5;8,4;ui_main_inventory.png]"
	
minetest.register_node("technic:electric_furnace", {
	description = "LV Electric Furnace",
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
		meta:set_string("infotext", "Electric Furnace")
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
	description = "LV Electric Furnace",
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
		meta:set_string("infotext", "LV Electric Furnace");
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
		internal_EU_buffer_size=meta:get_float("internal_EU_buffer_size")
		local load = math.floor(internal_EU_buffer/internal_EU_buffer_size * 100)
		meta:set_string("formspec",
				electric_furnace_formspec..
				"image[1,1;1,2;technic_power_meter_bg.png^[lowpart:"..
					(load)..":technic_power_meter_fg.png]")

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
			meta:set_string("src_time", 0)
			return
			end

		end

				hacky_swap_node(pos,"technic:electric_furnace")
				meta:set_string("infotext","Furnace inactive")
				meta:set_string("furnace_is_cookin",0)
				meta:set_string("src_time", 0)

end,
})

register_LV_machine ("technic:electric_furnace","RE")
register_LV_machine ("technic:electric_furnace_active","RE")
