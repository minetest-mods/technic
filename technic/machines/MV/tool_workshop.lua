-- Tool workshop
-- This machine repairs tools.

minetest.register_alias("tool_workshop", "technic:tool_workshop")

local S = technic.getter

minetest.register_craft({
	output = 'technic:tool_workshop',
	recipe = {
		{'group:wood',                         'default:diamond',        'group:wood'},
		{'mesecons_pistons:piston_sticky_off', 'technic:machine_casing', 'technic:carbon_cloth'},
		{'default:obsidian',                   'technic:mv_cable0',      'default:obsidian'},
	}
})

local workshop_formspec =
	"invsize[8,9;]"..
	"list[current_name;src;3,1;1,1;]"..
	"label[0,0;"..S("%s Tool Workshop"):format("MV").."]"..
	"list[current_player;main;0,5;8,4;]"

local run = function(pos, node)
	local meta         = minetest.get_meta(pos)
	local inv          = meta:get_inventory()
	local eu_input     = meta:get_int("MV_EU_input")
	local machine_name = S("%s Tool Workshop"):format("MV")
	local machine_node = "technic:tool_workshop"
	local demand       = 5000

	-- Setup meta data if it does not exist.
	if not eu_input then
		meta:set_int("MV_EU_demand", demand)
		meta:set_int("MV_EU_input", 0)
		return
	end

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
	if not repairable then
		meta:set_string("infotext", S("%s Idle"):format(machine_name))
		meta:set_int("MV_EU_demand", 0)
		return
	end
	
	if eu_input < demand then
		meta:set_string("infotext", S("%s Unpowered"):format(machine_name))
	elseif eu_input >= demand then
		meta:set_string("infotext", S("%s Active"):format(machine_name))
		srcstack:add_wear(-1000)
		inv:set_stack("src", 1, srcstack)
	end
	meta:set_int("MV_EU_demand", demand)
end

minetest.register_node("technic:tool_workshop", {
	description = S("%s Tool Workshop"):format("MV"),
	tiles = {"technic_workshop_top.png", "technic_machine_bottom.png", "technic_workshop_side.png",
	         "technic_workshop_side.png", "technic_workshop_side.png", "technic_workshop_side.png"},
	groups = {snappy=2, choppy=2, oddly_breakable_by_hand=2, technic_machine=1},
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", S("%s Tool Workshop"):format("MV"))
		meta:set_string("formspec", workshop_formspec)
		local inv = meta:get_inventory()
		inv:set_size("src", 1)
	end,	
	can_dig = technic.machine_can_dig,
	allow_metadata_inventory_put = technic.machine_inventory_put,
	allow_metadata_inventory_take = technic.machine_inventory_take,
	technic_run = run,
})

technic.register_machine("MV", "technic:tool_workshop", technic.receiver)

