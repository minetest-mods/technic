-- LV Tool workshop
-- This machine repairs tools.

minetest.register_alias("tool_workshop", "technic:tool_workshop")
minetest.register_craft({
	output = 'technic:tool_workshop',
	recipe = {
		{'group:wood',    'group:wood',           'group:wood'},
		{'group:wood',    'default:diamond',      'group:wood'},
		{'default:stone', 'default:copper_ingot', 'default:stone'},
	}
})

local workshop_formspec =
	"invsize[8,9;]"..
	"list[current_name;src;3,1;1,1;]"..
	"label[0,0;Tool Workshop]"..
	"list[current_player;main;0,5;8,4;]"

minetest.register_node("technic:tool_workshop", {
	description = "Tool Workshop",
	tiles = {"technic_workshop_top.png", "technic_machine_bottom.png", "technic_workshop_side.png",
	         "technic_workshop_side.png", "technic_workshop_side.png", "technic_workshop_side.png"},
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", "Tool Workshop")
		meta:set_float("technic_power_machine", 1)
		meta:set_string("formspec", workshop_formspec)
		local inv = meta:get_inventory()
		inv:set_size("src", 1)
	end,	
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("src") then
			minetest.chat_send_player(player:get_player_name(),
				"Machine cannot be removed because it is not empty");
			return false
		end
		return true
	end,
})

minetest.register_abm({
	nodenames = {"technic:tool_workshop"},
	interval = 1,
	chance   = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local meta         = minetest.get_meta(pos)
		local inv          = meta:get_inventory()
		local eu_input     = meta:get_int("MV_EU_input")
		local machine_name = "Tool Workshop"
		local machine_node = "technic:tool_workshop"
		local demand       = 5000

		-- Setup meta data if it does not exist.
		if not eu_input then
			meta:set_int("MV_EU_demand", demand)
			meta:set_int("MV_EU_input", 0)
			return
		end

		-- Power off automatically if no longer connected to a switching station
		technic.switching_station_timeout_count(pos, "MV")

		srcstack = inv:get_stack("src", 1)
		if inv:is_empty("src") or
		   srcstack:get_wear() == 0 or
		   srcstack:get_name() == "technic:water_can" or
		   srcstack:get_name() == "technic:lava_can" then
			meta:set_string("infotext", machine_name.." Idle")
			meta:set_int("MV_EU_demand", 0)
			return
		end
		
		if eu_input < demand then
			meta:set_string("infotext", machine_name.." Unpowered")
		elseif eu_input >= demand then
			meta:set_string("infotext", machine_name.." Active")
			srcstack:add_wear(-1000)
			inv:set_stack("src", 1, srcstack)
		end
		meta:set_int("MV_EU_demand", demand)
	end
}) 

technic.register_machine("MV", "technic:tool_workshop", technic.receiver)

