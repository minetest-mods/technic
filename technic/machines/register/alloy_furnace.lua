
local S = technic.getter

-- Register alloy recipes
technic.alloy_recipes = {}

-- Register recipe in a table
technic.register_alloy_recipe = function(metal1, count1, metal2, count2, result, count3)
	in1 = {
		name  = metal1,
		count = count1,
	}
	in2 = {
		name  = metal2,
		count = count2,
	}
	-- Sort the inputs alphebetically
	if in1.name > in2.name then
		local temp = in1
		in1 = in2
		in2 = temp
	end
	technic.alloy_recipes[in1.name.." "..in2.name] = {
		input = {in1, in2},
		output = {
			name = result,
			count = count3,
		},
	}
	if unified_inventory then
		unified_inventory.register_craft({
			type = "alloy",
			output = result.." "..count3,
			items = {metal1.." "..count1, metal2.." "..count2},
			width = 2,
		})
	end
end

-- Retrieve a recipe given the input metals.
function technic.get_alloy_recipe(stack1, stack2)
	-- Sort the stacks alphebetically
	if stack1:get_name() > stack2:get_name() then
		local temp = stack1
		stack1 = stack2
		stack2 = temp
	end
	for _, recipe in pairs(technic.alloy_recipes) do
		if recipe.input[1].name == stack1:get_name() and
		   recipe.input[2].name == stack2:get_name() and
		   stack1:get_count() >= recipe.input[1].count and
		   stack2:get_count() >= recipe.input[2].count then
			return recipe
		end
	end
end

technic.register_alloy_recipe("technic:copper_dust",   3, "technic:tin_dust",       1, "technic:bronze_dust",           4)
technic.register_alloy_recipe("default:copper_ingot",  3, "moreores:tin_ingot",     1, "moreores:bronze_ingot",         4)
technic.register_alloy_recipe("technic:iron_dust",     3, "technic:chromium_dust",  1, "technic:stainless_steel_dust",  4)
technic.register_alloy_recipe("default:steel_ingot",   3, "technic:chromium_ingot", 1, "technic:stainless_steel_ingot", 4)
technic.register_alloy_recipe("technic:copper_dust",   2, "technic:zinc_dust",      1, "technic:brass_dust",            3)
technic.register_alloy_recipe("default:copper_ingot",  2, "technic:zinc_ingot",     1, "technic:brass_ingot",           3)
technic.register_alloy_recipe("default:sand",          2, "technic:coal_dust",      2, "technic:silicon_wafer",         1)
technic.register_alloy_recipe("technic:silicon_wafer", 1, "technic:gold_dust",      1, "technic:doped_silicon_wafer",   1)

local tube = {
	insert_object = function(pos, node, stack, direction)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		return inv:add_item("src", stack)
	end,
	can_insert = function(pos, node, stack, direction)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		return inv:room_for_item("src", stack)
	end,
	connect_sides = {left=1, right=1, back=1, top=1, bottom=1},
}


