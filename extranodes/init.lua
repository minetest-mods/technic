-- Minetest 0.4.6 mod: extranodes
-- namespace: technic
-- Boilerplate to support localized strings if intllib mod is installed.
local S = rawget(_G, "intllib") and intllib.Getter() or function(s) return s end

if minetest.get_modpath("moreblocks") then

	-- register stairsplus/circular_saw nodes
	-- we skip blast resistant concrete and uranium intentionally
	-- chrome seems to be too hard of a metal to be actually sawable

	stairsplus:register_all("technic", "marble", "technic:marble", {
		description=S("Marble"),
		groups={cracky=3, not_in_creative_inventory=1},
		tiles={"technic_marble.png"},
	})

	stairsplus:register_all("technic", "marble_bricks", "technic:marble_bricks", {
		description=S("Marble Bricks"),
		groups={cracky=3, not_in_creative_inventory=1},
		tiles={"technic_marble_bricks.png"},
	})

	stairsplus:register_all("technic", "granite", "technic:granite", {
		description=S("Granite"),
		groups={cracky=1, not_in_creative_inventory=1},
		tiles={"technic_granite.png"},
	})

	stairsplus:register_all("technic", "concrete", "technic:concrete", {
		description=S("Concrete"),
		groups={cracky=3, not_in_creative_inventory=1},
		tiles={"basic_materials_concrete_block.png"},
	})

	stairsplus:register_all("technic", "zinc_block", "technic:zinc_block", {
		description=S("Zinc Block"),
		groups={cracky=1, not_in_creative_inventory=1},
		tiles={"technic_zinc_block.png"},
	})

	stairsplus:register_all("technic", "cast_iron_block", "technic:cast_iron_block", {
		description=S("Cast Iron Block"),
		groups={cracky=1, not_in_creative_inventory=1},
		tiles={"technic_cast_iron_block.png"},
	})

	stairsplus:register_all("technic", "carbon_steel_block", "technic:carbon_steel_block", {
		description=S("Carbon Steel Block"),
		groups={cracky=1, not_in_creative_inventory=1},
		tiles={"technic_carbon_steel_block.png"},
	})

	stairsplus:register_all("technic", "stainless_steel_block", "technic:stainless_steel_block", {
		description=S("Stainless Steel Block"),
		groups={cracky=1, not_in_creative_inventory=1},
		tiles={"technic_stainless_steel_block.png"},
	})

	function register_technic_stairs_alias(origmod, origname, newmod, newname)
		local func = minetest.register_alias
		local function remap(kind, suffix)
			-- Old: stairsplus:slab_concrete_wall
			-- New:    technic:slab_concrete_wall
			func(("%s:%s_%s%s"):format(origmod, kind, origname, suffix),
				("%s:%s_%s%s"):format(newmod, kind, newname, suffix))
		end

		-- Slabs
		remap("slab", "")
		remap("slab", "_inverted")
		remap("slab", "_wall")
		remap("slab", "_quarter")
		remap("slab", "_quarter_inverted")
		remap("slab", "_quarter_wall")
		remap("slab", "_three_quarter")
		remap("slab", "_three_quarter_inverted")
		remap("slab", "_three_quarter_wall")

		-- Stairs
		remap("stair", "")
		remap("stair", "_inverted")
		remap("stair", "_wall")
		remap("stair", "_wall_half")
		remap("stair", "_wall_half_inverted")
		remap("stair", "_half")
		remap("stair", "_half_inverted")
		remap("stair", "_right_half")
		remap("stair", "_right_half_inverted")
		remap("stair", "_inner")
		remap("stair", "_inner_inverted")
		remap("stair", "_outer")
		remap("stair", "_outer_inverted")

		-- Other
		remap("panel", "_bottom")
		remap("panel", "_top")
		remap("panel", "_vertical")
		remap("micro", "_bottom")
		remap("micro", "_top")
	end

	register_technic_stairs_alias("stairsplus", "concrete", "technic", "concrete")
	register_technic_stairs_alias("stairsplus", "marble", "technic", "marble")
	register_technic_stairs_alias("stairsplus", "granite", "technic", "granite")
	register_technic_stairs_alias("stairsplus", "marble_bricks", "technic", "marble_bricks")

