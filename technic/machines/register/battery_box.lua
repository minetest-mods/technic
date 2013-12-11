
local S = technic.getter

technic.register_power_tool("technic:battery", 10000)
technic.register_power_tool("technic:red_energy_crystal", 100000)
technic.register_power_tool("technic:green_energy_crystal", 250000)
technic.register_power_tool("technic:blue_energy_crystal", 500000)

minetest.register_craft({
	output = 'technic:battery',
	recipe = {
		{'group:wood', 'default:copper_ingot', 'group:wood'},
		{'group:wood', 'moreores:tin_ingot',   'group:wood'},
		{'group:wood', 'default:copper_ingot', 'group:wood'},
	}
})

minetest.register_tool("technic:battery", {
	description = S("RE Battery"),
	inventory_image = "technic_battery.png",
	tool_capabilities = {
		charge = 0,
		max_drop_level = 0,
		groupcaps = {
			fleshy = {times={}, uses=10000, maxlevel=0}
		}
	}
})


function technic.register_battery_box(data)
	local tier = data.tier
	local ltier = string.lower(tier)

	local formspec =
		"invsize[8,9;]"..
		"image[1,1;1,2;technic_power_meter_bg.png]"..
		"list[current_name;src;3,1;1,1;]"..
		"image[4,1;1,1;technic_battery_reload.png]"..
		"list[current_name;dst;5,1;1,1;]"..
		"label[0,0;"..S("%s Battery Box"):format(tier).."]"..
		"label[3,0;"..S("Charge").."]"..
		"label[5,0;"..S("Discharge").."]"..
		"label[1,3;"..S("Power level").."]"..
		"list[current_player;main;0,5;8,4;]"

	for i = 0, 8 do
		local groups = {snappy=2, choppy=2, oddly_breakable_by_hand=2}
		if i ~= 0 then
			groups.not_in_creative_inventory = 1
		end
		minetest.register_node("technic:"..ltier.."_battery_box"..i, {
			description = S("%s Battery Box"):format(tier),
			tiles = {"technic_"..ltier.."_battery_box_top.png",
			         "technic_"..ltier.."_battery_box_bottom.png",
				 "technic_"..ltier.."_battery_box_side.png^technic_power_meter"..i..".png",
				 "technic_"..ltier.."_battery_box_side.png^technic_power_meter"..i..".png",
				 "technic_"..ltier.."_battery_box_side.png^technic_power_meter"..i..".png",
				 "technic_"..ltier.."_battery_box_side.png^technic_power_meter"..i..".png"},
			groups = groups,
			sounds = default.node_sound_wood_defaults(),
			drop = "technic:"..ltier.."_battery_box0",
			on_construct = function(pos)
				local meta = minetest.get_meta(pos)
				local inv = meta:get_inventory()
				local node = minetest.get_node(pos)

				meta:set_string("infotext", S("%s Battery Box"):format(tier))
				meta:set_string("formspec", formspec)
				meta:set_int(tier.."_EU_demand", 0)
				meta:set_int(tier.."_EU_supply", 0)
				meta:set_int(tier.."_EU_input",  0)
				meta:set_float("internal_EU_charge", 0)
				inv:set_size("src", 1)
				inv:set_size("dst", 1)
			end,
			can_dig = technic.machine_can_dig,
			allow_metadata_inventory_put = technic.machine_inventory_put,
			allow_metadata_inventory_take = technic.machine_inventory_take,
			allow_metadata_inventory_move = technic.machine_inventory_move,
		})
	end


	minetest.register_abm({
		nodenames = {"technic:"..ltier.."_battery_box0", "technic:"..ltier.."_battery_box1",
		             "technic:"..ltier.."_battery_box2", "technic:"..ltier.."_battery_box3",
		             "technic:"..ltier.."_battery_box4", "technic:"..ltier.."_battery_box5",
		             "technic:"..ltier.."_battery_box6", "technic:"..ltier.."_battery_box7",
		             "technic:"..ltier.."_battery_box8"},
		interval = 1,
		chance   = 1,
		action = function(pos, node, active_object_count, active_object_count_wider)
			local meta           = minetest.get_meta(pos)
			local eu_input       = meta:get_int(tier.."_EU_input")
			local current_charge = meta:get_int("internal_EU_charge")

			-- Power off automatically if no longer connected to a switching station
			technic.switching_station_timeout_count(pos, tier)

			-- Charge/discharge the battery with the input EUs
			if eu_input >= 0 then
				current_charge = math.min(current_charge + eu_input, data.max_charge)
			else
				current_charge = math.max(current_charge + eu_input, 0)
			end

			-- Charging/discharging tools here
			current_charge = technic.charge_tools(meta,
					current_charge, data.charge_step)
			current_charge = technic.discharge_tools(meta,
					current_charge, data.discharge_step,
					data.max_charge)

			-- We allow batteries to charge on less than the demand
			meta:set_int(tier.."_EU_demand",
					math.min(data.charge_rate, data.max_charge - current_charge))
			meta:set_int(tier.."_EU_supply",
					math.min(data.discharge_rate, current_charge))

			meta:set_int("internal_EU_charge", current_charge)

			-- Select node textures
			local charge_count = math.ceil((current_charge / data.max_charge) * 8)
			charge_count = math.min(charge_count, 8)
			charge_count = math.max(charge_count, 0)
			local last_count = meta:get_float("last_side_shown")
			if charge_count ~= last_count then
				technic.swap_node(pos,"technic:"..ltier.."_battery_box"..charge_count)
				meta:set_float("last_side_shown", charge_count)
			end

			local charge_percent = math.floor(current_charge / data.max_charge * 100)
			meta:set_string("formspec",
				formspec..
				"image[1,1;1,2;technic_power_meter_bg.png"
				.."^[lowpart:"..charge_percent
				..":technic_power_meter_fg.png]")

			local infotext = S("%s Battery Box: %d/%d"):format(tier,
					current_charge, data.max_charge)
			if eu_input == 0 then
				infotext = S("%s Idle"):format(infotext)
			end
			meta:set_string("infotext", infotext)
		end
	})

	-- Register as a battery type
	-- Battery type machines function as power reservoirs and can both receive and give back power
	for i = 0, 8 do
		technic.register_machine(tier, "technic:"..ltier.."_battery_box"..i, technic.battery)
	end

