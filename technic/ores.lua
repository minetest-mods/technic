minetest.register_node( "technic:marble", {
	description = "Marble",
	tiles = { "technic_marble.png" },
	is_ground_content = true,
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
}) 

minetest.register_node( "technic:marble_bricks", {
	description = "Marble Bricks",
	tiles = { "technic_marble_bricks.png" },
	is_ground_content = true,
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
}) 

minetest.register_craft({
	output = 'technic:marble_bricks 4',
	recipe = {
		{'technic:marble','technic:marble'},
		{'technic:marble','technic:marble'}
	}
})

minetest.register_node( "technic:granite", {
	description = "Granite",
	tiles = { "technic_granite.png" },
	is_ground_content = true,
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
}) 

-- cross-compatibility with default obsidian

function register_technic_stairs_alias(modname, origname, newmod, newname)
	minetest.register_alias(modname .. ":slab_" .. origname, newmod..":slab_" .. newname)
	minetest.register_alias(modname .. ":slab_" .. origname .. "_inverted", newmod..":slab_" .. newname .. "_inverted")
	minetest.register_alias(modname .. ":slab_" .. origname .. "_wall", newmod..":slab_" .. newname .. "_wall")
	minetest.register_alias(modname .. ":slab_" .. origname .. "_quarter", newmod..":slab_" .. newname .. "_quarter")
	minetest.register_alias(modname .. ":slab_" .. origname .. "_quarter_inverted", newmod..":slab_" .. newname .. "_quarter_inverted")
	minetest.register_alias(modname .. ":slab_" .. origname .. "_quarter_wall", newmod..":slab_" .. newname .. "_quarter_wall")
	minetest.register_alias(modname .. ":slab_" .. origname .. "_three_quarter", newmod..":slab_" .. newname .. "_three_quarter")
	minetest.register_alias(modname .. ":slab_" .. origname .. "_three_quarter_inverted", newmod..":slab_" .. newname .. "_three_quarter_inverted")
	minetest.register_alias(modname .. ":slab_" .. origname .. "_three_quarter_wall", newmod..":slab_" .. newname .. "_three_quarter_wall")
	minetest.register_alias(modname .. ":stair_" .. origname, newmod..":stair_" .. newname)
	minetest.register_alias(modname .. ":stair_" .. origname .. "_inverted", newmod..":stair_" .. newname .. "_inverted")
	minetest.register_alias(modname .. ":stair_" .. origname .. "_wall", newmod..":stair_" .. newname .. "_wall")
	minetest.register_alias(modname .. ":stair_" .. origname .. "_wall_half", newmod..":stair_" .. newname .. "_wall_half")
	minetest.register_alias(modname .. ":stair_" .. origname .. "_wall_half_inverted", newmod..":stair_" .. newname .. "_wall_half_inverted")
	minetest.register_alias(modname .. ":stair_" .. origname .. "_half", newmod..":stair_" .. newname .. "_half")
	minetest.register_alias(modname .. ":stair_" .. origname .. "_half_inverted", newmod..":stair_" .. newname .. "_half_inverted")
	minetest.register_alias(modname .. ":stair_" .. origname .. "_right_half", newmod..":stair_" .. newname .. "_right_half")
	minetest.register_alias(modname .. ":stair_" .. origname .. "_right_half_inverted", newmod..":stair_" .. newname .. "_right_half_inverted")
	minetest.register_alias(modname .. ":stair_" .. origname .. "_wall_half", newmod..":stair_" .. newname .. "_wall_half")
	minetest.register_alias(modname .. ":stair_" .. origname .. "_wall_half_inverted", newmod..":stair_" .. newname .. "_wall_half_inverted")
	minetest.register_alias(modname .. ":stair_" .. origname .. "_inner", newmod..":stair_" .. newname .. "_inner")
	minetest.register_alias(modname .. ":stair_" .. origname .. "_inner_inverted", newmod..":stair_" .. newname .. "_inner_inverted")
	minetest.register_alias(modname .. ":stair_" .. origname .. "_outer", newmod..":stair_" .. newname .. "_outer")
	minetest.register_alias(modname .. ":stair_" .. origname .. "_outer_inverted", newmod..":stair_" .. newname .. "_outer_inverted")
	minetest.register_alias(modname .. ":panel_" .. origname .. "_bottom", newmod..":panel_" .. newname .. "_bottom")
	minetest.register_alias(modname .. ":panel_" .. origname .. "_top", newmod..":panel_" .. newname .. "_top")
	minetest.register_alias(modname .. ":panel_" .. origname .. "_vertical", newmod..":panel_" .. newname .. "_vertical")
	minetest.register_alias(modname .. ":micro_" .. origname .. "_bottom", newmod..":micro_" .. newname .. "_bottom")
	minetest.register_alias(modname .. ":micro_" .. origname .. "_top", newmod..":micro_" .. newname .. "_top")
