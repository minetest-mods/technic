
local S = technic.worldgen.gettext

local mineral_uranium_def = {
	description = S("Uranium Ore"),
	tiles = { "default_stone.png^technic_mineral_uranium.png" },
	is_ground_content = true,
	groups = {cracky=3, radioactive=1,pickaxey=5,material_stone=1},
	sounds = sounds.node_sound_stone_defaults(),
	drop = "technic:uranium_lump",
	_mcl_hardness =  5,
	_mcl_blast_resistance =  3,
	_mcl_silk_touch_drop = true,
	_mcl_fortune_drop = mcl_core.fortune_drop_ore
}

local mineral_chromium_def = {
	description = S("Chromium Ore"),
	tiles = { "default_stone.png^technic_mineral_chromium.png" },
	is_ground_content = true,
	groups = {cracky=3,pickaxey=3,material_stone=1},
	sounds = sounds.node_sound_stone_defaults(),
	drop = "technic:chromium_lump",
	_mcl_hardness =  3,
	_mcl_blast_resistance =  3,
	_mcl_silk_touch_drop = true,
	_mcl_fortune_drop = mcl_core.fortune_drop_ore
}

local mineral_zinc_def = {
	description = S("Zinc Ore"),
	tiles = { "default_stone.png^technic_mineral_zinc.png" },
	is_ground_content = true,
	groups = {cracky=3,pickaxey=2,material_stone=1},
	sounds = sounds.node_sound_stone_defaults(),
	drop = "technic:zinc_lump",
	_mcl_hardness =  2,
	_mcl_blast_resistance =  3,
	_mcl_silk_touch_drop = true,
	_mcl_fortune_drop = mcl_core.fortune_drop_ore
}

local mineral_lead_def = {
	description = S("Lead Ore"),
	tiles = { "default_stone.png^technic_mineral_lead.png" },
	is_ground_content = true,
	groups = {cracky=3,pickaxey=2,material_stone=1},
	sounds = sounds.node_sound_stone_defaults(),
	drop = "technic:lead_lump",
	_mcl_hardness =  2,
	_mcl_blast_resistance =  3,
	_mcl_silk_touch_drop = true,
	_mcl_fortune_drop = mcl_core.fortune_drop_ore
}

local mineral_sulfur_def = {
	description = S("Sulfur Ore"),
	tiles = { "default_stone.png^technic_mineral_sulfur.png" },
	is_ground_content = true,
	groups = {cracky=3,pickaxey=1,material_stone=1},
	sounds = sounds.node_sound_stone_defaults(),
	drop = "technic:sulfur_lump",
	_mcl_hardness =  1,
	_mcl_blast_resistance =  3,
	_mcl_silk_touch_drop = true,
	_mcl_fortune_drop = mcl_core.fortune_drop_ore
}

local marble_def = {
	description = S("Marble"),
	tiles = { "technic_marble.png" },
	is_ground_content = true,
	groups = {cracky=3, marble=1,pickaxey=3},
	sounds = sounds.node_sound_stone_defaults(),
	_mcl_hardness =  3,
	_mcl_blast_resistance =  3,
	_mcl_silk_touch_drop = true
}

local marble_bricks_def = {
	description = S("Marble Bricks"),
	tiles = { "technic_marble_bricks.png" },
	is_ground_content = false,
	groups = {cracky=3,pickaxey=3},
	sounds = sounds.node_sound_stone_defaults(),
	_mcl_hardness =  3,
	_mcl_blast_resistance =  3,
	_mcl_silk_touch_drop = true
}

local uranium_block_def = {
	description = S("Uranium Block"),
	tiles = { "technic_uranium_block.png" },
	is_ground_content = true,
	groups = {uranium_block=1, cracky=1, level=2, radioactive=2,pickaxey=5},
	sounds = sounds.node_sound_stone_defaults(),
	_mcl_hardness =  5,
	_mcl_blast_resistance =  3,
	_mcl_silk_touch_drop = true
}

local chromium_block_def = {
	description = S("Chromium Block"),
	tiles = { "technic_chromium_block.png" },
	is_ground_content = true,
	groups = {cracky=1, level=2,pickaxey=4},
	sounds = sounds.node_sound_stone_defaults(),
	_mcl_hardness =  4,
	_mcl_blast_resistance =  3,
	_mcl_silk_touch_drop = true
}