end

local iclip_def = {
	description = S("Insulator/cable clip"),
	drawtype = "mesh",
	mesh = "technic_insulator_clip.obj",
	tiles = {"technic_insulator_clip.png"},
	is_ground_content = false,
	groups = {choppy=1, snappy=1, oddly_breakable_by_hand=1 },
	sounds = default.node_sound_stone_defaults(),
}

local iclipfence_def = {
	description = S("Insulator/cable clip"),
	tiles = {"technic_insulator_clip.png"},
	is_ground_content = false,
	paramtype = "light",
	drawtype = "nodebox",
	node_box = {
		type = "connected",
		fixed = {
			{ -0.25,   0.75,   -0.25,   0.25,   1.25,   0.25   }, -- the clip on top
			{ -0.125, 0.6875, -0.125, 0.125, 0.75,   0.125 },
			{ -0.1875,  0.625,  -0.1875,  0.1875,  0.6875, 0.1875  },
			{ -0.125, 0.5625, -0.125, 0.125, 0.625,  0.125 },
			{ -0.1875,  0.5,    -0.1875,  0.1875,  0.5625, 0.1875  },
			{ -0.125, 0.4375, -0.125, 0.125, 0.5,    0.125 },
			{ -0.1875,  0.375,  -0.1875,  0.1875,  0.4375, 0.1875  },
			{ -0.125, -0.5,    -0.125,  0.125,  0.375,  0.125  }, -- the post, slightly short
		},
		-- connect_top =
		-- connect_bottom =
		connect_front = {{-1/16,3/16,-1/2,1/16,5/16,-1/8},
			{-1/16,-5/16,-1/2,1/16,-3/16,-1/8}},
		connect_left = {{-1/2,3/16,-1/16,-1/8,5/16,1/16},
			{-1/2,-5/16,-1/16,-1/8,-3/16,1/16}},
		connect_back = {{-1/16,3/16,1/8,1/16,5/16,1/2},
			{-1/16,-5/16,1/8,1/16,-3/16,1/2}},
		connect_right = {{1/8,3/16,-1/16,1/2,5/16,1/16},
			{1/8,-5/16,-1/16,1/2,-3/16,1/16}},
	},
	connects_to = {"group:fence", "group:wood", "group:tree"},
	groups = {fence=1, choppy=1, snappy=1, oddly_breakable_by_hand=1 },
	sounds = default.node_sound_stone_defaults(),
}

local sclip_tex = {
	"technic_insulator_clip.png",
	{ name = "strut.png^technic_steel_strut_overlay.png", color = "white" },
	{ name = "strut.png", color = "white" }
}

local streetsmod = minetest.get_modpath("streets") or minetest.get_modpath ("steelsupport")
-- cheapie's fork breaks it into several individual mods, with differernt names for the same content.

if streetsmod then
	sclip_tex = {
		"technic_insulator_clip.png",
		{ name = "streets_support.png^technic_steel_strut_overlay.png", color = "white" },
		{ name = "streets_support.png", color = "white" }
	}
end

local sclip_def = {
	description = S("Steel strut with insulator/cable clip"),
	drawtype = "mesh",
	mesh = "technic_steel_strut_with_insulator_clip.obj",
	tiles = sclip_tex,
	paramtype = "light",
	paramtype2 = "wallmounted",
	is_ground_content = false,
	sounds = default.node_sound_stone_defaults(),
	groups = { choppy=1, cracky=1 },
	backface_culling = false
}