end


minetest.register_alias("technic:obsidian", "default:obsidian")
minetest.register_alias("moreblocks:obsidian", "default:obsidian")

register_stair_slab_panel_micro(
	":default",
	"obsidian",
	"default:obsidian",
	{cracky=3, not_in_creative_inventory=1},
	{"default_obsidian.png"},
	"Obsidian",
	"default:obsidian",
	"none",
	light
)

register_technic_stairs_alias("moreblocks", "obsidian", "default", "obsidian")
table.insert(circular_saw.known_stairs, "default:obsidian")

-- other stairs/slabs

if type(register_stair_and_slab_and_panel_and_micro) == "function" then
register_stair_and_slab_and_panel_and_micro(":stairsplus", "marble", "technic:marble",
		{cracky=3, not_in_creative_inventory=1},
		{"technic_marble.png"},
		"Marble Stairs",
		"Marble Slab",
		"Marble Panel",
		"Marble Microblock",
		"marble")
register_stair_and_slab_and_panel_and_micro(":stairsplus", "marble_bricks", "technic:marble_bricks",
		{cracky=3, not_in_creative_inventory=1},
		{"technic_marble_bricks.png"},
		"Marble Bricks Stairs",
		"Marble Bricks Slab",
		"Marble Bricks Panel",
		"Marble Bricks Microblock",
		"marble_bricks")
register_stair_and_slab_and_panel_and_micro(":stairsplus", "granite", "technic:granite",
		{cracky=3, not_in_creative_inventory=1},
		{"technic_granite.png"},
		"Granite Stairs",
		"Granite Slab",
		"Granite Panel",
		"Granite Microblock",
		"granite")
register_stair_and_slab_and_panel_and_micro(":stairsplus", "obsidian", "default:obsidian",
		{cracky=3, not_in_creative_inventory=1},
		{"default_obsidian.png"},
		"Obsidian Stairs",
		"Obsidian Slab",
		"Obsidian Panel",
		"Obsidian Microblock",
		"obsidian")
end

if type(register_stair_slab_panel_micro) == "function" then
register_stair_slab_panel_micro(":stairsplus", "marble", "technic:marble",
		{cracky=3, not_in_creative_inventory=1},
		{"technic_marble.png"},
		"Marble Stairs",
		"Marble Slab",
		"Marble Panel",
		"Marble Microblock",
		"marble")
register_stair_slab_panel_micro(":stairsplus", "marble_bricks", "technic:marble_bricks",
		{cracky=3, not_in_creative_inventory=1},
		{"technic_marble_bricks.png"},
		"Marble Bricks Stairs",
		"Marble Bricks Slab",
		"Marble Bricks Panel",
		"Marble Bricks Microblock",
		"marble_bricks")
register_stair_slab_panel_micro(":stairsplus", "granite", "technic:granite",
		{cracky=3, not_in_creative_inventory=1},
		{"technic_granite.png"},
		"Granite Stairs",
		"Granite Slab",
		"Granite Panel",
		"Granite Microblock",
		"granite")
register_stair_slab_panel_micro(":stairsplus", "obsidian", "technic:obsidian",
		{cracky=3, not_in_creative_inventory=1},
		{"technic_obsidian.png"},
		"Obsidian Stairs",
		"Obsidian Slab",
		"Obsidian Panel",
		"Obsidian Microblock",
		"obsidian")
end

minetest.register_node( "technic:mineral_diamond", {
	description = "Diamond Ore",
	tiles = { "default_stone.png^technic_mineral_diamond.png" },
	is_ground_content = true,
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
	drop = 'craft "technic:diamond" 1',
}) 

