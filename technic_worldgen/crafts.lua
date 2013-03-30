minetest.register_craftitem( ":technic:uranium", {
	description = "Uranium",
	inventory_image = "technic_uranium.png",
	on_place_on_ground = minetest.craftitem_place_item,
})

minetest.register_craftitem( ":technic:chromium_lump", {
	description = "Chromium Lump",
	inventory_image = "technic_chromium_lump.png",
	on_place_on_ground = minetest.craftitem_place_item,
})

minetest.register_craftitem( ":technic:chromium_ingot", {
	description = "Chromium Ingot",
	inventory_image = "technic_chromium_ingot.png",
	on_place_on_ground = minetest.craftitem_place_item,
})

minetest.register_craft({
	type = 'cooking',
	output = "technic:chromium_ingot",
	recipe = "technic:chromium_lump"
})

minetest.register_craftitem( ":technic:zinc_lump", {
	description = "Zinc Lump",
	inventory_image = "technic_zinc_lump.png",
})

minetest.register_craftitem( ":technic:zinc_ingot", {
	description = "Zinc Ingot",
	inventory_image = "technic_zinc_ingot.png",
})

minetest.register_craftitem( ":technic:stainless_steel_ingot", {
	description = "Stainless Steel Ingot",
	inventory_image = "technic_stainless_steel_ingot.png",
})

minetest.register_craftitem( ":technic:brass_ingot", {
	description = "Brass Ingot",
	inventory_image = "technic_brass_ingot.png",
})

minetest.register_craft({
	type = 'cooking',
	output = "technic:zinc_ingot",
	recipe = "technic:zinc_lump"
})
