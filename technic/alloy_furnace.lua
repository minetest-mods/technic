minetest.register_craft({
	output = 'technic:coal_alloy_furnace',
	recipe = {
		{'default:brick', 'default:brick', 'default:brick'},
		{'default:brick', '', 'default:brick'},
		{'default:brick', 'default:brick', 'default:brick'},
	}
})

minetest.register_craft({
	output = 'technic:alloy_furnace',
	recipe = {
		{'default:brick', 'default:brick', 'default:brick'},
		{'default:brick', '', 'default:brick'},
		{'default:steel_ingot', 'default:copper_ingot', 'default:steel_ingot'},
	}
})

-- LV alloy furnace

alloy_furnace_formspec =
	"invsize[8,9;]"..
	"image[1,1;1,2;technic_power_meter_bg.png]"..
	"list[current_name;src;3,1;1,1;]"..
	"list[current_name;src2;3,2;1,1;]"..
	"list[current_name;dst;5,1;2,2;]"..
	"list[current_player;main;0,5;8,4;]"..
	"label[0,0;LV Electric Alloy Furnace]"..
	"label[1,3;Power level]"..
	"background[-0.19,-0.25;8.4,9.75;ui_form_bg.png]"..
	"background[0,0;8,4;ui_lv_alloy_furnace.png]"..
	"background[0,5;8,4;ui_main_inventory.png]"
	
minetest.register_node("technic:alloy_furnace", {
	description = "LV Electric alloy furnace",
	tiles = {"technic_alloy_furnace_top.png", "technic_machine_bottom.png", "technic_alloy_furnace_side.png",
		"technic_alloy_furnace_side.png", "technic_alloy_furnace_side.png", "technic_alloy_furnace_front.png"},
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
		meta:set_string("formspec", alloy_furnace_formspec)
		meta:set_string("infotext", "Electric Alloy furnace")
		local inv = meta:get_inventory()
		inv:set_size("src", 1)
		inv:set_size("src2", 1)
		inv:set_size("dst", 4)
		local EU_used  = 0
		local furnace_is_cookin = 0
		local cooked = nil
		meta:set_float("internal_EU_buffer",0)
		meta:set_float("internal_EU_buffer_size",2000)
		meta:set_float("tube_time", 0)
	end,

	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("dst") then
			return false end
		if not inv:is_empty("src") then
			return false end
		if not inv:is_empty("src2") then
			return false end
		return true
	end,
})

minetest.register_node("technic:alloy_furnace_active", {
	description = "Alloy Furnace",
	tiles = {"technic_alloy_furnace_top.png", "technic_machine_bottom.png", "technic_alloy_furnace_side.png",
		"technic_alloy_furnace_side.png", "technic_alloy_furnace_side.png", "technic_alloy_furnace_front_active.png"},
	paramtype2 = "facedir",
	light_source = 8,
	drop = "technic:alloy_furnace",
	groups = {cracky=2,not_in_creative_inventory=1},
	legacy_facedir_simple = true,
	sounds = default.node_sound_stone_defaults(),
	internal_EU_buffer=0;
	interal_EU_buffer_size=2000;
	technic_power_machine=1,
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
	nodenames = {"technic:alloy_furnace","technic:alloy_furnace_active"},
	interval = 1,
	chance = 1,
	
	action = function(pos, node, active_object_count, active_object_count_wider)

		local meta = minetest.env:get_meta(pos)
		internal_EU_buffer=meta:get_float("internal_EU_buffer")
		internal_EU_buffer_size=meta:get_float("internal_EU_buffer")
		local load = math.floor(internal_EU_buffer/2000 * 100)
		meta:set_string("formspec",
				alloy_furnace_formspec..
				"image[1,1;1,2;technic_power_meter_bg.png^[lowpart:"..
						(load)..":technic_power_meter_fg.png]")

		local inv = meta:get_inventory()

		local furnace_is_cookin = meta:get_int("furnace_is_cookin")

		local srclist = inv:get_list("src")
		local srclist2 = inv:get_list("src2")

		srcstack = inv:get_stack("src", 1)
		if srcstack then src_item1=srcstack:to_table() end
		srcstack = inv:get_stack("src2", 1)
		if srcstack then src_item2=srcstack:to_table() end
		dst_index=nil

		if src_item1 and src_item2 then 
				dst_index=get_cook_result(src_item1,src_item2) 
				end


		if (furnace_is_cookin == 1) then
			if internal_EU_buffer>=150 then
			internal_EU_buffer=internal_EU_buffer-150;
			meta:set_float("internal_EU_buffer",internal_EU_buffer)
			meta:set_float("src_time", meta:get_float("src_time") + 1)
			if dst_index and meta:get_float("src_time") >= 4 then
				-- check if there's room for output in "dst" list
				dst_stack={}
				dst_stack["name"]=alloy_recipes[dst_index].dst_name
				dst_stack["count"]=alloy_recipes[dst_index].dst_count
				if inv:room_for_item("dst",dst_stack) then
					-- Put result in "dst" list
					inv:add_item("dst",dst_stack)
					-- take stuff from "src" list
					for i=1,alloy_recipes[dst_index].src1_count,1 do
						srcstack = inv:get_stack("src", 1)
						srcstack:take_item()
						inv:set_stack("src", 1, srcstack)
						end
					for i=1,alloy_recipes[dst_index].src2_count,1 do
						srcstack = inv:get_stack("src2", 1)
						srcstack:take_item()
						inv:set_stack("src2", 1, srcstack)
						end


				else
					print("Furnace inventory full!")
				end
				meta:set_string("src_time", 0)
			end
			end	
		end

		if dst_index and meta:get_int("furnace_is_cookin")==0 then
			hacky_swap_node(pos,"technic:alloy_furnace_active")
			meta:set_string("infotext","Electric Alloy Furnace active")
			meta:set_int("furnace_is_cookin",1)
			meta:set_string("src_time", 0)
			return
			end

		if meta:get_int("furnace_is_cookin")==0 or dst_index==nil then
			hacky_swap_node(pos,"technic:alloy_furnace")
			meta:set_string("infotext","Electric Alloy Furnace inactive")
			meta:set_int("furnace_is_cookin",0)
			meta:set_string("src_time", 0)
		end
	
end,		
})