end -- End registration


function technic.charge_tools(meta, batt_charge, charge_step)
	local inv = meta:get_inventory()
	if inv:is_empty("src") then
		return batt_charge
	end
	local srcstack = inv:get_stack("src", 1)
	local src_meta = get_item_meta(srcstack:get_metadata())

	local toolname = srcstack:get_name()
	if not technic.power_tools[toolname] then
		return batt_charge
	end
	-- Set meta data for the tool if it didn't do it itself
	src_meta = get_item_meta(srcstack:get_metadata())
	src_meta = src_meta or {}
	if not src_meta.charge then
		src_meta.charge = 0
	end
	-- Do the charging
	local item_max_charge = technic.power_tools[toolname]
	local tool_charge     = src_meta.charge
	if tool_charge >= item_max_charge or batt_charge <= 0 then
		return batt_charge
	end
	charge_step = math.min(charge_step, batt_charge)
	charge_step = math.min(charge_step, item_max_charge - tool_charge)
	tool_charge = tool_charge + charge_step
	batt_charge = batt_charge - charge_step
	technic.set_RE_wear(srcstack, tool_charge, item_max_charge)
	src_meta.charge = tool_charge
	srcstack:set_metadata(set_item_meta(src_meta))
	inv:set_stack("src", 1, srcstack)
	return batt_charge
end


function technic.discharge_tools(meta, batt_charge, charge_step, max_charge)
	local inv = meta:get_inventory()
	if inv:is_empty("dst") then
		return batt_charge
	end
	srcstack = inv:get_stack("dst", 1)
	local toolname = srcstack:get_name()
	if technic.power_tools[toolname] == nil then
		return batt_charge
	end
	-- Set meta data for the tool if it didn't do it itself :-(
	local src_meta = get_item_meta(srcstack:get_metadata())
	src_meta = src_meta or {}
	if not src_meta.charge then
		src_meta.charge = 0
	end

	-- Do the discharging
	local item_max_charge = technic.power_tools[toolname]
	local tool_charge     = src_meta.charge
	if tool_charge <= 0 or batt_charge >= max_charge then
		return batt_charge
	end
	charge_step = math.min(charge_step, max_charge - batt_charge)
	charge_step = math.min(charge_step, tool_charge)
	tool_charge = tool_charge - charge_step
	batt_charge = batt_charge + charge_step
	technic.set_RE_wear(srcstack, tool_charge, item_max_charge)
	src_meta.charge = tool_charge
	srcstack:set_metadata(set_item_meta(src_meta))
	inv:set_stack("dst", 1, srcstack)
	return batt_charge
end

