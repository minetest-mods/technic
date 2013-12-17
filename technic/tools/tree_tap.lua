
local S = technic.getter

minetest.register_tool("technic:treetap", {
	description = S("Tree Tap"),
	inventory_image = "technic_tree_tap.png",
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type ~= "node" then
			return
		end
		local inv = user:get_inventory()
		if not inv:room_for_item("main", ItemStack("technic:raw_latex")) then
			return
		end
		local pos = pointed_thing.under
		if minetest.is_protected(pos, user:get_player_name()) then
			minetest.record_protection_violation(pos, user:get_player_name())
			return
		end
		local node = minetest.get_node(pos)
		local node_name = node.name
		if node_name ~= "moretrees:rubber_tree_trunk" then
			return
		end
		node.name = "moretrees:rubber_tree_trunk_empty"
		inv:add_item("main", ItemStack("technic:raw_latex"))
		minetest.swap_node(pos, node)
		local item_wear = tonumber(itemstack:get_wear())
		item_wear = item_wear + 819
		if item_wear > 65535 then
			itemstack:clear()
			return itemstack
		end
		itemstack:set_wear(item_wear)
		return itemstack
	end,
})

minetest.register_craft({
	output = "technic:treetap",
	recipe = {
		{"pipeworks:tube", "group:wood",    "default:stick"},
		{"",               "default:stick", "default:stick"}
	},
})
     
minetest.register_craftitem("technic:raw_latex", {
	description = S("Raw Latex"),
	inventory_image = "technic_raw_latex.png",
})
     
minetest.register_craft({
	type = "cooking",
	output = "technic:rubber",
	recipe = "technic:raw_latex",
})

minetest.register_craftitem("technic:rubber", {
	description = S("Rubber Fiber"),
	inventory_image = "technic_rubber.png",
})

minetest.register_abm({
	nodenames = {"moretrees:rubber_tree_trunk_empty"},
	interval = 60,
	chance = 15,
	action = function(pos, node)
		local meta = minetest.get_meta(pos)
		if meta:get_int("placed") ~= 0 then
			return
		end
		minetest.set_node(pos, {name="moretrees:rubber_tree_trunk"})
	end
})

