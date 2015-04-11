local S = technic.getter

local desc = S("Administrative HV Powernode")
local default_eu_rate = 100000 -- TODO: Make EU rate configurable via a formspec. 

minetest.register_node("technic:hv_admin_powernode", {
	description = desc,
		tiles = {	"technic_admin_powernode.png", "technic_admin_powernode.png",
					"technic_admin_powernode_sides.png", "technic_admin_powernode_sides.png",
					"technic_admin_powernode_sides.png", "technic_admin_powernode_sides.png"},
	paramtype2 = "facedir",
	groups = {cracky=3, not_in_creative_inventory=1, mesecon=2},
	sounds = default.node_sound_wood_defaults(),
	paramtype = "light",
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", desc..S(" - Inactive"))
		meta:set_int("HV_EU_supply", 0)
		meta:set_int("eu_rate", default_eu_rate)
	end,
	after_place_node = function(pos, player, itemstack, pointed_thing)
		local meta = minetest.get_meta(pos)
		if placer and placer:is_player() then
			meta:set_string("owner", placer:get_player_name())
		end
	end,
	on_punch = function (pos, node)
		local meta = minetest.get_meta(pos)
		if meta:get_int("HV_EU_supply") == 0 then
			meta:set_string("infotext", desc..S(" - Active("..meta:get_int("eu_rate").."EU's)"))
			meta:set_int("HV_EU_supply", meta:get_int("eu_rate"))
		else
			meta:set_string("infotext", desc..S(" - Inactive"))
			meta:set_int("HV_EU_supply", 0)
		end
	end,
	can_dig = function (pos, player)
		local meta = minetest.get_meta(pos)
		return meta:get_int("locked") == 0 or (player and player:is_player() and player:get_player_name() == meta:get_string("owner"))
	end,
	mesecons={effector={action_on=function(pos,node)
		action_on = minetest.punch_node(pos)
	end}},
})

technic.register_machine("HV", "technic:hv_admin_powernode", technic.producer)

