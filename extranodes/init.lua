-- Minetest 0.4.6 mod: extranodes
-- namespace: technic

--register stairslike nodes 
register_stair_slab_panel_micro("technic", "marble", "technic:marble",
	{cracky=2, not_in_creative_inventory=1},
	{"technic_marble.png"},
	"Marble",
	"marble",
	"facedir",
	0)

register_stair_slab_panel_micro("technic", "marble_bricks", "technic:marble_bricks",
	{cracky=2, not_in_creative_inventory=1},
	{"technic_marble_bricks.png"},
	"Marble Bricks",
	"marble_bricks",
	"facedir",
	0)

register_stair_slab_panel_micro("technic", "granite", "technic:granite",
	{cracky=3, not_in_creative_inventory=1},
	{"technic_granite.png"},
	"Granite",
	"granite",
	"facedir",
	0)

register_stair_slab_panel_micro("technic", "concrete", "technic:concrete",
	{cracky=3, not_in_creative_inventory=1},
	{"technic_concrete_block.png"},
	"Concrete",
	"concrete",
	"facedir",
	0)

--register nodes in circular saw if aviable
if circular_saw then 
	for i,v in ipairs({"concrete",  "marble",  "marble_bricks",  "granite",  "default:obsidian"}) do
		table.insert(circular_saw.known_stairs, "technic:" ..v);
	end
end

 
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