minetest.register_craftitem( "technic:diamond", {
	description = "Diamond",
	inventory_image = "technic_diamond.png",
	on_place_on_ground = minetest.craftitem_place_item,
})

minetest.register_node( "technic:mineral_uranium", {
	description = "Uranium Ore",
	tiles = { "default_stone.png^technic_mineral_uranium.png" },
	is_ground_content = true,
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
	drop = 'craft "technic:uranium" 1',
}) 

minetest.register_craftitem( "technic:uranium", {
	description = "Uranium",
	inventory_image = "technic_uranium.png",
	on_place_on_ground = minetest.craftitem_place_item,
})

minetest.register_node( "technic:mineral_chromium", {
	description = "Chromium Ore",
	tiles = { "default_stone.png^technic_mineral_chromium.png" },
	is_ground_content = true,
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
	drop = 'craft "technic:chromium_lump" 1',
}) 

minetest.register_craftitem( "technic:chromium_lump", {
	description = "Chromium Lump",
	inventory_image = "technic_chromium_lump.png",
	on_place_on_ground = minetest.craftitem_place_item,
})

minetest.register_craftitem( "technic:chromium_ingot", {
	description = "Chromium Ingot",
	inventory_image = "technic_chromium_ingot.png",
	on_place_on_ground = minetest.craftitem_place_item,
})

minetest.register_craft({
				type = 'cooking',
				output = "technic:chromium_ingot",
				recipe = "technic:chromium_lump"
			})


minetest.register_node( "technic:mineral_zinc", {
	description = "Zinc Ore",
	tile_images = { "default_stone.png^technic_mineral_zinc.png" },
	is_ground_content = true,
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
	drop = 'craft "technic:zinc_lump" 1',
})

minetest.register_craftitem( "technic:zinc_lump", {
	description = "Zinc Lump",
	inventory_image = "technic_zinc_lump.png",
})

minetest.register_craftitem( "technic:zinc_ingot", {
	description = "Zinc Ingot",
	inventory_image = "technic_zinc_ingot.png",
})

minetest.register_craftitem( "technic:stainless_steel_ingot", {
	description = "Stainless Steel Ingot",
	inventory_image = "technic_stainless_steel_ingot.png",
})

minetest.register_craftitem( "technic:brass_ingot", {
	description = "Brass Ingot",
	inventory_image = "technic_brass_ingot.png",
})

minetest.register_craft({
				type = 'cooking',
				output = "technic:zinc_ingot",
				recipe = "technic:zinc_lump"
			})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "technic:mineral_diamond",
	wherein        = "default:stone",
	clust_scarcity = 11*11*11,
	clust_num_ores = 4,
	clust_size     = 3,
	height_min     = -31000,
	height_max     = -450,
})
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "technic:mineral_uranium",
	wherein        = "default:stone",
	clust_scarcity = 10*10*10,
	clust_num_ores = 4,
	clust_size     = 3,
	height_min     = -300,
	height_max     = -80,
})
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "technic:mineral_chromium",
	wherein        = "default:stone",
	clust_scarcity = 10*10*10,
	clust_num_ores = 2,
	clust_size     = 3,
	height_min     = -31000,
	height_max     = -100,
})
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "technic:mineral_zinc",
	wherein        = "default:stone",
	clust_scarcity = 9*9*9,
	clust_num_ores = 4,
	clust_size     = 3,
	height_min     = -31000,
	height_max     = 2,
})
minetest.register_ore({
	ore_type       = "sheet",
	ore            = "technic:marble",
	wherein        = "default:stone",
	clust_scarcity = 1,
	clust_num_ores = 1,
	clust_size     = 3,
	height_min     = -150,
	height_max     = -50,
	noise_threshhold = 0.5,
	noise_params = {offset=0, scale=15, spread={x=150, y=150, z=150}, seed=23, octaves=3, persist=0.70}
})
minetest.register_ore({
	ore_type       = "sheet",
	ore            = "technic:granite",
	wherein        = "default:stone",
	clust_scarcity = 1,
	clust_num_ores = 1,
	clust_size     = 4,
	height_min     = -100,
	height_max     = -250,
	noise_threshhold = 0.5,
	noise_params = {offset=0, scale=15, spread={x=130, y=130, z=130}, seed=24, octaves=3, persist=0.70}
})
