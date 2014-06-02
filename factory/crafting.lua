minetest.register_craft({
	output = "factory:belt 12",
	recipe = {
		{"", "default:gold_ingot", ""},
		{"default:obsidian", "factory:small_steel_gear", "default:obsidian"},
		{"default:steelblock", "default:steelblock", "default:steelblock"}
	}
})

minetest.register_craft({
	output = "factory:arm",
	recipe = {
		{"default:steel_ingot", "default:steel_ingot", "farming:hoe_steel"},
		{"default:steel_ingot", "default:gold_ingot", "factory:small_steel_gear"},
		{"default:steelblock", "default:steelblock", "default:steelblock"}
	}
})

minetest.register_craft({
	output = "factory:smoke_tube",
	recipe = {
		{"default:steel_ingot", "", "default:steel_ingot"},
		{"default:steel_ingot", "", "default:steel_ingot"},
		{"default:steel_ingot", "", "default:steel_ingot"}
	}
})

minetest.register_craft({
	output = "factory:ind_furnace",
	recipe = {
		{"factory:small_steel_gear", "default:steel_ingot", "factory:small_steel_gear"},
		{"default:steel_ingot", "default:furnace", "default:steel_ingot"},
		{"default:stonebrick", "default:obsidian", "default:stonebrick"}
	}
})

minetest.register_craft({
	output = "factory:small_steel_gear 3",
	recipe = {
		{"default:steel_ingot", "", "default:steel_ingot"},
		{"", "default:steel_ingot", ""},
		{"default:steel_ingot", "", "default:steel_ingot"}
	}
})

minetest.register_craft({
	output = "factory:small_gold_gear 2",
	recipe = {
		{"default:gold_ingot", "", "default:gold_ingot"},
		{"", "factory:small_steel_gear", ""},
		{"default:gold_ingot", "", "default:gold_ingot"}
	}
})

minetest.register_craft({
	output = "factory:small_diamond_gear 2",
	recipe = {
		{"default:diamond", "", "default:diamond"},
		{"", "factory:small_gold_gear", ""},
		{"default:diamond", "", "default:diamond"}
	}
})

minetest.register_craft({
	output = "factory:taker",
	recipe = {
		{"default:shovel_steel", "default:steel_ingot", "default:gold_ingot"},
		{"factory:small_steel_gear", "factory:small_steel_gear", "default:gold_ingot"},
		{"default:steelblock", "default:steelblock", "default:steelblock"}
	}
})

minetest.register_craft({
	type = "shapeless", 
	output = "factory:taker_gold",
	recipe = {"factory:taker", "default:goldblock", "factory:small_gold_gear"}
})

minetest.register_craft({
	type = "shapeless", 
	output = "factory:taker_diamond",
	recipe = {"factory:taker_gold", "default:diamondblock", "factory:small_diamond_gear"}
})

minetest.register_craft({
	type = "shapeless", 
	output = "factory:queuedarm",
	recipe = {"factory:arm", "default:chest", "factory:small_gold_gear"}
})

factory.register_craft({
	type = "ind_squeezer",
	output = "factory:tree_sap",
	recipe = {{"default:tree"}}
})

factory.register_craft({
	type = "ind_squeezer",
	output = "factory:tree_sap",
	recipe = {{"default:jungle_tree"}}
})

factory.register_craft({
	type = "ind_squeezer",
	output = "factory:compressed_clay",
	recipe = {{"default:clay_lump"}}
})

minetest.register_craft({
	type = "cooking", 
	output = "factory:factory_lump",
	recipe = "factory:compressed_clay"
})

minetest.register_craft({
	output = 'factory:factory_brick 6',
	recipe = {
		{'factory:factory_lump', 'factory:factory_lump'},
		{'factory:factory_lump', 'factory:factory_lump'},
	}
})

minetest.register_craft({
	output = "factory:ind_squeezer",
	recipe = {
		{"default:glass", "default:stick", "default:glass"},
		{"default:glass", "default:steelblock", "default:glass"},
		{"factory:small_gold_gear", "factory:ind_furnace", "factory:small_gold_gear"}
	}
})