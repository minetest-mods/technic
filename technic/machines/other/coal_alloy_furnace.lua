
-- Fuel driven alloy furnace. This uses no EUs:

local S = technic.getter

minetest.register_craft({
	output = 'technic:coal_alloy_furnace',
	recipe = {
		{'default:brick', 'default:brick', 'default:brick'},
		{'default:brick', '',              'default:brick'},
		{'default:brick', 'default:brick', 'default:brick'},
	}
})

local machine_name = S("Fuel-Fired Alloy Furnace")
local formspec =
	"size[8,9]"..
	"label[0,0;"..machine_name.."]"..
	"image[2,2;1,1;default_furnace_fire_bg.png]"..
	"list[current_name;fuel;2,3;1,1;]"..
	"list[current_name;src;2,1;2,1;]"..
	"list[current_name;dst;5,1;2,2;]"..
	"list[current_player;main;0,5;8,4;]"..
	"listring[current_name;dst]"..
	"listring[current_player;main]"..
	"listring[current_name;src]"..
	"listring[current_player;main]"..
	"listring[current_name;fuel]"..
	"listring[current_player;main]"

minetest.register_node("technic:coal_alloy_furnace", {
	description = machine_name,
	tiles = {"technic_coal_alloy_furnace_top.png",  "technic_coal_alloy_furnace_bottom.png",
	         "technic_coal_alloy_furnace_side.png", "technic_coal_alloy_furnace_side.png",
	         "technic_coal_alloy_furnace_side.png", "technic_coal_alloy_furnace_front.png"},
	paramtype2 = "facedir",
	groups = {cracky=2},
	legacy_facedir_simple = true,
	sounds = default.node_sound_stone_defaults(),
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", formspec)
		meta:set_string("infotext", machine_name)
		local inv = meta:get_inventory()
		inv:set_size("fuel", 1)
		inv:set_size("src", 2)
		inv:set_size("dst", 4)
	end,
	can_dig = technic.machine_can_dig,
	allow_metadata_inventory_put = technic.machine_inventory_put,
	allow_metadata_inventory_take = technic.machine_inventory_take,
	allow_metadata_inventory_move = technic.machine_inventory_move,
})

minetest.register_node("technic:coal_alloy_furnace_active", {
	description = machine_name,
	tiles = {"technic_coal_alloy_furnace_top.png",  "technic_coal_alloy_furnace_bottom.png",
	         "technic_coal_alloy_furnace_side.png", "technic_coal_alloy_furnace_side.png",
	         "technic_coal_alloy_furnace_side.png", "technic_coal_alloy_furnace_front_active.png"},
	paramtype2 = "facedir",
	light_source = 8,
	drop = "technic:coal_alloy_furnace",
	groups = {cracky=2, not_in_creative_inventory=1},
	legacy_facedir_simple = true,
	sounds = default.node_sound_stone_defaults(),
	can_dig = technic.machine_can_dig,
	allow_metadata_inventory_put = technic.machine_inventory_put,
	allow_metadata_inventory_take = technic.machine_inventory_take,
	allow_metadata_inventory_move = technic.machine_inventory_move,
})

minetest.register_abm({
	label = "Machines: run coal alloy furnace",
	nodenames = {"technic:coal_alloy_furnace", "technic:coal_alloy_furnace_active"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local meta = minetest.get_meta(pos)
		local inv    = meta:get_inventory()

		if inv:get_size("src") == 1 then -- Old furnace -> convert it
			inv:set_size("src", 2)
			inv:set_stack("src", 2, inv:get_stack("src2", 1))
			inv:set_size("src2", 0)
		end

		for i, name in pairs({
				"fuel_totaltime",
				"fuel_time",
				"src_totaltime",
				"src_time"}) do
			if not meta:get_float(name) then
				meta:set_float(name, 0.0)
			end
		end

		-- Get what to cook if anything
		local result = technic.get_recipe("alloy", inv:get_list("src"))

		local was_active = false

		if meta:get_float("fuel_time") < meta:get_float("fuel_totaltime") then
			was_active = true
			meta:set_int("fuel_time", meta:get_int("fuel_time") + 1)
			if result then
				meta:set_int("src_time", meta:get_int("src_time") + 1)
				if meta:get_int("src_time") >= result.time then
					meta:set_int("src_time", 0)
					local result_stack = ItemStack(result.output)
					if inv:room_for_item("dst", result_stack) then
						inv:set_list("src", result.new_input)
						inv:add_item("dst", result_stack)
					end
				end
			else
				meta:set_int("src_time", 0)
			end
		end

		if meta:get_float("fuel_time") < meta:get_float("fuel_totaltime") then
			local percent = math.floor(meta:get_float("fuel_time") /
					meta:get_float("fuel_totaltime") * 100)
			meta:set_string("infotext", S("%s Active"):format(machine_name).." ("..percent.."%)")
			technic.swap_node(pos, "technic:coal_alloy_furnace_active")
			meta:set_string("formspec",
					"size[8,9]"..
					"label[0,0;"..machine_name.."]"..
					"image[2,2;1,1;default_furnace_fire_bg.png^[lowpart:"..
					(100 - percent)..":default_furnace_fire_fg.png]"..
					"list[current_name;fuel;2,3;1,1;]"..
					"list[current_name;src;2,1;2,1;]"..
					"list[current_name;dst;5,1;2,2;]"..
					"list[current_player;main;0,5;8,4;]"..
					"listring[current_name;dst]"..
					"listring[current_player;main]"..
					"listring[current_name;src]"..
					"listring[current_player;main]"..
					"listring[current_name;fuel]"..
					"listring[current_player;main]")
			return
		end

		local recipe = technic.get_recipe("alloy", inv:get_list("src"))

		if not recipe then
			if was_active then
				meta:set_string("infotext", S("%s is empty"):format(machine_name))
				technic.swap_node(pos, "technic:coal_alloy_furnace")
				meta:set_string("formspec", formspec)
			end
			return
		end

		-- Next take a hard look at the fuel situation
		local fuel = nil
		local afterfuel
		local fuellist = inv:get_list("fuel")

		if fuellist then
			fuel, afterfuel = minetest.get_craft_result({method = "fuel", width = 1, items = fuellist})
		end

		if fuel.time <= 0 then
			meta:set_string("infotext", S("%s Out Of Fuel"):format(machine_name))
			technic.swap_node(pos, "technic:coal_alloy_furnace")
			meta:set_string("formspec", formspec)
			return
		end

		meta:set_string("fuel_totaltime", fuel.time)
		meta:set_string("fuel_time", 0)

		inv:set_stack("fuel", 1, afterfuel.items[1])
	end,
})

