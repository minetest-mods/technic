-- Configuration
local vacuum_max_charge        = 10000 -- 10000 - Maximum charge of the vacuum cleaner
local vacuum_charge_per_object = 100   -- 100   - Capable of picking up 50 objects
local vacuum_range             = 8     -- 8     - Area in which to pick up objects

local S = technic.getter

technic.register_power_tool("technic:vacuum", vacuum_max_charge)

minetest.register_tool("technic:vacuum", {
	description = S("Vacuum Cleaner"),
	inventory_image = "technic_vacuum.png",
	stack_max = 1,
	wear_represents = "technic_RE_charge",
	on_refill = technic.refill_RE_charge,
	on_use = function(itemstack, user, pointed_thing)
		local meta = technic.get_stack_meta(itemstack)
		local charge = meta:get_int("technic:charge")
		if charge < vacuum_charge_per_object then
			return
		end
		minetest.sound_play("vacuumcleaner", {
			to_player = user:get_player_name(),
			gain = 0.4,
		})
		local pos = user:get_pos()
		local inv = user:get_inventory()
		for _, object in ipairs(minetest.get_objects_inside_radius(pos, vacuum_range)) do
			local luaentity = object:get_luaentity()
			if not object:is_player() and luaentity and luaentity.name == "__builtin:item" and luaentity.itemstring ~= "" then
				if inv and inv:room_for_item("main", ItemStack(luaentity.itemstring)) then
					charge = charge - vacuum_charge_per_object
					if charge < vacuum_charge_per_object then
						return
					end
					inv:add_item("main", ItemStack(luaentity.itemstring))
					minetest.sound_play("item_drop_pickup", {
						to_player = user:get_player_name(),
						gain = 0.4,
					})
					luaentity.itemstring = ""
					object:remove()
				end
			end
		end

		meta:set_int("technic:charge", charge)
		technic.set_RE_wear(itemstack, charge, vacuum_max_charge)
		return itemstack
	end,
})

minetest.register_craft({
	output = 'technic:vacuum',
	recipe = {
		{'pipeworks:tube_1',              'pipeworks:filter', 'technic:battery'},
		{'pipeworks:tube_1',              'basic_materials:motor',    'technic:battery'},
		{'technic:stainless_steel_ingot', '',                 ''},
	}
})
