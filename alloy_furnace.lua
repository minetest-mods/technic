alloy_recipes ={}

registered_recipes_count=1

function register_alloy_recipe (string1,count1, string2,count2, string3,count3)
alloy_recipes[registered_recipes_count]={}
alloy_recipes[registered_recipes_count].src1_name=string1
alloy_recipes[registered_recipes_count].src1_count=count1
alloy_recipes[registered_recipes_count].src2_name=string2
alloy_recipes[registered_recipes_count].src2_count=count2
alloy_recipes[registered_recipes_count].dst_name=string3
alloy_recipes[registered_recipes_count].dst_count=count3
registered_recipes_count=registered_recipes_count+1
alloy_recipes[registered_recipes_count]={}
alloy_recipes[registered_recipes_count].src1_name=string2
alloy_recipes[registered_recipes_count].src1_count=count2
alloy_recipes[registered_recipes_count].src2_name=string1
alloy_recipes[registered_recipes_count].src2_count=count1
alloy_recipes[registered_recipes_count].dst_name=string3
alloy_recipes[registered_recipes_count].dst_count=count3
registered_recipes_count=registered_recipes_count+1
end

register_alloy_recipe ("technic:copper_dust",3, "technic:tin_dust",1, "technic:bronze_dust",4)
register_alloy_recipe ("moreores:copper_ingot",3, "moreores:tin_ingot",1, "moreores:bronze_ingot",4)
register_alloy_recipe ("technic:iron_dust",3, "technic:chromium_dust",1, "technic:stainless_steel_dust",4)
register_alloy_recipe ("default:steel_ingot",3, "technic:chromium_ingot",1, "technic:stainless_steel_ingot",4)
register_alloy_recipe ("technic:copper_dust",2, "technic:zinc_dust",1, "technic:brass_dust",3)
register_alloy_recipe ("technic:copper_ingot",2, "technic:zinc_ingot",1, "technic:brass_ingot",3)
register_alloy_recipe ("default:sand",2, "technic:coal_dust",2, "technic:silicon_wafer",1)
register_alloy_recipe ("technic:silicon_wafer",1, "technic:mithril_dust",2, "technic:doped_silicon_wafer",1)

minetest.register_alias("alloy_furnace", "technic:alloy_furnace")


minetest.register_craft({
	output = 'technic:alloy_furnace',
	recipe = {
		{'default:stone', 'default:stone', 'default:stone'},
		{'default:stone', '', 'default:stone'},
		{'moreores:gold_ingot', 'moreores:copper_ingot', 'moreores:gold_ingot'},
	}
})


alloy_furnace_formspec =
	"invsize[8,9;]"..
	"image[1,1;1,2;technic_power_meter_bg.png]"..
	"list[current_name;src;3,1;1,1;]"..
	"list[current_name;src2;3,2;1,1;]"..
	"list[current_name;dst;5,1;2,2;]"..
	"list[current_player;main;0,5;8,4;]"..
	"label[0,0;Alloy Furnace]"..
	"label[1,3;Power level]"
	
minetest.register_node("technic:alloy_furnace", {
	description = "Electric alloy furnace",
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
		meta:set_string("infotext", "Alloy furnace")
		local inv = meta:get_inventory()
		inv:set_size("src", 1)
		inv:set_size("src2", 1)
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
	groups = {cracky=2, not_in_creative_inventory=1},
	legacy_facedir_simple = true,
	sounds = default.node_sound_stone_defaults(),
	internal_EU_buffer=0;
	interal_EU_buffer_size=2000;
	technic_power_machine=1,
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_float("technic_power_machine", 1)
		meta:set_string("formspec", alloy_furnace_formspec)
		meta:set_string("infotext", "Alloy furnace");
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
	nodenames = {"technic:alloy_furnace","technic:alloy_furnace_active"},
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
				"list[current_name;src2;3,2;1,1;]"..
				"list[current_name;dst;5,1;2,2;]"..
				"list[current_player;main;0,5;8,4;]"..
				"label[0,0;Alloy Furnace]"..
				"label[1,3;Power level]")

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
			meta:set_string("infotext","Alloy Furnace active")
			meta:set_int("furnace_is_cookin",1)
			meta:set_string("src_time", 0)
			return
			end

			
		if meta:get_int("furnace_is_cookin")==0 or dst_index==nil then
			hacky_swap_node(pos,"technic:alloy_furnace")
			meta:set_string("infotext","Alloy Furnace inactive")
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