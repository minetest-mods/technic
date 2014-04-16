
local S = technic.worldgen.gettext

minetest.register_craftitem(":technic:uranium", {
	description = S("Uranium"),
	inventory_image = "technic_uranium.png",
	on_place_on_ground = minetest.craftitem_place_item,
})

minetest.register_craftitem(":technic:chromium_lump", {
	description = S("Chromium Lump"),
	inventory_image = "technic_chromium_lump.png",
	on_place_on_ground = minetest.craftitem_place_item,
})

minetest.register_craftitem(":technic:chromium_ingot", {
	description = S("Chromium Ingot"),
	inventory_image = "technic_chromium_ingot.png",
	on_place_on_ground = minetest.craftitem_place_item,
})

minetest.register_craftitem(":technic:zinc_lump", {
	description = S("Zinc Lump"),
	inventory_image = "technic_zinc_lump.png",
})

minetest.register_craftitem(":technic:zinc_ingot", {
	description = S("Zinc Ingot"),
	inventory_image = "technic_zinc_ingot.png",
})

minetest.register_craftitem(":technic:brass_ingot", {
	description = S("Brass Ingot"),
	inventory_image = "technic_brass_ingot.png",
})

minetest.register_craftitem(":technic:stainless_steel_ingot", {
	description = S("Stainless Steel Ingot"),
	inventory_image = "technic_stainless_steel_ingot.png",
})

local function register_block(block, ingot)
	minetest.register_craft({
		output = block,
		recipe = {
			{ingot, ingot, ingot},
			{ingot, ingot, ingot},
			{ingot, ingot, ingot},
		}
	})

	minetest.register_craft({
		output = ingot.." 9",
		recipe = {
			{block}
		}
	})
end

register_block("technic:uranium_block", "technic:uranium")
register_block("technic:chromium_block", "technic:chromium_ingot")
register_block("technic:zinc_block", "technic:zinc_ingot")
register_block("technic:brass_block", "technic:brass_ingot")
register_block("technic:stainless_steel_block", "technic:stainless_steel_ingot")

minetest.register_craft({
	type = 'cooking',
	recipe = "technic:zinc_lump",
	output = "technic:zinc_ingot",
})

minetest.register_craft({
	type = 'cooking',
	recipe = "technic:chromium_lump",
	output = "technic:chromium_ingot",
})