function get_cook_result(src_item1, src_item2)
local counter=registered_recipes_count-1
for i=1, counter,1 do
if	alloy_recipes[i].src1_name==src_item1["name"] and
	alloy_recipes[i].src2_name==src_item2["name"] and
	alloy_recipes[i].src1_count<=src_item1["count"] and
	alloy_recipes[i].src2_count<=src_item2["count"] 
	then return i end
end
return nil
end

register_LV_machine ("technic:alloy_furnace","RE")
register_LV_machine ("technic:alloy_furnace_active","RE")

--coal driven alloy furnace:

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
		local furnace_is_cookin = 0
		local dst_index = nil

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
		for i, name in ipairs({
				"fuel_totaltime",
				"fuel_time",
				"src_totaltime",
				"src_time"
		}) do
			if meta:get_string(name) == "" then
				meta:set_float(name, 0.0)
			end
		end

		local inv = meta:get_inventory()

		srcstack = inv:get_stack("src", 1)
		if srcstack then src_item1=srcstack:to_table() end
		srcstack = inv:get_stack("src2", 1)
		if srcstack then src_item2=srcstack:to_table() end
		dst_index=nil

		if src_item1 and src_item2 then 
				dst_index=get_cook_result(src_item1,src_item2) 
				end	
		
		local was_active = false
		
		if meta:get_float("fuel_time") < meta:get_float("fuel_totaltime") then
			was_active = true
			meta:set_float("fuel_time", meta:get_float("fuel_time") + 1)
			meta:set_float("src_time", meta:get_float("src_time") + 1)
			if dst_index and meta:get_float("src_time") >= 5 then
				-- check if there's room for output in "dst" list
				dst_stack={}
				dst_stack["name"]=alloy_recipes[dst_index].dst_name
				dst_stack["count"]=alloy_recipes[dst_index].dst_count			
				if inv:room_for_item("dst",dst_stack) then
					-- Put result in "dst" list
					inv:add_item("dst", dst_stack)
					-- take stuff from "src" list
					for i=1,alloy_recipes[dst_index].src1_count,1 do
						srcstack = inv:get_stack("src", 1)
						srcstack:take_item()
						inv:set_stack("src", 1, srcstack)
						end
					for i=1,alloy_recipes[dst_index].src2_count,1 do
						srcstack = inv:get_stack("src2", 1)
						srcstack:take_item()
						inv:set_stack("src2", 1, srcstack)
						end
				else
					print("Furnace inventory full!")
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

		local fuel = nil
		local fuellist = inv:get_list("fuel")
		
		srcstack = inv:get_stack("src", 1)
		if srcstack then src_item1=srcstack:to_table() end
		srcstack = inv:get_stack("src2", 1)
		if srcstack then src_item2=srcstack:to_table() end
		dst_index=nil

		if src_item1 and src_item2 then 
				dst_index=get_cook_result(src_item1,src_item2) 
				end
		
		
		if fuellist then
			fuel = minetest.get_craft_result({method = "fuel", width = 1, items = fuellist})
		end

		if fuel.time <= 0 then
			meta:set_string("infotext","Furnace out of fuel")
			hacky_swap_node(pos,"technic:coal_alloy_furnace")
			meta:set_string("formspec", coal_alloy_furnace_formspec)
			return
		end

		if dst_index==nil then
			if was_active then
				meta:set_string("infotext","Furnace is empty")
				hacky_swap_node(pos,"technic:coal_alloy_furnace")
				meta:set_string("formspec", coal_alloy_furnace_formspec)
			end
			return
		end

		meta:set_string("fuel_totaltime", fuel.time)
		meta:set_string("fuel_time", 0)
		
		local stack = inv:get_stack("fuel", 1)
		stack:take_item()
		inv:set_stack("fuel", 1, stack)
	
end,		
})
