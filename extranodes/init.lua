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
		tiles={"technic_concrete_block.png"},
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

	stairsplus:register_all("technic", "brass_block", "technic:brass_block", {
		description=S("Brass Block"),
		groups={cracky=1, not_in_creative_inventory=1},
		tiles={"technic_brass_block.png"},
	})

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

	register_technic_stairs_alias("stairsplus", "concrete", "technic", "concrete")
	register_technic_stairs_alias("stairsplus", "marble", "technic", "marble")
	register_technic_stairs_alias("stairsplus", "granite", "technic", "granite")
	register_technic_stairs_alias("stairsplus", "marble_bricks", "technic", "marble_bricks")

end
