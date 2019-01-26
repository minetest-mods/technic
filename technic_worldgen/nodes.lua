
local S = technic.worldgen.gettext

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

local function for_each_registered_node(action)
	local really_register_node = minetest.register_node
	minetest.register_node = function(name, def)
		really_register_node(name, def)
		action(name:gsub("^:", ""), def)
	end
	for name, def in pairs(minetest.registered_nodes) do
		action(name, def)
	end
end

for_each_registered_node(function(node_name, node_def)
	if node_name ~= "default:steelblock" and
			node_name:find("steelblock", 1, true) and
			node_def.description:find("Steel", 1, true) then
		minetest.override_item(node_name, {
			description = node_def.description:gsub("Steel", S("Wrought Iron")),
		})
	end
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
end)

