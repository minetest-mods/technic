
technic.recipes = {}
function technic.register_recipe_type(typename, desc)
	if unified_inventory and unified_inventory.register_craft_type then
		unified_inventory.register_craft_type(typename, {
			description = desc,
			height = 1,
			width = 1,
		})
	end
	technic.recipes[typename] = {}
end

function technic.register_recipe(typename, data)
	local src = ItemStack(data.input):get_name()
	technic.recipes[typename][src] = data
	if unified_inventory then
		unified_inventory.register_craft({
			type = typename,
			output = data.output,
			items = {data.input},
			width = 0,
		})
	end
end

function technic.get_recipe(typename, item)
	if typename == "cooking" then -- Already builtin in Minetest, so use that
		local result = minetest.get_craft_result({
			method = "cooking",
			width = 1,
			items = {item}})
		-- Compatibility layer
		if not result or result.time == 0 then
			return nil
		else
			return {time = result.time,
			        input = item:get_name(),
			        output = result.item:to_string()}
		end
	end
	local recipe = technic.recipes[typename][item:get_name()]
	if recipe and item:get_count() >= ItemStack(recipe.input):get_count() then
		return recipe
	else
		return nil
	end
end

-- Handle aliases
minetest.after(0.01, function ()
	for _, recipes_list in pairs(technic.recipes) do
		for ingredient, recipe in pairs(recipes_list) do
			ingredient = minetest.registered_aliases[ingredient]
			while ingredient do
				recipes_list[ingredient] = recipe
				ingredient = minetest.registered_aliases[ingredient]
			end
		end
	end
end)


