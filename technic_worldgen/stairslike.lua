-- cross-compatibility with default obsidian

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

minetest.register_alias("technic:obsidian", "default:obsidian")
minetest.register_alias("moreblocks:obsidian", "default:obsidian")

register_stair_slab_panel_micro(
	":default",
	"obsidian",
	"default:obsidian",
	{cracky=3, not_in_creative_inventory=1},
	{"default_obsidian.png"},
	"Obsidian",
	"default:obsidian",
	"none",
	light
)

register_technic_stairs_alias("moreblocks", "obsidian", "default", "obsidian")
table.insert(circular_saw.known_stairs, "default:obsidian")

-- other stairs/slabs

if type(register_stair_and_slab_and_panel_and_micro) == "function" then
register_stair_and_slab_and_panel_and_micro(":stairsplus", "marble", "technic:marble",
		{cracky=3, not_in_creative_inventory=1},
		{"technic_marble.png"},
		"Marble Stairs",
		"Marble Slab",
		"Marble Panel",
		"Marble Microblock",
		"marble")
register_stair_and_slab_and_panel_and_micro(":stairsplus", "marble_bricks", "technic:marble_bricks",
		{cracky=3, not_in_creative_inventory=1},
		{"technic_marble_bricks.png"},
		"Marble Bricks Stairs",
		"Marble Bricks Slab",
		"Marble Bricks Panel",
		"Marble Bricks Microblock",
		"marble_bricks")
register_stair_and_slab_and_panel_and_micro(":stairsplus", "granite", "technic:granite",
		{cracky=3, not_in_creative_inventory=1},
		{"technic_granite.png"},
		"Granite Stairs",
		"Granite Slab",
		"Granite Panel",
		"Granite Microblock",
		"granite")
register_stair_and_slab_and_panel_and_micro(":stairsplus", "obsidian", "default:obsidian",
		{cracky=3, not_in_creative_inventory=1},
		{"default_obsidian.png"},
		"Obsidian Stairs",
		"Obsidian Slab",
		"Obsidian Panel",
		"Obsidian Microblock",
		"obsidian")
end

if type(register_stair_slab_panel_micro) == "function" then
register_stair_slab_panel_micro(":stairsplus", "marble", "technic:marble",
		{cracky=3, not_in_creative_inventory=1},
		{"technic_marble.png"},
		"Marble Stairs",
		"Marble Slab",
		"Marble Panel",
		"Marble Microblock",
		"marble")
register_stair_slab_panel_micro(":stairsplus", "marble_bricks", "technic:marble_bricks",
		{cracky=3, not_in_creative_inventory=1},
		{"technic_marble_bricks.png"},
		"Marble Bricks Stairs",
		"Marble Bricks Slab",
		"Marble Bricks Panel",
		"Marble Bricks Microblock",
		"marble_bricks")
register_stair_slab_panel_micro(":stairsplus", "granite", "technic:granite",
		{cracky=3, not_in_creative_inventory=1},
		{"technic_granite.png"},
		"Granite Stairs",
		"Granite Slab",
		"Granite Panel",
		"Granite Microblock",
		"granite")
register_stair_slab_panel_micro(":stairsplus", "obsidian", "technic:obsidian",
		{cracky=3, not_in_creative_inventory=1},
		{"technic_obsidian.png"},
		"Obsidian Stairs",
		"Obsidian Slab",
		"Obsidian Panel",
		"Obsidian Microblock",
		"obsidian")
end
