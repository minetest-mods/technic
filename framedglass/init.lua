-- Minetest 0.4.5 mod: framedglass

minetest.register_craft({
	output = 'framedglass:wooden_framed_glass 4',
	recipe = {
		{'default:glass', 'default:glass', 'default:stick'},
		{'default:glass', 'default:glass', 'default:stick'},
		{'default:stick', 'default:stick', ''},
	}
})

minetest.register_craft({
	output = 'framedglass:steel_framed_glass 4',
	recipe = {
		{'default:glass', 'default:glass', 'default:steel_ingot'},
		{'default:glass', 'default:glass', 'default:steel_ingot'},
		{'default:steel_ingot', 'default:steel_ingot', ''},
	}
})

minetest.register_craft({
	output = 'framedglass:wooden_framed_obsidian_glass 4',
	recipe = {
		{'default:obsidian_glass', 'default:obsidian_glass', 'default:stick'},
		{'default:obsidian_glass', 'default:obsidian_glass', 'default:stick'},
		{'default:stick', 'default:stick', ''},
	}
})

minetest.register_craft({
	output = 'framedglass:steel_framed_obsidian_glass 4',
	recipe = {
		{'default:obsidian_glass', 'default:obsidian_glass', 'default:steel_ingot'},
		{'default:obsidian_glass', 'default:obsidian_glass', 'default:steel_ingot'},
		{'default:steel_ingot', 'default:steel_ingot', ''},
	}
})

minetest.register_node("framedglass:wooden_framed_glass", {
	description = "Wooden-framed Glass",
	drawtype = "glasslike_framed",
	tiles = {"framedglass_wooden_frame.png","framedglass_glass_face_streaks.png"},
	paramtype = "light",
	sunlight_propagates = true,
	groups = {cracky=3,oddly_breakable_by_hand=3},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("framedglass:steel_framed_glass", {
	description = "Steel-framed Glass",
	drawtype = "glasslike_framed",
	tiles = {"framedglass_steel_frame.png","framedglass_glass_face_streaks.png"},
	paramtype = "light",
	sunlight_propagates = true,
	groups = {cracky=3,oddly_breakable_by_hand=3},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("framedglass:wooden_framed_obsidian_glass", {
	description = "Wooden-framed Obsidian Glass",
	drawtype = "glasslike_framed",
	tiles = {"framedglass_wooden_frame.png","framedglass_glass_face_clean.png"},
	paramtype = "light",
	sunlight_propagates = true,
	groups = {cracky=3,oddly_breakable_by_hand=3},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("framedglass:steel_framed_obsidian_glass", {
	description = "Steel-framed Obsidian Glass",
	drawtype = "glasslike_framed",
	tiles = {"framedglass_steel_frame.png","framedglass_glass_face_clean.png"},
	paramtype = "light",
	sunlight_propagates = true,
	groups = {cracky=3,oddly_breakable_by_hand=3},
	sounds = default.node_sound_glass_defaults(),
})
