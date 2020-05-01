local cast_iron_ingot
if minetest.get_modpath("technic_worldgen") then
	cast_iron_ingot = "technic:cast_iron_ingot"
else
	cast_iron_ingot = "default:steel_ingot"
end

minetest.register_craft({
	output = 'technic:iron_chest 1',
	recipe = {
		{cast_iron_ingot,cast_iron_ingot,cast_iron_ingot},
		{cast_iron_ingot,'default:chest',cast_iron_ingot},
		{cast_iron_ingot,cast_iron_ingot,cast_iron_ingot},
	}
})

minetest.register_craft({
	output = 'technic:iron_locked_chest 1',
	recipe = {
		{cast_iron_ingot,cast_iron_ingot,cast_iron_ingot},
		{cast_iron_ingot,'default:chest_locked',cast_iron_ingot},
		{cast_iron_ingot,cast_iron_ingot,cast_iron_ingot},
	}
})

minetest.register_craft({
	output = 'technic:iron_locked_chest 1',
	type = "shapeless",
	recipe = {
		'basic_materials:padlock',
		'technic:iron_chest',
	}
})

technic.chests:register("Iron", {
	width = 9,
	height = 5,
	sort = true,
	autosort = false,
	infotext = false,
	color = false,
	locked = false,
})

technic.chests:register("Iron", {
	width = 9,
	height = 5,
	sort = true,
	autosort = false,
	infotext = false,
	color = false,
	locked = true,
})

