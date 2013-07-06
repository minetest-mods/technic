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

minetest.register_craftitem( ":group:brass_ingot", {
	description = "Brass Ingot",
	inventory_image = "technic_brass_ingot.png",
})

minetest.register_craft({
	output = "node technic:uranium_block",
	recipe = {{"technic:uranium", "technic:uranium", "technic:uranium"},
		  {"technic:uranium", "technic:uranium", "technic:uranium"},
		  {"technic:uranium", "technic:uranium", "technic:uranium"}}
})

minetest.register_craft({
	output = "craft technic:uranium 9",
	recipe = {{"technic:uranium_block"}}
})

minetest.register_craft({
	output = "node technic:chromium_block",
	recipe = {{"technic:chromium_ingot", "technic:chromium_ingot", "technic:chromium_ingot"},
		  {"technic:chromium_ingot", "technic:chromium_ingot", "technic:chromium_ingot"},
		  {"technic:chromium_ingot", "technic:chromium_ingot", "technic:chromium_ingot"}}
})

minetest.register_craft({
	output = "craft technic:chromium_ingot 9",
	recipe = {{"technic:chromium_block"}}
})

minetest.register_craft({
	output = "node technic:zinc_block",
	recipe = {{"technic:zinc_ingot", "technic:zinc_ingot", "technic:zinc_ingot"},
		  {"technic:zinc_ingot", "technic:zinc_ingot", "technic:zinc_ingot"},
		  {"technic:zinc_ingot", "technic:zinc_ingot", "technic:zinc_ingot"}}
})

minetest.register_craft({
	output = "craft technic:zinc_ingot 9",
	recipe = {{"technic:zinc_block"}}
})

minetest.register_craft({
	output = "node technic:stainless_steel_block",
	recipe = {{"technic:stainless_steel_ingot", "technic:stainless_steel_ingot", "technic:stainless_steel_ingot"},
		  {"technic:stainless_steel_ingot", "technic:stainless_steel_ingot", "technic:stainless_steel_ingot"},
		  {"technic:stainless_steel_ingot", "technic:stainless_steel_ingot", "technic:stainless_steel_ingot"}}
})

minetest.register_craft({
	output = "craft technic:stainless_steel_ingot 9",
	recipe = {{"technic:stainless_steel_block"}}
})

minetest.register_craft({
	output = "node group:brass_block",
	recipe = {{"group:brass_ingot", "group:brass_ingot", "group:brass_ingot"},
		  {"group:brass_ingot", "group:brass_ingot", "group:brass_ingot"},
		  {"group:brass_ingot", "group:brass_ingot", "group:brass_ingot"}}
})

minetest.register_craft({
	output = "craft group:brass_ingot 9",
	recipe = {{"group:brass_block"}}
})

minetest.register_craft({
	type = 'cooking',
	output = "technic:zinc_ingot",
	recipe = "technic:zinc_lump"
})

minetest.register_craft({
	type = 'cooking',
	output = "technic:chromium_ingot",
	recipe = "technic:chromium_lump"
})
