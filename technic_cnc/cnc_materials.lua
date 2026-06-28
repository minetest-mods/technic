local S = technic_cnc.getter

-- Conditional variables for MineClone2 compatibility
local is_mcl = minetest.get_modpath("mcl_core")

-- Helper function to safely register materials based on existing node definitions
local function register_material(nodename, tiles_override, descr_override)
	local ndef = minetest.registered_nodes[nodename]
	if not ndef then
		return
	end

	-- Inherit groups from the base node
	local groups = {
		cracky = ndef.groups.cracky,
		crumbly = ndef.groups.crumbly,
		choppy = ndef.groups.choppy,
		flammable = ndef.groups.flammable,
		level = ndef.groups.level,
		snappy = ndef.groups.snappy,
		wood = ndef.groups.wood,
		oddly_breakable_by_hand = ndef.groups.oddly_breakable_by_hand,
		not_in_creative_inventory = 1,
	}

	-- Fallback tiles: Use override, or the top tile, or the last tile in the list
	local tiles = tiles_override or { ndef.tiles[1] }
	
	technic_cnc.register_all(nodename,
		groups,
		tiles,
		descr_override or ndef.description or S("Unknown Material")
	)
end

---
--- Material Registration
---

-- DIRT & GRASS
register_material(is_mcl and "mcl_core:dirt" or "default:dirt", nil, S("Dirt"))
register_material(is_mcl and "mcl_core:dirt_with_grass" or "default:dirt_with_grass", 
	{is_mcl and "mcl_core_palette_grass.png" or "default_grass.png"}, S("Grassy dirt"))

-- WOOD & TREE
register_material(is_mcl and "mcl_core:wood" or "default:wood", nil, S("Wooden"))
register_material(is_mcl and "mcl_core:tree" or "default:tree", nil, S("Tree"))

-- STONE, COBBLE, BRICK
register_material(is_mcl and "mcl_core:stone" or "default:stone", nil, S("Stone"))
register_material(is_mcl and "mcl_core:cobble" or "default:cobble", nil, S("Cobble"))
register_material(is_mcl and "mcl_core:brick" or "default:brick", nil, S("Brick"))

-- SANDSTONE
register_material(is_mcl and "mcl_core:sandstone" or "default:sandstone", 
	{is_mcl and "mcl_core_sandstone_top.png" or nil}, S("Sandstone"))

-- LEAVES
register_material(is_mcl and "mcl_core:leaves" or "default:leaves", nil, S("Leaves"))

-- METALS (Bronze/Steel/Iron)
if not is_mcl then
	register_material("default:bronzeblock", nil, S("Bronze"))
else
	register_material("mcl_core:bronze_block", nil, S("Bronze"))
end

local steel_node = is_mcl and "mcl_core:iron_block" or "default:steelblock"
local steel_name = is_mcl and S("Iron") or S("Steel")

-- TECHNIC SPECIFIC
if technic_cnc.technic_modpath then
	if not is_mcl then
		steel_name = S("Wrought Iron")
		-- Register Technic specific nodes
		register_material("technic:stainless_steel_block", {"technic_stainless_steel_block.png"}, S("Stainless Steel"))
		register_material("technic:marble", {"technic_marble.png"}, S("Marble"))
		register_material("technic:granite", {"technic_granite.png"}, S("Granite"))
		register_material("technic:blast_resistant_concrete", {"technic_blast_resistant_concrete_block.png"}, S("Blast-resistant concrete"))
	end
end

register_material(steel_node, nil, steel_name)

-- CONCRETE AND CEMENT (basic_materials)
if minetest.get_modpath("basic_materials") then
	register_material("basic_materials:concrete_block", nil, S("Concrete"))
	register_material("basic_materials:cement_block", nil, S("Cement"))
	register_material("basic_materials:brass_block", nil, S("Brass block"))
end