local zinc_block_def = {
	description = S("Zinc Block"),
	tiles = { "technic_zinc_block.png" },
	is_ground_content = true,
	groups = {cracky=1, level=2,pickaxey=3},
	sounds = sounds.node_sound_stone_defaults(),
	_mcl_hardness =  3,
	_mcl_blast_resistance =  3,
	_mcl_silk_touch_drop = true
}

local lead_block_def = {
	description = S("Lead Block"),
	tiles = { "technic_lead_block.png" },
	is_ground_content = true,
	groups = {cracky=1, level=2,pickaxey=5},
	sounds = sounds.node_sound_stone_defaults(),
	_mcl_hardness =  5,
	_mcl_blast_resistance =  5,
	_mcl_silk_touch_drop = true
}

local cast_iron_block_def = {
	description = S("Cast Iron Block"),
	tiles = { "technic_cast_iron_block.png" },
	is_ground_content = true,
	groups = {cracky=1, level=2},
	sounds = sounds.node_sound_stone_defaults(),
	_mcl_hardness =  3,
	_mcl_blast_resistance =  3,
	_mcl_silk_touch_drop = true
}

local carbon_steel_block_def = {
	description = S("Carbon Steel Block"),
	tiles = { "technic_carbon_steel_block.png" },
	is_ground_content = true,
	groups = {cracky=1, level=2},
	sounds = sounds.node_sound_stone_defaults(),
	_mcl_hardness =  3,
	_mcl_blast_resistance =  3,
	_mcl_silk_touch_drop = true
}

local stainless_steel_block_def = {
	description = S("Stainless Steel Block"),
	tiles = { "technic_stainless_steel_block.png" },
	is_ground_content = true,
	groups = {cracky=1, level=2},
	sounds = sounds.node_sound_stone_defaults(),
	_mcl_hardness =  3,
	_mcl_blast_resistance =  3,
	_mcl_silk_touch_drop = true
}



minetest.register_node( ":technic:mineral_uranium", mineral_uranium_def)

minetest.register_node( ":technic:mineral_chromium", mineral_chromium_def)

minetest.register_node( ":technic:mineral_zinc", mineral_zinc_def)

minetest.register_node( ":technic:mineral_lead", mineral_lead_def)

minetest.register_node( ":technic:mineral_sulfur", mineral_sulfur_def)

if minetest.get_modpath("default") then
	minetest.register_node( ":technic:granite", {
		description = S("Granite"),
		tiles = { "technic_granite.png" },
		is_ground_content = true,
		groups = {cracky=1},
		sounds = sounds.node_sound_stone_defaults(),
	})


	minetest.register_node( ":technic:granite_bricks", {
		description = S("Granite Bricks"),
		tiles = { "technic_granite_bricks.png" },
		is_ground_content = false,
		groups = {cracky=1},
		sounds = sounds.node_sound_stone_defaults(),
	})
end

minetest.register_node( ":technic:marble", marble_def)

minetest.register_node( ":technic:marble_bricks", marble_bricks_def)

minetest.register_node(":technic:uranium_block", uranium_block_def)

minetest.register_node(":technic:chromium_block", chromium_block_def)

minetest.register_node(":technic:zinc_block", zinc_block_def)

minetest.register_node(":technic:lead_block", lead_block_def)

if minetest.get_modpath("default") then
	minetest.register_alias("technic:wrought_iron_block", "default:steelblock")

	minetest.override_item("default:steelblock", {
		description = S("Wrought Iron Block"),
		tiles = { "technic_wrought_iron_block.png" },
	})
end

minetest.register_node(":technic:cast_iron_block", cast_iron_block_def)

minetest.register_node(":technic:carbon_steel_block", carbon_steel_block_def)

minetest.register_node(":technic:stainless_steel_block", stainless_steel_block_def)

if minetest.get_modpath("default") then
	minetest.register_craft({
		output = 'technic:granite_bricks 4',
		recipe = {
			{granite_ingredient,granite_ingredient},
			{granite_ingredient,granite_ingredient}
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