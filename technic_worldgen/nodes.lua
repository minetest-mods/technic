
local S = technic.worldgen.gettext

minetest.register_node( ":technic:mineral_uranium", {
	description = S("Uranium Ore"),
	tiles = { "default_stone.png^technic_mineral_uranium.png" },
	is_ground_content = true,
	groups = {cracky=3, radioactive=1,pickaxey=5,material_stone=1},
	sounds = stone_sounds,
	drop = "technic:uranium_lump",
	_mcl_hardness =  5,
	_mcl_blast_resistance =  3,
	_mcl_silk_touch_drop = true,
	_mcl_fortune_drop = mcl_core.fortune_drop_ore
})

minetest.register_node( ":technic:mineral_chromium", {
	description = S("Chromium Ore"),
	tiles = { "default_stone.png^technic_mineral_chromium.png" },
	is_ground_content = true,
	groups = {cracky=3,pickaxey=3,material_stone=1},
	sounds = stone_sounds,
	drop = "technic:chromium_lump",
	_mcl_hardness =  3,
	_mcl_blast_resistance =  3,
	_mcl_silk_touch_drop = true,
	_mcl_fortune_drop = mcl_core.fortune_drop_ore
})

minetest.register_node( ":technic:mineral_zinc", {
	description = S("Zinc Ore"),
	tiles = { "default_stone.png^technic_mineral_zinc.png" },
	is_ground_content = true,
	groups = {cracky=3,pickaxey=2,material_stone=1},
	sounds = stone_sounds,
	drop = "technic:zinc_lump",
	_mcl_hardness =  2,
	_mcl_blast_resistance =  3,
	_mcl_silk_touch_drop = true,
	_mcl_fortune_drop = mcl_core.fortune_drop_ore
})

minetest.register_node( ":technic:mineral_lead", {
	description = S("Lead Ore"),
	tiles = { "default_stone.png^technic_mineral_lead.png" },
	is_ground_content = true,
	groups = {cracky=3,pickaxey=2,material_stone=1},
	sounds = stone_sounds,
	drop = "technic:lead_lump",
	_mcl_hardness =  2,
	_mcl_blast_resistance =  3,
	_mcl_silk_touch_drop = true,
	_mcl_fortune_drop = mcl_core.fortune_drop_ore
})

minetest.register_node( ":technic:mineral_sulfur", {
	description = S("Sulfur Ore"),
	tiles = { "default_stone.png^technic_mineral_sulfur.png" },
	is_ground_content = true,
	groups = {cracky=3,pickaxey=1,material_stone=1},
	sounds = stone_sounds,
	drop = "technic:sulfur_lump",
	_mcl_hardness =  1,
	_mcl_blast_resistance =  3,
	_mcl_silk_touch_drop = true,
	_mcl_fortune_drop = mcl_core.fortune_drop_ore
})

if minetest.get_modpath("default") then
minetest.register_node( ":technic:granite", {
	description = S("Granite"),
	tiles = { "technic_granite.png" },
	is_ground_content = true,
	groups = {cracky=1},
	sounds = stone_sounds,
})


minetest.register_node( ":technic:granite_bricks", {
	description = S("Granite Bricks"),
	tiles = { "technic_granite_bricks.png" },
	is_ground_content = false,
	groups = {cracky=1},
	sounds = stone_sounds,
})
end

minetest.register_node( ":technic:marble", {
	description = S("Marble"),
	tiles = { "technic_marble.png" },
	is_ground_content = true,
	groups = {cracky=3, marble=1,pickaxey=3},
	sounds = stone_sounds,
	_mcl_hardness =  3,
	_mcl_blast_resistance =  3,
	_mcl_silk_touch_drop = true,
	_mcl_fortune_drop = mcl_core.fortune_drop_ore
})

minetest.register_node( ":technic:marble_bricks", {
	description = S("Marble Bricks"),
	tiles = { "technic_marble_bricks.png" },
	is_ground_content = false,
	groups = {cracky=3,pickaxey=3},
	sounds = stone_sounds,
	_mcl_hardness =  3,
	_mcl_blast_resistance =  3,
	_mcl_silk_touch_drop = true,
	_mcl_fortune_drop = mcl_core.fortune_drop_ore
})

