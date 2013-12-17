local sonic_screwdriver_max_charge = 15000

local S = technic.getter

technic.register_power_tool("technic:sonic_screwdriver", sonic_screwdriver_max_charge)

minetest.register_tool("technic:sonic_screwdriver", {
	description = S("Sonic Screwdriver"),
	inventory_image = "technic_sonic_screwdriver.png",
	on_use = function(itemstack, user, pointed_thing)
		-- Must be pointing to facedir applicable node
		if pointed_thing.type ~= "node" then
			return
		end
		local pos = minetest.get_pointed_thing_position(pointed_thing, above)
		local node = minetest.get_node(pos)
		local node_name = node.name
		if minetest.registered_nodes[node_name].paramtype2 ~= "facedir" and
		   minetest.registered_nodes[node_name].paramtype2 ~= "wallmounted" then
			return itemstack
		end
		if node.param2 == nil then
			return
		end
		local meta1 = minetest.deserialize(itemstack:get_metadata())
		if not meta1 or not meta1.charge then
			return
		end
		if meta1.charge - 100 > 0 then
			minetest.sound_play("technic_sonic_screwdriver",
					{pos = pos, gain = 0.3, max_hear_distance = 10})
			local p = node.param2
			if minetest.registered_nodes[node_name].paramtype2 == "facedir" then
				p = p + 1
				if p == 4 then
					p = 0
				end
			else
				p = p + 1
				if p == 6 then
					p = 0
				end
			end
			if minetest.is_protected(pos, user:get_player_name()) then
				minetest.record_protection_violation(pos, user:get_player_name())
			else
				node.param2 = p
				minetest.swap_node(pos, node)

				meta1.charge = meta1.charge - 100
				itemstack:set_metadata(minetest.serialize(meta1))
				technic.set_RE_wear(itemstack, meta1.charge, sonic_screwdriver_max_charge)
			end
		end
		return itemstack
	end, 
})
 
minetest.register_craft({
	output = "technic:sonic_screwdriver",
	recipe = {
		{"default:diamond"},
		{"technic:battery"},
		{"technic:stainless_steel_ingot"}
	}
})

