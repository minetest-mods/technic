
technic.compressor_recipes = {}

local S = technic.getter

if unified_inventory and unified_inventory.register_craft_type then
	unified_inventory.register_craft_type("compressing", {
		description = S("Compressing"),
		height = 1,
		width = 1,
	})
end

technic.register_compressor_recipe = function(src, src_count, dst, dst_count)
	technic.compressor_recipes[src] = {src_count = src_count, dst_name = dst, dst_count = dst_count}
	if unified_inventory then
		unified_inventory.register_craft({
			type = "compressing",
			output = dst.." "..dst_count,
			items = {src.." "..src_count},
			width = 0,
		})
	end
end

technic.get_compressor_recipe = function(item)
	if technic.compressor_recipes[item.name] and 
	   item.count >= technic.compressor_recipes[item.name].src_count then
		return technic.compressor_recipes[item.name]
	else
		return nil
	end
end

technic.register_compressor_recipe("default:snowblock",         1, "default:ice",             1)
technic.register_compressor_recipe("default:sand",              1, "default:sandstone",       1)
technic.register_compressor_recipe("default:desert_sand",       1, "default:desert_stone",    1)
technic.register_compressor_recipe("technic:mixed_metal_ingot", 1, "technic:composite_plate", 1)
technic.register_compressor_recipe("default:copper_ingot",      5, "technic:copper_plate",    1)
technic.register_compressor_recipe("technic:coal_dust",         4, "technic:graphite",        1)
technic.register_compressor_recipe("technic:carbon_cloth",      1, "technic:carbon_plate",    1)
technic.register_compressor_recipe("technic:enriched_uranium",  4, "technic:uranium_fuel",    1)


minetest.register_alias("compressor", "technic:compressor")
minetest.register_craft({
	output = 'technic:compressor',
	recipe = {
		{'default:stone',	'default:stone',	'default:stone'},
		{'mesecons:piston',	'technic:motor',	'mesecons:piston'},
		{'default:stone',	'technic:lv_cable0',	'default:stone'},
	}
})

local compressor_formspec =
	"invsize[8,9;]"..
	"label[0,0;"..S("%s Compressor"):format("LV").."]"..
	"list[current_name;src;3,1;1,1;]"..
	"list[current_name;dst;5,1;2,2;]"..
	"list[current_player;main;0,5;8,4;]"

minetest.register_node("technic:compressor", {
	description = S("%s Compressor"):format("LV"),
	tiles = {"technic_compressor_top.png",  "technic_compressor_bottom.png",
	         "technic_compressor_side.png", "technic_compressor_side.png",
	         "technic_compressor_back.png", "technic_compressor_front.png"},
	paramtype2 = "facedir",
	groups = {cracky=2},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", S("%s Compressor"):format("LV"))
		meta:set_string("formspec", compressor_formspec)
		local inv = meta:get_inventory()
		inv:set_size("src", 1)
		inv:set_size("dst", 4)
	end,
	can_dig = technic.machine_can_dig,
	allow_metadata_inventory_put = technic.machine_inventory_put,
	allow_metadata_inventory_take = technic.machine_inventory_take,
	allow_metadata_inventory_move = technic.machine_inventory_move,
})

minetest.register_node("technic:compressor_active", {
	description = S("%s Compressor"):format("LV"),
	tiles = {"technic_compressor_top.png",  "technic_compressor_bottom.png",
	         "technic_compressor_side.png", "technic_compressor_side.png",
	         "technic_compressor_back.png", "technic_compressor_front_active.png"},
	paramtype2 = "facedir",
	drop = "technic:compressor",
	groups = {cracky=2, not_in_creative_inventory=1},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	can_dig = technic.machine_can_dig,
	allow_metadata_inventory_put = technic.machine_inventory_put,
	allow_metadata_inventory_take = technic.machine_inventory_take,
	allow_metadata_inventory_move = technic.machine_inventory_move,
})

minetest.register_abm({
	nodenames = {"technic:compressor","technic:compressor_active"},
	interval = 1,
	chance   = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local meta         = minetest.get_meta(pos)
		local eu_input     = meta:get_int("LV_EU_input")
		local machine_name = S("%s Compressor"):format("LV")
		local machine_node = "technic:compressor"
		local demand       = 300
 
		 -- Setup meta data if it does not exist.
		if not eu_input then
			meta:set_int("LV_EU_demand", demand)
			meta:set_int("LV_EU_input", 0)
			return
		end
 
		-- Power off automatically if no longer connected to a switching station
		technic.switching_station_timeout_count(pos, "LV")
		local inv    = meta:get_inventory()
		local empty  = inv:is_empty("src")
		local srcstack  = inv:get_stack("src", 1)
		local src_item, recipe, result = nil, nil, nil

		if srcstack then
			src_item = srcstack:to_table()
		end
		if src_item then
			recipe = technic.get_compressor_recipe(src_item)
		end
		if recipe then
			result = {name=recipe.dst_name, count=recipe.dst_count}
		end 
		if empty or (not result) or
		   (not inv:room_for_item("dst", result)) then
			technic.swap_node(pos, machine_node)
			meta:set_string("infotext", S("%s Idle"):format(machine_name))
			meta:set_int("LV_EU_demand", 0)
			meta:set_int("src_time", 0)
			return
		end

		if eu_input < demand then
			technic.swap_node(pos, machine_node)
			meta:set_string("infotext", S("%s Unpowered"):format(machine_name))
		elseif eu_input >= demand then
			technic.swap_node(pos, machine_node.."_active")
			meta:set_string("infotext", S("%s Active"):format(machine_name))

			meta:set_int("src_time", meta:get_int("src_time") + 1)
			if meta:get_int("src_time") >= 4 then 
				meta:set_int("src_time", 0)
				srcstack:take_item(recipe.src_count)
				inv:set_stack("src", 1, srcstack)
				inv:add_item("dst", result)
			end
		end
		meta:set_int("LV_EU_demand", demand)
	end
})

technic.register_machine("LV", "technic:compressor",        technic.receiver)
technic.register_machine("LV", "technic:compressor_active", technic.receiver)