minetest.register_node(":technic:uranium_block", {
	description = S("Uranium Block"),
	tiles = { "technic_uranium_block.png" },
	is_ground_content = true,
	groups = {uranium_block=1, cracky=1, level=2, radioactive=2,pickaxey=5},
	sounds = stone_sounds,
	_mcl_hardness =  5,
	_mcl_blast_resistance =  3,
	_mcl_silk_touch_drop = true,
	_mcl_fortune_drop = mcl_core.fortune_drop_ore
})

minetest.register_node(":technic:chromium_block", {
	description = S("Chromium Block"),
	tiles = { "technic_chromium_block.png" },
	is_ground_content = true,
	groups = {cracky=1, level=2,pickaxey=4},
	sounds = stone_sounds,
	_mcl_hardness =  4,
	_mcl_blast_resistance =  3,
	_mcl_silk_touch_drop = true,
	_mcl_fortune_drop = mcl_core.fortune_drop_ore
})

minetest.register_node(":technic:zinc_block", {
	description = S("Zinc Block"),
	tiles = { "technic_zinc_block.png" },
	is_ground_content = true,
	groups = {cracky=1, level=2,pickaxey=3},
	sounds = stone_sounds,
	_mcl_hardness =  3,
	_mcl_blast_resistance =  3,
	_mcl_silk_touch_drop = true,
	_mcl_fortune_drop = mcl_core.fortune_drop_ore
})

minetest.register_node(":technic:lead_block", {
	description = S("Lead Block"),
	tiles = { "technic_lead_block.png" },
	is_ground_content = true,
	groups = {cracky=1, level=2,pickaxey=5},
	sounds = stone_sounds,
	_mcl_hardness =  5,
	_mcl_blast_resistance =  5,
	_mcl_silk_touch_drop = true,
	_mcl_fortune_drop = mcl_core.fortune_drop_ore,
})

if minetest.get_modpath("default") then
minetest.register_alias("technic:wrought_iron_block", "default:steelblock")

minetest.override_item("default:steelblock", {
	description = S("Wrought Iron Block"),
	tiles = { "technic_wrought_iron_block.png" },
})
end

minetest.register_node(":technic:cast_iron_block", {
	description = S("Cast Iron Block"),
	tiles = { "technic_cast_iron_block.png" },
	is_ground_content = true,
	groups = {cracky=1, level=2},
	sounds = stone_sounds,
	_mcl_hardness =  3,
	_mcl_blast_resistance =  3,
	_mcl_silk_touch_drop = true,
	_mcl_fortune_drop = mcl_core.fortune_drop_ore,
})

minetest.register_node(":technic:carbon_steel_block", {
	description = S("Carbon Steel Block"),
	tiles = { "technic_carbon_steel_block.png" },
	is_ground_content = true,
	groups = {cracky=1, level=2},
	sounds = stone_sounds,
	_mcl_hardness =  3,
	_mcl_blast_resistance =  3,
	_mcl_silk_touch_drop = true,
	_mcl_fortune_drop = mcl_core.fortune_drop_ore,
})

minetest.register_node(":technic:stainless_steel_block", {
	description = S("Stainless Steel Block"),
	tiles = { "technic_stainless_steel_block.png" },
	is_ground_content = true,
	groups = {cracky=1, level=2},
	sounds = stone_sounds,
	_mcl_hardness =  3,
	_mcl_blast_resistance =  3,
	_mcl_silk_touch_drop = true,
	_mcl_fortune_drop = mcl_core.fortune_drop_ore,
})

if minetest.get_modpath("default") then
minetest.register_craft({
	output = 'technic:granite_bricks 4',
	recipe = {
		{granite_ingrediant,granite_ingrediant},
		{granite_ingrediant,granite_ingrediant}
	}
})
end

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

if minetest.get_modpath("default") then

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

end