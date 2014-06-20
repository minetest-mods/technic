
technic.extractor_recipes ={}

local S = technic.getter

if unified_inventory and unified_inventory.register_craft_type then
	unified_inventory.register_craft_type("extracting", {
		description = S("Extracting"),
		height = 1,
		width = 1,
	})
end

technic.register_extractor_recipe = function(src, src_count, dst, dst_count)
	technic.extractor_recipes[src] = {src_count = src_count, dst_name = dst, dst_count = dst_count}
	if unified_inventory then
		unified_inventory.register_craft({
			type = "extracting",
			output = dst.." "..dst_count,
			items = {src.." "..src_count},
			width = 0,
		})
	end
end

-- Receive an ItemStack of result by an ItemStack input
technic.get_extractor_recipe = function(item)
	if technic.extractor_recipes[item.name] and
	   item.count >= technic.extractor_recipes[item.name].src_count then
		return technic.extractor_recipes[item.name]
	else
		return nil
	end
end



technic.register_extractor_recipe("technic:coal_dust",        1,          "dye:black",      2)
technic.register_extractor_recipe("default:cactus",           1,          "dye:green",      2)
technic.register_extractor_recipe("default:dry_shrub",        1,          "dye:brown",      2)
technic.register_extractor_recipe("flowers:geranium",         1,          "dye:blue",       2)
technic.register_extractor_recipe("flowers:dandelion_white",  1,          "dye:white",      2)
technic.register_extractor_recipe("flowers:dandelion_yellow", 1,          "dye:yellow",     2)
technic.register_extractor_recipe("flowers:tulip",            1,          "dye:orange",     2)
technic.register_extractor_recipe("flowers:rose",             1,          "dye:red",        2)
technic.register_extractor_recipe("flowers:viola",            1,          "dye:violet",     2)
technic.register_extractor_recipe("technic:raw_latex",        1,          "technic:rubber", 3)
technic.register_extractor_recipe("moretrees:rubber_tree_trunk_empty", 1, "technic:rubber", 1)
technic.register_extractor_recipe("moretrees:rubber_tree_trunk",       1, "technic:rubber", 1)
technic.register_extractor_recipe("technic:uranium",          5,          "technic:enriched_uranium", 1)

minetest.register_alias("extractor", "technic:extractor")
minetest.register_craft({
	output = 'technic:extractor',
	recipe = {
		{'technic:treetap', 'technic:motor',     'technic:treetap'},
		{'technic:treetap', 'technic:lv_cable0', 'technic:treetap'},
		{'',                '',                  ''},
	}
})

local extractor_formspec =
   "invsize[8,9;]"..
   "label[0,0;"..S("%s Extractor"):format("LV").."]"..
   "list[current_name;src;3,1;1,1;]"..
   "list[current_name;dst;5,1;2,2;]"..
   "list[current_player;main;0,5;8,4;]"

minetest.register_node("technic:extractor", {
	description = S("%s Extractor"):format("LV"),
	tiles = {"technic_lv_grinder_top.png",  "technic_lv_grinder_bottom.png", "technic_lv_grinder_side.png",
	         "technic_lv_grinder_side.png", "technic_lv_grinder_side.png",   "technic_lv_grinder_front.png"},
	paramtype2 = "facedir",
	groups = {cracky=2},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", S("%s Extractor"):format("LV"))
		meta:set_string("formspec", extractor_formspec)
		local inv = meta:get_inventory()
		inv:set_size("src", 1)
		inv:set_size("dst", 4)
	end,
	can_dig = technic.machine_can_dig,
	allow_metadata_inventory_put = technic.machine_inventory_put,
	allow_metadata_inventory_take = technic.machine_inventory_take,
	allow_metadata_inventory_move = technic.machine_inventory_move,
})

minetest.register_node("technic:extractor_active", {
	description = S("%s Extractor"):format("LV"),
	tiles = {"technic_lv_grinder_top.png",  "technic_lv_grinder_bottom.png",
	         "technic_lv_grinder_side.png", "technic_lv_grinder_side.png",
	         "technic_lv_grinder_side.png", "technic_lv_grinder_front_active.png"},
	paramtype2 = "facedir",
	drop = "technic:extractor",
	groups = {cracky=2, not_in_creative_inventory=1},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	can_dig = technic.machine_can_dig,
	allow_metadata_inventory_put = technic.machine_inventory_put,
	allow_metadata_inventory_take = technic.machine_inventory_take,
	allow_metadata_inventory_move = technic.machine_inventory_move,
})

minetest.register_abm({
	nodenames = {"technic:extractor", "technic:extractor_active"},
	interval = 1,
	chance   = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		-- The machine will automatically shut down if disconnected from power in some fashion.
		local meta     = minetest.get_meta(pos)
		local inv      = meta:get_inventory()
		local srcstack = inv:get_stack("src", 1)
		local eu_input = meta:get_int("LV_EU_input")

		-- Machine information
		local machine_name = S("%s Extractor"):format("LV")
		local machine_node = "technic:extractor"
		local demand       = 300

		-- Setup meta data if it does not exist.
		if not eu_input then
			meta:set_int("LV_EU_demand", demand)
			meta:set_int("LV_EU_input", 0)
			return
		end

		-- Power off automatically if no longer connected to a switching station
		technic.switching_station_timeout_count(pos, "LV")

		local src_item = nil
		if srcstack then
			src_item = srcstack:to_table()
		end
		if src_item then
			recipe = technic.get_extractor_recipe(src_item)
		end
		if recipe then
			result = {name=recipe.dst_name, count=recipe.dst_count}
		end 
		if inv:is_empty("src") or (not recipe) or (not result) or
		   (not inv:room_for_item("dst", result)) then
			technic.swap_node(pos, machine_node)
			meta:set_string("infotext", S("%s Idle"):format(machine_name))
			meta:set_int("LV_EU_demand", 0)
			return
		end

		if eu_input < demand then
			-- unpowered - go idle
			technic.swap_node(pos, machine_node)
			meta:set_string("infotext", S("%s Unpowered"):format(machine_name))
		elseif eu_input >= demand then
			-- Powered
			technic.swap_node(pos, machine_node.."_active")
			meta:set_string("infotext", S("%s Active"):format(machine_name))

			meta:set_int("src_time", meta:get_int("src_time") + 1)
			if meta:get_int("src_time") >= 4 then -- 4 ticks per output
				meta:set_int("src_time", 0)
				srcstack:take_item(recipe.src_count)
				inv:set_stack("src", 1, srcstack)
				inv:add_item("dst", result)
			end
		end
		meta:set_int("LV_EU_demand", demand)
	end
})

technic.register_machine("LV", "technic:extractor",        technic.receiver)
technic.register_machine("LV", "technic:extractor_active", technic.receiver)

