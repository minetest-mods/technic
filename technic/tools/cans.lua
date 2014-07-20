local S = technic.getter

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

function technic.register_can(d)
	local data = {}
	for k, v in pairs(d) do data[k] = v end
	minetest.register_tool(data.can_name, {
		description = data.can_description,
		inventory_image = data.can_inventory_image,
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
			if node.name == data.liquid_source_name then
				if charge < data.can_capacity then
					minetest.remove_node(pointed_thing.under)
					charge = charge + 1
					itemstack:set_metadata(tostring(charge))
					set_can_wear(itemstack, charge, data.can_capacity)
				end
				return itemstack
			end
			if charge == 0 then
				return
			end

			if node.name == data.liquid_flowing_name then
				minetest.set_node(pointed_thing.under, {name=data.liquid_source_name})
				charge = charge - 1
				itemstack:set_metadata(tostring(charge))
				set_can_wear(itemstack, charge, data.can_capacity)
				return itemstack
			end

			node = minetest.get_node(pointed_thing.above)
			if node.name == "air" then
				minetest.set_node(pointed_thing.above, {name=data.liquid_source_name})
				charge = charge - 1
				itemstack:set_metadata(tostring(charge))
				set_can_wear(itemstack, charge, data.can_capacity)
				return itemstack
			end		
		end,
		on_refill = function(stack)
			stack:set_metadata(tostring(data.can_capacity))
			set_can_wear(stack, data.can_capacity, data.can_capacity)
			return stack
		end,
	})
end

technic.register_can({
	can_name = "technic:water_can",
	can_description = S("Water Can"),
	can_inventory_image = "technic_water_can.png",
	can_capacity = 16,
	liquid_source_name = "default:water_source",
	liquid_flowing_name = "default:water_flowing",
})

minetest.register_craft({
	output = 'technic:water_can 1',
	recipe = {
		{'technic:zinc_ingot', 'technic:rubber','technic:zinc_ingot'},
		{'technic:carbon_steel_ingot', '', 'technic:carbon_steel_ingot'},
		{'technic:zinc_ingot', 'technic:carbon_steel_ingot', 'technic:zinc_ingot'},
	}
})

technic.register_can({
	can_name = "technic:lava_can",
	can_description = S("Lava Can"),
	can_inventory_image = "technic_lava_can.png",
	can_capacity = 8,
	liquid_source_name = "default:lava_source",
	liquid_flowing_name = "default:lava_flowing",
})

minetest.register_craft({
	output = 'technic:lava_can 1',
	recipe = {
		{'technic:zinc_ingot', 'technic:stainless_steel_ingot','technic:zinc_ingot'},
		{'technic:stainless_steel_ingot', '', 'technic:stainless_steel_ingot'},
		{'technic:zinc_ingot', 'technic:stainless_steel_ingot', 'technic:zinc_ingot'},
	}
})