function technic.register_alloy_furnace(data)
	local tier = data.tier
	local ltier = string.lower(tier)

	local tube_side_texture = data.tube and "technic_"..ltier.."_alloy_furnace_side_tube.png"
			or "technic_"..ltier.."_alloy_furnace_side.png"

	local groups = {cracky=2}
	local active_groups = {cracky=2, not_in_creative_inventory=1}
	if data.tube then
		groups.tubedevice = 1
		groups.tubedevice_receiver = 1
		active_groups.tubedevice = 1
		active_groups.tubedevice_receiver = 1
	end

	local formspec =
		"invsize[8,10;]"..
		"label[0,0;"..S("%s Alloy Furnace"):format(tier).."]"..
		"list[current_name;src;3,1;1,2;]"..
		"list[current_name;dst;5,1;2,2;]"..
		"list[current_player;main;0,6;8,4;]"
	if data.upgrade then
		formspec = formspec..
			"list[current_name;upgrade1;1,4;1,1;]"..
			"list[current_name;upgrade2;2,4;1,1;]"..
			"label[1,5;Upgrade Slots]"
	end

	minetest.register_node("technic:"..ltier.."_alloy_furnace", {
		description = S("%s Alloy Furnace"):format(tier),
		tiles = {"technic_"..ltier.."_alloy_furnace_top.png",
		         "technic_"..ltier.."_alloy_furnace_bottom.png",
			 tube_side_texture,
		         tube_side_texture,
			 "technic_"..ltier.."_alloy_furnace_side.png",
		         "technic_"..ltier.."_alloy_furnace_front.png"},
		paramtype2 = "facedir",
		groups = groups,
		tube = data.tube and tube or nil,
		legacy_facedir_simple = true,
		sounds = default.node_sound_stone_defaults(),
		on_construct = function(pos)
			local meta = minetest.get_meta(pos)
			local name = minetest.get_node(pos).name

			meta:set_string("infotext", S("%s Alloy Furnace"):format(tier))
			meta:set_string("formspec", formspec)
			meta:set_int("tube_time",  0)
			local inv = meta:get_inventory()
			inv:set_size("src", 2)
			inv:set_size("dst", 4)
			inv:set_size("upgrade1", 1)
			inv:set_size("upgrade2", 1)
		end,
		can_dig = technic.machine_can_dig,
		allow_metadata_inventory_put = technic.machine_inventory_put,
		allow_metadata_inventory_take = technic.machine_inventory_take,
		allow_metadata_inventory_move = technic.machine_inventory_move,
	})

	minetest.register_node("technic:"..ltier.."_alloy_furnace_active",{
		description = S(tier.." Alloy Furnace"),
		tiles = {"technic_"..ltier.."_alloy_furnace_top.png",
		         "technic_"..ltier.."_alloy_furnace_bottom.png",
			 tube_side_texture,
		         tube_side_texture,
			 "technic_"..ltier.."_alloy_furnace_side.png",
		         "technic_"..ltier.."_alloy_furnace_front_active.png"},
		paramtype2 = "facedir",
		light_source = 8,
		drop = "technic:"..ltier.."_alloy_furnace",
		groups = active_groups,
		tube = data.tube and tube or nil,
		legacy_facedir_simple = true,
		sounds = default.node_sound_stone_defaults(),
		can_dig = technic.machine_can_dig,
		allow_metadata_inventory_put = technic.machine_inventory_put,
		allow_metadata_inventory_take = technic.machine_inventory_take,
		allow_metadata_inventory_move = technic.machine_inventory_move,
	})

	minetest.register_abm({
		nodenames = {"technic:"..ltier.."_alloy_furnace", "technic:"..ltier.."_alloy_furnace_active"},
		interval = 1,
		chance = 1,
		action = function(pos, node, active_object_count, active_object_count_wider)
			local meta         = minetest.get_meta(pos)
			local inv          = meta:get_inventory()
			local eu_input     = meta:get_int(tier.."_EU_input")

			-- Machine information
			local machine_name   = S("%s Alloy Furnace"):format(tier)
			local machine_node   = "technic:"..ltier.."_alloy_furnace"
			local machine_demand = data.demand

			-- Setup meta data if it does not exist.
			if not eu_input then
				meta:set_int(tier.."_EU_demand", machine_demand[1])
				meta:set_int(tier.."_EU_input", 0)
			end

			-- Power off automatically if no longer connected to a switching station
			technic.switching_station_timeout_count(pos, tier)

			local EU_upgrade, tube_upgrade = 0, 0
			if data.upgrade then
				EU_upgrade, tube_upgrade = technic.handle_machine_upgrades(meta)
			end
			if data.tube then
				technic.handle_machine_pipeworks(pos, tube_upgrade)
			end

			-- Get what to cook if anything
			local srcstack  = inv:get_stack("src", 1)
			local src2stack = inv:get_stack("src", 2)
			local recipe = technic.get_alloy_recipe(srcstack, src2stack)
			local result = recipe and ItemStack(recipe.output) or nil
			-- Sort the stacks alphabetically
			if srcstack:get_name() > src2stack:get_name() then
				local temp = srcstack
				srcstack = src2stack
				src2stack = temp
			end
			if not result or
			   not inv:room_for_item("dst", result) then
				technic.swap_node(pos, machine_node)
				meta:set_string("infotext", S("%s Idle"):format(machine_name))
				meta:set_int(tier.."_EU_demand", 0)
				return
			end

			if eu_input < machine_demand[EU_upgrade+1] then
				-- Unpowered - go idle
				technic.swap_node(pos, machine_node)
				meta:set_string("infotext", S("%s Unpowered"):format(machine_name))
			elseif eu_input >= machine_demand[EU_upgrade+1] then
				-- Powered
				technic.swap_node(pos, machine_node.."_active")
				meta:set_string("infotext", S("%s Active"):format(machine_name))
				meta:set_int("src_time", meta:get_int("src_time") + 1)
				if meta:get_int("src_time") == data.cook_time then
					meta:set_int("src_time", 0)
					-- check if there's room for output and that we have the materials
					if inv:room_for_item("dst", result) then
						srcstack:take_item(recipe.input[1].count)
						inv:set_stack("src", 1, srcstack)
						src2stack:take_item(recipe.input[2].count)
						inv:set_stack("src", 2, src2stack)
						-- Put result in "dst" list
						inv:add_item("dst", result)
					else
						next_state = 1
					end
				end
			
			end
			meta:set_int(tier.."_EU_demand", machine_demand[EU_upgrade+1])
		end,
	})

	technic.register_machine(tier, "technic:"..ltier.."_alloy_furnace",        technic.receiver)
	technic.register_machine(tier, "technic:"..ltier.."_alloy_furnace_active", technic.receiver)

end -- End registration

