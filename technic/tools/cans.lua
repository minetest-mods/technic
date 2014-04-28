local water_can_max_load = 16
local lava_can_max_load = 8

local S = technic.getter

minetest.register_craft({
	output = 'technic:water_can 1',
	recipe = {
		{'technic:zinc_ingot', 'technic:rubber','technic:zinc_ingot'},
		{'default:steel_ingot', '', 'default:steel_ingot'},
		{'technic:zinc_ingot', 'default:steel_ingot', 'technic:zinc_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:lava_can 1',
	recipe = {
		{'technic:zinc_ingot', 'technic:stainless_steel_ingot','technic:zinc_ingot'},
		{'technic:stainless_steel_ingot', '', 'technic:stainless_steel_ingot'},
		{'technic:zinc_ingot', 'technic:stainless_steel_ingot', 'technic:zinc_ingot'},
	}
})

local function set_can_wear(itemstack, level, max_level)
	local temp
	if level == 0 then
		temp = 0
	else
		temp = 65536 - math.floor(level / max_level * 65535)
		if temp > 65535 then temp = 65535 end
		if temp < 1 then temp = 1 end
	end
	itemstack:set_wear(temp)
end

minetest.register_tool("technic:water_can", {
	description = S("Water Can"),
	inventory_image = "technic_water_can.png",
	stack_max = 1,
	wear_represents = "content_level",
	liquids_pointable = true,
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type ~= "node" then
			return
		end
		node = minetest.get_node(pointed_thing.under)

		local charge = nil
		if itemstack:get_metadata() == "" then
			charge = 0
		else
			charge = tonumber(itemstack:get_metadata())
		end
		if node.name == "default:water_source" then
			if charge < water_can_max_load then
				minetest.remove_node(pointed_thing.under)
				charge = charge + 1
				itemstack:set_metadata(tostring(charge))
				set_can_wear(itemstack, charge, water_can_max_load)
			end
			return itemstack
		end
		if charge == 0 then
			return
		end

		if node.name == "default:water_flowing" then
			minetest.set_node(pointed_thing.under, {name="default:water_source"})
			charge = charge - 1
			itemstack:set_metadata(tostring(charge))
			set_can_wear(itemstack, charge, water_can_max_load)
			return itemstack
		end

		node = minetest.get_node(pointed_thing.above)
		if node.name == "air" then
			minetest.set_node(pointed_thing.above, {name="default:water_source"})
			charge = charge - 1;
			itemstack:set_metadata(tostring(charge))
			set_can_wear(itemstack, charge, water_can_max_load)
			return itemstack
		end		
	end,
})

minetest.register_tool("technic:lava_can", {
	description = S("Lava Can"),
	inventory_image = "technic_lava_can.png",
	stack_max = 1,
	wear_represents = "content_level",
	liquids_pointable = true,
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type ~= "node" then
			return
		end
		node = minetest.get_node(pointed_thing.under)
		local charge = 0
		if itemstack:get_metadata() == "" then
			charge = 0
		else
			charge = tonumber(itemstack:get_metadata())
		end

		if node.name == "default:lava_source" then
			if charge < lava_can_max_load then
				minetest.remove_node(pointed_thing.under)
				charge = charge + 1
				itemstack:set_metadata(tostring(charge))
				set_can_wear(itemstack, charge, lava_can_max_load)
			end
			return itemstack
		end
		if charge == 0 then
			return
		end

		if node.name == "default:lava_flowing" then
			minetest.set_node(pointed_thing.under, {name="default:lava_source"})
			charge = charge - 1	
			itemstack:set_metadata(tostring(charge))
			set_can_wear(itemstack, charge, lava_can_max_load)
			return itemstack
		end

		node = minetest.get_node(pointed_thing.above)
		if node.name == "air" then
			minetest.set_node(pointed_thing.above, {name="default:lava_source"})
			charge = charge - 1
			itemstack:set_metadata(tostring(charge))
			set_can_wear(itemstack, charge, lava_can_max_load)
			return itemstack
		end
	end,
})