if minetest.get_modpath("unifieddyes") then
	iclip_def.paramtype2 = "colorwallmounted"
	iclip_def.palette = "unifieddyes_palette_colorwallmounted.png"
	iclip_def.after_place_node = function(pos, placer, itemstack, pointed_thing)
		unifieddyes.fix_rotation(pos, placer, itemstack, pointed_thing)
	end
	iclip_def.groups = {choppy=1, snappy=1, oddly_breakable_by_hand=1, ud_param2_colorable = 1}
	iclip_def.on_dig = unifieddyes.on_dig

	iclipfence_def.paramtype2 = "color"
	iclipfence_def.palette = "unifieddyes_palette_extended.png"
	iclipfence_def.on_construct = unifieddyes.on_construct
	iclipfence_def.groups = {fence=1, choppy=1, snappy=1, oddly_breakable_by_hand=1, ud_param2_colorable = 1}
	iclipfence_def.on_dig = unifieddyes.on_dig

	sclip_def.paramtype2 = "colorwallmounted"
	sclip_def.palette = "unifieddyes_palette_colorwallmounted.png"
	sclip_def.after_place_node = function(pos, placer, itemstack, pointed_thing)
		unifieddyes.fix_rotation(pos, placer, itemstack, pointed_thing)
	end
	sclip_def.on_dig = unifieddyes.on_dig
	sclip_def.groups = {choppy=1, cracky=1, ud_param2_colorable = 1}
end

minetest.register_node(":technic:insulator_clip", iclip_def)
minetest.register_node(":technic:insulator_clip_fencepost", iclipfence_def)

minetest.register_craft({
	output = "technic:insulator_clip",
	recipe = {
		{ "", "dye:white", ""},
		{ "", "technic:raw_latex", ""},
		{ "technic:raw_latex", "default:stone", "technic:raw_latex"},
	}
})

minetest.register_craft({
	output = "technic:insulator_clip_fencepost 2",
	recipe = {
		{ "", "dye:white", ""},
		{ "", "technic:raw_latex", ""},
		{ "technic:raw_latex", "default:fence_wood", "technic:raw_latex"},
	}
})

local steelmod = minetest.get_modpath("steel")

if streetsmod or steelmod then
	minetest.register_node(":technic:steel_strut_with_insulator_clip", sclip_def)

	if steelmod then
		minetest.register_craft({
			output = "technic:steel_strut_with_insulator_clip",
			recipe = {
				{"technic:insulator_clip_fencepost"},
				{"steel:strut_mount"}
			}
		})

		minetest.register_craft({
			output = "technic:steel_strut_with_insulator_clip",
			recipe = {
				{"technic:insulator_clip_fencepost", ""                    },
				{"steel:strut",                      "default:steel_ingot" },
			}
		})

	elseif streetsmod then
		minetest.register_craft({
			output = "technic:steel_strut_with_insulator_clip",
			recipe = {
				{"technic:insulator_clip_fencepost", ""                   },
				{"streets:steel_support",           "default:steel_ingot" },
			}
		})
	end
end

if minetest.get_modpath("unifieddyes") then

	unifieddyes.register_color_craft({
		output = "technic:insulator_clip_fencepost",
		palette = "extended",
		type = "shapeless",
		neutral_node = "technic:insulator_clip_fencepost",
		recipe = {
			"NEUTRAL_NODE",
			"MAIN_DYE"
		}
	})

	unifieddyes.register_color_craft({
		output = "technic:insulator_clip",
		palette = "wallmounted",
		type = "shapeless",
		neutral_node = "technic:insulator_clip",
		recipe = {
			"NEUTRAL_NODE",
			"MAIN_DYE"
		}
	})

	unifieddyes.register_color_craft({
		output = "technic:steel_strut_with_insulator_clip",
		palette = "wallmounted",
		type = "shapeless",
		neutral_node = "",
		recipe = {
			"technic:steel_strut_with_insulator_clip",
			"MAIN_DYE"
		}
	})

	if steelmod then
		unifieddyes.register_color_craft({
			output = "technic:steel_strut_with_insulator_clip",
			palette = "wallmounted",
			neutral_node = "",
			recipe = {
				{ "technic:insulator_clip_fencepost", "MAIN_DYE" },
				{ "steel:strut_mount",                ""         },
			}
		})
	end

	if streetsmod then
		unifieddyes.register_color_craft({
			output = "technic:steel_strut_with_insulator_clip",
			palette = "wallmounted",
			neutral_node = "technic:steel_strut_with_insulator_clip",
			recipe = {
				{ "technic:insulator_clip_fencepost", "MAIN_DYE"            },
				{ "streets:steel_support",            "default:steel_ingot" },
			}
		})
	end
end
