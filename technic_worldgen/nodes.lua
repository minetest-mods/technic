
local S = minetest.get_translator("technic_worldgen")

minetest.register_node( ":technic:mineral_uranium", {
	description = S("Uranium Ore"),
	tiles = { "default_stone.png^technic_mineral_uranium.png" },
	is_ground_content = true,
	groups = {cracky=3, radioactive=1},
	sounds = default.node_sound_stone_defaults(),
	drop = "technic:uranium_lump",
})

minetest.register_node( ":technic:mineral_chromium", {
	description = S("Chromium Ore"),
	tiles = { "default_stone.png^technic_mineral_chromium.png" },
	is_ground_content = true,
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
	drop = "technic:chromium_lump",
})

minetest.register_node( ":technic:mineral_zinc", {
	description = S("Zinc Ore"),
	tiles = { "default_stone.png^technic_mineral_zinc.png" },
	is_ground_content = true,
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
	drop = "technic:zinc_lump",
})

minetest.register_node( ":technic:mineral_lead", {
	description = S("Lead Ore"),
	tiles = { "default_stone.png^technic_mineral_lead.png" },
	is_ground_content = true,
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
	drop = "technic:lead_lump",
})

minetest.register_node( ":technic:mineral_sulfur", {
	description = S("Sulfur Ore"),
	tiles = { "default_stone.png^technic_mineral_sulfur.png" },
	is_ground_content = true,
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
	drop = "technic:sulfur_lump",
})

minetest.register_node( ":technic:granite", {
	description = S("Granite"),
	tiles = { "technic_granite.png" },
	is_ground_content = true,
	groups = {cracky=1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node( ":technic:marble", {
	description = S("Marble"),
	tiles = { "technic_marble.png" },
	is_ground_content = true,
	groups = {cracky=3, marble=1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node( ":technic:marble_bricks", {
	description = S("Marble Bricks"),
	tiles = { "technic_marble_bricks.png" },
	is_ground_content = true,
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node(":technic:uranium_block", {
	description = S("Uranium Block"),
	tiles = { "technic_uranium_block.png" },
	is_ground_content = true,
	groups = {uranium_block=1, cracky=1, level=2, radioactive=2},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node(":technic:chromium_block", {
	description = S("Chromium Block"),
	tiles = { "technic_chromium_block.png" },
	is_ground_content = true,
	groups = {cracky=1, level=2},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node(":technic:zinc_block", {
	description = S("Zinc Block"),
	tiles = { "technic_zinc_block.png" },
	is_ground_content = true,
	groups = {cracky=1, level=2},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node(":technic:lead_block", {
	description = S("Lead Block"),
	tiles = { "technic_lead_block.png" },
	is_ground_content = true,
	groups = {cracky=1, level=2},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_alias("technic:wrought_iron_block", "default:steelblock")

minetest.override_item("default:steelblock", {
	description = S("Wrought Iron Block"),
	tiles = { "technic_wrought_iron_block.png" },
})

minetest.register_node(":technic:cast_iron_block", {
	description = S("Cast Iron Block"),
	tiles = { "technic_cast_iron_block.png" },
	is_ground_content = true,
	groups = {cracky=1, level=2},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node(":technic:carbon_steel_block", {
	description = S("Carbon Steel Block"),
	tiles = { "technic_carbon_steel_block.png" },
	is_ground_content = true,
	groups = {cracky=1, level=2},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node(":technic:stainless_steel_block", {
	description = S("Stainless Steel Block"),
	tiles = { "technic_stainless_steel_block.png" },
	is_ground_content = true,
	groups = {cracky=1, level=2},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_craft({
	output = 'technic:marble_bricks 4',
	recipe = {
		{'technic:marble','technic:marble'},
		{'technic:marble','technic:marble'}
	}
})

minetest.register_alias("technic:diamond_block", "default:diamondblock")
minetest.register_alias("technic:diamond", "default:diamond")
minetest.register_alias("technic:mineral_diamond", "default:stone_with_diamond")

local steel_to_wrought_iron = {
	{name="stairs:stair_outer_steelblock", description=S("Outer Wrought Iron Block Stair")},
	{name="stairs:stair_inner_steelblock", description=S("Inner Wrought Iron Block Stair")},
	{name="stairs:stair_steelblock", description=S("Wrought Iron Block Stair")},
	{name="stairs:slab_steelblock", description=S("Wrought Iron Block Slab")}
}

for _, v in ipairs(steel_to_wrought_iron) do
	local node_name = v.name
	local node_def = minetest.registered_items[node_name]
	if node_def then
		minetest.override_item(node_name, {
			description = v.description
		})

		local tiles = node_def.tiles or node_def.tile_images
		if tiles then
			local new_tiles = {}
			local do_override = false
			if type(tiles) == "string" then
				tiles = {tiles}
			end
			for i, t in ipairs(tiles) do
				if type(t) == "string" and t == "default_steel_block.png" then
					do_override = true
					t = "technic_wrought_iron_block.png"
				end
				table.insert(new_tiles, t)
			end
			if do_override then
				minetest.override_item(node_name, {
					tiles = new_tiles
				})
			end
		end
	end
end

