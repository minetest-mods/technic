-- Tool workshop
-- This machine repairs tools.

minetest.register_alias("tool_workshop", "technic:tool_workshop")

local S = technic.getter

local tube_entry = "^pipeworks_tube_connection_wooden.png"

minetest.register_craft({
	output = 'technic:tool_workshop',
	recipe = {
		{'group:wood',                         'default:diamond',        'group:wood'},
		{'mesecons_pistons:piston_sticky_off', 'technic:machine_casing', 'technic:carbon_cloth'},
		{'default:obsidian',                   'technic:mv_cable',       'default:obsidian'},
	}
})

local workshop_demand = {5000, 3500, 2000}

local workshop_formspec =
	"size[8,9;]"..
	"list[current_name;src;3,1;1,1;]"..
	"label[0,0;"..S("%s Tool Workshop"):format("MV").."]"..
	"list[current_name;upgrade1;1,3;1,1;]"..
	"list[current_name;upgrade2;2,3;1,1;]"..
	"label[1,4;"..S("Upgrade Slots").."]"..
	"list[current_player;main;0,5;8,4;]"..
	"listring[current_player;main]"..
	"listring[current_name;src]"..
	"listring[current_player;main]"..
	"listring[current_name;upgrade1]"..
	"listring[current_player;main]"..
	"listring[current_name;upgrade2]"..
	"listring[current_player;main]"

local run = function(pos, node)
	local meta         = minetest.get_meta(pos)
	local inv          = meta:get_inventory()
	local eu_input     = meta:get_int("MV_EU_input")
	local machine_name = S("%s Tool Workshop"):format("MV")

	-- Setup meta data if it does not exist.
	if not eu_input then
		meta:set_int("MV_EU_demand", workshop_demand[1])
		meta:set_int("MV_EU_input", 0)
		return
	end

	local EU_upgrade, tube_upgrade = technic.handle_machine_upgrades(meta)

	local repairable = false
	local srcstack = inv:get_stack("src", 1)
	if not srcstack:is_empty() then
		local itemdef = minetest.registered_items[srcstack:get_name()]
		if itemdef and
				(not itemdef.wear_represents or
				itemdef.wear_represents == "mechanical_wear") and
				srcstack:get_wear() ~= 0 then
			repairable = true
		end
	end
	technic.handle_machine_pipeworks(pos, tube_upgrade, function (pos, x_velocity, z_velocity)
		if not repairable then
			technic.send_items(pos, x_velocity, z_velocity, "src")
		end
	end)
	if not repairable then
		meta:set_string("infotext", S("%s Idle"):format(machine_name))
		meta:set_int("MV_EU_demand", 0)
		return
	end

	if eu_input < workshop_demand[EU_upgrade+1] then
		meta:set_string("infotext", S("%s Unpowered"):format(machine_name))
	elseif eu_input >= workshop_demand[EU_upgrade+1] then
		meta:set_string("infotext", S("%s Active"):format(machine_name))
		srcstack:add_wear(-1000)
		inv:set_stack("src", 1, srcstack)
	end
	meta:set_int("MV_EU_demand", workshop_demand[EU_upgrade+1])
end

minetest.register_node("technic:tool_workshop", {
	description = S("%s Tool Workshop"):format("MV"),
	paramtype2 = "facedir",
	tiles = {
		"technic_workshop_top.png"..tube_entry,
		"technic_machine_bottom.png"..tube_entry,
		"technic_workshop_side.png"..tube_entry,
		"technic_workshop_side.png"..tube_entry,
		"technic_workshop_side.png"..tube_entry,
		"technic_workshop_side.png"
	},
	groups = {snappy=2, choppy=2, oddly_breakable_by_hand=2,
		technic_machine=1, technic_mv=1, tubedevice=1, tubedevice_receiver=1},
	connect_sides = {"bottom", "back", "left", "right"},
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", S("%s Tool Workshop"):format("MV"))
		meta:set_string("formspec", workshop_formspec)
		local inv = meta:get_inventory()
		inv:set_size("src", 1)
		inv:set_size("upgrade1", 1)
		inv:set_size("upgrade2", 1)
	end,
	can_dig = technic.machine_can_dig,
	allow_metadata_inventory_put = technic.machine_inventory_put,
	allow_metadata_inventory_take = technic.machine_inventory_take,
	tube = {
		can_insert = function (pos, node, stack, direction)
			return minetest.get_meta(pos):get_inventory():room_for_item("src", stack)
		end,
		insert_object = function (pos, node, stack, direction)
			return minetest.get_meta(pos):get_inventory():add_item("src", stack)
		end,
		connect_sides = {left = 1, right = 1, back = 1, top = 1, bottom = 1},
	},
	technic_run = run,
	after_place_node = pipeworks.after_place,
	after_dig_node = technic.machine_after_dig_node
})

technic.register_machine("MV", "technic:tool_workshop", technic.receiver)

