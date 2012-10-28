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

stairsplus.register_stair_and_slab_and_panel_and_micro("marble", "technic:marble",
		{cracky=3},
		{"technic_marble.png"},
		"Marble Stairs",
		"Marble Slab",
		"Marble Panel",
		"Marble Microblock",
		"marble")
stairsplus.register_stair_and_slab_and_panel_and_micro("marble_bricks", "technic:marble_bricks",
		{cracky=3},
		{"technic_marble_bricks.png"},
		"Marble Bricks Stairs",
		"Marble Bricks Slab",
		"Marble Bricks Panel",
		"Marble Bricks Microblock",
		"marble_bricks")
stairsplus.register_stair_and_slab_and_panel_and_micro("granite", "technic:granite",
		{cracky=3},
		{"technic_granite.png"},
		"Granite Stairs",
		"Granite Slab",
		"Granite Panel",
		"Granite Microblock",
		"granite")

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


local function generate_ore(name, wherein, minp, maxp, seed, chunks_per_volume, ore_per_chunk, height_min, height_max)
	if maxp.y < height_min or minp.y > height_max then
		return
	end
	local y_min = math.max(minp.y, height_min)
	local y_max = math.min(maxp.y, height_max)
	local volume = (maxp.x-minp.x+1)*(y_max-y_min+1)*(maxp.z-minp.z+1)
	local pr = PseudoRandom(seed)
	local num_chunks = math.floor(chunks_per_volume * volume)
	local chunk_size = 3
	if ore_per_chunk <= 4 then
		chunk_size = 2
	end
	local inverse_chance = math.floor(chunk_size*chunk_size*chunk_size / ore_per_chunk)
	--print("generate_ore num_chunks: "..dump(num_chunks))
	for i=1,num_chunks do
	if (y_max-chunk_size+1 <= y_min) then return end
		local y0 = pr:next(y_min, y_max-chunk_size+1)
		if y0 >= height_min and y0 <= height_max then
			local x0 = pr:next(minp.x, maxp.x-chunk_size+1)
			local z0 = pr:next(minp.z, maxp.z-chunk_size+1)
			local p0 = {x=x0, y=y0, z=z0}
			for x1=0,chunk_size-1 do
			for y1=0,chunk_size-1 do
			for z1=0,chunk_size-1 do
				if pr:next(1,inverse_chance) == 1 then
					local x2 = x0+x1
					local y2 = y0+y1
					local z2 = z0+z1
					local p2 = {x=x2, y=y2, z=z2}
					if minetest.env:get_node(p2).name == wherein then
						minetest.env:set_node(p2, {name=name})
					end
				end
			end
			end
			end
		end
	end
	--print("generate_ore done")
end

minetest.register_on_generated(function(minp, maxp, seed)
generate_ore("technic:mineral_diamond", "default:stone", minp, maxp, seed+21,   1/11/11/11,    4, -31000,  -450)
generate_ore("technic:mineral_uranium", "default:stone", minp, maxp, seed+22,   1/10/10/10,    3, -300,  -80)
generate_ore("technic:mineral_chromium", "default:stone", minp, maxp, seed+23,   1/10/10/10,    2, -31000,  -100)
generate_ore("technic:mineral_zinc", "default:stone", minp, maxp, seed+24,   1/9/9/9,    4, -31000,  2)
generate_ore("technic:marble", "default:stone", minp, maxp, seed+25,	1/128, 20, -100, -32)
generate_ore("technic:granite", "default:stone", minp, maxp, seed+25,	1/128, 15, -190, -90)
end)