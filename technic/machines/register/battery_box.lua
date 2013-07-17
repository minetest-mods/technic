
technic.battery_box_formspec =
	"invsize[8,9;]"..
	"image[1,1;1,2;technic_power_meter_bg.png]"..
	"list[current_name;src;3,1;1,1;]"..
	"image[4,1;1,1;technic_battery_reload.png]"..
	"list[current_name;dst;5,1;1,1;]"..
	"label[0,0;Battery Box]"..
	"label[3,0;Charge]"..
	"label[5,0;Discharge]"..
	"label[1,3;Power level]"..
	"list[current_player;main;0,5;8,4;]"

function technic.register_battery_box(data)
	local tier = data.tier
	local ltier = string.lower(tier)

	for i = 0, 8 do
		local groups = {snappy=2, choppy=2, oddly_breakable_by_hand=2}
		if i ~= 0 then
			groups.not_in_creative_inventory = 1
		end
		minetest.register_node("technic:"..ltier.."_battery_box"..i, {
			description = tier.." Battery Box",
			tiles = {"technic_"..ltier.."_battery_box_top.png",
			         "technic_"..ltier.."_battery_box_bottom.png",
				 "technic_"..ltier.."_battery_box_side.png^technic_power_meter"..i..".png",
				 "technic_"..ltier.."_battery_box_side.png^technic_power_meter"..i..".png",
				 "technic_"..ltier.."_battery_box_side.png^technic_power_meter"..i..".png",
				 "technic_"..ltier.."_battery_box_side.png^technic_power_meter"..i..".png"},
			groups = groups,
			sounds = default.node_sound_wood_defaults(),
			drop = "technic:"..ltier.."_battery_box0",
			technic = data,
			on_construct = function(pos)
				local meta = minetest.get_meta(pos)
				local inv = meta:get_inventory()
				local node = minetest.get_node(pos)
				local data = minetest.registered_nodes[node.name].technic

				meta:set_string("infotext", data.tier.." Battery Box")
				meta:set_string("formspec", battery_box_formspec)
				meta:set_int(data.tier.."_EU_demand", 0)
				meta:set_int(data.tier.."_EU_supply", 0)
				meta:set_int(data.tier.."_EU_input",  0)
				meta:set_float("internal_EU_charge", 0)
				inv:set_size("src", 1)
				inv:set_size("dst", 1)
			end,
			can_dig = function(pos,player)
				local meta = minetest.get_meta(pos);
				local inv = meta:get_inventory()
				if not inv:is_empty("src") or not inv:is_empty("dst") then
					minetest.chat_send_player(player:get_player_name(),
						"Machine cannot be removed because it is not empty");
					return false
				else
					return true
				end
			end,
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
			local data           = minetest.registered_nodes[node.name].technic
			local meta           = minetest.get_meta(pos)
			local eu_input       = meta:get_int(data.tier.."_EU_input")
			local current_charge = meta:get_int("internal_EU_charge")
			local max_charge     = data.max_charge
			local charge_rate    = data.charge_rate
			local discharge_rate = data.discharge_rate

			-- Power off automatically if no longer connected to a switching station
			technic.switching_station_timeout_count(pos, data.tier)

			-- Charge/discharge the battery with the input EUs
			if eu_input >= 0 then
				current_charge = math.min(current_charge + eu_input, max_charge)
			else
				current_charge = math.max(current_charge + eu_input, 0)
			end

			-- Charging/discharging tools here
			current_charge = technic.charge_tools(meta,
					current_charge, data.charge_step)
			current_charge = technic.discharge_tools(meta,
					current_charge, data.discharge_step, max_charge)

			-- We allow batteries to charge on less than the demand
			meta:set_int(data.tier.."_EU_demand",
					math.min(charge_rate, max_charge - current_charge))
			meta:set_int(data.tier.."_EU_supply",
					math.min(discharge_rate, current_charge))

			meta:set_int("internal_EU_charge", current_charge)

			-- Select node textures
			local charge_count = math.ceil((current_charge / max_charge) * 8)
			charge_count = math.min(charge_count, 8)
			charge_count = math.max(charge_count, 0)
			local last_count = meta:get_float("last_side_shown")
			if charge_count ~= last_count then
				hacky_swap_node(pos,"technic:"..string.lower(data.tier).."_battery_box"..charge_count)
				meta:set_float("last_side_shown", charge_count)
			end

			local charge_percent = math.floor(current_charge / max_charge * 100)
			meta:set_string("formspec",
				technic.battery_box_formspec..
				"image[1,1;1,2;technic_power_meter_bg.png^[lowpart:"
				..charge_percent..":technic_power_meter_fg.png]")

			local infotext = data.tier.." battery box: "
					..current_charge.."/"..max_charge
			if eu_input == 0 then
				infotext = infotext.." (idle)"
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


function technic.charge_tools(meta, charge, charge_step)
	--charge registered power tools
	local inv = meta:get_inventory()
	if not inv:is_empty("src") then
		local srcstack = inv:get_stack("src", 1)
		local src_item = srcstack:to_table()
		local src_meta = get_item_meta(src_item["metadata"])

		local toolname = src_item["name"]
		if technic.power_tools[toolname] ~= nil then
			-- Set meta data for the tool if it didn't do it itself :-(
			src_meta = get_item_meta(src_item["metadata"])
			src_meta = src_meta or {}
			if src_meta["charge"] == nil then
				src_meta["charge"] = 0
			end
			-- Do the charging
			local item_max_charge = technic.power_tools[toolname]
			local tool_charge     = src_meta["charge"]
			if tool_charge < item_max_charge and charge > 0 then
				if charge - charge_step < 0 then
					charge_step = charge
				end
				if tool_charge + charge_step > item_max_charge then
					charge_step = item_max_charge - tool_charge
				end
				tool_charge = tool_charge + charge_step
				charge = charge - charge_step
				technic.set_RE_wear(src_item, tool_charge, item_max_charge)
				src_meta["charge"]   = tool_charge
				src_item["metadata"] = set_item_meta(src_meta)
				inv:set_stack("src", 1, src_item)
			end
		end
	end
	return charge -- return the remaining charge in the battery
end


function technic.discharge_tools(meta, charge, charge_step, max_charge)
	-- discharging registered power tools
	local inv = meta:get_inventory()
	if not inv:is_empty("dst") then
		srcstack = inv:get_stack("dst", 1)
		src_item = srcstack:to_table()
		local src_meta = get_item_meta(src_item["metadata"])
		local toolname = src_item["name"]
		if technic.power_tools[toolname] ~= nil then
			-- Set meta data for the tool if it didn't do it itself :-(
			src_meta = get_item_meta(src_item["metadata"])
			src_meta = src_meta or {}
			if src_meta["charge"] == nil then
				src_meta["charge"] = 0
			end

			-- Do the discharging
			local item_max_charge = technic.power_tools[toolname]
			local tool_charge     = src_meta["charge"]
			if tool_charge > 0 and charge < max_charge then
				if charge + charge_step > max_charge then
					charge_step = max_charge - charge
				end
				if tool_charge - charge_step < 0 then
					charge_step = charge
				end
				tool_charge = tool_charge - charge_step
				charge = charge + charge_step
				technic.set_RE_wear(src_item, tool_charge, item_max_charge)
				src_meta["charge"] = tool_charge
				src_item["metadata"] = set_item_meta(src_meta)
				inv:set_stack("dst", 1, src_item)
			end
		end
	end
	return charge -- return the remaining charge in the battery
end

