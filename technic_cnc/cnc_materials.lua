-- REGISTER MATERIALS AND PROPERTIES FOR NONCUBIC ELEMENTS:
-----------------------------------------------------------

local S = technic_cnc.getter

local function register_material(nodename, tiles_override, descr_override)
	local ndef = minetest.registered_nodes[nodename]
	if not ndef then
		return
	end

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
	local count = 0
	for _ in pairs(groups) do
		count = count + 1
	end
	assert(count >= 2, "Too few groups. node name=" .. nodename)

	local tiles = tiles_override or { ndef.tiles[#ndef.tiles] }
	assert(tiles and #tiles == 1, "Unknown tile format in node name=" .. nodename)

	technic_cnc.register_all(nodename,
		groups,
		tiles,
		descr_override or ndef.description or "<unknown>"
	)
end

register_material("default:dirt")
register_material("default:dirt_with_grass", {"default_grass.png"}, S("Grassy dirt"))
register_material("default:wood", nil, S("Wooden"))
register_material("default:stone")
register_material("default:cobble")
register_material("default:sandstone")
register_material("default:leaves")
register_material("default:tree")
register_material("default:bronzeblock", nil, S("Bronze"))

local steelname = S("Steel")

if technic_cnc.technic_modpath then
	steelname = S("Wrought Iron")

	register_material("technic:stainless_steel_block", nil, S("Stainless Steel"))
	register_material("technic:stainless_steel_block")
	register_material("technic:marble")
	register_material("technic:granite")
	register_material("technic:blast_resistant_concrete")
	register_material("technic:blast_resistant_concrete")
end

register_material("default:steelblock", nil, steelname)


-- CONCRETE AND CEMENT
----------------------

register_material("basic_materials:concrete_block")
register_material("basic_materials:cement_block")
register_material("basic_materials:brass_block")
